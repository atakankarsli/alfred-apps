import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.theme) private var theme
    @Environment(AppState.self) private var appState
    @Query private var settings: [SettingsRecord]
    @Query private var stats: [StatsRecord]

    private var currentSettings: SettingsRecord? { settings.first }
    private var currentStats: StatsRecord? { stats.first }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                heroSection
                quickActions
                progressSection
                navigationCards
            }
            .padding(16)
        }
        .themedBackground()
        .navigationTitle("PULSE")
    }

    private var heroSection: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(theme.colors.accent.opacity(0.1))
                    .frame(width: 100, height: 100)
                PulseWaveView()
                    .frame(width: 80, height: 80)
            }

            Text("Tap to the Rhythm")
                .font(.system(size: 28, weight: .black, design: .rounded))
                .primaryText()

            Text("Master the Flow")
                .font(.system(size: 16, weight: .medium))
                .secondaryText()
        }
        .padding(.vertical, 12)
    }

    private var quickActions: some View {
        VStack(spacing: 10) {
            let nextTrack = currentSettings?.highestUnlockedLevel ?? 0

            GlassButton("Play Track \(nextTrack + 1)", icon: "play.fill") {
                appState.navigate(to: .play(index: nextTrack))
            }

            HStack(spacing: 10) {
                GlassButton("Daily Beat", icon: "calendar", style: .secondary) {
                    appState.navigate(to: .daily)
                }
                GlassButton("Freestyle", icon: "waveform.path", style: .secondary) {
                    appState.navigate(to: .freestyle)
                }
            }
        }
    }

    private var progressSection: some View {
        let xp = currentStats?.totalXP ?? 0
        let level = PulseConfig.levelForXP(xp)
        let progress = PulseConfig.xpProgressInLevel(xp)
        let title = PulseConfig.xpLevelTitle(level)

        return HStack(spacing: 14) {
            ZStack {
                Circle()
                    .stroke(theme.colors.cardBorder.opacity(0.15), lineWidth: 4)
                    .frame(width: 52, height: 52)
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(theme.colors.accent, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .frame(width: 52, height: 52)
                    .rotationEffect(.degrees(-90))
                Text("\(level)")
                    .font(.system(size: 18, weight: .black, design: .rounded))
                    .primaryText()
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .primaryText()
                Text("\(xp) XP")
                    .font(.system(size: 13, weight: .medium, design: .monospaced))
                    .secondaryText()
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 3) {
                HStack(spacing: 3) {
                    Image(systemName: "flame.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(.orange)
                    Text("\(currentStats?.currentStreak ?? 0)")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .primaryText()
                }
                Text("streak")
                    .font(.system(size: 11))
                    .mutedText()
            }
        }
        .padding(14)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(theme.colors.surface.opacity(0.4))
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(theme.colors.cardBorder.opacity(0.12), lineWidth: 1)
                }
        }
    }

    private var navigationCards: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
            navCard("Seasons", icon: "music.note.list", count: "\(Season.all.count)") {
                appState.navigate(to: .seasonMap)
            }
            navCard("Stats", icon: "chart.bar.fill", count: "\(currentStats?.tracksCompleted ?? 0)") {
                appState.navigate(to: .stats)
            }
            navCard("Achievements", icon: "trophy.fill", count: nil) {
                appState.navigate(to: .achievements)
            }
            navCard("Settings", icon: "gearshape.fill", count: nil) {
                appState.navigate(to: .settings)
            }
        }
    }

    private func navCard(_ title: String, icon: String, count: String?, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundStyle(theme.colors.accent)
                Text(title)
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .primaryText()
                if let count {
                    Text(count)
                        .font(.system(size: 11, weight: .medium))
                        .secondaryText()
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background {
                RoundedRectangle(cornerRadius: 14)
                    .fill(theme.colors.surface.opacity(0.35))
                    .overlay {
                        RoundedRectangle(cornerRadius: 14)
                            .strokeBorder(theme.colors.cardBorder.opacity(0.1), lineWidth: 1)
                    }
            }
        }
        .buttonStyle(BounceButtonStyle())
    }
}

struct PulseWaveView: View {
    @Environment(\.theme) private var theme
    @State private var phase: Double = 0

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let midY = size.height / 2
                let amplitude = size.height * 0.3
                let time = timeline.date.timeIntervalSinceReferenceDate

                var path = Path()
                for x in stride(from: 0, to: size.width, by: 2) {
                    let normalized = x / size.width
                    let nd = Double(normalized)
                    let y = midY + CGFloat(sin(nd * .pi * 4.0 + time * 3.0) * sin(nd * .pi)) * amplitude
                    if x == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
                context.stroke(path, with: .color(theme.colors.accent), lineWidth: 3)
            }
        }
    }
}
