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
                explorationStats
                missionStats
                performanceStats
            }
            .padding(16)
        }
        .themedBackground()
        .navigationTitle("Statistics")
    }

    private var xpSection: some View {
        let xp = s?.totalXP ?? 0
        let level = QuestConfig.levelForXP(xp)
        let progress = QuestConfig.xpProgressInLevel(xp)
        let title = QuestConfig.xpLevelTitle(level)

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
            if level < QuestConfig.xpPerLevel.count {
                Text("\(QuestConfig.xpPerLevel[level] - xp) XP to next level")
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

    private var explorationStats: some View {
        statsCard(title: "Exploration", rows: [
            ("Fog Cells Cleared", "\(s?.fogCellsCleared ?? 0)"),
            ("Regions Discovered", "\(s?.regionsPlayed.count ?? 0)/\(Region.all.count)"),
            ("Mission Types Used", "\(s?.typesUsed.count ?? 0)/\(MissionType.allCases.count)"),
        ])
    }

    private var missionStats: some View {
        statsCard(title: "Missions", rows: [
            ("Missions Completed", "\(s?.missionsCompleted ?? 0)"),
            ("Objectives Done", "\(s?.totalObjectivesCompleted ?? 0)"),
            ("3-Star Missions", "\(s?.threeStarCount ?? 0)"),
            ("Current Streak", "\(s?.currentStreak ?? 0) days"),
        ])
    }

    private var performanceStats: some View {
        statsCard(title: "Performance", rows: [
            ("Longest Streak", "\(s?.longestStreak ?? 0) days"),
            ("Time Exploring", formatTime(s?.totalTimePlayed ?? 0)),
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
