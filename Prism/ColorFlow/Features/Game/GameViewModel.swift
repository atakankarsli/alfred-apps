import SwiftUI
import SwiftData

@MainActor
@Observable
final class PrismViewModel {
    var puzzle: PrismPuzzle?
    var emitterDirections: [Int: Int] = [:]
    var moves: Int = 0
    var isComplete = false
    var level: Int = 0
    var stars: Int = 0
    var xpEarned: Int = 0
    var showConfetti = false
    var newAchievements: [Achievement] = []
    var timerSeconds: Int = 0
    var beamSegments: [BeamSegment] = []
    var cellColors: [Int: BeamColor] = [:]

    private var modelContext: ModelContext?
    private var timer: Timer?
    private var showTimer = true

    func startGame(level: Int, modelContext: ModelContext, showTimer: Bool) {
        self.level = level
        self.modelContext = modelContext
        self.showTimer = showTimer
        self.puzzle = PrismPuzzle.generate(level: level)

        guard let puzzle else { return }

        var rng = SeededRNG(seed: UInt64(level &* 4517 &+ 7723))
        emitterDirections = [:]
        for emitter in puzzle.emitters {
            let scramble = Int.random(in: 1..<4, using: &rng)
            emitterDirections[emitter.index] = (emitter.solutionDir + scramble) % 4
        }

        moves = 0
        isComplete = false
        stars = 0
        xpEarned = 0
        showConfetti = false
        newAchievements = []
        timerSeconds = 0

        updateBeams()
        startTimer()
    }

    func rotateEmitter(at index: Int) {
        guard !isComplete else { return }
        guard let dir = emitterDirections[index] else { return }

        emitterDirections[index] = (dir + 1) % 4
        moves += 1

        HapticsService.medium()
        SoundService.shared.playNote(index % 12 - 6)

        updateBeams()
        checkCompletion()
    }

    func cleanup() {
        timer?.invalidate()
        timer = nil
    }

    private func updateBeams() {
        guard let puzzle else { return }
        let (segs, colors) = PrismPuzzle.traceBeams(
            gridSize: puzzle.gridSize,
            emitters: puzzle.emitters,
            directions: emitterDirections,
            walls: puzzle.walls
        )
        beamSegments = segs
        cellColors = colors
    }

    private func checkCompletion() {
        guard let puzzle else { return }
        for target in puzzle.targets {
            if cellColors[target.index] != target.required { return }
        }

        isComplete = true
        timer?.invalidate()

        stars = PrismConfig.starsForMoves(moves, par: puzzle.parMoves)
        let spectrumIndex = Spectrum.spectrumForLevel(level).id
        xpEarned = PrismConfig.xpForPuzzle(stars: stars, spectrum: spectrumIndex)

        if stars >= 3 {
            showConfetti = true
            HapticsService.success()
        }

        SoundService.shared.playCelebration()
        updateStats()
        checkAchievements()
    }

    private func updateStats() {
        guard let ctx = modelContext else { return }
        let descriptor = FetchDescriptor<StatsRecord>()
        guard let stats = try? ctx.fetch(descriptor).first else { return }

        stats.puzzlesCompleted += 1
        stats.totalMoves += moves
        if stars >= 3 { stats.threeStarCount += 1 }
        stats.totalXP += xpEarned
        stats.totalTimePlayed += timerSeconds
        stats.noHintCompletions += 1
        stats.updateStreak()

        var best = stats.bestMoves
        if let existing = best[level] {
            if moves < existing { best[level] = moves }
        } else {
            best[level] = moves
        }
        stats.bestMoves = best

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
        case "first_beam": return stats.puzzlesCompleted >= 1
        case "first_light_complete": return completedSpectrumCount(stats: stats) >= 1
        case "refraction_complete": return completedSpectrumCount(stats: stats) >= 2
        case "chromatic_complete": return completedSpectrumCount(stats: stats) >= 3
        case "prismatic_complete": return completedSpectrumCount(stats: stats) >= 4
        case "luminance_complete": return completedSpectrumCount(stats: stats) >= 5
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
        case "color_master": return stats.puzzlesCompleted >= 40
        case "hidden_zen": return stats.puzzlesCompleted >= 50 && stats.hintsUsed == 0
        default: return false
        }
    }

    private func completedSpectrumCount(stats: StatsRecord) -> Int {
        Spectrum.all.filter { spectrum in
            spectrum.levelRange.allSatisfy { stats.bestMoves[$0] != nil }
        }.count
    }

    private func startTimer() {
        timer?.invalidate()
        guard showTimer else { return }
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in self?.timerSeconds += 1 }
        }
    }
}
