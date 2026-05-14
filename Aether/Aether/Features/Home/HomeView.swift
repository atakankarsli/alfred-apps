import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.theme) var theme
    @Environment(AppState.self) var appState
    @Query var stats: [StatsRecord]
    @Query var levels: [LevelRecord]

    private var nextLevel: Int {
        let completed = Set(levels.map { $0.levelIndex })
        return (0..<AetherConfig.totalLevels).first { !completed.contains($0) } ?? 0
    }

    var body: some View {
        let stat = stats.first
        let xp = stat?.totalXP ?? 0

        ZStack {
            FloatingOrbsView()
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Text("AETHER")
                            .font(.system(size: 42, weight: .bold, design: .serif))
                            .foregroundStyle(theme.colors.primary)
                        Text("Combine Elements, Create Worlds")
                            .font(.subheadline)
                            .foregroundStyle(theme.colors.textSecondary)
                    }
                    .padding(.top, 40)

                    GlassCard {
                        VStack(spacing: 12) {
                            HStack {
                                Text(AetherConfig.levelTitle(forXP: xp))
                                    .font(.title3.bold())
                                    .foregroundStyle(theme.colors.text)
                                Spacer()
                                Text("\(xp) XP")
                                    .font(.headline)
                                    .foregroundStyle(theme.colors.accent)
                            }
                            HStack {
                                Label("\(stat?.elementsDiscovered ?? 4)/\(ElementData.allElements.count)", systemImage: "atom")
                                Spacer()
                                Label("\(stat?.currentStreak ?? 0) day streak", systemImage: "flame.fill")
                            }
                            .font(.caption)
                            .foregroundStyle(theme.colors.textSecondary)
                        }
                    }
                    .padding(.horizontal)

                    VStack(spacing: 12) {
                        GlassButton( "Continue", icon: "play.fill") {
                            appState.navigate(to: .play(levelIndex: nextLevel))
                        }
                        GlassButton( "Sandbox", icon: "flask.fill") {
                            appState.navigate(to: .sandbox)
                        }
                        GlassButton( "Worlds", icon: "globe.americas.fill") {
                            appState.navigate(to: .worlds)
                        }
                        GlassButton( "Achievements", icon: "trophy.fill") {
                            appState.navigate(to: .achievements)
                        }
                        GlassButton( "Settings", icon: "gearshape.fill") {
                            appState.navigate(to: .settings)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 40)
            }
        }
    }
}
