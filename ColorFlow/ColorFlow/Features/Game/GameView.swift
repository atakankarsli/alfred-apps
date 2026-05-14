import SwiftUI
import SwiftData

struct GameView: View {
    @Environment(\.theme) private var theme
    @Environment(\.modelContext) private var modelContext
    @Environment(AppState.self) private var appState
    @Query private var settings: [SettingsRecord]

    let mode: GameMode

    @State private var viewModel = GameViewModel()
    @State private var showCompletion = false
    @State private var showAchievementToast = false
    @State private var latestAchievement: Achievement?
    @State private var gridShake: CGFloat = 0

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                header
                    .padding(.horizontal, 16)
                    .padding(.top, 8)

                Spacer(minLength: 16)

                energyGrid
                    .padding(.horizontal, 20)
                    .offset(x: gridShake)

                Spacer(minLength: 16)

                progressArea
                    .padding(.horizontal, 16)

                Spacer(minLength: 12)

                bottomControls
                    .padding(.horizontal, 20)
                    .padding(.bottom, 16)
            }

            if viewModel.showConfetti {
                ConfettiView()
                    .ignoresSafeArea()
            }

            if showAchievementToast, let achievement = latestAchievement {
                achievementToast(achievement)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .zIndex(10)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .themedBackground()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(modeLabel)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .primaryText()
            }
        }
        .task {
            viewModel.startGame(
                level: levelForMode,
                modelContext: modelContext,
                showTimer: settings.first?.showTimer ?? true
            )
        }
        .onDisappear { viewModel.cleanup() }
        .onChange(of: viewModel.isComplete) { _, isComplete in
            if isComplete {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    showCompletion = true
                }
                if case .level = mode {
                    if let s = settings.first, levelForMode >= s.currentLevelIndex {
                        s.currentLevelIndex = levelForMode + 1
                    }
                }
            }
        }
        .onChange(of: viewModel.taps) { _, _ in
            withAnimation(.spring(response: 0.08, dampingFraction: 0.3)) { gridShake = 3 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
                withAnimation(.spring(response: 0.08, dampingFraction: 0.3)) { gridShake = -2 }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.16) {
                withAnimation(.spring(response: 0.1, dampingFraction: 0.5)) { gridShake = 0 }
            }
        }
        .onChange(of: viewModel.newAchievements.count) { _, count in
            if count > 0 {
                latestAchievement = viewModel.newAchievements.last
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) { showAchievementToast = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation { showAchievementToast = false }
                }
            }
        }
        .fullScreenCover(isPresented: $showCompletion) { completionView }
    }

    // MARK: - Header

    private var header: some View {
        HStack(spacing: 12) {
            headerPill(icon: "hand.tap.fill", value: "\(viewModel.taps)", color: theme.colors.accent)
            Spacer()
            if viewModel.timerSeconds > 0, settings.first?.showTimer ?? true {
                headerPill(icon: "clock.fill", value: TimeInterval(viewModel.timerSeconds).formattedMMSS, color: theme.colors.textMuted)
            }
            Spacer()
            if let puzzle = viewModel.puzzle {
                headerPill(icon: "target", value: "\(puzzle.parTaps)", color: theme.colors.secondary)
            }
        }
    }

    private func headerPill(icon: String, value: String, color: Color) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon).font(.system(size: 11, weight: .bold))
            Text(value).font(.system(size: 16, weight: .bold, design: .rounded)).monospacedDigit()
        }
        .foregroundStyle(color)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background {
            Capsule().fill(color.opacity(0.1))
                .overlay { Capsule().strokeBorder(color.opacity(0.15), lineWidth: 1) }
        }
    }

    // MARK: - Energy Grid

    private var energyGrid: some View {
        Group {
            if let puzzle = viewModel.puzzle {
                let gridSize = puzzle.gridSize
                let spacing: CGFloat = gridSize <= 4 ? 8 : (gridSize <= 5 ? 6 : 4)

                GeometryReader { geo in
                    let totalSpacing = spacing * CGFloat(gridSize - 1)
                    let maxSize = min(geo.size.width, geo.size.height)
                    let cellSize = (maxSize - totalSpacing) / CGFloat(gridSize)

                    VStack(spacing: spacing) {
                        ForEach(0..<gridSize, id: \.self) { row in
                            HStack(spacing: spacing) {
                                ForEach(0..<gridSize, id: \.self) { col in
                                    let index = row * gridSize + col
                                    let cellEnergy = index < viewModel.energy.count ? viewModel.energy[index] : 0
                                    let critical = puzzle.criticalMass(at: index)
                                    let isExploding = viewModel.explosionCells.contains(index)
                                    let wasExploded = viewModel.recentlyExploded.contains(index)

                                    EnergyCellView(
                                        energy: cellEnergy,
                                        criticalMass: critical,
                                        isExploding: isExploding,
                                        wasExploded: wasExploded,
                                        size: cellSize
                                    )
                                    .onTapGesture {
                                        viewModel.tapCell(at: index)
                                    }
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .aspectRatio(1, contentMode: .fit)
            } else {
                ProgressView().frame(maxWidth: .infinity)
            }
        }
    }

    // MARK: - Progress

    private var progressArea: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                ForEach(1...3, id: \.self) { star in
                    Image(systemName: star <= viewModel.stars ? "star.fill" : "star")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(star <= viewModel.stars ? Color.yellow : theme.colors.textMuted.opacity(0.25))
                        .shadow(color: star <= viewModel.stars ? Color.yellow.opacity(0.4) : .clear, radius: 4)
                }
            }
            let remaining = viewModel.energy.filter { $0 > 0 }.count
            let total = viewModel.energy.count
            Text("\(remaining)/\(total) remaining")
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .mutedText()
        }
    }

    // MARK: - Bottom Controls

    private var bottomControls: some View {
        HStack(spacing: 16) {
            gameControlButton(icon: "arrow.counterclockwise", label: "Reset", color: theme.colors.textSecondary) {
                viewModel.startGame(
                    level: levelForMode,
                    modelContext: modelContext,
                    showTimer: settings.first?.showTimer ?? true
                )
                HapticsService.medium()
            }

            gameControlButton(icon: "arrow.uturn.backward", label: "Undo", color: theme.colors.accent) {
                viewModel.undo()
            }
            .opacity(viewModel.tapHistory.isEmpty || viewModel.isComplete || viewModel.isAnimating ? 0.4 : 1)
            .disabled(viewModel.tapHistory.isEmpty || viewModel.isComplete || viewModel.isAnimating)
        }
    }

    private func gameControlButton(icon: String, label: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    Circle().fill(color.opacity(0.12)).frame(width: 50, height: 50)
                    Image(systemName: icon).font(.system(size: 20, weight: .semibold)).foregroundStyle(color)
                }
                Text(label).font(.system(size: 11, weight: .bold, design: .rounded)).foregroundStyle(theme.colors.textSecondary)
            }
        }
        .buttonStyle(BounceButtonStyle())
        .frame(maxWidth: .infinity)
    }

    // MARK: - Completion

    private var completionView: some View {
        ZStack {
            if viewModel.showConfetti { ConfettiView().ignoresSafeArea() }
            completionContent
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .themedBackground()
    }

    private var completionContent: some View {
        VStack(spacing: 20) {
            Spacer()

            Text(viewModel.stars >= 3 ? "Supernova!" : "Cleared!")
                .font(.system(size: 32, weight: .black, design: .rounded))
                .primaryText()

            HStack(spacing: 12) {
                ForEach(1...3, id: \.self) { star in
                    Image(systemName: star <= viewModel.stars ? "star.fill" : "star")
                        .font(.system(size: 38, weight: .bold))
                        .foregroundStyle(star <= viewModel.stars ? Color.yellow : theme.colors.textMuted.opacity(0.25))
                        .shadow(color: star <= viewModel.stars ? Color.yellow.opacity(0.5) : .clear, radius: 6)
                        .scaleEffect(star <= viewModel.stars ? 1.0 : 0.8)
                        .animation(.spring(response: 0.4, dampingFraction: 0.6).delay(Double(star) * 0.15), value: showCompletion)
                }
            }

            if viewModel.xpEarned > 0 {
                HStack(spacing: 4) {
                    Image(systemName: "bolt.fill").font(.system(size: 16))
                    Text("+\(viewModel.xpEarned) XP").font(.system(size: 20, weight: .black, design: .rounded))
                }
                .foregroundStyle(theme.colors.accent)
                .padding(.horizontal, 16).padding(.vertical, 8)
                .background { Capsule().fill(theme.colors.accent.opacity(0.12)) }
            }

            VStack(spacing: 8) {
                statRow("Taps", "\(viewModel.taps)")
                if let puzzle = viewModel.puzzle { statRow("Par", "\(puzzle.parTaps)") }
                statRow("Time", TimeInterval(viewModel.timerSeconds).formattedMMSS)
                if viewModel.chainSteps.count > 0 { statRow("Chain", "\(viewModel.chainSteps.count) steps") }
            }
            .padding(16)
            .background {
                RoundedRectangle(cornerRadius: 16).fill(theme.colors.surface.opacity(0.4))
                    .overlay { RoundedRectangle(cornerRadius: 16).strokeBorder(theme.colors.boardBorder.opacity(0.12), lineWidth: 1) }
            }
            .padding(.horizontal, 32)

            if !viewModel.newAchievements.isEmpty {
                VStack(spacing: 6) {
                    ForEach(viewModel.newAchievements) { ach in
                        HStack(spacing: 8) {
                            Image(systemName: ach.icon).font(.system(size: 16)).foregroundStyle(theme.colors.accent)
                            Text(ach.title).font(.system(size: 14, weight: .bold, design: .rounded)).primaryText()
                            Spacer()
                            Text("+\(ach.tier.xpReward) XP").font(.system(size: 12, weight: .bold, design: .monospaced)).foregroundStyle(theme.colors.accent)
                        }
                    }
                }
                .padding(14)
                .background {
                    RoundedRectangle(cornerRadius: 14).fill(theme.colors.accent.opacity(0.06))
                        .overlay { RoundedRectangle(cornerRadius: 14).strokeBorder(theme.colors.accent.opacity(0.15), lineWidth: 1) }
                }
                .padding(.horizontal, 32)
            }

            Spacer()

            VStack(spacing: 12) {
                if case .level(let index) = mode {
                    GlassButton("Next Level", icon: "arrow.right") {
                        HapticsService.medium()
                        showCompletion = false
                        appState.pop()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            appState.navigateInCurrentTab(to: .game(mode: .level(index: index + 1)))
                        }
                    }
                }
                GlassButton("Home", icon: "house.fill", style: .secondary) {
                    HapticsService.light()
                    showCompletion = false
                    appState.popToRoot()
                }
            }
            .padding(.horizontal, 32).padding(.bottom, 32)
        }
    }

    // MARK: - Helpers

    private var levelForMode: Int {
        switch mode {
        case .level(let index): index
        case .daily: dailyLevel
        case .infinite: Int.random(in: 0..<GameConfig.totalLevels)
        }
    }

    private var dailyLevel: Int {
        let c = Calendar.current.dateComponents([.year, .month, .day], from: .now)
        return ((c.year ?? 2026) * 10000 + (c.month ?? 1) * 100 + (c.day ?? 1)) % GameConfig.totalLevels
    }

    private var modeLabel: String {
        switch mode {
        case .level(let index): "Level \(index + 1)"
        case .daily: "Daily Puzzle"
        case .infinite: "Quick Play"
        }
    }

    private func achievementToast(_ achievement: Achievement) -> some View {
        VStack {
            HStack(spacing: 10) {
                Image(systemName: achievement.icon).font(.system(size: 22)).foregroundStyle(theme.colors.accent)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Achievement Unlocked!").font(.system(size: 11, weight: .bold)).foregroundStyle(theme.colors.accent)
                    Text(achievement.title).font(.system(size: 16, weight: .black, design: .rounded)).primaryText()
                }
                Spacer()
                Text("+\(achievement.tier.xpReward) XP").font(.system(size: 13, weight: .bold, design: .monospaced)).foregroundStyle(theme.colors.accent)
            }
            .padding(14)
            .background {
                RoundedRectangle(cornerRadius: 16).fill(.ultraThinMaterial)
                    .shadow(color: theme.colors.accent.opacity(0.2), radius: 8, y: 4)
                    .overlay { RoundedRectangle(cornerRadius: 16).strokeBorder(theme.colors.accent.opacity(0.3), lineWidth: 1) }
            }
            .padding(.horizontal, 16).padding(.top, 60)
            Spacer()
        }
    }

    private func statRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label).secondaryText()
            Spacer()
            Text(value).font(.body.weight(.semibold)).primaryText()
        }
    }
}

