import SwiftUI
import SwiftData

@MainActor @Observable
final class MissionViewModel {
    let mission: Mission
    var objectivesDone: [Bool]
    var fogRevealed: [Bool]
    var starRating = 0
    var isComplete = false
    var showCelebration = false
    var elapsedTime: Int = 0

    private var timer: Timer?

    init(level: Int) {
        self.mission = MissionGenerator.mission(for: level)
        self.objectivesDone = Array(repeating: false, count: mission.objectives.count)
        self.fogRevealed = mission.fogPattern
    }

    var completedCount: Int { objectivesDone.filter { $0 }.count }
    var totalObjectives: Int { mission.objectives.count }
    var progress: Double { totalObjectives > 0 ? Double(completedCount) / Double(totalObjectives) : 0 }

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in self?.elapsedTime += 1 }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func completeObjective(_ index: Int) {
        guard index < objectivesDone.count, !objectivesDone[index] else { return }
        objectivesDone[index] = true
        revealFogCells(count: 3)
        HapticsService.medium()
        SoundService.shared.playDiscover()

        if completedCount == totalObjectives {
            finishMission()
        }
    }

    func revealFogCells(count: Int) {
        var hidden = fogRevealed.enumerated().filter { !$0.element }.map(\.offset)
        for _ in 0..<min(count, hidden.count) {
            guard !hidden.isEmpty else { break }
            let pick = Int.random(in: 0..<hidden.count)
            fogRevealed[hidden[pick]] = true
            hidden.remove(at: pick)
        }
    }

    func finishMission() {
        stopTimer()
        starRating = QuestConfig.starsForMission(
            objectivesCompleted: completedCount,
            totalObjectives: totalObjectives,
            timeSeconds: elapsedTime
        )
        isComplete = true
        showCelebration = true
        HapticsService.success()
        SoundService.shared.playCelebration()
    }

    func saveResults(modelContext: ModelContext) {
        guard let stats = (try? modelContext.fetch(FetchDescriptor<StatsRecord>()))?.first else { return }
        stats.missionsCompleted += 1
        stats.totalXP += mission.xpReward
        stats.totalObjectivesCompleted += completedCount
        stats.fogCellsCleared += fogRevealed.filter { $0 }.count
        stats.totalTimePlayed += elapsedTime

        if starRating >= 3 { stats.threeStarCount += 1 }

        stats.regionsPlayed.insert(mission.region.name)
        stats.typesUsed.insert(mission.type.rawValue)

        stats.updateStreak()

        let settings = (try? modelContext.fetch(FetchDescriptor<SettingsRecord>()))?.first
        let nextLevel = (settings?.currentLevelIndex ?? 0) + 1
        settings?.currentLevelIndex = nextLevel
        if nextLevel > (settings?.highestUnlockedLevel ?? 0) {
            settings?.highestUnlockedLevel = nextLevel
        }

        checkAchievements(stats: stats, modelContext: modelContext)
    }

    private func checkAchievements(stats: StatsRecord, modelContext: ModelContext) {
        let existing = Set((try? modelContext.fetch(FetchDescriptor<AchievementRecord>()))?.map(\.achievementId) ?? [])
        var toUnlock: [String] = []

        if stats.missionsCompleted >= 1 { toUnlock.append("first_step") }
        if stats.typesUsed.count >= 5 { toUnlock.append("all_types") }
        if starRating >= 3 { toUnlock.append("triple_star") }
        if stats.threeStarCount >= 10 { toUnlock.append("star_10") }
        if stats.threeStarCount >= 50 { toUnlock.append("star_50") }
        if stats.currentStreak >= 3 { toUnlock.append("streak_3") }
        if stats.currentStreak >= 7 { toUnlock.append("streak_7") }
        if stats.currentStreak >= 30 { toUnlock.append("streak_30") }
        if stats.currentStreak >= 100 { toUnlock.append("streak_100") }
        if stats.totalXP >= 100 { toUnlock.append("xp_100") }
        if stats.totalXP >= 500 { toUnlock.append("xp_500") }
        if stats.totalXP >= 2000 { toUnlock.append("xp_2000") }
        if stats.totalXP >= 10000 { toUnlock.append("xp_10000") }
        if stats.regionsPlayed.count >= Region.all.count { toUnlock.append("all_regions") }
        if fogRevealed.allSatisfy({ $0 }) { toUnlock.append("fog_clear") }

        for id in toUnlock where !existing.contains(id) {
            modelContext.insert(AchievementRecord(achievementId: id))
        }
    }
}
