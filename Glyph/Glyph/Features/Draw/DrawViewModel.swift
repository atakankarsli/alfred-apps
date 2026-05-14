import SwiftUI
import SwiftData

@MainActor
@Observable
final class DrawViewModel {
    var symbol: SymbolDefinition?
    var userStrokes: [[CGPoint]] = []
    var currentStroke: [CGPoint] = []
    var score: Double = 0
    var isComplete = false
    var isRunning = false
    var timeRemaining: Int = 30
    var stars: Int = 0
    var showGuide = true
    var guideOpacity: Double = 0.4
    var canvasSize: CGSize = .zero

    private(set) var challengeIndex: Int = 0
    private var isDaily = false
    private var timer: Timer?
    private var startTime: Date?

    func startChallenge(index: Int, isDaily: Bool) {
        self.challengeIndex = index
        self.isDaily = isDaily

        let s = SymbolData.symbol(for: index)
        symbol = s
        userStrokes = []
        currentStroke = []
        score = 0
        isComplete = false
        isRunning = true
        timeRemaining = timeLimitFor(difficulty: s.difficulty)
        stars = 0
        showGuide = true
        guideOpacity = guideOpacityFor(difficulty: s.difficulty)
        startTime = .now

        startTimer()
    }

    private func timeLimitFor(difficulty: Int) -> Int {
        switch difficulty {
        case 1: 30
        case 2: 25
        case 3: 20
        default: 15
        }
    }

    private func guideOpacityFor(difficulty: Int) -> Double {
        switch difficulty {
        case 1: 0.4
        case 2: 0.25
        case 3: 0.12
        default: 0.0
        }
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            Task { @MainActor in
                guard self.isRunning else { return }
                self.timeRemaining -= 1
                if self.timeRemaining <= 0 {
                    self.completeChallenge()
                }
            }
        }
    }

    func beginStroke(at point: CGPoint) {
        guard isRunning, !isComplete else { return }
        currentStroke = [point]
    }

    func continueStroke(to point: CGPoint) {
        guard isRunning, !isComplete else { return }
        currentStroke.append(point)
    }

    func endStroke() {
        guard isRunning, !isComplete, currentStroke.count >= 2 else {
            currentStroke = []
            return
        }
        HapticsService.light()
        SoundService.shared.playStroke()
        userStrokes.append(currentStroke)
        currentStroke = []
    }

    func undoLastStroke() {
        guard !userStrokes.isEmpty else { return }
        userStrokes.removeLast()
        HapticsService.selection()
    }

    func submitDrawing() {
        guard isRunning else { return }
        completeChallenge()
    }

    private func completeChallenge() {
        guard let symbol, !isComplete else { return }
        isComplete = true
        isRunning = false
        timer?.invalidate()
        timer = nil

        score = StrokeRecognizer.score(
            userStrokes: userStrokes,
            referenceStrokes: symbol.strokes,
            canvasSize: canvasSize
        )
        stars = GlyphConfig.starsForAccuracy(score)

        if stars > 0 {
            HapticsService.success()
            SoundService.shared.playCelebration()
        } else {
            HapticsService.medium()
            SoundService.shared.playFail()
        }
    }

    var elapsedSeconds: Int {
        guard let start = startTime else { return 0 }
        let limit = timeLimitFor(difficulty: symbol?.difficulty ?? 1)
        return limit - timeRemaining
    }

    func updateStats(modelContext: ModelContext) {
        guard let symbol else { return }
        let catIndex = SymbolCategory.allCases.firstIndex(of: symbol.category) ?? 0
        let xp = GlyphConfig.xpForChallenge(stars: stars, categoryIndex: catIndex)

        let statsDescriptor = FetchDescriptor<StatsRecord>()
        guard let stats = try? modelContext.fetch(statsDescriptor).first else { return }

        stats.symbolsCompleted += 1
        stats.totalXP += xp
        stats.totalAccuracySum += Int(score * 100)
        stats.totalTimePlayed += elapsedSeconds

        if stars == 3 { stats.threeStarCount += 1 }

        var best = stats.bestStars
        if best[challengeIndex] == nil || stars > (best[challengeIndex] ?? 0) {
            best[challengeIndex] = stars
        }
        stats.bestStars = best

        var cats = stats.categoriesUsed
        cats.insert(symbol.category.rawValue)
        stats.categoriesUsed = cats

        stats.updateStreak()
        if isDaily { stats.dailyChallengesCompleted += 1 }

        let settingsDescriptor = FetchDescriptor<SettingsRecord>()
        if let settings = try? modelContext.fetch(settingsDescriptor).first {
            if !isDaily && challengeIndex >= settings.highestUnlockedLevel {
                settings.highestUnlockedLevel = challengeIndex + 1
            }
            settings.currentLevelIndex = max(settings.currentLevelIndex, challengeIndex + 1)
        }
    }

    func checkAchievements(modelContext: ModelContext) {
        let descriptor = FetchDescriptor<AchievementRecord>()
        let existing = Set((try? modelContext.fetch(descriptor))?.map(\.achievementId) ?? [])
        let statsDescriptor = FetchDescriptor<StatsRecord>()
        guard let stats = try? modelContext.fetch(statsDescriptor).first else { return }

        var toUnlock: [String] = []

        if stats.symbolsCompleted >= 1 && !existing.contains("first_glyph") { toUnlock.append("first_glyph") }

        let best = stats.bestStars
        for (i, cat) in SymbolCategory.allCases.enumerated() {
            let ids = ["runes_done", "hieroglyphs_done", "kanji_done", "geometry_done", "alchemy_done"]
            if i < ids.count && cat.challengeRange.allSatisfy({ best[$0] != nil }) && !existing.contains(ids[i]) {
                toUnlock.append(ids[i])
            }
        }

        if SymbolCategory.allCases.allSatisfy({ cat in cat.challengeRange.allSatisfy { best[$0] != nil } }) && !existing.contains("all_done") {
            toUnlock.append("all_done")
        }

        if stats.threeStarCount >= 10 && !existing.contains("perfectionist") { toUnlock.append("perfectionist") }
        if stats.threeStarCount >= 50 && !existing.contains("star_collector") { toUnlock.append("star_collector") }
        if stats.currentStreak >= 3 && !existing.contains("streak_3") { toUnlock.append("streak_3") }
        if stats.currentStreak >= 7 && !existing.contains("streak_7") { toUnlock.append("streak_7") }
        if stats.currentStreak >= 30 && !existing.contains("streak_30") { toUnlock.append("streak_30") }
        if stats.currentStreak >= 100 && !existing.contains("streak_100") { toUnlock.append("streak_100") }
        if stats.totalXP >= 100 && !existing.contains("xp_100") { toUnlock.append("xp_100") }
        if stats.totalXP >= 500 && !existing.contains("xp_500") { toUnlock.append("xp_500") }
        if stats.totalXP >= 2000 && !existing.contains("xp_2000") { toUnlock.append("xp_2000") }
        if stats.totalXP >= 10000 && !existing.contains("xp_10000") { toUnlock.append("xp_10000") }
        if stats.categoriesUsed.count >= 5 && !existing.contains("all_categories") { toUnlock.append("all_categories") }
        if elapsedSeconds <= 10 && stars == 3 && !existing.contains("speed_draw") { toUnlock.append("speed_draw") }
        if stats.dailyChallengesCompleted >= 1 && !existing.contains("daily_first") { toUnlock.append("daily_first") }

        for id in toUnlock {
            modelContext.insert(AchievementRecord(achievementId: id))
        }
    }

    func cleanup() {
        timer?.invalidate()
    }
}
