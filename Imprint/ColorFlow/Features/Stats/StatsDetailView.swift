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
                puzzleStats
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
        let level = ImprintConfig.levelForXP(xp)
        let progress = ImprintConfig.xpProgressInLevel(xp)
        let title = ImprintConfig.xpLevelTitle(level)

        return VStack(spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Level \(level)")
                        .font(.system(size: 24, weight: .black, design: .rounded))
                        .primaryText()
                    Text(title)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(theme.colors.accent)
                }
                Spacer()
                Text("\(xp) XP")
                    .font(.system(size: 18, weight: .bold, design: .monospaced))
                    .secondaryText()
            }

            ProgressView(value: progress)
                .tint(theme.colors.accent)

            if level < ImprintConfig.xpPerLevel.count - 1 {
                Text("\(ImprintConfig.xpPerLevel[level + 1] - xp) XP to next level")
                    .font(.caption)
                    .mutedText()
            }
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(theme.colors.accent.opacity(0.06))
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(theme.colors.accent.opacity(0.15), lineWidth: 1)
                }
        }
    }

    private var puzzleStats: some View {
        statsCard(title: "Mosaics", rows: [
            ("Completed", "\(s?.puzzlesCompleted ?? 0)"),
            ("3-Star", "\(s?.threeStarCount ?? 0)"),
            ("Time Played", formatTime(s?.totalTimePlayed ?? 0)),
            ("Achievements", "\(achievements.count)/\(Achievement.all.count)"),
        ])
    }

    private var streakStats: some View {
        statsCard(title: "Streaks", rows: [
            ("Current Streak", "\(s?.currentStreak ?? 0) days"),
            ("Longest Streak", "\(s?.longestStreak ?? 0) days"),
            ("Daily Mosaics", "\(s?.dailyPuzzlesCompleted ?? 0)"),
        ])
    }

    private var performanceStats: some View {
        let noHint = s?.noHintCompletions ?? 0
        let total = max(s?.puzzlesCompleted ?? 1, 1)

        return statsCard(title: "Performance", rows: [
            ("Perfect Mosaics", "\(noHint) (\(noHint * 100 / total)%)"),
            ("Moments Completed", "\(momentsCompleted())/4"),
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
                statsRow(row)
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

    private func statsRow(_ row: (String, String)) -> some View {
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

    private func formatTime(_ seconds: Int) -> String {
        let h = seconds / 3600
        let m = (seconds % 3600) / 60
        if h > 0 { return "\(h)h \(m)m" }
        return "\(m)m"
    }

    private func momentsCompleted() -> Int {
        let best = s?.bestMoves ?? [:]
        return Moment.all.filter { moment in
            moment.levelRange.allSatisfy { best[$0] != nil }
        }.count
    }
}
