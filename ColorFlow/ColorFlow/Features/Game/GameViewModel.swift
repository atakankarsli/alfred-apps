import SwiftUI
import SwiftData

@MainActor
@Observable
final class GameViewModel {
    var puzzle: NovaPuzzle?
    var energy: [Int] = []
    var taps: Int = 0
    var isComplete = false
    var isAnimating = false
    var level: Int = 0
    var stars: Int = 0
    var xpEarned: Int = 0
    var showConfetti = false
    var newAchievements: [Achievement] = []
    var timerSeconds: Int = 0
    var explosionCells: Set<Int> = []
    var recentlyExploded: Set<Int> = []
    var tapHistory: [Int] = []
    var chainSteps: [[Int]] = []
    var currentChainStep: Int = -1

    private var modelContext: ModelContext?
    private var timer: Timer?
    private var showTimer = true

    func startGame(level: Int, modelContext: ModelContext, showTimer: Bool) {
        self.level = level
        self.modelContext = modelContext
        self.showTimer = showTimer
        self.puzzle = NovaPuzzle.generate(level: level)

        guard let puzzle else { return }
        energy = puzzle.initialEnergy
        taps = 0
        isComplete = false
        isAnimating = false
        stars = 0
        xpEarned = 0
        showConfetti = false
        newAchievements = []
        timerSeconds = 0
        explosionCells = []
        recentlyExploded = []
        tapHistory = []
        chainSteps = []
        currentChainStep = -1

        startTimer()
    }

    func tapCell(at index: Int) {
        guard puzzle != nil, !isComplete, !isAnimating else { return }
        guard index >= 0, index < energy.count else { return }

        energy[index] += 1
        taps += 1
        tapHistory.append(index)
        HapticsService.medium()

        let note = min(index % 12, 11)
        SoundService.shared.playNote(note - 6)

        processChainReaction()
    }

    func undo() {
        guard let p = puzzle, !tapHistory.isEmpty, !isAnimating, !isComplete else { return }
        energy = p.initialEnergy

        tapHistory.removeLast()
        taps = tapHistory.count

        for tap in tapHistory {
            energy[tap] += 1
            var state = energy
            _ = NovaPuzzle.simulate(energy: &state, gridSize: p.gridSize)
            energy = state
        }

        HapticsService.light()
    }

    func cleanup() {
        timer?.invalidate()
        timer = nil
    }

    private func processChainReaction() {
        guard let puzzle else { return }
        isAnimating = true

        var state = energy
        let steps = NovaPuzzle.simulate(energy: &state, gridSize: puzzle.gridSize)

        if steps.isEmpty {
            isAnimating = false
            energy = state
            checkCompletion()
            return
        }

        chainSteps = steps
        currentChainStep = 0
        animateNextStep(finalState: state)
    }

    private func animateNextStep(finalState: [Int]) {
        guard currentChainStep < chainSteps.count else {
            energy = finalState
            explosionCells = []
            recentlyExploded = []
            isAnimating = false
            checkCompletion()
            return
        }

        let cells = chainSteps[currentChainStep]
        withAnimation(.easeOut(duration: 0.15)) {
            explosionCells = Set(cells)
            recentlyExploded = recentlyExploded.union(cells)
        }

        let stepNote = min(currentChainStep + 2, 12)
        SoundService.shared.playNote(stepNote)
        HapticsService.heavy()

        currentChainStep += 1

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [weak self] in
            guard let self else { return }
            withAnimation(.easeOut(duration: 0.1)) {
                self.explosionCells = []
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.animateNextStep(finalState: finalState)
            }
        }
    }

    private func checkCompletion() {
        guard NovaPuzzle.isClear(energy) else { return }
        guard let puzzle else { return }

        isComplete = true
        timer?.invalidate()

        stars = GameConfig.starsForTaps(taps, par: puzzle.parTaps)
        let worldIndex = World.worldForLevel(level).id
        xpEarned = GameConfig.xpForPuzzle(stars: stars, world: worldIndex)

        if stars >= 3 {
            showConfetti = true
            HapticsService.success()
        }

        updateStats()
        checkAchievements()
    }

    private func updateStats() {
        guard let ctx = modelContext else { return }
        let descriptor = FetchDescriptor<StatsRecord>()
        guard let statsRecord = try? ctx.fetch(descriptor).first else { return }

        statsRecord.puzzlesCompleted += 1
        statsRecord.totalMoves += taps
        if stars >= 3 { statsRecord.threeStarCount += 1 }
        statsRecord.totalXP += xpEarned
        statsRecord.totalTimePlayed += timerSeconds
        statsRecord.updateStreak()

        var best = statsRecord.bestMoves
        if let existing = best[level] {
            if taps < existing { best[level] = taps }
        } else {
            best[level] = taps
        }
        statsRecord.bestMoves = best

        try? ctx.save()
    }

    private func checkAchievements() {
        guard let ctx = modelContext else { return }
        let statsDescriptor = FetchDescriptor<StatsRecord>()
        let achievementDescriptor = FetchDescriptor<AchievementRecord>()

        guard let stats = try? ctx.fetch(statsDescriptor).first,
              let unlocked = try? ctx.fetch(achievementDescriptor) else { return }

        let unlockedIds = Set(unlocked.map(\.achievementId))

        for achievement in Achievement.all where !unlockedIds.contains(achievement.id) {
            if shouldUnlock(achievement, stats: stats) {
                let record = AchievementRecord(achievementId: achievement.id, unlockedAt: .now)
                ctx.insert(record)
                newAchievements.append(achievement)
                xpEarned += achievement.tier.xpReward
                stats.totalXP += achievement.tier.xpReward
            }
        }

        try? ctx.save()
    }

    private func shouldUnlock(_ achievement: Achievement, stats: StatsRecord) -> Bool {
        switch achievement.id {
        case "first_light": return stats.puzzlesCompleted >= 1
        case "spark_complete": return completedWorldCount(stats: stats) >= 1
        case "pulse_complete": return completedWorldCount(stats: stats) >= 2
        case "wave_complete": return completedWorldCount(stats: stats) >= 3
        case "storm_complete": return completedWorldCount(stats: stats) >= 4
        case "supernova_complete": return completedWorldCount(stats: stats) >= 5
        case "perfectionist": return stats.threeStarCount >= 10
        case "star_collector": return stats.threeStarCount >= 50
        case "par_master": return stats.bestMoves.values.filter({ _ in true }).count >= 5
        case "no_help": return stats.noHintCompletions >= 20
        case "streak_3": return stats.currentStreak >= 3
        case "streak_7": return stats.currentStreak >= 7
        case "streak_30": return stats.currentStreak >= 30
        case "streak_100": return stats.currentStreak >= 100
        case "xp_100": return stats.totalXP >= 100
        case "xp_500": return stats.totalXP >= 500
        case "xp_2000": return stats.totalXP >= 2000
        case "xp_10000": return stats.totalXP >= 10000
        case "daily_first": return stats.dailyPuzzlesCompleted >= 1
        case "daily_30": return stats.dailyPuzzlesCompleted >= 30
        case "speed_demon": return timerSeconds <= 10 && isComplete
        case "chain_master": return chainSteps.count >= 8
        case "hidden_zen": return stats.puzzlesCompleted >= 50 && stats.hintsUsed == 0
        default: return false
        }
    }

    private func completedWorldCount(stats: StatsRecord) -> Int {
        World.all.filter { world in
            world.levelRange.allSatisfy { stats.bestMoves[$0] != nil }
        }.count
    }

    private func startTimer() {
        timer?.invalidate()
        guard showTimer else { return }
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.timerSeconds += 1
            }
        }
    }
}
