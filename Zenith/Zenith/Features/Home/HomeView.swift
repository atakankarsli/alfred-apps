import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.theme) private var theme
    @Environment(AppState.self) private var appState
    @Query private var stats: [StatsRecord]
    @Query private var levels: [LevelRecord]

    private var totalXP: Int { stats.first?.totalXP ?? 0 }
    private var streak: Int { stats.first?.currentStreak ?? 0 }

    var body: some View {
        ZStack {
            theme.gradient.ignoresSafeArea()
            StarFieldView()
            FloatingOrbsView()

            ScrollView {
                VStack(spacing: 20) {
                    xpBadge
                    playHero
                    modesSection
                    streakCard
                    quickNav
                    statsPreview
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden()
    }

    private var xpBadge: some View {
        HStack {
            Spacer()
            GlassCard(padding: 8, cornerRadius: 20) {
                HStack(spacing: 6) {
                    Image(systemName: "star.fill")
                        .font(.caption)
                        .foregroundStyle(theme.colors.warning)
                    Text("\(totalXP) XP")
                        .font(.caption.weight(.semibold).monospacedDigit())
                        .foregroundStyle(theme.colors.text)
                    Text(ZenithConfig.levelTitle(forXP: totalXP))
                        .font(.caption2)
                        .foregroundStyle(theme.colors.textSecondary)
                }
            }
        }
    }

    private var playHero: some View {
        GlassCard {
            VStack(spacing: 16) {
                Image(systemName: "moon.stars.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(theme.colors.primary)

                Text("ZENITH")
                    .font(.largeTitle.weight(.black))
                    .foregroundStyle(theme.colors.text)

                Text("Connect the Stars")
                    .font(.subheadline)
                    .foregroundStyle(theme.colors.textSecondary)

                GlassButton("Play", icon: "play.fill") {
                    let completedIndices = Set(levels.map(\.levelIndex))
                    let nextLevel = (0..<80).first { !completedIndices.contains($0) } ?? 0
                    appState.navigate(to: .play(levelIndex: nextLevel))
                }
            }
        }
    }

    private var modesSection: some View {
        HStack(spacing: 12) {
            modeCard(title: "Endless", icon: "infinity", color: theme.colors.accent) {
                appState.navigate(to: .endless)
            }
            modeCard(title: "Daily Sky", icon: "calendar.badge.clock", color: theme.colors.secondary) {
                appState.navigate(to: .dailySky)
            }
            modeCard(title: "Quiz", icon: "questionmark.circle", color: theme.colors.warning) {
                appState.navigate(to: .quiz)
            }
        }
    }

    private func modeCard(title: String, icon: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            GlassCard(padding: 12) {
                VStack(spacing: 8) {
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundStyle(color)
                    Text(title)
                        .font(.caption.weight(.medium))
                        .foregroundStyle(theme.colors.text)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .buttonStyle(ScaleButtonStyle())
    }

    private var streakCard: some View {
        GlassCard(padding: 12) {
            HStack {
                Image(systemName: "flame.fill")
                    .font(.title2)
                    .foregroundStyle(streak > 0 ? theme.colors.warning : theme.colors.textMuted)
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(streak) day streak")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(theme.colors.text)
                    Text("\(levels.count)/80 constellations found")
                        .font(.caption)
                        .foregroundStyle(theme.colors.textSecondary)
                }
                Spacer()
            }
        }
    }

    private var quickNav: some View {
        HStack(spacing: 12) {
            navButton("Worlds", icon: "globe.americas.fill") { appState.navigate(to: .worlds) }
            navButton("Stats", icon: "chart.bar.fill") { appState.navigate(to: .stats) }
            navButton("Awards", icon: "trophy.fill") { appState.navigate(to: .achievements) }
            navButton("Settings", icon: "gearshape.fill") { appState.navigate(to: .settings) }
        }
    }

    private func navButton(_ title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(theme.colors.primary)
                Text(title)
                    .font(.caption2)
                    .foregroundStyle(theme.colors.textSecondary)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(ScaleButtonStyle())
    }

    private var statsPreview: some View {
        GlassCard(padding: 12) {
            HStack {
                statItem("Completed", value: "\(levels.count)")
                Spacer()
                statItem("3 Stars", value: "\(stats.first?.threeStarCount ?? 0)")
                Spacer()
                statItem("No Hints", value: "\(stats.first?.noHintCount ?? 0)")
            }
        }
    }

    private func statItem(_ label: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title3.weight(.bold).monospacedDigit())
                .foregroundStyle(theme.colors.text)
            Text(label)
                .font(.caption2)
                .foregroundStyle(theme.colors.textMuted)
        }
    }
}
