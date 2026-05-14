import SwiftUI
import SwiftData

@MainActor @Observable
final class RitualViewModel {
    var ritualSet: RitualSet?
    var completedHabits: Set<Int> = []
    var isComplete = false
    var stars: Int = 0
    private var level: Int = 0
    private var mode: RitualMode = .ritual(index: 0)

    func startRitual(mode: RitualMode, modelContext: ModelContext) {
        self.mode = mode
        switch mode {
        case .ritual(let i): level = i
        case .daily: level = (Calendar.current.ordinality(of: .day, in: .era, for: .now) ?? 0) % RitualConfig.totalRituals
        case .quickRitual: level = Int.random(in: 0..<RitualConfig.totalRituals)
        }
        ritualSet = RitualSet.generate(level: level); completedHabits = []; isComplete = false; stars = 0
    }

    func toggleHabit(_ id: Int) {
        guard !isComplete else { return }
        if completedHabits.contains(id) { completedHabits.remove(id); HapticsService.light() }
        else { completedHabits.insert(id); HapticsService.success(); SoundService.shared.playTap() }
        if let r = ritualSet, completedHabits.count == r.habits.count { completeRitual() }
    }

    func finishEarly() { completeRitual() }

    private func completeRitual() {
        guard let r = ritualSet, !isComplete else { return }
        isComplete = true
        stars = RitualConfig.starsForCompletion(r.completionRatio(completed: completedHabits))
        if stars >= 2 { SoundService.shared.playCelebration(); HapticsService.success() } else { HapticsService.medium() }
    }

    func updateStats(modelContext: ModelContext) {
        let phase = RitualPhase.phaseForRitual(level)
        let xp = RitualConfig.xpForRitual(stars: stars, phase: phase.id)
        let desc = FetchDescriptor<StatsRecord>()
        guard let stats = try? modelContext.fetch(desc).first else { return }
        stats.puzzlesCompleted += 1; stats.totalXP += xp; stats.totalMoves += completedHabits.count
        if stars == 3 { stats.threeStarCount += 1 }
        var best = stats.bestMoves ?? [:]; if best[level] == nil || stars > (best[level] ?? 0) { best[level] = stars }
        stats.bestMoves = best; stats.updateStreak()
        if case .daily = mode { stats.dailyPuzzlesCompleted += 1 }
        let sd = FetchDescriptor<SettingsRecord>()
        if let s = try? modelContext.fetch(sd).first {
            if case .ritual(let idx) = mode, idx >= s.highestUnlockedLevel { s.highestUnlockedLevel = idx + 1 }
            s.currentLevelIndex = max(s.currentLevelIndex, level + 1)
        }
    }

    func checkAchievements(modelContext: ModelContext) {
        let desc = FetchDescriptor<AchievementRecord>()
        let existing = (try? modelContext.fetch(desc))?.map(\.achievementId) ?? []
        let sd = FetchDescriptor<StatsRecord>()
        guard let stats = try? modelContext.fetch(sd).first else { return }
        var u: [String] = []
        if stats.puzzlesCompleted >= 1 && !existing.contains("first_ritual") { u.append("first_ritual") }
        if stars == 3 && !existing.contains("triple_star") { u.append("triple_star") }
        if stats.threeStarCount >= 10 && !existing.contains("star_collector") { u.append("star_collector") }
        if stats.totalXP >= 100 && !existing.contains("xp_100") { u.append("xp_100") }
        if stats.totalXP >= 500 && !existing.contains("xp_500") { u.append("xp_500") }
        if stats.totalXP >= 2000 && !existing.contains("xp_2000") { u.append("xp_2000") }
        if stats.currentStreak >= 3 && !existing.contains("streak_3") { u.append("streak_3") }
        if stats.currentStreak >= 7 && !existing.contains("streak_7") { u.append("streak_7") }
        if stats.currentStreak >= 30 && !existing.contains("streak_30") { u.append("streak_30") }
        if stats.puzzlesCompleted >= 40 && !existing.contains("half_way") { u.append("half_way") }
        if stats.puzzlesCompleted >= 80 && !existing.contains("completionist") { u.append("completionist") }
        let best = stats.bestMoves ?? [:]
        if RitualPhase.all[0].ritualRange.allSatisfy({ best[$0] != nil }) && !existing.contains("dawn_master") { u.append("dawn_master") }
        if RitualPhase.all[1].ritualRange.allSatisfy({ best[$0] != nil }) && !existing.contains("vitality_master") { u.append("vitality_master") }
        if RitualPhase.all[2].ritualRange.allSatisfy({ best[$0] != nil }) && !existing.contains("flow_master") { u.append("flow_master") }
        if RitualPhase.all[3].ritualRange.allSatisfy({ best[$0] != nil }) && !existing.contains("dusk_master") { u.append("dusk_master") }
        let h = Calendar.current.component(.hour, from: .now)
        if h >= 0 && h < 5 && !existing.contains("night_owl") { u.append("night_owl") }
        if h >= 4 && h < 6 && !existing.contains("early_bird") { u.append("early_bird") }
        for id in u { modelContext.insert(AchievementRecord(achievementId: id, unlockedAt: .now)) }
    }
}
