import SwiftUI
import SwiftData

struct DriftView: View {
    @Environment(\.theme) private var theme
    @Environment(\.modelContext) private var modelContext
    @Environment(AppState.self) private var appState
    let mode: DriftMode

    @State private var viewModel = DriftViewModel()
    @State private var showCompletion = false
    @State private var showAchievementToast = false
    @State private var latestAchievement: Achievement?

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                header.padding(.horizontal, 16).padding(.top, 8)
                Spacer(minLength: 8)
                if let puzzle = viewModel.puzzle {
                    envLabel(puzzle).padding(.bottom, 8)
                    if viewModel.showTarget {
                        targetSection(puzzle).padding(.horizontal, 16).padding(.bottom, 12)
                    }
                    sliderSection(puzzle).padding(.horizontal, 16)
                    Spacer(minLength: 12)
                    bottomControls.padding(.horizontal, 20).padding(.bottom, 16)
                } else {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
            if viewModel.showConfetti { ConfettiView().ignoresSafeArea() }
            if showAchievementToast, let ach = latestAchievement {
                achievementToast(ach).transition(.move(edge: .top).combined(with: .opacity)).zIndex(10)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .themedBackground()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(modeLabel).font(.system(size: 18, weight: .bold, design: .rounded)).primaryText()
            }
        }
        .task { viewModel.startGame(level: levelForMode, modelContext: modelContext) }
        .onDisappear { viewModel.cleanup() }
        .onChange(of: viewModel.isComplete) { _, done in
            if done {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) { showCompletion = true }
                updateHighestLevel()
            }
        }
        .onChange(of: viewModel.newAchievements.count) { _, count in
            if count > 0 {
                latestAchievement = viewModel.newAchievements.last
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) { showAchievementToast = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { withAnimation { showAchievementToast = false } }
            }
        }
        .fullScreenCover(isPresented: $showCompletion) { completionView }
    }

    private var header: some View {
        HStack(spacing: 12) {
            headerPill(icon: "clock.fill", value: TimeInterval(viewModel.timerSeconds).formattedMMSS, color: theme.colors.textMuted)
            Spacer()
            headerPill(icon: "waveform", value: "\(viewModel.puzzle?.channelCount ?? 0) ch", color: theme.colors.accent)
            Spacer()
            headerPill(icon: "percent", value: "\(Int(viewModel.accuracy * 100))%", color: theme.colors.secondary)
        }
    }

    private func headerPill(icon: String, value: String, color: Color) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon).font(.system(size: 11, weight: .bold))
            Text(value).font(.system(size: 14, weight: .bold, design: .rounded)).monospacedDigit()
        }
        .foregroundStyle(color).padding(.horizontal, 12).padding(.vertical, 6)
        .background { Capsule().fill(color.opacity(0.1)).overlay { Capsule().strokeBorder(color.opacity(0.15), lineWidth: 1) } }
    }

    private func envLabel(_ puzzle: SoundscapePuzzle) -> some View {
        Text(puzzle.environment.rawValue.capitalized)
            .font(.system(size: 13, weight: .medium, design: .rounded))
            .foregroundStyle(theme.colors.accent.opacity(0.8))
            .padding(.horizontal, 14).padding(.vertical, 6)
            .background { Capsule().fill(theme.colors.accent.opacity(0.08)) }
    }

    private func targetSection(_ puzzle: SoundscapePuzzle) -> some View {
        VStack(spacing: 8) {
            Text("Target Mix").font(.system(size: 12, weight: .bold, design: .rounded)).secondaryText()
            HStack(spacing: 8) {
                ForEach(Array(puzzle.channels.enumerated()), id: \.element.id) { i, ch in
                    VStack(spacing: 4) {
                        targetBar(value: puzzle.targetVolumes[i], color: Color(hex: ch.colorHex))
                        Image(systemName: ch.icon).font(.system(size: 10)).foregroundStyle(Color(hex: ch.colorHex))
                    }
                }
            }
        }
        .padding(12)
        .background {
            RoundedRectangle(cornerRadius: 14).fill(theme.colors.surface.opacity(0.4))
                .overlay { RoundedRectangle(cornerRadius: 14).strokeBorder(theme.colors.accent.opacity(0.1), lineWidth: 1) }
        }
    }

    private func targetBar(value: Double, color: Color) -> some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 4).fill(theme.colors.cellBackground.opacity(0.3)).frame(width: 20, height: 50)
            RoundedRectangle(cornerRadius: 4).fill(color.opacity(0.6)).frame(width: 20, height: CGFloat(value) * 50)
        }
    }

    private func sliderSection(_ puzzle: SoundscapePuzzle) -> some View {
        VStack(spacing: 12) {
            ForEach(Array(puzzle.channels.enumerated()), id: \.element.id) { i, ch in
                channelRow(index: i, channel: ch)
            }
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 18).fill(theme.colors.surface.opacity(0.4))
                .overlay { RoundedRectangle(cornerRadius: 18).strokeBorder(theme.colors.boardBorder.opacity(0.12), lineWidth: 1) }
        }
    }

    private func channelRow(index: Int, channel: SoundChannel) -> some View {
        let color = Color(hex: channel.colorHex)
        return HStack(spacing: 12) {
            ZStack {
                Circle().fill(color.opacity(0.15)).frame(width: 36, height: 36)
                Image(systemName: channel.icon).font(.system(size: 14, weight: .bold)).foregroundStyle(color)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(channel.name).font(.system(size: 13, weight: .bold, design: .rounded)).primaryText()
                SliderView(value: Binding(get: { viewModel.volumes[index] }, set: { viewModel.setVolume($0, for: index) }), color: color)
            }
            Text("\(Int(viewModel.volumes[index] * 100))%")
                .font(.system(size: 12, weight: .bold, design: .monospaced))
                .foregroundStyle(color)
                .frame(width: 40, alignment: .trailing)
        }
    }

    private var bottomControls: some View {
        HStack(spacing: 16) {
            controlButton(icon: "eye.fill", label: "Peek", color: .orange) { viewModel.revealTarget() }
            controlButton(icon: "checkmark.circle.fill", label: "Submit", color: theme.colors.accent) { viewModel.submitMix() }
            controlButton(icon: "arrow.counterclockwise", label: "Reset", color: theme.colors.textSecondary) {
                viewModel.startGame(level: levelForMode, modelContext: modelContext)
            }
        }
    }

    private func controlButton(icon: String, label: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    Circle().fill(color.opacity(0.12)).frame(width: 50, height: 50)
                    Image(systemName: icon).font(.system(size: 20, weight: .semibold)).foregroundStyle(color)
                }
                Text(label).font(.system(size: 11, weight: .bold, design: .rounded)).foregroundStyle(theme.colors.textSecondary)
            }
        }.buttonStyle(BounceButtonStyle()).frame(maxWidth: .infinity)
    }

    // MARK: - Completion

    private var completionView: some View {
        ZStack {
            if viewModel.showConfetti { ConfettiView().ignoresSafeArea() }
            VStack(spacing: 20) {
                Spacer()
                Text(viewModel.stars >= 3 ? "Perfect Mix!" : "Mixed!").font(.system(size: 32, weight: .black, design: .rounded)).primaryText()
                completionStars
                accuracyBadge
                xpBadge
                completionStats
                Spacer()
                completionButtons.padding(.horizontal, 32).padding(.bottom, 32)
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity).themedBackground()
    }

    private var completionStars: some View {
        HStack(spacing: 12) {
            ForEach(1...3, id: \.self) { star in
                Image(systemName: star <= viewModel.stars ? "star.fill" : "star")
                    .font(.system(size: 38, weight: .bold))
                    .foregroundStyle(star <= viewModel.stars ? Color.yellow : theme.colors.textMuted.opacity(0.25))
                    .shadow(color: star <= viewModel.stars ? Color.yellow.opacity(0.5) : .clear, radius: 6)
            }
        }
    }

    private var accuracyBadge: some View {
        Text("\(Int(viewModel.accuracy * 100))% Accuracy")
            .font(.system(size: 20, weight: .black, design: .rounded))
            .foregroundStyle(theme.colors.accent)
            .padding(.horizontal, 16).padding(.vertical, 8)
            .background { Capsule().fill(theme.colors.accent.opacity(0.12)) }
    }

    @ViewBuilder private var xpBadge: some View {
        if viewModel.xpEarned > 0 {
            HStack(spacing: 4) {
                Image(systemName: "headphones").font(.system(size: 16))
                Text("+\(viewModel.xpEarned) XP").font(.system(size: 18, weight: .black, design: .rounded))
            }.foregroundStyle(theme.colors.accent)
        }
    }

    private var completionStats: some View {
        VStack(spacing: 8) {
            statRow("Time", TimeInterval(viewModel.timerSeconds).formattedMMSS)
            statRow("Channels", "\(viewModel.puzzle?.channelCount ?? 0)")
            statRow("Environment", viewModel.puzzle?.environment.rawValue.capitalized ?? "—")
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 16).fill(theme.colors.surface.opacity(0.4))
                .overlay { RoundedRectangle(cornerRadius: 16).strokeBorder(theme.colors.boardBorder.opacity(0.12), lineWidth: 1) }
        }.padding(.horizontal, 32)
    }

    private var completionButtons: some View {
        VStack(spacing: 12) {
            if case .mix(let index) = mode {
                GlassButton("Next Mix", icon: "arrow.right") {
                    HapticsService.medium(); showCompletion = false; appState.pop()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { appState.navigateInCurrentTab(to: .drift(mode: .mix(index: index + 1))) }
                }
            }
            GlassButton("Home", icon: "house.fill", style: .secondary) {
                HapticsService.light(); showCompletion = false; appState.popToRoot()
            }
        }
    }

    // MARK: - Helpers

    private var levelForMode: Int {
        switch mode {
        case .mix(let i): i
        case .daily: dailyLevel
        case .freeform: Int.random(in: 0..<DriftConfig.totalLevels)
        }
    }

    private var dailyLevel: Int {
        let c = Calendar.current.dateComponents([.year, .month, .day], from: .now)
        return ((c.year ?? 2026) * 10000 + (c.month ?? 1) * 100 + (c.day ?? 1)) % DriftConfig.totalLevels
    }

    private var modeLabel: String {
        switch mode {
        case .mix(let i): "Mix \(i + 1)"
        case .daily: "Daily Mix"
        case .freeform: "Free Mix"
        }
    }

    private func updateHighestLevel() {
        let descriptor = FetchDescriptor<SettingsRecord>()
        guard let settings = try? modelContext.fetch(descriptor).first else { return }
        if levelForMode >= settings.currentLevelIndex { settings.currentLevelIndex = levelForMode + 1 }
    }

    private func achievementToast(_ ach: Achievement) -> some View {
        VStack {
            HStack(spacing: 10) {
                Image(systemName: ach.icon).font(.system(size: 22)).foregroundStyle(theme.colors.accent)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Achievement Unlocked!").font(.system(size: 11, weight: .bold)).foregroundStyle(theme.colors.accent)
                    Text(ach.title).font(.system(size: 16, weight: .black, design: .rounded)).primaryText()
                }
                Spacer()
                Text("+\(ach.tier.xpReward) XP").font(.system(size: 13, weight: .bold, design: .monospaced)).foregroundStyle(theme.colors.accent)
            }.padding(14).background {
                RoundedRectangle(cornerRadius: 16).fill(.ultraThinMaterial).shadow(color: theme.colors.accent.opacity(0.2), radius: 8, y: 4)
                    .overlay { RoundedRectangle(cornerRadius: 16).strokeBorder(theme.colors.accent.opacity(0.3), lineWidth: 1) }
            }.padding(.horizontal, 16).padding(.top, 60)
            Spacer()
        }
    }

    private func statRow(_ label: String, _ value: String) -> some View {
        HStack { Text(label).secondaryText(); Spacer(); Text(value).font(.body.weight(.semibold)).primaryText() }
    }
}

// MARK: - Slider View

struct SliderView: View {
    @Binding var value: Double
    let color: Color

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(color.opacity(0.15)).frame(height: 8)
                Capsule()
                    .fill(LinearGradient(colors: [color, color.opacity(0.7)], startPoint: .leading, endPoint: .trailing))
                    .frame(width: max(8, geo.size.width * value), height: 8)
                Circle().fill(color).frame(width: 20, height: 20)
                    .shadow(color: color.opacity(0.3), radius: 4)
                    .offset(x: max(0, geo.size.width * value - 10))
            }
            .contentShape(Rectangle())
            .gesture(DragGesture(minimumDistance: 0).onChanged { drag in
                let newVal = max(0, min(1, drag.location.x / geo.size.width))
                value = (newVal * 20).rounded() / 20
            })
        }.frame(height: 20)
    }
}
