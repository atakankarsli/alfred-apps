import SwiftUI
import SwiftData

@MainActor
@Observable
final class DriftViewModel {
    var puzzle: SoundscapePuzzle?
    var level: Int = 0
    var isComplete = false
    var stars: Int = 0
    var xpEarned: Int = 0
    var showConfetti = false
    var newAchievements: [Achievement] = []
    var timerSeconds: Int = 0
    var volumes: [Double] = []
    var showTarget = true
    var accuracy: Double = 0

    private var modelContext: ModelContext?
    private var timer: Timer?

    func startGame(level: Int, modelContext: ModelContext) {
        self.level = level
        self.modelContext = modelContext
        self.puzzle = SoundscapePuzzle.generate(level: level)
        guard let puzzle else { return }

        volumes = Array(repeating: 0.0, count: puzzle.channelCount)
        isComplete = false
        stars = 0
        xpEarned = 0
        showConfetti = false
        newAchievements = []
        timerSeconds = 0
        accuracy = 0
        showTarget = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            self?.showTarget = false
        }
        startTimer()
    }

    func setVolume(_ value: Double, for index: Int) {
        guard !isComplete, index < volumes.count else { return }
        let snapped = (value * 20).rounded() / 20
        volumes[index] = max(0, min(1, snapped))
        HapticsService.selection()
    }

    func submitMix() {
        guard let puzzle, !isComplete else { return }

        accuracy = SoundscapePuzzle.accuracy(guess: volumes, target: puzzle.targetVolumes)
        stars = SoundscapePuzzle.starsForAccuracy(accuracy)
        let envIndex = SoundWorld.worldForLevel(level).id
        xpEarned = DriftConfig.xpForPuzzle(stars: stars, env: envIndex)

        isComplete = true
        timer?.invalidate()

        if stars >= 3 {
            showConfetti = true
            HapticsService.success()
        }
        SoundService.shared.playCelebration()

        updateStats()
        checkAchievements()
    }

    func revealTarget() {
        showTarget = true
        HapticsService.medium()
        if let ctx = modelContext {
            let descriptor = FetchDescriptor<StatsRecord>()
            if let stats = try? ctx.fetch(descriptor).first {
                stats.hintsUsed += 1
                try? ctx.save()
            }
        }
    }

    func cleanup() {
        timer?.invalidate()
        timer = nil
    }

    private func updateStats() {
        guard let ctx = modelContext else { return }
        let descriptor = FetchDescriptor<StatsRecord>()
        guard let stats = try? ctx.fetch(descriptor).first else { return }

        stats.puzzlesCompleted += 1
        stats.totalMoves += volumes.count
        if stars >= 3 { stats.threeStarCount += 1 }
        stats.totalXP += xpEarned
        stats.totalTimePlayed += timerSeconds
        stats.updateStreak()

        var best = stats.bestMoves
        let accuracyInt = Int(accuracy * 100)
        if let existing = best[level] {
            if accuracyInt > existing { best[level] = accuracyInt }
        } else {
            best[level] = accuracyInt
        }
        stats.bestMoves = best
        try? ctx.save()
    }

    private func checkAchievements() {
        guard let ctx = modelContext else { return }
        let statsDesc = FetchDescriptor<StatsRecord>()
        let achDesc = FetchDescriptor<AchievementRecord>()
        guard let stats = try? ctx.fetch(statsDesc).first,
              let unlocked = try? ctx.fetch(achDesc) else { return }

        let unlockedIds = Set(unlocked.map(\.achievementId))
        for ach in Achievement.all where !unlockedIds.contains(ach.id) {
            if shouldUnlock(ach, stats: stats) {
                ctx.insert(AchievementRecord(achievementId: ach.id, unlockedAt: .now))
                newAchievements.append(ach)
                xpEarned += ach.tier.xpReward
                stats.totalXP += ach.tier.xpReward
            }
        }
        try? ctx.save()
    }

    private func shouldUnlock(_ ach: Achievement, stats: StatsRecord) -> Bool {
        switch ach.id {
        case "first_mix": return stats.puzzlesCompleted >= 1
        case "nature_complete": return completedWorldCount(stats: stats) >= 1
        case "urban_complete": return completedWorldCount(stats: stats) >= 2
        case "space_complete": return completedWorldCount(stats: stats) >= 3
        case "indoor_complete": return completedWorldCount(stats: stats) >= 4
        case "mystic_complete": return completedWorldCount(stats: stats) >= 5
        case "perfectionist": return stats.threeStarCount >= 10
        case "star_collector": return stats.threeStarCount >= 40
        case "golden_ear": return accuracy >= 0.95
        case "no_hints": return stats.noHintCompletions >= 20
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
        case "all_envs": return allEnvsSolved(stats: stats)
        case "speed_mix": return timerSeconds <= 15 && isComplete
        default: return false
        }
    }

    private func completedWorldCount(stats: StatsRecord) -> Int {
        SoundWorld.all.filter { w in w.levelRange.allSatisfy { stats.bestMoves[$0] != nil } }.count
    }

    private func allEnvsSolved(stats: StatsRecord) -> Bool {
        let starts = [0, 16, 32, 48, 64]
        return starts.allSatisfy { s in (s..<s+16).contains { stats.bestMoves[$0] != nil } }
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in self?.timerSeconds += 1 }
        }
    }
}
