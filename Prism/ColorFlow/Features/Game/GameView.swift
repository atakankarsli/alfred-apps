import SwiftUI
import SwiftData

struct PrismView: View {
    @Environment(\.theme) private var theme
    @Environment(\.modelContext) private var modelContext
    @Environment(AppState.self) private var appState
    @Query private var settings: [SettingsRecord]

    let mode: PrismMode

    @State private var viewModel = PrismViewModel()
    @State private var showCompletion = false
    @State private var showAchievementToast = false
    @State private var latestAchievement: Achievement?
    @State private var gridShake: CGFloat = 0

    var body: some View {
        ZStack {
            gameBody
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
                Text(modeLabel)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .primaryText()
            }
        }
        .task {
            viewModel.startGame(level: levelForMode, modelContext: modelContext, showTimer: settings.first?.showTimer ?? true)
        }
        .onDisappear { viewModel.cleanup() }
        .onChange(of: viewModel.isComplete) { _, done in
            if done {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) { showCompletion = true }
                if case .level = mode, let s = settings.first, levelForMode >= s.currentLevelIndex {
                    s.currentLevelIndex = levelForMode + 1
                }
            }
        }
        .onChange(of: viewModel.moves) { _, _ in
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { withAnimation { showAchievementToast = false } }
            }
        }
        .fullScreenCover(isPresented: $showCompletion) { completionView }
    }

    // MARK: - Game Body

    private var gameBody: some View {
        VStack(spacing: 0) {
            header.padding(.horizontal, 16).padding(.top, 8)
            Spacer(minLength: 16)
            prismGrid.padding(.horizontal, 20).offset(x: gridShake)
            Spacer(minLength: 16)
            progressArea.padding(.horizontal, 16)
            Spacer(minLength: 12)
            bottomControls.padding(.horizontal, 20).padding(.bottom, 16)
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack(spacing: 12) {
            headerPill(icon: "arrow.triangle.2.circlepath", value: "\(viewModel.moves)", color: theme.colors.accent)
            Spacer()
            if viewModel.timerSeconds > 0, settings.first?.showTimer ?? true {
                headerPill(icon: "clock.fill", value: TimeInterval(viewModel.timerSeconds).formattedMMSS, color: theme.colors.textMuted)
            }
            Spacer()
            if let puzzle = viewModel.puzzle {
                headerPill(icon: "target", value: "\(puzzle.parMoves)", color: theme.colors.secondary)
            }
        }
    }

    private func headerPill(icon: String, value: String, color: Color) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon).font(.system(size: 11, weight: .bold))
            Text(value).font(.system(size: 16, weight: .bold, design: .rounded)).monospacedDigit()
        }
        .foregroundStyle(color)
        .padding(.horizontal, 12).padding(.vertical, 6)
        .background {
            Capsule().fill(color.opacity(0.1))
                .overlay { Capsule().strokeBorder(color.opacity(0.15), lineWidth: 1) }
        }
    }

    // MARK: - Prism Grid

    private var prismGrid: some View {
        Group {
            if let puzzle = viewModel.puzzle {
                let gs = puzzle.gridSize
                let spacing: CGFloat = gs <= 5 ? 6 : 4

                GeometryReader { geo in
                    let totalSpacing = spacing * CGFloat(gs - 1)
                    let maxSize = min(geo.size.width, geo.size.height)
                    let cellSize = (maxSize - totalSpacing) / CGFloat(gs)

                    cellGridView(puzzle: puzzle, cellSize: cellSize, spacing: spacing)
                        .overlay { beamOverlayView(cellSize: cellSize, spacing: spacing) }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .aspectRatio(1, contentMode: .fit)
            } else {
                ProgressView().frame(maxWidth: .infinity)
            }
        }
    }

    private func cellGridView(puzzle: PrismPuzzle, cellSize: CGFloat, spacing: CGFloat) -> some View {
        VStack(spacing: spacing) {
            ForEach(0..<puzzle.gridSize, id: \.self) { row in
                HStack(spacing: spacing) {
                    ForEach(0..<puzzle.gridSize, id: \.self) { col in
                        prismCellView(row: row, col: col, puzzle: puzzle, cellSize: cellSize)
                    }
                }
            }
        }
    }

    private func prismCellView(row: Int, col: Int, puzzle: PrismPuzzle, cellSize: CGFloat) -> some View {
        let index = row * puzzle.gridSize + col
        let emitter = puzzle.emitters.first { $0.index == index }
        let target = puzzle.targets.first { $0.index == index }
        let isEmitter = emitter != nil

        return Group {
            if let emitter {
                emitterCell(emitter: emitter, cellSize: cellSize)
            } else if let target {
                targetCell(target: target, cellSize: cellSize)
            } else {
                emptyCell(cellSize: cellSize)
            }
        }
        .frame(width: cellSize, height: cellSize)
        .onTapGesture {
            if isEmitter {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    viewModel.rotateEmitter(at: index)
                }
            }
        }
    }

    private func emitterCell(emitter: Emitter, cellSize: CGFloat) -> some View {
        let dir = viewModel.emitterDirections[emitter.index] ?? 0
        let rotation = Double(dir) * 90.0

        return ZStack {
            RoundedRectangle(cornerRadius: cellSize * 0.2)
                .fill(emitter.color.swiftColor.opacity(0.15))
                .overlay {
                    RoundedRectangle(cornerRadius: cellSize * 0.2)
                        .strokeBorder(emitter.color.swiftColor.opacity(0.4), lineWidth: 1.5)
                }

            Circle()
                .fill(emitter.color.swiftColor.opacity(0.85))
                .frame(width: cellSize * 0.45, height: cellSize * 0.45)
                .shadow(color: emitter.color.swiftColor.opacity(0.5), radius: 4)

            Image(systemName: "arrow.up")
                .font(.system(size: cellSize * 0.22, weight: .bold))
                .foregroundStyle(.white)
                .rotationEffect(.degrees(rotation))
        }
    }

    private func targetCell(target: Target, cellSize: CGFloat) -> some View {
        let received = viewModel.cellColors[target.index]
        let matches = received == target.required

        return ZStack {
            RoundedRectangle(cornerRadius: cellSize * 0.2)
                .fill(matches ? Color.green.opacity(0.08) : target.required.swiftColor.opacity(0.06))
                .overlay {
                    RoundedRectangle(cornerRadius: cellSize * 0.2)
                        .strokeBorder(
                            matches ? Color.green.opacity(0.6) : target.required.swiftColor.opacity(0.3),
                            lineWidth: matches ? 2 : 1
                        )
                }

            Circle()
                .strokeBorder(target.required.swiftColor, lineWidth: 2)
                .frame(width: cellSize * 0.5, height: cellSize * 0.5)

            if let received, received != .off {
                Circle()
                    .fill(received.swiftColor.opacity(0.7))
                    .frame(width: cellSize * 0.3, height: cellSize * 0.3)
            }

            if matches {
                Image(systemName: "checkmark")
                    .font(.system(size: cellSize * 0.22, weight: .bold))
                    .foregroundStyle(.green)
            }
        }
    }

    private func emptyCell(cellSize: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: cellSize * 0.15)
            .fill(theme.colors.cellBackground.opacity(0.2))
            .overlay {
                RoundedRectangle(cornerRadius: cellSize * 0.15)
                    .strokeBorder(theme.colors.boardBorder.opacity(0.08), lineWidth: 0.5)
            }
    }

    // MARK: - Beams

    private func beamOverlayView(cellSize: CGFloat, spacing: CGFloat) -> some View {
        ForEach(Array(viewModel.beamSegments.enumerated()), id: \.offset) { _, seg in
            beamLine(seg: seg, cellSize: cellSize, spacing: spacing)
        }
        .allowsHitTesting(false)
    }

    private func beamLine(seg: BeamSegment, cellSize: CGFloat, spacing: CGFloat) -> some View {
        let step = cellSize + spacing
        let fromX = CGFloat(seg.fromCol) * step + cellSize / 2
        let fromY = CGFloat(seg.fromRow) * step + cellSize / 2
        let toX = CGFloat(seg.toCol) * step + cellSize / 2
        let toY = CGFloat(seg.toRow) * step + cellSize / 2

        return Path { path in
            path.move(to: CGPoint(x: fromX, y: fromY))
            path.addLine(to: CGPoint(x: toX, y: toY))
        }
        .stroke(seg.color.swiftColor.opacity(0.75), lineWidth: 3)
        .shadow(color: seg.color.swiftColor.opacity(0.5), radius: 6)
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
            if let puzzle = viewModel.puzzle {
                let matched = puzzle.targets.filter { viewModel.cellColors[$0.index] == $0.required }.count
                Text("\(matched)/\(puzzle.targets.count) targets lit")
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .mutedText()
            }
        }
    }

    // MARK: - Bottom Controls

    private var bottomControls: some View {
        HStack(spacing: 16) {
            controlButton(icon: "arrow.counterclockwise", label: "Reset", color: theme.colors.textSecondary) {
                viewModel.startGame(level: levelForMode, modelContext: modelContext, showTimer: settings.first?.showTimer ?? true)
                HapticsService.medium()
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

            Text(viewModel.stars >= 3 ? "Brilliant!" : "Solved!")
                .font(.system(size: 32, weight: .black, design: .rounded))
                .primaryText()

            completionStars

            if viewModel.xpEarned > 0 { completionXP }

            completionStats

            if !viewModel.newAchievements.isEmpty { completionAchievements }

            Spacer()

            completionButtons
        }
    }

    private var completionStars: some View {
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
    }

    private var completionXP: some View {
        HStack(spacing: 4) {
            Image(systemName: "bolt.fill").font(.system(size: 16))
            Text("+\(viewModel.xpEarned) XP").font(.system(size: 20, weight: .black, design: .rounded))
        }
        .foregroundStyle(theme.colors.accent)
        .padding(.horizontal, 16).padding(.vertical, 8)
        .background { Capsule().fill(theme.colors.accent.opacity(0.12)) }
    }

    private var completionStats: some View {
        VStack(spacing: 8) {
            statRow("Moves", "\(viewModel.moves)")
            if let puzzle = viewModel.puzzle { statRow("Par", "\(puzzle.parMoves)") }
            statRow("Time", TimeInterval(viewModel.timerSeconds).formattedMMSS)
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 16).fill(theme.colors.surface.opacity(0.4))
                .overlay { RoundedRectangle(cornerRadius: 16).strokeBorder(theme.colors.boardBorder.opacity(0.12), lineWidth: 1) }
        }
        .padding(.horizontal, 32)
    }

    private var completionAchievements: some View {
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

    private var completionButtons: some View {
        VStack(spacing: 12) {
            if case .level(let index) = mode {
                GlassButton("Next Level", icon: "arrow.right") {
                    HapticsService.medium()
                    showCompletion = false
                    appState.pop()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        appState.navigateInCurrentTab(to: .prism(mode: .level(index: index + 1)))
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

    // MARK: - Helpers

    private var levelForMode: Int {
        switch mode {
        case .level(let index): index
        case .daily: dailyLevel
        case .freePlay: Int.random(in: 0..<PrismConfig.totalLevels)
        }
    }

    private var dailyLevel: Int {
        let c = Calendar.current.dateComponents([.year, .month, .day], from: .now)
        return ((c.year ?? 2026) * 10000 + (c.month ?? 1) * 100 + (c.day ?? 1)) % PrismConfig.totalLevels
    }

    private var modeLabel: String {
        switch mode {
        case .level(let index): "Level \(index + 1)"
        case .daily: "Daily Puzzle"
        case .freePlay: "Free Play"
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
