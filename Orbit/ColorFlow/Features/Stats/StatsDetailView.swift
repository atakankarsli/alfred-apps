import SwiftUI
import SwiftData

struct StatsDetailView: View {
    @Environment(\.theme) private var theme
    @Query private var stats: [StatsRecord]
    @Query private var achievements: [AchievementRecord]

    private var s: StatsRecord? { stats.first }

    var body: some View {
        ScrollView { VStack(spacing: 16) { xpSection; missionStats; streakStats; performanceStats }.padding(16) }
        .themedBackground().navigationTitle("Statistics")
    }

    private var xpSection: some View {
        let xp = s?.totalXP ?? 0; let level = OrbitConfig.levelForXP(xp); let progress = OrbitConfig.xpProgressInLevel(xp); let title = OrbitConfig.xpLevelTitle(level)
        return VStack(spacing: 10) {
            HStack { VStack(alignment: .leading, spacing: 2) { Text("Level \(level)").font(.system(size: 24, weight: .black, design: .rounded)).primaryText(); Text(title).font(.system(size: 14, weight: .medium)).foregroundStyle(theme.colors.accent) }; Spacer(); Text("\(xp) XP").font(.system(size: 18, weight: .bold, design: .monospaced)).secondaryText() }
            ProgressView(value: progress).tint(theme.colors.accent)
            if level < OrbitConfig.xpPerLevel.count { Text("\(OrbitConfig.xpPerLevel[level] - xp) XP to next level").font(.caption).mutedText() }
        }.padding(16).background { RoundedRectangle(cornerRadius: 16).fill(theme.colors.accent.opacity(0.06)).overlay { RoundedRectangle(cornerRadius: 16).strokeBorder(theme.colors.accent.opacity(0.15), lineWidth: 1) } }
    }

    private var missionStats: some View {
        statsCard(title: "Missions", rows: [("Completed", "\(s?.puzzlesCompleted ?? 0)"), ("Perfect Orbits", "\(s?.threeStarCount ?? 0)"), ("Masses Placed", "\(s?.totalMoves ?? 0)"), ("Time Played", formatTime(s?.totalTimePlayed ?? 0)), ("Achievements", "\(achievements.count)/\(Achievement.all.count)")])
    }

    private var streakStats: some View {
        statsCard(title: "Streaks", rows: [("Current", "\(s?.currentStreak ?? 0) days"), ("Longest", "\(s?.longestStreak ?? 0) days"), ("Daily Missions", "\(s?.dailyPuzzlesCompleted ?? 0)")])
    }

    private var performanceStats: some View {
        let noHint = s?.noHintCompletions ?? 0; let total = max(s?.puzzlesCompleted ?? 1, 1)
        return statsCard(title: "Performance", rows: [("Avg Accuracy", avgAccuracy), ("No-Hint Solves", "\(noHint) (\(noHint * 100 / total)%)"), ("Hints Used", "\(s?.hintsUsed ?? 0)"), ("Sectors Unlocked", "\(sectorsUnlocked())/5")])
    }

    private var avgAccuracy: String {
        let best = s?.bestMoves ?? [:]; guard !best.isEmpty else { return "—" }
        let total = best.values.reduce(0, +)
        return "\(total / best.count)%"
    }

    private func statsCard(title: String, rows: [(String, String)]) -> some View {
        VStack(spacing: 0) {
            HStack { Text(title).font(.system(size: 15, weight: .bold, design: .rounded)).primaryText(); Spacer() }.padding(.bottom, 10)
            ForEach(Array(rows.enumerated()), id: \.offset) { _, row in HStack { Text(row.0).font(.system(size: 14)).secondaryText(); Spacer(); Text(row.1).font(.system(size: 14, weight: .semibold, design: .rounded)).primaryText() }.padding(.vertical, 6) }
        }.padding(16).background { RoundedRectangle(cornerRadius: 16).fill(theme.colors.surface.opacity(0.4)).overlay { RoundedRectangle(cornerRadius: 16).strokeBorder(theme.colors.boardBorder.opacity(0.12), lineWidth: 1) } }
    }

    private func formatTime(_ seconds: Int) -> String { let h = seconds / 3600; let m = (seconds % 3600) / 60; return h > 0 ? "\(h)h \(m)m" : "\(m)m" }
    private func sectorsUnlocked() -> Int { let best = s?.bestMoves ?? [:]; return Sector.all.filter { $0.levelRange.allSatisfy { best[$0] != nil } }.count }
}
