import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.theme) private var theme
    @Environment(AppState.self) private var appState
    @Query private var statsRecords: [StatsRecord]
    private var stats: StatsRecord? { statsRecords.first }
    private var xp: Int { stats?.totalXP ?? 0 }

    var body: some View {
        ZStack {
            FloatingOrbsView()
            ScrollView {
                VStack(spacing: 20) {
                    xpBadge
                    dailyFlow
                    elementsGrid
                    statsBar
                    navButtons
                }
                .padding()
            }
        }
        .themedBackground()
        .navigationTitle("Flux")
        .navigationBarTitleDisplayMode(.large)
    }

    private var xpBadge: some View {
        GlassCard {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(FluxConfig.title(forXP: xp)).font(.headline).primaryText()
                    Text("Level \(FluxConfig.level(forXP: xp))").font(.subheadline).secondaryText()
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(xp) XP").font(.title3.bold()).foregroundStyle(theme.colors.primary)
                    ProgressView(value: FluxConfig.xpProgress(forXP: xp)).tint(theme.colors.primary).frame(width: 100)
                }
            }
        }
    }

    private var dailyFlow: some View {
        GlassCard {
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: "drop.fill").font(.title2).foregroundStyle(theme.colors.primary)
                    Text("Daily Flow").font(.title3.bold()).primaryText()
                    Spacer()
                }
                Text("Today's fluid challenge awaits").font(.subheadline).secondaryText()
                    .frame(maxWidth: .infinity, alignment: .leading)
                GlassButton("Start Flow", icon: "play.fill") {
                    HapticsService.medium(); appState.path.append(Route.dailyFlow)
                }
            }
        }
    }

    private var elementsGrid: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Free Play").font(.headline).primaryText()
            LazyVGrid(columns: [.init(.flexible()), .init(.flexible())], spacing: 12) {
                ForEach(FluidElement.allCases) { el in
                    Button { appState.path.append(Route.freePlay(element: el)) } label: {
                        GlassCard {
                            VStack(spacing: 8) {
                                Image(systemName: el.icon).font(.title2).foregroundStyle(el.baseColor)
                                Text(el.displayName).font(.caption.bold()).primaryText()
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .buttonStyle(ScaleButtonStyle())
                }
            }
        }
    }

    private var statsBar: some View {
        GlassCard {
            HStack(spacing: 0) {
                miniStat("flame.fill", "\(stats?.currentStreak ?? 0)", "Streak")
                Spacer()
                miniStat("star.fill", "\(stats?.threeStarFlows ?? 0)", "Perfect")
                Spacer()
                miniStat("drop.fill", "\(stats?.flowsCompleted ?? 0)", "Flows")
            }
        }
    }

    private func miniStat(_ icon: String, _ value: String, _ label: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon).font(.body).foregroundStyle(theme.colors.primary)
            Text(value).font(.headline.monospacedDigit()).primaryText()
            Text(label).font(.caption2).secondaryText()
        }
    }

    private var navButtons: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                navBtn("Zones", icon: "map.fill", route: .elementMap)
                navBtn("Gallery", icon: "photo.fill", route: .gallery)
            }
            HStack(spacing: 10) {
                navBtn("Stats", icon: "chart.bar.fill", route: .stats)
                navBtn("Badges", icon: "trophy.fill", route: .achievements)
            }
            GlassButton("Settings", icon: "gearshape.fill", style: .subtle) { appState.path.append(Route.settings) }
        }
    }

    private func navBtn(_ title: String, icon: String, route: Route) -> some View {
        Button { appState.path.append(route) } label: {
            GlassCard {
                HStack {
                    Image(systemName: icon).foregroundStyle(theme.colors.primary)
                    Text(title).font(.subheadline.bold()).primaryText()
                    Spacer(); Image(systemName: "chevron.right").font(.caption).secondaryText()
                }
            }
        }
        .buttonStyle(ScaleButtonStyle())
    }
}
