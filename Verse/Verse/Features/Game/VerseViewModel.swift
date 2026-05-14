import SwiftUI
import SwiftData

@MainActor
@Observable
final class VerseViewModel {
    var puzzle: VersePuzzle?
    var level: Int = 0
    var lines: [[WordTile]] = []
    var availableTiles: [WordTile] = []
    var isComplete = false
    var stars: Int = 0
    var xpEarned: Int = 0
    var showConfetti = false
    var newAchievements: [Achievement] = []
    var timerSeconds: Int = 0

    private var modelContext: ModelContext?
    private var timer: Timer?
    private var showTimer = true

    var syllablesPerLine: [Int] {
        guard let puzzle else { return [] }
        return lines.enumerated().map { idx, line in
            (line.reduce(0) { $0 + $1.syllables }, puzzle.form.syllablesPerLine[idx])
        }.map(\.0)
    }

    func currentSyllables(line: Int) -> Int {
        guard line < lines.count else { return 0 }
        return lines[line].reduce(0) { $0 + $1.syllables }
    }

    func targetSyllables(line: Int) -> Int {
        guard let puzzle, line < puzzle.form.syllablesPerLine.count else { return 0 }
        return puzzle.form.syllablesPerLine[line]
    }

    func lineMatchesSyllables(_ lineIdx: Int) -> Bool {
        currentSyllables(line: lineIdx) == targetSyllables(line: lineIdx)
    }

    func rhymeMatches(_ lineIdx: Int) -> Bool {
        guard let puzzle, let scheme = puzzle.form.rhymeScheme else { return true }
        let currentGroup = scheme[lineIdx]
        let currentLastWord = lines[lineIdx].last?.word

        for prevIdx in 0..<lineIdx {
            if scheme[prevIdx] == currentGroup {
                let prevLastWord = lines[prevIdx].last?.word
                if let a = prevLastWord, let b = currentLastWord {
                    return RhymeEngine.rhymes(a, b)
                }
                return prevLastWord == nil && currentLastWord == nil
            }
        }
        return true
    }

    var allLinesComplete: Bool {
        guard let puzzle else { return false }
        for i in 0..<puzzle.form.lineCount {
            if !lineMatchesSyllables(i) { return false }
        }
        return true
    }

    var allRhymesMatch: Bool {
        guard let puzzle else { return false }
        guard puzzle.form.requiresRhyme else { return true }
        for i in 0..<puzzle.form.lineCount {
            if !rhymeMatches(i) { return false }
        }
        return true
    }

    func startGame(level: Int, modelContext: ModelContext, showTimer: Bool) {
        self.level = level
        self.modelContext = modelContext
        self.showTimer = showTimer

        let puzzle = VersePuzzle.generate(level: level)
        self.puzzle = puzzle

        lines = Array(repeating: [], count: puzzle.form.lineCount)
        availableTiles = puzzle.tiles
        isComplete = false
        stars = 0
        xpEarned = 0
        showConfetti = false
        newAchievements = []
        timerSeconds = 0

        startTimer()
    }

    func placeTile(_ tile: WordTile, onLine lineIdx: Int) {
        guard !isComplete else { return }
        guard lineIdx < lines.count else { return }

        if let availIdx = availableTiles.firstIndex(of: tile) {
            availableTiles.remove(at: availIdx)
            lines[lineIdx].append(tile)
            HapticsService.soft()
            SoundService.shared.playTileDrop()
        }

        checkCompletion()
    }

    func removeTile(_ tile: WordTile, fromLine lineIdx: Int) {
        guard !isComplete else { return }
        guard lineIdx < lines.count else { return }

        if let idx = lines[lineIdx].firstIndex(of: tile) {
            lines[lineIdx].remove(at: idx)
            availableTiles.append(tile)
            HapticsService.light()
        }
    }

    func cleanup() {
        timer?.invalidate()
        timer = nil
    }

    private func checkCompletion() {
        guard allLinesComplete else { return }
        guard allRhymesMatch || !(puzzle?.form.requiresRhyme ?? false) else { return }

        isComplete = true
        timer?.invalidate()

        let allUsed = availableTiles.filter { !$0.isBonus }.isEmpty
        let bonusUsed = availableTiles.isEmpty
        let perfectForm = allLinesComplete && allRhymesMatch
        stars = VerseConfig.starsForCompletion(perfectForm: perfectForm, allWordsUsed: allUsed, bonusUsed: bonusUsed)

        let chapterIdx = Chapter.chapterForLevel(level).id
        xpEarned = VerseConfig.xpForPuzzle(stars: stars, chapter: chapterIdx)

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
        guard let stats = try? ctx.fetch(FetchDescriptor<StatsRecord>()).first else { return }

        stats.poemsCompleted += 1
        if stars >= 3 { stats.threeStarCount += 1 }
        stats.totalXP += xpEarned
        stats.totalTimePlayed += timerSeconds
        stats.updateStreak()

        var best = stats.bestStars
        if let existing = best[level] {
            if stars > existing { best[level] = stars }
        } else {
            best[level] = stars
        }
        stats.bestStars = best

        try? ctx.save()
    }

    private func checkAchievements() {
        guard let ctx = modelContext else { return }
        guard let stats = try? ctx.fetch(FetchDescriptor<StatsRecord>()).first,
              let unlocked = try? ctx.fetch(FetchDescriptor<AchievementRecord>()) else { return }

        let unlockedIds = Set(unlocked.map(\.achievementId))

        for achievement in Achievement.all where !unlockedIds.contains(achievement.id) {
            if shouldUnlock(achievement, stats: stats) {
                ctx.insert(AchievementRecord(achievementId: achievement.id))
                newAchievements.append(achievement)
                xpEarned += achievement.tier.xpReward
                stats.totalXP += achievement.tier.xpReward
            }
        }

        try? ctx.save()
    }

    private func shouldUnlock(_ achievement: Achievement, stats: StatsRecord) -> Bool {
        switch achievement.id {
        case "first_verse": return stats.poemsCompleted >= 1
        case "whisper_done": return completedChapterCount(stats: stats) >= 1
        case "murmur_done": return completedChapterCount(stats: stats) >= 2
        case "rhythm_done": return completedChapterCount(stats: stats) >= 3
        case "verse_done": return completedChapterCount(stats: stats) >= 4
        case "opus_done": return completedChapterCount(stats: stats) >= 5
        case "perfectionist": return stats.threeStarCount >= 10
        case "star_collector": return stats.threeStarCount >= 50
        case "streak_3": return stats.currentStreak >= 3
        case "streak_7": return stats.currentStreak >= 7
        case "streak_30": return stats.currentStreak >= 30
        case "streak_100": return stats.currentStreak >= 100
        case "xp_100": return stats.totalXP >= 100
        case "xp_500": return stats.totalXP >= 500
        case "xp_2000": return stats.totalXP >= 2000
        case "xp_10000": return stats.totalXP >= 10000
        case "daily_first": return stats.dailyPoemsCompleted >= 1
        case "daily_30": return stats.dailyPoemsCompleted >= 30
        case "speed_poet": return timerSeconds <= 15 && isComplete
        case "all_forms": return completedChapterCount(stats: stats) >= 5
        default: return false
        }
    }

    private func completedChapterCount(stats: StatsRecord) -> Int {
        Chapter.all.filter { chapter in
            chapter.levelRange.allSatisfy { stats.bestStars[$0] != nil }
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
