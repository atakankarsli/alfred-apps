import SwiftUI
import SwiftData

@MainActor
@Observable
final class NexusViewModel {
    var puzzle: NexusPuzzle?
    var words: [String] = []
    var selectedWords: [String] = []
    var solvedClusters: [WordCluster] = []
    var mistakes: Int = 0
    var isComplete = false
    var level: Int = 0
    var stars: Int = 0
    var xpEarned: Int = 0
    var showConfetti = false
    var newAchievements: [Achievement] = []
    var timerSeconds: Int = 0
    var feedbackMessage: String?
    var shakeSelected = false

    private var modelContext: ModelContext?
    private var timer: Timer?
    private var showTimer = true
    private var oneAwayCount = 0

    func startGame(level: Int, modelContext: ModelContext, showTimer: Bool) {
        self.level = level
        self.modelContext = modelContext
        self.showTimer = showTimer
        self.puzzle = NexusPuzzle.generate(level: level)

        guard let puzzle else { return }
        words = puzzle.shuffledWords
        selectedWords = []
        solvedClusters = []
        mistakes = 0
        isComplete = false
        stars = 0
        xpEarned = 0
        showConfetti = false
        newAchievements = []
        timerSeconds = 0
        feedbackMessage = nil
        shakeSelected = false
        oneAwayCount = 0

        startTimer()
    }

    func toggleWord(_ word: String) {
        guard !isComplete else { return }
        guard !solvedClusters.flatMap(\.words).contains(word) else { return }

        if selectedWords.contains(word) {
            selectedWords.removeAll { $0 == word }
            HapticsService.light()
        } else if selectedWords.count < NexusConfig.wordsPerCluster {
            selectedWords.append(word)
            HapticsService.selection()
            SoundService.shared.playNote(selectedWords.count - 1)
        }
    }

    func submitGroup() {
        guard let puzzle, selectedWords.count == NexusConfig.wordsPerCluster else { return }

        if let cluster = puzzle.checkGroup(selectedWords) {
            solvedClusters.append(cluster)
            words.removeAll { cluster.words.contains($0) }
            selectedWords = []
            feedbackMessage = "✓ \(cluster.category)"
            HapticsService.success()
            SoundService.shared.playCelebration()

            if solvedClusters.count == NexusConfig.clustersPerPuzzle {
                completeGame()
            }

            clearFeedback()
        } else {
            mistakes += 1
            HapticsService.heavy()

            if puzzle.isOneAway(selectedWords) {
                feedbackMessage = "One away!"
                oneAwayCount += 1
            } else {
                feedbackMessage = "Not a group"
            }

            shakeSelected = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
                self?.shakeSelected = false
            }

            if mistakes >= NexusConfig.maxMistakes {
                revealRemaining()
            }

            clearFeedback()
        }
    }

    func shuffleWords() {
        let solved = Set(solvedClusters.flatMap(\.words))
        var remaining = words.filter { !solved.contains($0) }
        remaining.shuffle()
        words = remaining
        HapticsService.light()
    }

    func deselectAll() {
        selectedWords = []
        HapticsService.light()
    }

    func cleanup() {
        timer?.invalidate()
        timer = nil
    }

    private func revealRemaining() {
        guard let puzzle else { return }
        for cluster in puzzle.clusters where !solvedClusters.contains(where: { $0.id == cluster.id }) {
            solvedClusters.append(cluster)
        }
        words = []
        selectedWords = []
        completeGame()
    }

    private func completeGame() {
        isComplete = true
        timer?.invalidate()

        stars = NexusConfig.starsForMistakes(mistakes)
        let worldIndex = WordRealm.worldForLevel(level).id
        xpEarned = NexusConfig.xpForPuzzle(stars: stars, world: worldIndex)

        if stars >= 3 {
            showConfetti = true
            HapticsService.success()
        }

        updateStats()
        checkAchievements()
    }

    private func clearFeedback() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.feedbackMessage = nil
        }
    }

    private func updateStats() {
        guard let ctx = modelContext else { return }
        let descriptor = FetchDescriptor<StatsRecord>()
        guard let statsRecord = try? ctx.fetch(descriptor).first else { return }

        statsRecord.puzzlesCompleted += 1
        statsRecord.totalMoves += (mistakes + solvedClusters.count)
        if stars >= 3 { statsRecord.threeStarCount += 1 }
        statsRecord.totalXP += xpEarned
        statsRecord.totalTimePlayed += timerSeconds
        statsRecord.updateStreak()

        var best = statsRecord.bestMoves
        if let existing = best[level] {
            if mistakes < existing { best[level] = mistakes }
        } else {
            best[level] = mistakes
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
        case "first_link": return stats.puzzlesCompleted >= 1
        case "library_complete": return completedWorldCount(stats: stats) >= 1
        case "lab_complete": return completedWorldCount(stats: stats) >= 2
        case "observatory_complete": return completedWorldCount(stats: stats) >= 3
        case "archive_complete": return completedWorldCount(stats: stats) >= 4
        case "nexus_complete": return completedWorldCount(stats: stats) >= 5
        case "perfectionist": return stats.threeStarCount >= 10
        case "flawless_20": return stats.threeStarCount >= 20
        case "word_master": return stats.puzzlesCompleted * 3 >= 100
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
        case "speed_link": return timerSeconds <= 30 && isComplete && mistakes == 0
        case "one_away": return oneAwayCount >= 5
        default: return false
        }
    }

    private func completedWorldCount(stats: StatsRecord) -> Int {
        WordRealm.all.filter { world in
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