// MARK: - Energy Cell View

struct EnergyCellView: View {
    @Environment(\.theme) private var theme

    let energy: Int
    let criticalMass: Int
    let isExploding: Bool
    let wasExploded: Bool
    let size: CGFloat

    private var energyRatio: Double {
        guard criticalMass > 0 else { return 0 }
        return min(1.0, Double(energy) / Double(criticalMass))
    }

    private var energyColor: Color {
        if energy == 0 { return theme.colors.cellBackground.opacity(0.3) }
        switch energyRatio {
        case 0..<0.5: return Color(hex: "5BC0EB")
        case 0.5..<0.8: return Color(hex: "FDE74C")
        default: return Color(hex: "FF6B35")
        }
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.2)
                .fill(cellFill)
                .frame(width: size, height: size)
                .shadow(
                    color: energy > 0 ? energyColor.opacity(0.5) : .clear,
                    radius: energy > 0 ? size * 0.2 * energyRatio : 0
                )
                .overlay {
                    if energy > 0 {
                        RoundedRectangle(cornerRadius: size * 0.2)
                            .fill(
                                RadialGradient(
                                    colors: [Color.white.opacity(0.3 * energyRatio), Color.clear],
                                    center: .init(x: 0.4, y: 0.35),
                                    startRadius: 0,
                                    endRadius: size * 0.5
                                )
                            )
                    }
                }
                .overlay {
                    RoundedRectangle(cornerRadius: size * 0.2)
                        .strokeBorder(
                            energy > 0 ? energyColor.opacity(0.6) : theme.colors.boardBorder.opacity(0.1),
                            lineWidth: energy > 0 ? 1.5 : 0.5
                        )
                }
                .overlay {
                    if energy > 0 {
                        Text("\(energy)")
                            .font(.system(size: size * 0.3, weight: .black, design: .rounded))
                            .foregroundStyle(.white.opacity(0.9))
                    }
                }
                .scaleEffect(isExploding ? 1.3 : 1.0)
                .opacity(isExploding ? 0.3 : 1.0)
                .animation(.spring(response: 0.15, dampingFraction: 0.4), value: isExploding)
                .animation(.easeInOut(duration: 0.2), value: energy)
        }
    }

    private var cellFill: some ShapeStyle {
        if energy == 0 {
            return AnyShapeStyle(theme.colors.cellBackground.opacity(0.3))
        }
        return AnyShapeStyle(
            LinearGradient(
                colors: [energyColor, energyColor.opacity(0.7)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}
