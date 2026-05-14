import SwiftUI
import SwiftData

struct VerseGameView: View {
    @Environment(\.theme) private var theme
    @Environment(\.modelContext) private var modelContext
    @Environment(AppState.self) private var appState
    @Query private var settings: [SettingsRecord]

    let mode: VerseMode

    @State private var viewModel = VerseViewModel()
    @State private var showCompletion = false
    @State private var showAchievementToast = false
    @State private var latestAchievement: Achievement?
    @State private var draggedTile: WordTile?
    @State private var highlightedLine: Int?

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
                Text(modeLabel).font(.system(size: 18, weight: .bold, design: .rounded)).primaryText()
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
                    if levelForMode >= s.highestUnlockedLevel {
                        s.highestUnlockedLevel = levelForMode + 1
                    }
                }
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
            formGuide.padding(.horizontal, 16).padding(.top, 10)
            lineSlots.padding(.horizontal, 16).padding(.top, 12)
            Spacer(minLength: 8)
            tileBank.padding(.horizontal, 12).padding(.bottom, 8)
            bottomControls.padding(.horizontal, 20).padding(.bottom, 16)
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack(spacing: 12) {
            if let puzzle = viewModel.puzzle {
                headerPill(icon: puzzle.form.icon, value: puzzle.form.displayName, color: theme.colors.accent)
            }
            Spacer()
            if viewModel.timerSeconds > 0, settings.first?.showTimer ?? true {
                headerPill(icon: "clock.fill", value: TimeInterval(viewModel.timerSeconds).formattedMMSS, color: theme.colors.textMuted)
            }
            Spacer()
            headerPill(icon: "square.grid.2x2.fill", value: "\(viewModel.availableTiles.count) left", color: theme.colors.secondary)
        }
    }

    private func headerPill(icon: String, value: String, color: Color) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon).font(.system(size: 11, weight: .bold))
            Text(value).font(.system(size: 14, weight: .bold, design: .rounded))
        }
        .foregroundStyle(color)
        .padding(.horizontal, 12).padding(.vertical, 6)
        .background { Capsule().fill(color.opacity(0.1)).overlay { Capsule().strokeBorder(color.opacity(0.15), lineWidth: 1) } }
    }

    // MARK: - Form Guide

    private var formGuide: some View {
        HStack(spacing: 4) {
            if let puzzle = viewModel.puzzle {
                ForEach(0..<puzzle.form.lineCount, id: \.self) { i in
                    Text("\(puzzle.form.syllablesPerLine[i])")
                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                        .foregroundStyle(viewModel.lineMatchesSyllables(i) ? .green : theme.colors.textMuted)
                }
                if let scheme = puzzle.form.rhymeScheme {
                    Text("•").foregroundStyle(theme.colors.textMuted).font(.system(size: 10))
                    ForEach(Array(scheme.enumerated()), id: \.offset) { _, ch in
                        Text(String(ch)).font(.system(size: 12, weight: .bold, design: .monospaced)).foregroundStyle(theme.colors.accent)
                    }
                }
            }
        }
        .padding(.horizontal, 10).padding(.vertical, 4)
        .background { Capsule().fill(theme.colors.surface.opacity(0.3)) }
    }

    // MARK: - Line Slots

    private var lineSlots: some View {
        VStack(spacing: 8) {
            if let puzzle = viewModel.puzzle {
                ForEach(0..<puzzle.form.lineCount, id: \.self) { lineIdx in
                    lineSlotView(lineIdx: lineIdx)
                }
            }
        }
    }

    private func lineSlotView(lineIdx: Int) -> some View {
        let current = viewModel.currentSyllables(line: lineIdx)
        let target = viewModel.targetSyllables(line: lineIdx)
        let matches = viewModel.lineMatchesSyllables(lineIdx)
        let isHighlighted = highlightedLine == lineIdx

        return VStack(spacing: 2) {
            HStack(spacing: 4) {
                Text("L\(lineIdx + 1)")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundStyle(theme.colors.textMuted)
                Spacer()
                Text("\(current)/\(target)")
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .foregroundStyle(matches ? .green : (current > target ? .red : theme.colors.textSecondary))
            }
            .padding(.horizontal, 8)

            HStack(spacing: 4) {
                ForEach(viewModel.lines.indices.contains(lineIdx) ? viewModel.lines[lineIdx] : []) { tile in
                    wordTileChip(tile, removable: true) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            viewModel.removeTile(tile, fromLine: lineIdx)
                        }
                    }
                }
                Spacer(minLength: 0)
            }
            .frame(minHeight: 38)
            .padding(.horizontal, 8).padding(.vertical, 4)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(isHighlighted ? theme.colors.accent.opacity(0.08) : (matches ? Color.green.opacity(0.04) : theme.colors.surface.opacity(0.3)))
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(
                                matches ? Color.green.opacity(0.3) : (isHighlighted ? theme.colors.accent.opacity(0.3) : theme.colors.boardBorder.opacity(0.12)),
                                lineWidth: matches ? 1.5 : 1
                            )
                    }
            }
            .onTapGesture {
                if let tile = draggedTile {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        viewModel.placeTile(tile, onLine: lineIdx)
                        draggedTile = nil
                        highlightedLine = nil
                    }
                }
            }
        }
    }

    // MARK: - Tile Bank

    private var tileBank: some View {
        let columns = [GridItem(.adaptive(minimum: 70), spacing: 6)]
        return LazyVGrid(columns: columns, spacing: 6) {
            ForEach(viewModel.availableTiles) { tile in
                wordTileChip(tile, removable: false) {
                    selectTileForPlacement(tile)
                }
            }
        }
        .padding(10)
        .background {
            RoundedRectangle(cornerRadius: 16).fill(theme.colors.surface.opacity(0.25))
                .overlay { RoundedRectangle(cornerRadius: 16).strokeBorder(theme.colors.boardBorder.opacity(0.1), lineWidth: 1) }
        }
    }

    private func selectTileForPlacement(_ tile: WordTile) {
        if draggedTile == tile {
            draggedTile = nil
            highlightedLine = nil
            return
        }
        draggedTile = tile

        if let puzzle = viewModel.puzzle {
            for i in 0..<puzzle.form.lineCount {
                if viewModel.currentSyllables(line: i) < viewModel.targetSyllables(line: i) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        viewModel.placeTile(tile, onLine: i)
                        draggedTile = nil
                        highlightedLine = nil
                    }
                    return
                }
            }
        }
    }

    private func wordTileChip(_ tile: WordTile, removable: Bool, action: @escaping () -> Void) -> some View {
        let isSelected = draggedTile == tile
        let isBonus = tile.isBonus

        return Button(action: action) {
            HStack(spacing: 3) {
                Text(tile.word)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                Text("\(tile.syllables)")
                    .font(.system(size: 9, weight: .bold, design: .monospaced))
                    .foregroundStyle(theme.colors.textMuted)
            }
            .padding(.horizontal, 10).padding(.vertical, 6)
            .foregroundStyle(isSelected ? theme.colors.textOnPrimary : theme.colors.text)
            .background {
                Capsule()
                    .fill(isSelected ? theme.colors.accent : (isBonus ? theme.colors.accent.opacity(0.1) : theme.colors.surface.opacity(0.6)))
                    .overlay {
                        Capsule().strokeBorder(
                            isSelected ? theme.colors.accent : (isBonus ? theme.colors.accent.opacity(0.3) : theme.colors.boardBorder.opacity(0.15)),
                            lineWidth: 1
                        )
                    }
            }
        }
        .buttonStyle(BounceButtonStyle())
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

            Text(viewModel.stars >= 3 ? "Beautiful!" : "Well Done!")
                .font(.system(size: 32, weight: .black, design: .rounded))
                .primaryText()

            completionStars
            if viewModel.xpEarned > 0 { completionXP }
            poemPreview
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

    private var poemPreview: some View {
        VStack(spacing: 6) {
            ForEach(Array(viewModel.lines.enumerated()), id: \.offset) { _, line in
                Text(line.map(\.word).joined(separator: " "))
                    .font(.system(size: 16, weight: .medium, design: .serif))
                    .primaryText()
                    .italic()
            }
        }
        .padding(20)
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
                GlassButton("Next Poem", icon: "arrow.right") {
                    HapticsService.medium()
                    showCompletion = false
                    appState.pop()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        appState.navigateInCurrentTab(to: .verse(mode: .level(index: index + 1)))
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
        case .freePlay: Int.random(in: 0..<VerseConfig.totalLevels)
        }
    }

    private var dailyLevel: Int {
        let c = Calendar.current.dateComponents([.year, .month, .day], from: .now)
        return ((c.year ?? 2026) * 10000 + (c.month ?? 1) * 100 + (c.day ?? 1)) % VerseConfig.totalLevels
    }

    private var modeLabel: String {
        switch mode {
        case .level(let index): "Poem \(index + 1)"
        case .daily: "Daily Verse"
        case .freePlay: "Free Write"
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
}
