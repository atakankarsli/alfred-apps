import SwiftUI
import SwiftData

struct GardenView: View {
    @Environment(\.theme) private var theme
    @Environment(\.modelContext) private var modelContext
    @Environment(AppState.self) private var appState
    @Query private var settings: [SettingsRecord]

    let mode: GardenMode

    @State private var viewModel = GardenViewModel()
    @State private var showCompletion = false
    @State private var showAchievementToast = false
    @State private var latestAchievement: Achievement?

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                header
                    .padding(.horizontal, 16)
                    .padding(.top, 8)

                Spacer(minLength: 12)

                gardenGrid
                    .padding(.horizontal, 20)

                Spacer(minLength: 12)

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

            if viewModel.showEmotionPicker {
                emotionPickerOverlay
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
            viewModel.startGarden(
                index: gardenForMode,
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
                if case .garden = mode {
                    if let s = settings.first, gardenForMode >= s.currentLevelIndex {
                        s.currentLevelIndex = gardenForMode + 1
                    }
                }
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
            headerPill(icon: "leaf.fill", value: "\(viewModel.plantsPlanted)", color: Color(hex: "6BCB77"))
            Spacer()
            if viewModel.timerSeconds > 0, settings.first?.showTimer ?? true {
                headerPill(icon: "clock.fill", value: TimeInterval(viewModel.timerSeconds).formattedMMSS, color: theme.colors.textMuted)
            }
            Spacer()
            if let garden = viewModel.garden {
                headerPill(icon: "square.grid.2x2.fill", value: "\(garden.filledCells)/\(garden.totalCells)", color: theme.colors.secondary)
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

    // MARK: - Garden Grid

    private var gardenGrid: some View {
        Group {
            if let garden = viewModel.garden {
                let gridSize = garden.gridSize
                let spacing: CGFloat = gridSize <= 3 ? 10 : (gridSize <= 4 ? 8 : 6)

                GeometryReader { geo in
                    let totalSpacing = spacing * CGFloat(gridSize - 1)
                    let maxSize = min(geo.size.width, geo.size.height)
                    let cellSize = (maxSize - totalSpacing) / CGFloat(gridSize)

                    VStack(spacing: spacing) {
                        ForEach(0..<gridSize, id: \.self) { row in
                            HStack(spacing: spacing) {
                                ForEach(0..<gridSize, id: \.self) { col in
                                    let position = row * gridSize + col
                                    let plant = garden.plantAt(position)
                                    let isGrowing = viewModel.growingCells.contains(position)
                                    let isWatering = viewModel.wateringCell == position
                                    let isSelected = viewModel.selectedPosition == position

                                    GardenCellView(
                                        plant: plant,
                                        isGrowing: isGrowing,
                                        isWatering: isWatering,
                                        isSelected: isSelected,
                                        size: cellSize
                                    )
                                    .onTapGesture {
                                        viewModel.selectCell(at: position)
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
                    let currentStars = viewModel.garden.map { BloomConfig.starsForGarden(grownCount: $0.fullyGrownCount, totalCells: $0.totalCells) } ?? 0
                    Image(systemName: star <= currentStars ? "star.fill" : "star")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(star <= currentStars ? Color.yellow : theme.colors.textMuted.opacity(0.25))
                        .shadow(color: star <= currentStars ? Color.yellow.opacity(0.4) : .clear, radius: 4)
                }
            }
            if let garden = viewModel.garden {
                let grown = garden.fullyGrownCount
                Text("\(grown)/\(garden.totalCells) fully grown")
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .mutedText()
            }
        }
    }

    // MARK: - Bottom Controls

    private var bottomControls: some View {
        HStack(spacing: 16) {
            gameControlButton(icon: "arrow.counterclockwise", label: "New", color: theme.colors.textSecondary) {
                viewModel.startGarden(
                    index: gardenForMode,
                    modelContext: modelContext,
                    showTimer: settings.first?.showTimer ?? true
                )
                HapticsService.medium()
            }

            gameControlButton(icon: "drop.fill", label: "Water All", color: Color(hex: "5BC0EB")) {
                guard let g = viewModel.garden else { return }
                for plant in g.plants where !plant.isFullyGrown {
                    viewModel.waterPlant(at: plant.position)
                }
            }
            .opacity(viewModel.garden?.plants.isEmpty ?? true ? 0.4 : 1)
            .disabled(viewModel.garden?.plants.isEmpty ?? true)
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

    // MARK: - Emotion Picker

    private var emotionPickerOverlay: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture { viewModel.cancelEmotionPicker() }

            VStack(spacing: 16) {
                Text("How do you feel?")
                    .font(.system(size: 22, weight: .black, design: .rounded))
                    .primaryText()

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 14) {
                    ForEach(Emotion.all) { emotion in
                        Button {
                            viewModel.plantEmotion(emotion)
                        } label: {
                            VStack(spacing: 6) {
                                ZStack {
                                    Circle()
                                        .fill(Color(hex: emotion.colorHex).opacity(0.2))
                                        .frame(width: 52, height: 52)
                                    Image(systemName: emotion.icon)
                                        .font(.system(size: 24))
                                        .foregroundStyle(Color(hex: emotion.colorHex))
                                }
                                Text(emotion.name)
                                    .font(.system(size: 10, weight: .bold, design: .rounded))
                                    .primaryText()
                            }
                        }
                        .buttonStyle(BounceButtonStyle())
                    }
                }

                Button {
                    viewModel.cancelEmotionPicker()
                } label: {
                    Text("Cancel")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(theme.colors.textSecondary)
                }
            }
            .padding(24)
            .background {
                RoundedRectangle(cornerRadius: 24)
                    .fill(.ultraThinMaterial)
                    .overlay {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(theme.colors.surface.opacity(0.5))
                    }
                    .overlay {
                        RoundedRectangle(cornerRadius: 24)
                            .strokeBorder(theme.colors.boardBorder.opacity(0.15), lineWidth: 1)
                    }
            }
            .padding(.horizontal, 24)
        }
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

            Text(viewModel.stars >= 3 ? "Full Bloom!" : "Garden Complete!")
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
                    Image(systemName: "leaf.fill").font(.system(size: 16))
                    Text("+\(viewModel.xpEarned) XP").font(.system(size: 20, weight: .black, design: .rounded))
                }
                .foregroundStyle(Color(hex: "6BCB77"))
                .padding(.horizontal, 16).padding(.vertical, 8)
                .background { Capsule().fill(Color(hex: "6BCB77").opacity(0.12)) }
            }

            VStack(spacing: 8) {
                statRow("Plants", "\(viewModel.plantsPlanted)")
                if let g = viewModel.garden { statRow("Fully Grown", "\(g.fullyGrownCount)") }
                statRow("Time", TimeInterval(viewModel.timerSeconds).formattedMMSS)
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
                            Image(systemName: ach.icon).font(.system(size: 16)).foregroundStyle(Color(hex: "6BCB77"))
                            Text(ach.title).font(.system(size: 14, weight: .bold, design: .rounded)).primaryText()
                            Spacer()
                            Text("+\(ach.tier.xpReward) XP").font(.system(size: 12, weight: .bold, design: .monospaced)).foregroundStyle(Color(hex: "6BCB77"))
                        }
                    }
                }
                .padding(14)
                .background {
                    RoundedRectangle(cornerRadius: 14).fill(Color(hex: "6BCB77").opacity(0.06))
                        .overlay { RoundedRectangle(cornerRadius: 14).strokeBorder(Color(hex: "6BCB77").opacity(0.15), lineWidth: 1) }
                }
                .padding(.horizontal, 32)
            }

            Spacer()

            VStack(spacing: 12) {
                if case .garden(let index) = mode {
                    GlassButton("Next Garden", icon: "arrow.right") {
                        HapticsService.medium()
                        showCompletion = false
                        appState.pop()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            appState.navigateInCurrentTab(to: .garden(mode: .garden(index: index + 1)))
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

    private var gardenForMode: Int {
        switch mode {
        case .garden(let index): index
        case .daily: dailyGarden
        case .freeGarden: Int.random(in: 0..<BloomConfig.totalGardens)
        }
    }

    private var dailyGarden: Int {
        let c = Calendar.current.dateComponents([.year, .month, .day], from: .now)
        return ((c.year ?? 2026) * 10000 + (c.month ?? 1) * 100 + (c.day ?? 1)) % BloomConfig.totalGardens
    }

    private var modeLabel: String {
        switch mode {
        case .garden(let index): "Garden \(index + 1)"
        case .daily: "Daily Garden"
        case .freeGarden: "Free Garden"
        }
    }

    private func achievementToast(_ achievement: Achievement) -> some View {
        VStack {
            HStack(spacing: 10) {
                Image(systemName: achievement.icon).font(.system(size: 22)).foregroundStyle(Color(hex: "6BCB77"))
                VStack(alignment: .leading, spacing: 2) {
                    Text("Achievement Unlocked!").font(.system(size: 11, weight: .bold)).foregroundStyle(Color(hex: "6BCB77"))
                    Text(achievement.title).font(.system(size: 16, weight: .black, design: .rounded)).primaryText()
                }
                Spacer()
                Text("+\(achievement.tier.xpReward) XP").font(.system(size: 13, weight: .bold, design: .monospaced)).foregroundStyle(Color(hex: "6BCB77"))
            }
            .padding(14)
            .background {
                RoundedRectangle(cornerRadius: 16).fill(.ultraThinMaterial)
                    .shadow(color: Color(hex: "6BCB77").opacity(0.2), radius: 8, y: 4)
                    .overlay { RoundedRectangle(cornerRadius: 16).strokeBorder(Color(hex: "6BCB77").opacity(0.3), lineWidth: 1) }
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

// MARK: - Garden Cell View

struct GardenCellView: View {
    @Environment(\.theme) private var theme

    let plant: GardenPlant?
    let isGrowing: Bool
    let isWatering: Bool
    let isSelected: Bool
    let size: CGFloat

    private var plantColor: Color {
        guard let plant else { return theme.colors.cellBackground.opacity(0.3) }
        guard let emotion = Emotion.find(plant.emotionId) else { return theme.colors.cellBackground }
        return Color(hex: emotion.colorHex)
    }

    private var plantIcon: String {
        guard let plant else { return "plus" }
        return plant.plantType.growthIcons[min(plant.growthStage, 4)]
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.2)
                .fill(cellFill)
                .frame(width: size, height: size)
                .shadow(
                    color: plant != nil ? plantColor.opacity(0.4) : .clear,
                    radius: plant != nil ? size * 0.15 : 0
                )
                .overlay {
                    if plant != nil {
                        RoundedRectangle(cornerRadius: size * 0.2)
                            .fill(
                                RadialGradient(
                                    colors: [Color.white.opacity(0.2), Color.clear],
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
                            plant != nil ? plantColor.opacity(0.5) :
                                isSelected ? theme.colors.accent.opacity(0.6) :
                                theme.colors.boardBorder.opacity(0.1),
                            lineWidth: plant != nil || isSelected ? 1.5 : 0.5
                        )
                }
                .overlay {
                    VStack(spacing: 2) {
                        Image(systemName: plantIcon)
                            .font(.system(size: size * 0.28, weight: .bold))
                            .foregroundStyle(plant != nil ? .white.opacity(0.9) : theme.colors.textMuted.opacity(0.3))

                        if let plant, !plant.isFullyGrown {
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    Capsule()
                                        .fill(Color.white.opacity(0.2))
                                        .frame(height: 3)
                                    Capsule()
                                        .fill(Color.white.opacity(0.7))
                                        .frame(width: max(3, geo.size.width * plant.waterProgress), height: 3)
                                }
                            }
                            .frame(width: size * 0.6, height: 3)
                        }
                    }
                }
                .scaleEffect(isGrowing ? 1.2 : 1.0)
                .scaleEffect(isWatering ? 1.05 : 1.0)
                .animation(.spring(response: 0.2, dampingFraction: 0.5), value: isGrowing)
                .animation(.easeOut(duration: 0.15), value: isWatering)
                .animation(.easeInOut(duration: 0.2), value: plant?.growthStage)
        }
    }

    private var cellFill: some ShapeStyle {
        if plant == nil {
            return AnyShapeStyle(theme.colors.cellBackground.opacity(0.3))
        }
        return AnyShapeStyle(
            LinearGradient(
                colors: [plantColor, plantColor.opacity(0.7)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}
