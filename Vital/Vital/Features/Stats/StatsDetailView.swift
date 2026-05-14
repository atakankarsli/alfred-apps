import SwiftUI
import SwiftData

struct StatsDetailView: View {
    @Environment(\.theme) private var theme
    @Query private var stats: [StatsRecord]
    @Query private var achievements: [AchievementRecord]

    private var s: StatsRecord? { stats.first }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                xpSection
                gameStats
                healthStats
                performanceStats
            }
            .padding(16)
        }
        .themedBackground()
        .navigationTitle("Statistics")
    }

    private var xpSection: some View {
        let xp = s?.totalXP ?? 0
        let level = VitalConfig.levelForXP(xp)
        let progress = VitalConfig.xpProgressInLevel(xp)

        return VStack(spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Level \(level)").font(.system(size: 24, weight: .black, design: .rounded)).primaryText()
                    Text(VitalConfig.xpLevelTitle(level)).font(.system(size: 14, weight: .medium)).foregroundStyle(theme.colors.accent)
                }
                Spacer()
                Text("\(xp) XP").font(.system(size: 18, weight: .bold, design: .monospaced)).secondaryText()
            }
            ProgressView(value: progress).tint(theme.colors.accent)
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(theme.colors.accent.opacity(0.06))
                .overlay { RoundedRectangle(cornerRadius: 16).strokeBorder(theme.colors.accent.opacity(0.15), lineWidth: 1) }
        }
    }

    private var gameStats: some View {
        statsCard(title: "Games", rows: [
            ("Games Completed", "\(s?.gamesCompleted ?? 0)"),
            ("Eye Focus", "\(s?.eyeFocusGames ?? 0)"),
            ("Breath Sync", "\(s?.breathSyncGames ?? 0)"),
            ("Reflex Rush", "\(s?.reflexRushGames ?? 0)"),
            ("Posture Check", "\(s?.postureCheckGames ?? 0)"),
        ])
    }

    private var healthStats: some View {
        statsCard(title: "Health", rows: [
            ("Breath Cycles", "\(s?.totalBreathCycles ?? 0)"),
            ("Best Reflex", s?.bestReflexTime ?? 0 > 0 ? String(format: "%.0fms", (s?.bestReflexTime ?? 0) * 1000) : "—"),
            ("3-Star Games", "\(s?.threeStarCount ?? 0)"),
            ("Game Types Played", "\(s?.typesPlayed.count ?? 0)/\(GameType.allCases.count)"),
        ])
    }

    private var performanceStats: some View {
        statsCard(title: "Performance", rows: [
            ("Current Streak", "\(s?.currentStreak ?? 0) days"),
            ("Longest Streak", "\(s?.longestStreak ?? 0) days"),
            ("Time Playing", formatTime(s?.totalTimePlayed ?? 0)),
            ("Achievements", "\(achievements.count)/\(Achievement.all.count)"),
        ])
    }

    private func statsCard(title: String, rows: [(String, String)]) -> some View {
        VStack(spacing: 0) {
            HStack {
                Text(title).font(.system(size: 15, weight: .bold, design: .rounded)).primaryText()
                Spacer()
            }.padding(.bottom, 10)
            ForEach(Array(rows.enumerated()), id: \.offset) { _, row in
                HStack {
                    Text(row.0).font(.system(size: 14)).secondaryText()
                    Spacer()
                    Text(row.1).font(.system(size: 14, weight: .semibold, design: .rounded)).primaryText()
                }.padding(.vertical, 6)
            }
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(theme.colors.surface.opacity(0.4))
                .overlay { RoundedRectangle(cornerRadius: 16).strokeBorder(theme.colors.cardBorder.opacity(0.12), lineWidth: 1) }
        }
    }

    private func formatTime(_ seconds: Int) -> String {
        let h = seconds / 3600; let m = (seconds % 3600) / 60
        if h > 0 { return "\(h)h \(m)m" }
        return "\(m)m"
    }
}
