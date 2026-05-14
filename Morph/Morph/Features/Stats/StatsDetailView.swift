import SwiftUI
import SwiftData

struct StatsDetailView: View {
    @Environment(\.theme) private var theme
    @Query private var stats: [StatsRecord]
    @Query private var achievements: [AchievementRecord]
    @Query private var levels: [LevelRecord]

    private var s: StatsRecord? { stats.first }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                xpSection
                morphStats
                streakStats
                realmStats
            }
            .padding(16)
        }
        .themedBackground()
        .navigationTitle("Statistics")
    }

    private var xpSection: some View {
        let xp = s?.totalXP ?? 0
        let level = MorphConfig.levelForXP(xp)
        let progress = MorphConfig.xpProgressInLevel(xp)
        let title = MorphConfig.levelTitle(level)

        return VStack(spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Level \(level)").font(.system(size: 24, weight: .black, design: .rounded)).primaryText()
                    Text(title).font(.system(size: 14, weight: .medium)).foregroundStyle(theme.colors.accent)
                }
                Spacer()
                Text("\(xp) XP").font(.system(size: 18, weight: .bold, design: .monospaced)).secondaryText()
            }
            ProgressView(value: progress).tint(theme.colors.accent)
            if level < MorphConfig.xpPerLevel.count {
                Text("\(MorphConfig.xpPerLevel[level] - xp) XP to next level").font(.caption).mutedText()
            }
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 16).fill(theme.colors.accent.opacity(0.06))
                .overlay { RoundedRectangle(cornerRadius: 16).strokeBorder(theme.colors.accent.opacity(0.15), lineWidth: 1) }
        }
    }

    private var morphStats: some View {
        statsCard(title: "Morphs", rows: [
            ("Completed", "\(s?.levelsCompleted ?? 0)"),
            ("3-Star", "\(s?.threeStarCount ?? 0)"),
            ("Time Played", formatTime(s?.totalTimePlayed ?? 0)),
            ("Achievements", "\(achievements.count)/\(Achievement.all.count)"),
        ])
    }

    private var streakStats: some View {
        statsCard(title: "Streaks", rows: [
            ("Current", "\(s?.currentStreak ?? 0) days"),
            ("Longest", "\(s?.longestStreak ?? 0) days"),
            ("Daily Morphs", "\(s?.dailyMorphsCompleted ?? 0)"),
            ("Endless Best", "\(s?.endlessBest ?? 0)"),
        ])
    }

    private var realmStats: some View {
        statsCard(title: "Realms", rows: [
            ("Prisms", "\(s?.prismsCompleted ?? 0) levels"),
            ("Polygons", "\(s?.polygonsCompleted ?? 0) levels"),
            ("Fractals", "\(s?.fractalsCompleted ?? 0) levels"),
            ("Symmetry", "\(s?.symmetryCompleted ?? 0) levels"),
            ("Chaos", "\(s?.chaosCompleted ?? 0) levels"),
        ])
    }

    private func statsCard(title: String, rows: [(String, String)]) -> some View {
        VStack(spacing: 0) {
            HStack { Text(title).font(.system(size: 15, weight: .bold, design: .rounded)).primaryText(); Spacer() }.padding(.bottom, 10)
            ForEach(Array(rows.enumerated()), id: \.offset) { _, row in
                HStack {
                    Text(row.0).font(.system(size: 14)).secondaryText()
                    Spacer()
                    Text(row.1).font(.system(size: 14, weight: .semibold, design: .rounded)).primaryText()
                }
                .padding(.vertical, 6)
            }
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 16).fill(theme.colors.surface.opacity(0.4))
                .overlay { RoundedRectangle(cornerRadius: 16).strokeBorder(theme.colors.cardBorder.opacity(0.12), lineWidth: 1) }
        }
    }

    private func formatTime(_ seconds: Int) -> String {
        let h = seconds / 3600
        let m = (seconds % 3600) / 60
        if h > 0 { return "\(h)h \(m)m" }
        return "\(m)m"
    }
}
