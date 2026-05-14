import SwiftUI
import SwiftData

@MainActor
@Observable
final class ChallengeViewModel {
    var prompt: CreativePrompt?
    var userPattern: [Int] = []
    var selectedColorIndex: Int = 0
    var score: Double = 0
    var isComplete = false
    var isRunning = false
    var timeRemaining: Int = 60
    var stars: Int = 0
    var showTargetPreview = true
    var previewCountdown: Int = 3

    private(set) var challengeIndex: Int = 0
    private var isDaily = false
    private var isFreeCreate = false
    private var timer: Timer?
    private var previewTimer: Timer?

    func startChallenge(index: Int, isDaily: Bool, isFreeCreate: Bool) {
        self.challengeIndex = index
        self.isDaily = isDaily
        self.isFreeCreate = isFreeCreate

        let p = CreativePrompt.generate(index: index)
        prompt = p
        userPattern = Array(repeating: -1, count: p.gridSize * p.gridSize)
        selectedColorIndex = 0
        score = 0
        isComplete = false
        isRunning = false
        timeRemaining = p.timeLimit
        stars = 0

        if isFreeCreate {
            showTargetPreview = false
            isRunning = true
            startTimer()
        } else {
            showTargetPreview = true
            previewCountdown = 3
            startPreview()
        }
    }

    private func startPreview() {
        previewTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            Task { @MainActor in
                self.previewCountdown -= 1
                if self.previewCountdown <= 0 {
                    self.previewTimer?.invalidate()
                    self.previewTimer = nil
                    withAnimation(.easeOut(duration: 0.4)) {
                        self.showTargetPreview = false
                    }
                    self.isRunning = true
                    self.startTimer()
                }
            }
        }
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            Task { @MainActor in
                guard self.isRunning else { return }
                self.timeRemaining -= 1
                if self.timeRemaining <= 10 {
                    SoundService.shared.playCountdown()
                }
                if self.timeRemaining <= 0 {
                    self.completeChallenge()
                }
            }
        }
    }

    func tapCell(_ index: Int) {
        guard isRunning, !isComplete else { return }
        guard index >= 0, index < userPattern.count else { return }

        HapticsService.light()
        SoundService.shared.playTick()
        userPattern[index] = selectedColorIndex

        if !isFreeCreate && !userPattern.contains(-1) {
            completeChallenge()
        }
    }

    func selectColor(_ index: Int) {
        selectedColorIndex = index
        HapticsService.selection()
    }

    private func completeChallenge() {
        guard let prompt, !isComplete else { return }
        isComplete = true
        isRunning = false
        timer?.invalidate()
        timer = nil

        if isFreeCreate {
            score = 1.0
            stars = 3
        } else {
            score = prompt.similarityScore(userPattern: userPattern)
            stars = MuseConfig.starsForAccuracy(score)
        }

        if stars > 0 {
            HapticsService.success()
            SoundService.shared.playCelebration()
        } else {
            HapticsService.medium()
            SoundService.shared.playComplete()
        }
    }

    func updateStats(modelContext: ModelContext) {
        guard let prompt else { return }
        let season = Season.seasonForChallenge(challengeIndex)
        let xp = MuseConfig.xpForChallenge(stars: stars, seasonId: season.id)

        let statsDescriptor = FetchDescriptor<StatsRecord>()
        guard let stats = try? modelContext.fetch(statsDescriptor).first else { return }

        stats.challengesCompleted += 1
        stats.totalXP += xp
        stats.totalAccuracySum += Int(score * 100)
        stats.totalTimePlayed += (prompt.timeLimit - timeRemaining)

        if stars == 3 { stats.threeStarCount += 1 }

        var best = stats.bestStars
        if best[challengeIndex] == nil || stars > (best[challengeIndex] ?? 0) {
            best[challengeIndex] = stars
        }
        stats.bestStars = best

        var modes = stats.modesUsed
        modes.insert(prompt.mode.rawValue)
        stats.modesUsed = modes

        stats.updateStreak()

        if isDaily { stats.dailyChallengesCompleted += 1 }

        let settingsDescriptor = FetchDescriptor<SettingsRecord>()
        if let settings = try? modelContext.fetch(settingsDescriptor).first {
            if !isDaily && !isFreeCreate && challengeIndex >= settings.highestUnlockedLevel {
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

        if stats.challengesCompleted >= 1 && !existing.contains("first_spark") { toUnlock.append("first_spark") }

        let best = stats.bestStars
        if Season.all[0].challengeRange.allSatisfy({ best[$0] != nil }) && !existing.contains("spark_done") { toUnlock.append("spark_done") }
        if Season.all[1].challengeRange.allSatisfy({ best[$0] != nil }) && !existing.contains("flow_done") { toUnlock.append("flow_done") }
        if Season.all.count > 2 && Season.all[2].challengeRange.allSatisfy({ best[$0] != nil }) && !existing.contains("bloom_done") { toUnlock.append("bloom_done") }
        if Season.all.count > 3 && Season.all[3].challengeRange.allSatisfy({ best[$0] != nil }) && !existing.contains("storm_done") { toUnlock.append("storm_done") }
        if Season.all.allSatisfy({ s in s.challengeRange.allSatisfy { best[$0] != nil } }) && !existing.contains("opus_done") { toUnlock.append("opus_done") }

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

        if stats.modesUsed.count >= 5 && !existing.contains("all_modes") { toUnlock.append("all_modes") }

        if let prompt, timeRemaining >= (prompt.timeLimit - 10) && stars > 0 && !existing.contains("speed_demon") {
            toUnlock.append("speed_demon")
        }

        if stats.dailyChallengesCompleted >= 1 && !existing.contains("daily_first") { toUnlock.append("daily_first") }
        if stats.dailyChallengesCompleted >= 30 && !existing.contains("daily_30") { toUnlock.append("daily_30") }

        for id in toUnlock {
            modelContext.insert(AchievementRecord(achievementId: id))
        }
    }

    func cleanup() {
        timer?.invalidate()
        previewTimer?.invalidate()
    }
}
