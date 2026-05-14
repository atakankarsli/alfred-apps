import SwiftUI
import SwiftData

@MainActor @Observable
final class GrowthViewModel {
    var params = GrowthParameters()
    var isGrowing = false
    var growthProgress: Double = 0
    var grownCrystal: Crystal?
    var showResult = false

    private var growthTimer: Timer?

    func startGrowth() {
        guard !isGrowing else { return }
        isGrowing = true
        growthProgress = 0
        grownCrystal = nil
        showResult = false
        HapticsService.medium()
        SoundService.shared.playGrow()

        growthTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                guard let self else { return }
                self.growthProgress += 0.02
                if self.growthProgress >= 1.0 {
                    self.growthTimer?.invalidate()
                    self.completeGrowth()
                }
            }
        }
    }

    private func completeGrowth() {
        let crystal = CrystalEngine.grow(params: params)
        grownCrystal = crystal
        isGrowing = false
        showResult = true

        if crystal.stars >= 3 {
            HapticsService.success()
            SoundService.shared.playCelebration()
        } else {
            HapticsService.light()
            SoundService.shared.playChime()
        }
    }

    func saveCrystal(stats: StatsRecord?, context: ModelContext) {
        guard let crystal = grownCrystal, let stats else { return }
        stats.recordCrystal(crystal)
        checkAchievements(stats: stats, crystal: crystal, context: context)
        showResult = false
        grownCrystal = nil
    }

    func reset() {
        growthTimer?.invalidate()
        isGrowing = false
        growthProgress = 0
        grownCrystal = nil
        showResult = false
    }

    private func checkAchievements(stats: StatsRecord, crystal: Crystal, context: ModelContext) {
        let unlocked = (try? context.fetch(FetchDescriptor<AchievementRecord>()))?.map(\.achievementId) ?? []
        var newIds: [String] = []

        if stats.crystalsGrown >= 1 && !unlocked.contains("first_crystal") { newIds.append("first_crystal") }
        if stats.quartzGrown >= 10 && !unlocked.contains("quartz_10") { newIds.append("quartz_10") }
        if stats.berylGrown >= 10 && !unlocked.contains("beryl_10") { newIds.append("beryl_10") }
        if stats.corundumGrown >= 10 && !unlocked.contains("corundum_10") { newIds.append("corundum_10") }
        if stats.familiesPlayed.count >= 5 && !unlocked.contains("all_families") { newIds.append("all_families") }
        if crystal.stars >= 3 && !unlocked.contains("triple_star") { newIds.append("triple_star") }
        if stats.threeStarCount >= 10 && !unlocked.contains("star_10") { newIds.append("star_10") }
        if stats.threeStarCount >= 50 && !unlocked.contains("star_50") { newIds.append("star_50") }
        if stats.currentStreak >= 3 && !unlocked.contains("streak_3") { newIds.append("streak_3") }
        if stats.currentStreak >= 7 && !unlocked.contains("streak_7") { newIds.append("streak_7") }
        if stats.currentStreak >= 30 && !unlocked.contains("streak_30") { newIds.append("streak_30") }
        if stats.currentStreak >= 100 && !unlocked.contains("streak_100") { newIds.append("streak_100") }
        if stats.totalXP >= 100 && !unlocked.contains("xp_100") { newIds.append("xp_100") }
        if stats.totalXP >= 500 && !unlocked.contains("xp_500") { newIds.append("xp_500") }
        if stats.totalXP >= 2000 && !unlocked.contains("xp_2000") { newIds.append("xp_2000") }
        if stats.totalXP >= 10000 && !unlocked.contains("xp_10000") { newIds.append("xp_10000") }
        if crystal.type == .diamond && !unlocked.contains("diamond") { newIds.append("diamond") }
        if crystal.temperature >= 0.95 && !unlocked.contains("hot_crystal") { newIds.append("hot_crystal") }
        if crystal.temperature <= 0.05 && !unlocked.contains("cold_crystal") { newIds.append("cold_crystal") }
        if stats.crystalsGrown >= 20 && !unlocked.contains("collection_20") { newIds.append("collection_20") }

        for id in newIds {
            context.insert(AchievementRecord(achievementId: id))
        }
    }
}
