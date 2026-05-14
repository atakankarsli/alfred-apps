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
                rhythmStats
                streakStats
                performanceStats
            }
            .padding(16)
        }
        .themedBackground()
        .navigationTitle("Statistics")
    }

    private var xpSection: some View {
        let xp = s?.totalXP ?? 0
        let level = PulseConfig.levelForXP(xp)
        let progress = PulseConfig.xpProgressInLevel(xp)
        let title = PulseConfig.xpLevelTitle(level)

        return VStack(spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Level \(level)")
                        .font(.system(size: 24, weight: .black, design: .rounded)).primaryText()
                    Text(title)
                        .font(.system(size: 14, weight: .medium)).foregroundStyle(theme.colors.accent)
                }
                Spacer()
                Text("\(xp) XP")
                    .font(.system(size: 18, weight: .bold, design: .monospaced)).secondaryText()
            }
            ProgressView(value: progress).tint(theme.colors.accent)
            if level < PulseConfig.xpPerLevel.count {
                Text("\(PulseConfig.xpPerLevel[level] - xp) XP to next level")
                    .font(.caption).mutedText()
            }
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(theme.colors.accent.opacity(0.06))
                .overlay { RoundedRectangle(cornerRadius: 16).strokeBorder(theme.colors.accent.opacity(0.15), lineWidth: 1) }
        }
    }

    private var rhythmStats: some View {
        statsCard(title: "Rhythm", rows: [
            ("Tracks Completed", "\(s?.tracksCompleted ?? 0)"),
            ("Total Hits", "\(s?.totalHits ?? 0)"),
            ("Perfect Hits", "\(s?.perfectHits ?? 0)"),
            ("Max Combo", "\(s?.maxCombo ?? 0)×"),
            ("3-Star Tracks", "\(s?.threeStarCount ?? 0)"),
        ])
    }

    private var streakStats: some View {
        statsCard(title: "Streaks", rows: [
            ("Current Streak", "\(s?.currentStreak ?? 0) days"),
            ("Longest Streak", "\(s?.longestStreak ?? 0) days"),
            ("Daily Beats", "\(s?.dailyTracksCompleted ?? 0)"),
        ])
    }

    private var performanceStats: some View {
        let total = (s?.totalHits ?? 0) + (s?.missedHits ?? 0)
        let accuracy = total > 0 ? Double(s?.perfectHits ?? 0) / Double(total) * 100 : 0

        return statsCard(title: "Performance", rows: [
            ("Perfect Rate", String(format: "%.1f%%", accuracy)),
            ("Seasons Played", "\(s?.seasonsPlayed.count ?? 0)/\(Season.all.count)"),
            ("Time Playing", formatTime(s?.totalTimePlayed ?? 0)),
            ("Achievements", "\(achievements.count)/\(Achievement.all.count)"),
        ])
    }

    private func statsCard(title: String, rows: [(String, String)]) -> some View {
        VStack(spacing: 0) {
            HStack {
                Text(title).font(.system(size: 15, weight: .bold, design: .rounded)).primaryText()
                Spacer()
            }
            .padding(.bottom, 10)

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
            RoundedRectangle(cornerRadius: 16)
                .fill(theme.colors.surface.opacity(0.4))
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
