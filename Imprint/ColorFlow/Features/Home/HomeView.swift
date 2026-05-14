import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.theme) private var theme
    @Environment(AppState.self) private var appState
    @Query private var settings: [SettingsRecord]
    @Query private var stats: [StatsRecord]

    var body: some View {
        ZStack {
            FloatingOrbsView()
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    titleSection
                    mainButtons
                    quickActions
                    statsPreview
                }
                .padding(20)
            }
        }
        .themedBackground()
        .navigationBarTitleDisplayMode(.inline)
    }

    private var titleSection: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(theme.colors.accent.opacity(0.1))
                    .frame(width: 90, height: 90)
                    .blur(radius: 8)

                Image(systemName: "camera.macro")
                    .font(.system(size: 44))
                    .foregroundStyle(theme.colors.accent)
                    .shadow(color: theme.colors.accent.opacity(0.4), radius: 8)
            }

            Text("Imprint")
                .font(.system(size: 32, weight: .black, design: .rounded))
                .primaryText()

            Text("Color Memory Mosaic")
                .font(.system(size: 15, weight: .medium))
                .secondaryText()
        }
        .padding(.top, 20)
    }

    private var mainButtons: some View {
        let currentLevel = settings.first?.currentLevelIndex ?? 0
        return VStack(spacing: 12) {
            GlassButton("Continue Mosaic \(currentLevel + 1)", icon: "play.fill") {
                HapticsService.medium()
                appState.navigate(to: .imprint(mode: .mosaic(index: currentLevel)))
            }

            GlassButton("Daily Mosaic", icon: "calendar") {
                HapticsService.medium()
                appState.navigate(to: .imprint(mode: .daily))
            }

            GlassButton("Quick Snap", icon: "bolt.fill") {
                HapticsService.medium()
                appState.navigate(to: .imprint(mode: .quickSnap))
            }
        }
    }

    private var quickActions: some View {
        HStack(spacing: 12) {
            navButton(icon: "map.fill", label: "Moments") {
                appState.navigate(to: .momentMap)
            }
            navButton(icon: "trophy.fill", label: "Badges") {
                appState.navigate(to: .achievements)
            }
            navButton(icon: "chart.bar.fill", label: "Stats") {
                appState.navigate(to: .stats)
            }
            navButton(icon: "gearshape.fill", label: "Settings") {
                appState.navigate(to: .settings)
            }
        }
    }

    private func navButton(icon: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: {
            HapticsService.light()
            action()
        }) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                Text(label)
                    .font(.system(size: 11, weight: .bold, design: .rounded))
            }
            .foregroundStyle(theme.colors.accent)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background {
                RoundedRectangle(cornerRadius: 14)
                    .fill(theme.colors.accent.opacity(0.08))
                    .overlay {
                        RoundedRectangle(cornerRadius: 14)
                            .strokeBorder(theme.colors.accent.opacity(0.15), lineWidth: 1)
                    }
            }
        }
        .buttonStyle(BounceButtonStyle())
    }

    private var statsPreview: some View {
        let s = stats.first
        let xp = s?.totalXP ?? 0
        let level = ImprintConfig.levelForXP(xp)
        let title = ImprintConfig.xpLevelTitle(level)
        let progress = ImprintConfig.xpProgressInLevel(xp)

        return VStack(spacing: 8) {
            HStack {
                Text("Level \(level) — \(title)")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .primaryText()
                Spacer()
                Text("\(xp) XP")
                    .font(.system(size: 13, weight: .semibold, design: .monospaced))
                    .secondaryText()
            }
            ProgressView(value: progress)
                .tint(theme.colors.accent)
        }
        .padding(14)
        .background {
            RoundedRectangle(cornerRadius: 14)
                .fill(theme.colors.surface.opacity(0.3))
                .overlay {
                    RoundedRectangle(cornerRadius: 14)
                        .strokeBorder(theme.colors.boardBorder.opacity(0.12), lineWidth: 1)
                }
        }
    }
}

struct BounceButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

struct FloatingOrbsView: View {
    @Environment(\.theme) private var theme
    @State private var animate = false

    var body: some View {
        ZStack {
            Circle()
                .fill(theme.colors.accent.opacity(0.06))
                .frame(width: 200, height: 200)
                .offset(x: animate ? 30 : -30, y: animate ? -50 : 50)
                .blur(radius: 60)

            Circle()
                .fill(theme.colors.secondary.opacity(0.04))
                .frame(width: 250, height: 250)
                .offset(x: animate ? -40 : 40, y: animate ? 60 : -60)
                .blur(radius: 70)

            Circle()
                .fill(theme.colors.accent.opacity(0.03))
                .frame(width: 150, height: 150)
                .offset(x: animate ? 60 : -20, y: animate ? 30 : -40)
                .blur(radius: 50)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }
}
