import SwiftUI
import SwiftData

struct JournalView: View {
    @Environment(\.theme) private var theme
    @Query private var settings: [SettingsRecord]
    @Query private var stats: [StatsRecord]

    private var currentSettings: SettingsRecord? { settings.first }
    private var s: StatsRecord? { stats.first }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                summaryCard
                missionLogList
            }
            .padding(16)
        }
        .themedBackground()
        .navigationTitle("Journal")
    }

    private var summaryCard: some View {
        let completed = s?.missionsCompleted ?? 0
        let xp = s?.totalXP ?? 0
        let fog = s?.fogCellsCleared ?? 0
        let regions = s?.regionsPlayed.count ?? 0

        return VStack(spacing: 10) {
            Text("Explorer's Journal")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(theme.colors.accent)

            HStack(spacing: 16) {
                statBadge(value: "\(completed)", label: "Missions")
                statBadge(value: "\(xp)", label: "XP")
                statBadge(value: "\(fog)", label: "Fog Cleared")
                statBadge(value: "\(regions)", label: "Regions")
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

    private func statBadge(value: String, label: String) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(size: 16, weight: .bold, design: .monospaced))
                .primaryText()
            Text(label)
                .font(.system(size: 10, weight: .medium))
                .mutedText()
        }
        .frame(maxWidth: .infinity)
    }

    private var missionLogList: some View {
        let completed = currentSettings?.currentLevelIndex ?? 0

        return VStack(alignment: .leading, spacing: 8) {
            Text("Mission Log")
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .primaryText()

            if completed == 0 {
                Text("No missions completed yet. Start your first quest!")
                    .font(.system(size: 14))
                    .secondaryText()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
            } else {
                ForEach((0..<completed).reversed(), id: \.self) { level in
                    let mission = MissionGenerator.mission(for: level)
                    HStack(spacing: 10) {
                        Image(systemName: mission.type.icon)
                            .font(.system(size: 14))
                            .foregroundStyle(mission.type.color(theme))
                            .frame(width: 24)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(mission.title)
                                .font(.system(size: 14, weight: .semibold))
                                .primaryText()
                            Text("\(mission.region.name) · \(mission.objectives.count) objectives")
                                .font(.system(size: 11))
                                .mutedText()
                        }

                        Spacer()

                        Text("+\(mission.xpReward)")
                            .font(.system(size: 12, weight: .bold, design: .monospaced))
                            .foregroundStyle(theme.colors.accent)
                    }
                    .padding(10)
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(theme.colors.surface.opacity(0.2))
                    }
                }
            }
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(theme.colors.surface.opacity(0.3))
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(theme.colors.cardBorder.opacity(0.1), lineWidth: 1)
                }
        }
    }
}
