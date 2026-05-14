import SwiftUI
import SwiftData

struct StatsDetailView: View {
    @Environment(\.theme) private var theme
    @Query private var statsRecords: [StatsRecord]
    private var stats: StatsRecord? { statsRecords.first }
    private var xp: Int { stats?.totalXP ?? 0 }

    var body: some View {
        ZStack {
            FloatingOrbsView()
            ScrollView {
                VStack(spacing: 16) {
                    GlassCard {
                        VStack(spacing: 12) {
                            Text("Level \(FluxConfig.level(forXP: xp))").font(.title.bold()).primaryText()
                            Text(FluxConfig.title(forXP: xp)).font(.headline).foregroundStyle(theme.colors.primary)
                            ProgressView(value: FluxConfig.xpProgress(forXP: xp)).tint(theme.colors.primary).scaleEffect(y: 2)
                            Text("\(xp) XP").font(.subheadline).secondaryText()
                        }
                    }
                    GlassCard {
                        VStack(spacing: 12) {
                            Text("Flows").font(.headline).primaryText()
                            row("Total Flows", "\(stats?.flowsCompleted ?? 0)")
                            row("3-Star Flows", "\(stats?.threeStarFlows ?? 0)")
                            row("Particles Spawned", "\(stats?.totalParticlesSpawned ?? 0)")
                            Divider().opacity(0.3)
                            row("Water", "\(stats?.waterFlows ?? 0)")
                            row("Lava", "\(stats?.lavaFlows ?? 0)")
                            row("Plasma", "\(stats?.plasmaFlows ?? 0)")
                            row("Mercury", "\(stats?.mercuryFlows ?? 0)")
                            row("Ether", "\(stats?.etherFlows ?? 0)")
                        }
                    }
                    GlassCard {
                        VStack(spacing: 12) {
                            Text("Streaks").font(.headline).primaryText()
                            row("Current", "\(stats?.currentStreak ?? 0) days")
                            row("Best", "\(stats?.bestStreak ?? 0) days")
                        }
                    }
                }
                .padding()
            }
        }
        .themedBackground()
        .navigationTitle("Statistics")
    }

    private func row(_ label: String, _ value: String) -> some View {
        HStack { Text(label).secondaryText(); Spacer(); Text(value).font(.subheadline.bold()).primaryText() }
    }
}
