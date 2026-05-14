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
                gardenStats
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
        let level = BloomConfig.levelForXP(xp)
        let progress = BloomConfig.xpProgressInLevel(xp)
        let title = BloomConfig.xpLevelTitle(level)

        return VStack(spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Level \(level)")
                        .font(.system(size: 24, weight: .black, design: .rounded))
                        .primaryText()
                    Text(title)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color(hex: "6BCB77"))
                }
                Spacer()
                Text("\(xp) XP")
                    .font(.system(size: 18, weight: .bold, design: .monospaced))
                    .secondaryText()
            }

            ProgressView(value: progress)
                .tint(Color(hex: "6BCB77"))

            if level < BloomConfig.xpPerLevel.count {
                Text("\(BloomConfig.xpPerLevel[level] - xp) XP to next level")
                    .font(.caption)
                    .mutedText()
            }
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: "6BCB77").opacity(0.06))
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(Color(hex: "6BCB77").opacity(0.15), lineWidth: 1)
                }
        }
    }

    private var gardenStats: some View {
        statsCard(title: "Gardens", rows: [
            ("Completed", "\(s?.puzzlesCompleted ?? 0)"),
            ("3-Star", "\(s?.threeStarCount ?? 0)"),
            ("Total Plants", "\(s?.totalMoves ?? 0)"),
            ("Time Played", formatTime(s?.totalTimePlayed ?? 0)),
            ("Achievements", "\(achievements.count)/\(Achievement.all.count)"),
        ])
    }

    private var streakStats: some View {
        statsCard(title: "Streaks", rows: [
            ("Current Streak", "\(s?.currentStreak ?? 0) days"),
            ("Longest Streak", "\(s?.longestStreak ?? 0) days"),
            ("Daily Gardens", "\(s?.dailyPuzzlesCompleted ?? 0)"),
        ])
    }

    private var performanceStats: some View {
        let avg = (s?.puzzlesCompleted ?? 0) > 0
            ? Double(s?.totalMoves ?? 0) / Double(s?.puzzlesCompleted ?? 1)
            : 0

        return statsCard(title: "Performance", rows: [
            ("Avg Plants/Garden", String(format: "%.1f", avg)),
            ("Seasons Completed", "\(seasonsCompleted())/4"),
        ])
    }

    private func statsCard(title: String, rows: [(String, String)]) -> some View {
        VStack(spacing: 0) {
            HStack {
                Text(title)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .primaryText()
                Spacer()
            }
            .padding(.bottom, 10)

            ForEach(Array(rows.enumerated()), id: \.offset) { _, row in
                HStack {
                    Text(row.0)
                        .font(.system(size: 14))
                        .secondaryText()
                    Spacer()
                    Text(row.1)
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .primaryText()
                }
                .padding(.vertical, 6)
            }
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(theme.colors.surface.opacity(0.4))
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(theme.colors.boardBorder.opacity(0.12), lineWidth: 1)
                }
        }
    }

    private func formatTime(_ seconds: Int) -> String {
        let h = seconds / 3600
        let m = (seconds % 3600) / 60
        if h > 0 { return "\(h)h \(m)m" }
        return "\(m)m"
    }

    private func seasonsCompleted() -> Int {
        let best = s?.bestMoves ?? [:]
        return Season.all.filter { season in
            season.gardenRange.allSatisfy { best[$0] != nil }
        }.count
    }
}
