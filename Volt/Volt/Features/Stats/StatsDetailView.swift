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
                componentStats
                performanceStats
            }
            .padding(16)
        }
        .themedBackground()
        .navigationTitle("Statistics")
    }

    private var xpSection: some View {
        let xp = s?.totalXP ?? 0
        let level = VoltConfig.levelForXP(xp)
        let progress = VoltConfig.xpProgressInLevel(xp)

        return VStack(spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Level \(level)").font(.system(size: 24, weight: .black, design: .rounded)).primaryText()
                    Text(VoltConfig.xpLevelTitle(level)).font(.system(size: 14, weight: .medium)).foregroundStyle(theme.colors.accent)
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

    private var puzzleStats: some View {
        statsCard(title: "Puzzles", rows: [
            ("Puzzles Completed", "\(s?.puzzlesCompleted ?? 0)/\(VoltConfig.totalPuzzles)"),
            ("3-Star Puzzles", "\(s?.threeStarCount ?? 0)"),
            ("Sandbox Builds", "\(s?.sandboxBuilds ?? 0)"),
            ("Fastest Solve", s?.fastestSolveTime ?? 0 > 0 ? formatTime(s?.fastestSolveTime ?? 0) : "—"),
        ])
    }

    private var componentStats: some View {
        statsCard(title: "Components", rows: [
            ("Types Used", "\(s?.componentsUsed.count ?? 0)/\(ComponentType.allCases.count)"),
            ("Seasons Played", "\(s?.seasonsPlayed.count ?? 0)/\(Season.all.count)"),
            ("Hints Used", "\(s?.hintsUsed ?? 0)"),
            ("No-Hint Solves", "\(s?.puzzlesWithoutHints ?? 0)"),
        ])
    }

    private var performanceStats: some View {
        statsCard(title: "Performance", rows: [
            ("Current Streak", "\(s?.currentStreak ?? 0) days"),
            ("Longest Streak", "\(s?.longestStreak ?? 0) days"),
            ("Achievements", "\(achievements.count)/\(Achievement.all.count)"),
        ])
    }

    private func formatTime(_ seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%d:%02d", m, s)
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
}
