import SwiftUI
import SwiftData

@MainActor
@Observable
final class OrbitViewModel {
    var puzzle: OrbitPuzzle?
    var placedSources: [Int: MassKind] = [:]
    var selectedMassKind: MassKind = .planet
    var orbitPath: [(x: Double, y: Double)] = []
    var checkpointsHit: Int = 0
    var isSimulating = false
    var isComplete = false
    var level: Int = 0
    var stars: Int = 0
    var xpEarned: Int = 0
    var showConfetti = false
    var newAchievements: [Achievement] = []
    var timerSeconds: Int = 0
    var accuracy: Double = 0

    private var modelContext: ModelContext?
    private var timer: Timer?
    private var showTimer = true

    func startGame(level: Int, modelContext: ModelContext, showTimer: Bool) {
        self.level = level
        self.modelContext = modelContext
        self.showTimer = showTimer
        self.puzzle = OrbitPuzzle.generate(level: level)

        placedSources = [:]
        selectedMassKind = puzzle?.availableMasses.first ?? .planet
        orbitPath = []
        checkpointsHit = 0
        isSimulating = false
        isComplete = false
        stars = 0
        xpEarned = 0
        showConfetti = false
        newAchievements = []
        timerSeconds = 0
        accuracy = 0

        startTimer()
    }

    func toggleSlot(_ slotIndex: Int) {
        guard !isComplete, !isSimulating else { return }
        if placedSources[slotIndex] != nil {
            placedSources.removeValue(forKey: slotIndex)
            HapticsService.light()
        } else {
            placedSources[slotIndex] = selectedMassKind
            HapticsService.medium()
            SoundService.shared.playNote(slotIndex % 12 - 6)
        }
        updatePreview()
    }

    func selectMass(_ kind: MassKind) {
        selectedMassKind = kind
        HapticsService.selection()
    }

    func launch() {
        guard let puzzle, !isComplete else { return }
        isSimulating = true
        HapticsService.heavy()

        let allSources = buildAllSources()
        let path = OrbitPuzzle.simulate(
            sources: allSources,
            startX: puzzle.satelliteStart.x,
            startY: puzzle.satelliteStart.y,
            vx: puzzle.satelliteVelocity.vx,
            vy: puzzle.satelliteVelocity.vy,
            steps: OrbitConfig.simSteps
        )

        animatePath(path, puzzle: puzzle)
    }

    func reset() {
        placedSources = [:]
        orbitPath = []
        checkpointsHit = 0
        isSimulating = false
        isComplete = false
        accuracy = 0
        HapticsService.medium()
    }

    func cleanup() {
        timer?.invalidate()
        timer = nil
    }

    private func updatePreview() {
        guard let puzzle else { return }
        let allSources = buildAllSources()
        orbitPath = OrbitPuzzle.simulate(
            sources: allSources,
            startX: puzzle.satelliteStart.x,
            startY: puzzle.satelliteStart.y,
            vx: puzzle.satelliteVelocity.vx,
            vy: puzzle.satelliteVelocity.vy,
            steps: OrbitConfig.simSteps
        )
    }

    private func buildAllSources() -> [GravitySource] {
        guard let puzzle else { return [] }
        var sources = puzzle.fixedSources
        for (slotIndex, kind) in placedSources {
            guard slotIndex < puzzle.placementSlots.count else { continue }
            let slot = puzzle.placementSlots[slotIndex]
            sources.append(GravitySource(x: slot.x, y: slot.y, mass: kind.massValue, kind: kind))
        }
        return sources
    }

    private func animatePath(_ path: [(x: Double, y: Double)], puzzle: OrbitPuzzle) {
        orbitPath = []
        let stepDelay = 0.005
        for (i, point) in path.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + stepDelay * Double(i)) { [weak self] in
                guard let self else { return }
                self.orbitPath.append(point)

                if i == path.count - 1 {
                    self.isSimulating = false
                    self.checkpointsHit = OrbitPuzzle.checkpointsHit(path: path, checkpoints: puzzle.checkpoints)
                    self.accuracy = OrbitPuzzle.accuracy(path: path, checkpoints: puzzle.checkpoints)

                    if self.accuracy >= 0.5 {
                        self.completeGame()
                    }
                }
            }
        }
    }

    private func completeGame() {
        isComplete = true
        timer?.invalidate()

        stars = OrbitConfig.starsForAccuracy(accuracy)
        let worldIndex = Sector.worldForLevel(level).id
        xpEarned = OrbitConfig.xpForPuzzle(stars: stars, world: worldIndex)

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
        guard let statsRecord = try? ctx.fetch(descriptor).first else { return }

        statsRecord.puzzlesCompleted += 1
        statsRecord.totalMoves += placedSources.count
        if stars >= 3 { statsRecord.threeStarCount += 1 }
        statsRecord.totalXP += xpEarned
        statsRecord.totalTimePlayed += timerSeconds
        statsRecord.updateStreak()

        var best = statsRecord.bestMoves
        let score = Int(accuracy * 100)
        if let existing = best[level] {
            if score > existing { best[level] = score }
        } else {
            best[level] = score
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
        case "first_orbit": return stats.puzzlesCompleted >= 1
        case "inner_complete": return completedWorldCount(stats: stats) >= 1
        case "belt_complete": return completedWorldCount(stats: stats) >= 2
        case "gas_complete": return completedWorldCount(stats: stats) >= 3
        case "binary_complete": return completedWorldCount(stats: stats) >= 4
        case "dark_complete": return completedWorldCount(stats: stats) >= 5
        case "perfectionist": return stats.threeStarCount >= 10
        case "star_collector": return stats.threeStarCount >= 50
        case "efficient": return stats.threeStarCount >= 10
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
        case "speed_orbit": return timerSeconds <= 15 && isComplete
        case "gravity_master": return stats.totalMoves >= 100
        default: return false
        }
    }

    private func completedWorldCount(stats: StatsRecord) -> Int {
        Sector.all.filter { world in
            world.levelRange.allSatisfy { stats.bestMoves[$0] != nil }
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
