import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.theme) private var theme
    @Environment(AppState.self) private var appState
    @Query private var settings: [SettingsRecord]
    @Query private var stats: [StatsRecord]

    private var currentSettings: SettingsRecord? { settings.first }
    private var s: StatsRecord? { stats.first }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                headerSection
                dailyMissionCard
                progressSection
                quickActions
            }
            .padding(16)
        }
        .themedBackground()
        .overlay { FloatingOrbsView() }
    }

    private var headerSection: some View {
        VStack(spacing: 6) {
            Text("QUEST")
                .font(.system(size: 36, weight: .black, design: .rounded))
                .foregroundStyle(theme.colors.accent)
            Text("Daily Real-World Missions")
                .font(.system(size: 14, weight: .medium))
                .secondaryText()
        }
        .padding(.top, 20)
    }

    private var dailyMissionCard: some View {
        let level = currentSettings?.currentLevelIndex ?? 0
        let mission = MissionGenerator.mission(for: level)

        return NavigationLink(value: Route.mission(index: level)) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: mission.type.icon)
                        .font(.title2)
                        .foregroundStyle(mission.type.color(theme))
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Today's Mission")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(theme.colors.accent)
                        Text(mission.title)
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .primaryText()
                    }
                    Spacer()
                    Text("\(mission.xpReward) XP")
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
                        .foregroundStyle(theme.colors.accent)
                }

                Text(mission.region.name)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(mission.region.color(theme).opacity(0.8))

                HStack(spacing: 4) {
                    ForEach(0..<mission.objectives.count, id: \.self) { i in
                        Circle()
                            .fill(theme.colors.accent.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                    Spacer()
                    Text("\(mission.objectives.count) objectives")
                        .font(.caption)
                        .mutedText()
                }
            }
            .padding(16)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(theme.colors.accent.opacity(0.08))
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(theme.colors.accent.opacity(0.2), lineWidth: 1)
                    }
            }
        }
        .buttonStyle(.plain)
    }

    private var progressSection: some View {
        let completed = s?.missionsCompleted ?? 0
        let xp = s?.totalXP ?? 0
        let level = QuestConfig.levelForXP(xp)
        let progress = QuestConfig.xpProgressInLevel(xp)

        return VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Level \(level)")
                        .font(.system(size: 20, weight: .black, design: .rounded))
                        .primaryText()
                    Text(QuestConfig.xpLevelTitle(level))
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(theme.colors.accent)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(xp) XP")
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                        .primaryText()
                    Text("\(completed) missions")
                        .font(.caption)
                        .mutedText()
                }
            }
            ProgressView(value: progress)
                .tint(theme.colors.accent)
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(theme.colors.surface.opacity(0.4))
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(theme.colors.cardBorder.opacity(0.12), lineWidth: 1)
                }
        }
    }

    private var quickActions: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            actionCard(icon: "map.fill", title: "Regions", route: .regionMap)
            actionCard(icon: "book.fill", title: "Journal", route: .journal)
            actionCard(icon: "trophy.fill", title: "Achievements", route: .achievements)
            actionCard(icon: "chart.bar.fill", title: "Stats", route: .stats)
        }
    }

    private func actionCard(icon: String, title: String, route: Route) -> some View {
        NavigationLink(value: route) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(theme.colors.accent)
                Text(title)
                    .font(.system(size: 13, weight: .semibold))
                    .primaryText()
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(theme.colors.surface.opacity(0.3))
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(theme.colors.cardBorder.opacity(0.1), lineWidth: 1)
                    }
            }
        }
        .buttonStyle(.plain)
    }
}
