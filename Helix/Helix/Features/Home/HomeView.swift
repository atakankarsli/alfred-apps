import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.theme) var theme
    @Environment(AppState.self) var appState
    @Query var stats: [StatsRecord]
    @Query var levels: [LevelRecord]

    private var nextLevel: Int {
        let completed = Set(levels.map { $0.levelIndex })
        return (0..<HelixConfig.totalLevels).first { !completed.contains($0) } ?? 0
    }

    var body: some View {
        let stat = stats.first
        let xp = stat?.totalXP ?? 0

        ZStack {
            FloatingOrbsView()
            ScrollView {
                VStack(spacing: 24) {
                    VStack(spacing: 8) {
                        Text("HELIX")
                            .font(.system(size: 42, weight: .bold, design: .serif))
                            .foregroundStyle(theme.colors.primary)
                        Text("Decode the Strand")
                            .font(.subheadline)
                            .foregroundStyle(theme.colors.textSecondary)
                    }
                    .padding(.top, 40)

                    GlassCard {
                        VStack(spacing: 12) {
                            HStack {
                                Text(HelixConfig.levelTitle(forXP: xp))
                                    .font(.title3.bold())
                                    .foregroundStyle(theme.colors.text)
                                Spacer()
                                Text("\(xp) XP")
                                    .font(.headline)
                                    .foregroundStyle(theme.colors.accent)
                            }
                            HStack {
                                Label("\(stat?.levelsCompleted ?? 0)/\(HelixConfig.totalLevels)", systemImage: "checkmark.circle")
                                Spacer()
                                Label("\(stat?.currentStreak ?? 0) day streak", systemImage: "flame.fill")
                            }
                            .font(.caption)
                            .foregroundStyle(theme.colors.textSecondary)
                        }
                    }
                    .padding(.horizontal)

                    VStack(spacing: 12) {
                        GlassButton("Continue", icon: "play.fill") {
                            appState.navigate(to: .play(levelIndex: nextLevel))
                        }
                        GlassButton("Daily Strand", icon: "calendar") {
                            appState.navigate(to: .daily)
                        }
                        GlassButton("Realms", icon: "circle.hexagongrid.fill") {
                            appState.navigate(to: .worlds)
                        }
                        GlassButton("Achievements", icon: "trophy.fill") {
                            appState.navigate(to: .achievements)
                        }
                        GlassButton("Settings", icon: "gearshape.fill") {
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
