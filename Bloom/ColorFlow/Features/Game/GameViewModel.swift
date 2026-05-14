import SwiftUI
import SwiftData

@MainActor
@Observable
final class GardenViewModel {
    var garden: Garden?
    var selectedEmotion: Emotion?
    var gardenIndex: Int = 0
    var isComplete = false
    var stars: Int = 0
    var xpEarned: Int = 0
    var showConfetti = false
    var newAchievements: [Achievement] = []
    var timerSeconds: Int = 0
    var plantsPlanted: Int = 0
    var showEmotionPicker = false
    var selectedPosition: Int?
    var growingCells: Set<Int> = []
    var wateringCell: Int?

    private var modelContext: ModelContext?
    private var timer: Timer?
    private var showTimer = true

    func startGarden(index: Int, modelContext: ModelContext, showTimer: Bool) {
        self.gardenIndex = index
        self.modelContext = modelContext
        self.showTimer = showTimer

        let seasonIndex = Season.seasonForGarden(index).id
        garden = Garden.generate(seasonIndex: seasonIndex, gardenIndex: index)

        isComplete = false
        stars = 0
        xpEarned = 0
        showConfetti = false
        newAchievements = []
        timerSeconds = 0
        plantsPlanted = 0
        selectedEmotion = nil
        showEmotionPicker = false
        selectedPosition = nil
        growingCells = []
        wateringCell = nil

        startTimer()
    }

    func selectCell(at position: Int) {
        guard garden != nil, !isComplete else { return }

        if let existingPlant = garden?.plantAt(position) {
            if !existingPlant.isFullyGrown {
                waterPlant(at: position)
            }
            return
        }

        selectedPosition = position
        showEmotionPicker = true
        HapticsService.light()
    }

    func plantEmotion(_ emotion: Emotion) {
        guard var g = garden, let pos = selectedPosition else { return }

        g.addPlant(emotion: emotion, at: pos)
        garden = g
        plantsPlanted += 1

        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            growingCells.insert(pos)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.growingCells.remove(pos)
        }

        let seasonIndex = Season.seasonForGarden(gardenIndex).id
        xpEarned += BloomConfig.xpForPlanting(emotion: emotion, season: seasonIndex)

        HapticsService.medium()
        let note = Emotion.all.firstIndex(where: { $0.id == emotion.id }) ?? 0
        SoundService.shared.playNote(note - 2)

        showEmotionPicker = false
        selectedPosition = nil
        selectedEmotion = nil

        checkCompletion()
    }

    func waterPlant(at position: Int) {
        guard var g = garden else { return }

        let beforeStage = g.plantAt(position)?.growthStage ?? 0
        g.waterPlant(at: position)
        garden = g
        let afterStage = g.plantAt(position)?.growthStage ?? 0

        if afterStage > beforeStage {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                growingCells.insert(position)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.growingCells.remove(position)
            }
            SoundService.shared.playWordFound()
            HapticsService.success()
        } else {
            withAnimation(.easeOut(duration: 0.2)) {
                wateringCell = position
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.wateringCell = nil
            }
            HapticsService.soft()
            SoundService.shared.playTap()
        }

        checkCompletion()
    }

    func cancelEmotionPicker() {
        showEmotionPicker = false
        selectedPosition = nil
        selectedEmotion = nil
    }

    func cleanup() {
        timer?.invalidate()
        timer = nil
    }

    private func checkCompletion() {
        guard let g = garden else { return }
        guard g.isComplete && g.fullyGrownCount == g.totalCells else { return }

        isComplete = true
        timer?.invalidate()

        stars = BloomConfig.starsForGarden(grownCount: g.fullyGrownCount, totalCells: g.totalCells)
        let seasonIndex = Season.seasonForGarden(gardenIndex).id
        xpEarned += BloomConfig.xpForFullGarden(stars: stars, season: seasonIndex)

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
        statsRecord.totalMoves += plantsPlanted
        if stars >= 3 { statsRecord.threeStarCount += 1 }
        statsRecord.totalXP += xpEarned
        statsRecord.totalTimePlayed += timerSeconds
        statsRecord.updateStreak()

        var best = statsRecord.bestMoves
        if let existing = best[gardenIndex] {
            if plantsPlanted < existing { best[gardenIndex] = plantsPlanted }
        } else {
            best[gardenIndex] = plantsPlanted
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
        case "first_seed": return stats.puzzlesCompleted >= 0 && plantsPlanted >= 1
        case "spring_complete": return completedSeasonCount(stats: stats) >= 1
        case "summer_complete": return completedSeasonCount(stats: stats) >= 2
        case "autumn_complete": return completedSeasonCount(stats: stats) >= 3
        case "winter_complete": return completedSeasonCount(stats: stats) >= 4
        case "gardener_10": return stats.threeStarCount >= 10
        case "gardener_50": return stats.threeStarCount >= 50
        case "garden_perfect": return stats.threeStarCount >= 10
        case "emotion_variety":
            if let g = garden {
                let unique = Set(g.plants.map(\.emotionId))
                return unique.count >= 8
            }
            return false
        case "joy_lover": return true
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
        case "night_gardener":
            let hour = Calendar.current.component(.hour, from: .now)
            return hour >= 22
        case "zen_garden":
            if let g = garden, g.isComplete {
                let types = Set(g.plants.map(\.emotionId))
                return types.isSubset(of: ["calm", "peace"])
            }
            return false
        case "rainbow_garden":
            if let g = garden {
                return Set(g.plants.map(\.emotionId)).count >= 8
            }
            return false
        default: return false
        }
    }

    private func completedSeasonCount(stats: StatsRecord) -> Int {
        Season.all.filter { season in
            season.gardenRange.allSatisfy { stats.bestMoves[$0] != nil }
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
