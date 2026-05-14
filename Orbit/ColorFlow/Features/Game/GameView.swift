import SwiftUI
import SwiftData

struct OrbitView: View {
    @Environment(\.theme) private var theme
    @Environment(\.modelContext) private var modelContext
    @Environment(AppState.self) private var appState
    @Query private var settings: [SettingsRecord]

    let mode: OrbitMode

    @State private var viewModel = OrbitViewModel()
    @State private var showCompletion = false
    @State private var showAchievementToast = false
    @State private var latestAchievement: Achievement?

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                header.padding(.horizontal, 16).padding(.top, 8)
                Spacer(minLength: 8)
                spaceCanvas.padding(.horizontal, 12)
                Spacer(minLength: 8)
                massPalette.padding(.horizontal, 16)
                Spacer(minLength: 8)
                bottomControls.padding(.horizontal, 20).padding(.bottom, 16)
            }
            if viewModel.showConfetti { ConfettiView().ignoresSafeArea() }
            if showAchievementToast, let ach = latestAchievement {
                achievementToast(ach).transition(.move(edge: .top).combined(with: .opacity)).zIndex(10)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .themedBackground()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { ToolbarItem(placement: .principal) { Text(modeLabel).font(.system(size: 18, weight: .bold, design: .rounded)).primaryText() } }
        .task { viewModel.startGame(level: levelForMode, modelContext: modelContext, showTimer: settings.first?.showTimer ?? true) }
        .onDisappear { viewModel.cleanup() }
        .onChange(of: viewModel.isComplete) { _, done in
            if done {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) { showCompletion = true }
                if case .mission(let idx) = mode, let s = settings.first, idx >= s.currentLevelIndex { s.currentLevelIndex = idx + 1 }
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

    // MARK: - Header
    private var header: some View {
        HStack(spacing: 12) {
            headerPill(icon: "scope", value: "\(viewModel.placedSources.count)", color: theme.colors.accent)
            Spacer()
            if viewModel.timerSeconds > 0 { headerPill(icon: "clock.fill", value: TimeInterval(viewModel.timerSeconds).formattedMMSS, color: theme.colors.textMuted) }
            Spacer()
            if let puzzle = viewModel.puzzle { headerPill(icon: "target", value: "\(viewModel.checkpointsHit)/\(puzzle.checkpoints.count)", color: theme.colors.secondary) }
        }
    }

    private func headerPill(icon: String, value: String, color: Color) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon).font(.system(size: 11, weight: .bold))
            Text(value).font(.system(size: 16, weight: .bold, design: .rounded)).monospacedDigit()
        }
        .foregroundStyle(color)
        .padding(.horizontal, 12).padding(.vertical, 6)
        .background { Capsule().fill(color.opacity(0.1)).overlay { Capsule().strokeBorder(color.opacity(0.15), lineWidth: 1) } }
    }

    // MARK: - Space Canvas
    private var spaceCanvas: some View {
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height)
            ZStack {
                canvasBackground(size: size)
                checkpointLayer(size: size)
                fixedSourceLayer(size: size)
                slotLayer(size: size)
                pathLayer(size: size)
                satelliteMarker(size: size)
            }
            .frame(width: size, height: size)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .aspectRatio(1, contentMode: .fit)
    }

    private func canvasBackground(size: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.black.opacity(0.85))
            .frame(width: size, height: size)
            .overlay {
                RoundedRectangle(cornerRadius: 16).strokeBorder(theme.colors.boardBorder.opacity(0.2), lineWidth: 1)
            }
    }

    private func checkpointLayer(size: CGFloat) -> some View {
        ForEach(Array((viewModel.puzzle?.checkpoints ?? []).enumerated()), id: \.offset) { _, cp in
            let hit = isCheckpointHit(cp)
            Circle()
                .fill(hit ? Color(hex: "22C55E").opacity(0.3) : Color.white.opacity(0.08))
                .frame(width: size * cp.radius * 2, height: size * cp.radius * 2)
                .overlay { Circle().strokeBorder(hit ? Color(hex: "22C55E") : Color.white.opacity(0.3), lineWidth: 1.5) }
                .position(x: cp.x * size, y: cp.y * size)
        }
    }

    private func fixedSourceLayer(size: CGFloat) -> some View {
        ForEach(Array((viewModel.puzzle?.fixedSources ?? []).enumerated()), id: \.offset) { _, source in
            let color = Color(hex: source.kind.colorHex)
            ZStack {
                Circle().fill(color.opacity(0.3)).frame(width: size * 0.08, height: size * 0.08).blur(radius: 6)
                Image(systemName: source.kind.icon).font(.system(size: size * 0.035, weight: .bold)).foregroundStyle(color)
            }
            .position(x: source.x * size, y: source.y * size)
        }
    }

    private func slotLayer(size: CGFloat) -> some View {
        ForEach(Array((viewModel.puzzle?.placementSlots ?? []).enumerated()), id: \.offset) { i, slot in
            let placed = viewModel.placedSources[i]
            Button { viewModel.toggleSlot(i) } label: {
                ZStack {
                    if let kind = placed {
                        let color = Color(hex: kind.colorHex)
                        Circle().fill(color.opacity(0.4)).frame(width: size * 0.07, height: size * 0.07)
                        Image(systemName: kind.icon).font(.system(size: size * 0.03, weight: .bold)).foregroundStyle(color)
                    } else {
                        Circle().strokeBorder(Color.white.opacity(0.2), style: StrokeStyle(lineWidth: 1, dash: [3, 3])).frame(width: size * 0.06, height: size * 0.06)
                        Image(systemName: "plus").font(.system(size: size * 0.02)).foregroundStyle(Color.white.opacity(0.3))
                    }
                }
            }
            .position(x: slot.x * size, y: slot.y * size)
        }
    }

    private func pathLayer(size: CGFloat) -> some View {
        Path { path in
            for (i, point) in viewModel.orbitPath.enumerated() {
                let p = CGPoint(x: point.x * size, y: point.y * size)
                if i == 0 { path.move(to: p) } else { path.addLine(to: p) }
            }
        }
        .stroke(LinearGradient(colors: [theme.colors.accent, theme.colors.accent.opacity(0.2)], startPoint: .leading, endPoint: .trailing), lineWidth: 2)
    }

    private func satelliteMarker(size: CGFloat) -> some View {
        Group {
            if let puzzle = viewModel.puzzle {
                let pos = viewModel.orbitPath.last ?? (x: puzzle.satelliteStart.x, y: puzzle.satelliteStart.y)
                Circle().fill(Color.white).frame(width: 8, height: 8).shadow(color: .white.opacity(0.6), radius: 4)
                    .position(x: pos.x * size, y: pos.y * size)
            }
        }
    }

    private func isCheckpointHit(_ cp: OrbitCheckpoint) -> Bool {
        viewModel.orbitPath.contains { point in
            let dx = point.x - cp.x
            let dy = point.y - cp.y
            return dx * dx + dy * dy <= cp.radius * cp.radius
        }
    }

    // MARK: - Mass Palette
    private var massPalette: some View {
        HStack(spacing: 8) {
            ForEach(viewModel.puzzle?.availableMasses ?? [], id: \.rawValue) { kind in
                massButton(kind)
            }
        }
    }

    private func massButton(_ kind: MassKind) -> some View {
        let isSelected = viewModel.selectedMassKind == kind
        let color = Color(hex: kind.colorHex)
        return Button { viewModel.selectMass(kind) } label: {
            VStack(spacing: 4) {
                ZStack {
                    Circle().fill(isSelected ? color.opacity(0.25) : color.opacity(0.1)).frame(width: 44, height: 44)
                    Image(systemName: kind.icon).font(.system(size: 18, weight: .bold)).foregroundStyle(color)
                }
                Text(kind.label).font(.system(size: 9, weight: .bold, design: .rounded)).foregroundStyle(isSelected ? color : theme.colors.textSecondary)
            }
            .frame(maxWidth: .infinity).padding(.vertical, 8)
            .background {
                RoundedRectangle(cornerRadius: 14).fill(isSelected ? color.opacity(0.08) : theme.colors.surface.opacity(0.3))
                    .overlay { if isSelected { RoundedRectangle(cornerRadius: 14).strokeBorder(color.opacity(0.3), lineWidth: 1) } }
            }
        }
        .buttonStyle(BounceButtonStyle())
    }

    // MARK: - Bottom Controls
    private var bottomControls: some View {
        HStack(spacing: 12) {
            controlBtn(icon: "arrow.counterclockwise", label: "Reset", color: theme.colors.textSecondary) { viewModel.reset() }
            GlassButton("Launch", icon: "paperplane.fill") { viewModel.launch() }
                .opacity(viewModel.placedSources.isEmpty || viewModel.isSimulating ? 0.4 : 1)
                .disabled(viewModel.placedSources.isEmpty || viewModel.isSimulating)
        }
    }

    private func controlBtn(icon: String, label: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack { Circle().fill(color.opacity(0.12)).frame(width: 50, height: 50); Image(systemName: icon).font(.system(size: 20, weight: .semibold)).foregroundStyle(color) }
                Text(label).font(.system(size: 11, weight: .bold, design: .rounded)).foregroundStyle(theme.colors.textSecondary)
            }
        }.buttonStyle(BounceButtonStyle())
    }

    // MARK: - Completion
    private var completionView: some View {
        ZStack {
            if viewModel.showConfetti { ConfettiView().ignoresSafeArea() }
            VStack(spacing: 20) {
                Spacer()
                Text(viewModel.stars >= 3 ? "Perfect Orbit!" : "Mission Complete!")
                    .font(.system(size: 32, weight: .black, design: .rounded)).primaryText()
                HStack(spacing: 12) {
                    ForEach(1...3, id: \.self) { star in
                        Image(systemName: star <= viewModel.stars ? "star.fill" : "star")
                            .font(.system(size: 38, weight: .bold))
                            .foregroundStyle(star <= viewModel.stars ? Color.yellow : theme.colors.textMuted.opacity(0.25))
                            .shadow(color: star <= viewModel.stars ? Color.yellow.opacity(0.5) : .clear, radius: 6)
                    }
                }
                if viewModel.xpEarned > 0 {
                    HStack(spacing: 4) {
                        Image(systemName: "bolt.fill").font(.system(size: 16))
                        Text("+\(viewModel.xpEarned) XP").font(.system(size: 20, weight: .black, design: .rounded))
                    }
                    .foregroundStyle(theme.colors.accent).padding(.horizontal, 16).padding(.vertical, 8)
                    .background { Capsule().fill(theme.colors.accent.opacity(0.12)) }
                }
                VStack(spacing: 8) {
                    statRow("Accuracy", "\(Int(viewModel.accuracy * 100))%")
                    statRow("Masses Placed", "\(viewModel.placedSources.count)")
                    statRow("Time", TimeInterval(viewModel.timerSeconds).formattedMMSS)
                }
                .padding(16)
                .background { RoundedRectangle(cornerRadius: 16).fill(theme.colors.surface.opacity(0.4)).overlay { RoundedRectangle(cornerRadius: 16).strokeBorder(theme.colors.boardBorder.opacity(0.12), lineWidth: 1) } }
                .padding(.horizontal, 32)
                Spacer()
                VStack(spacing: 12) {
                    if case .mission(let index) = mode {
                        GlassButton("Next Mission", icon: "arrow.right") {
                            HapticsService.medium(); showCompletion = false; appState.pop()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { appState.navigateInCurrentTab(to: .orbit(mode: .mission(index: index + 1))) }
                        }
                    }
                    GlassButton("Home", icon: "house.fill", style: .secondary) { HapticsService.light(); showCompletion = false; appState.popToRoot() }
                }
                .padding(.horizontal, 32).padding(.bottom, 32)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity).themedBackground()
    }

    // MARK: - Helpers
    private var levelForMode: Int {
        switch mode { case .mission(let i): i; case .daily: dailyLevel; case .sandbox: Int.random(in: 0..<OrbitConfig.totalLevels) }
    }
    private var dailyLevel: Int {
        let c = Calendar.current.dateComponents([.year, .month, .day], from: .now)
        return ((c.year ?? 2026) * 10000 + (c.month ?? 1) * 100 + (c.day ?? 1)) % OrbitConfig.totalLevels
    }
    private var modeLabel: String {
        switch mode { case .mission(let i): "Mission \(i + 1)"; case .daily: "Daily Mission"; case .sandbox: "Sandbox" }
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
            .background { RoundedRectangle(cornerRadius: 16).fill(.ultraThinMaterial).shadow(color: theme.colors.accent.opacity(0.2), radius: 8, y: 4).overlay { RoundedRectangle(cornerRadius: 16).strokeBorder(theme.colors.accent.opacity(0.3), lineWidth: 1) } }
            .padding(.horizontal, 16).padding(.top, 60)
            Spacer()
        }
    }
    private func statRow(_ label: String, _ value: String) -> some View {
        HStack { Text(label).secondaryText(); Spacer(); Text(value).font(.body.weight(.semibold)).primaryText() }
    }
}
