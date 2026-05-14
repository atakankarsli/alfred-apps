import SwiftUI
import SwiftData

struct NexusView: View {
    @Environment(\.theme) private var theme
    @Environment(\.modelContext) private var modelContext
    @Environment(AppState.self) private var appState
    @Query private var settings: [SettingsRecord]

    let mode: NexusMode

    @State private var viewModel = NexusViewModel()
    @State private var showCompletion = false
    @State private var showAchievementToast = false
    @State private var latestAchievement: Achievement?

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                header.padding(.horizontal, 16).padding(.top, 8)
                Spacer(minLength: 12)
                solvedSection
                Spacer(minLength: 8)
                wordGrid.padding(.horizontal, 16)
                feedbackArea
                Spacer(minLength: 8)
                bottomControls.padding(.horizontal, 20).padding(.bottom, 16)
            }

            if viewModel.showConfetti { ConfettiView().ignoresSafeArea() }

            if showAchievementToast, let achievement = latestAchievement {
                achievementToast(achievement).transition(.move(edge: .top).combined(with: .opacity)).zIndex(10)
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
                if case .puzzle(let idx) = mode, let s = settings.first, idx >= s.currentLevelIndex {
                    s.currentLevelIndex = idx + 1
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

    // MARK: - Header

    private var header: some View {
        HStack(spacing: 12) {
            headerPill(icon: "xmark.circle.fill", value: "\(viewModel.mistakes)/\(NexusConfig.maxMistakes)", color: viewModel.mistakes > 2 ? .red : theme.colors.textMuted)
            Spacer()
            if viewModel.timerSeconds > 0, settings.first?.showTimer ?? true {
                headerPill(icon: "clock.fill", value: TimeInterval(viewModel.timerSeconds).formattedMMSS, color: theme.colors.textMuted)
            }
            Spacer()
            headerPill(icon: "checkmark.circle.fill", value: "\(viewModel.solvedClusters.count)/3", color: theme.colors.accent)
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

    // MARK: - Solved Clusters

    private var solvedSection: some View {
        VStack(spacing: 6) {
            ForEach(viewModel.solvedClusters) { cluster in
                solvedClusterRow(cluster)
            }
        }
        .padding(.horizontal, 16)
    }

    private func solvedClusterRow(_ cluster: WordCluster) -> some View {
        let color = Color(hex: cluster.colorHex)
        return VStack(spacing: 4) {
            Text(cluster.category)
                .font(.system(size: 14, weight: .black, design: .rounded))
                .foregroundStyle(color)
            Text(cluster.words.joined(separator: ", "))
                .font(.system(size: 12, weight: .medium))
                .secondaryText()
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background {
            RoundedRectangle(cornerRadius: 12).fill(color.opacity(0.08))
                .overlay { RoundedRectangle(cornerRadius: 12).strokeBorder(color.opacity(0.2), lineWidth: 1) }
        }
    }

    // MARK: - Word Grid

    private var wordGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3), spacing: 8) {
            ForEach(viewModel.words, id: \.self) { word in
                wordTile(word)
            }
        }
        .offset(x: viewModel.shakeSelected ? -4 : 0)
        .animation(.spring(response: 0.08, dampingFraction: 0.3), value: viewModel.shakeSelected)
    }

    private func wordTile(_ word: String) -> some View {
        let isSelected = viewModel.selectedWords.contains(word)
        let accentColor = theme.colors.accent

        return Button { viewModel.toggleWord(word) } label: {
            Text(word)
                .font(.system(size: 14, weight: isSelected ? .black : .semibold, design: .rounded))
                .foregroundStyle(isSelected ? .white : theme.colors.text)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(isSelected ? AnyShapeStyle(accentColor) : AnyShapeStyle(theme.colors.surface.opacity(0.6)))
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(isSelected ? accentColor.opacity(0.8) : theme.colors.boardBorder.opacity(0.12), lineWidth: 1)
                        }
                }
                .shadow(color: isSelected ? accentColor.opacity(0.3) : .clear, radius: 6, y: 2)
        }
        .buttonStyle(BounceButtonStyle())
    }

    // MARK: - Feedback

    private var feedbackArea: some View {
        Group {
            if let msg = viewModel.feedbackMessage {
                Text(msg)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundStyle(msg.contains("✓") ? Color(hex: "22C55E") : .orange)
                    .transition(.scale.combined(with: .opacity))
            } else {
                Text(" ").font(.system(size: 15))
            }
        }
        .frame(height: 30)
        .animation(.spring(response: 0.3), value: viewModel.feedbackMessage)
    }

    // MARK: - Bottom Controls

    private var bottomControls: some View {
        HStack(spacing: 12) {
            controlButton(icon: "shuffle", label: "Shuffle", color: theme.colors.textSecondary) {
                viewModel.shuffleWords()
            }
            controlButton(icon: "xmark", label: "Deselect", color: theme.colors.textSecondary) {
                viewModel.deselectAll()
            }
            .opacity(viewModel.selectedWords.isEmpty ? 0.4 : 1)

            GlassButton("Submit", icon: "checkmark") {
                viewModel.submitGroup()
            }
            .opacity(viewModel.selectedWords.count == NexusConfig.wordsPerCluster ? 1 : 0.4)
            .disabled(viewModel.selectedWords.count != NexusConfig.wordsPerCluster)
        }
    }

    private func controlButton(icon: String, label: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    Circle().fill(color.opacity(0.12)).frame(width: 44, height: 44)
                    Image(systemName: icon).font(.system(size: 18, weight: .semibold)).foregroundStyle(color)
                }
                Text(label).font(.system(size: 10, weight: .bold, design: .rounded)).foregroundStyle(theme.colors.textSecondary)
            }
        }
        .buttonStyle(BounceButtonStyle())
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
            Text(viewModel.stars >= 3 ? "Flawless!" : "Solved!")
                .font(.system(size: 32, weight: .black, design: .rounded)).primaryText()

            completionStars

            if viewModel.xpEarned > 0 { xpBadge }

            completionStats.padding(.horizontal, 32)

            if !viewModel.newAchievements.isEmpty { achievementsList.padding(.horizontal, 32) }

            Spacer()
            completionButtons.padding(.horizontal, 32).padding(.bottom, 32)
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

    private var xpBadge: some View {
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
            statRow("Mistakes", "\(viewModel.mistakes)")
            statRow("Time", TimeInterval(viewModel.timerSeconds).formattedMMSS)
            statRow("Clusters", "\(viewModel.solvedClusters.count)")
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 16).fill(theme.colors.surface.opacity(0.4))
                .overlay { RoundedRectangle(cornerRadius: 16).strokeBorder(theme.colors.boardBorder.opacity(0.12), lineWidth: 1) }
        }
    }

    private var achievementsList: some View {
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
    }

    private var completionButtons: some View {
        VStack(spacing: 12) {
            if case .puzzle(let index) = mode {
                GlassButton("Next Puzzle", icon: "arrow.right") {
                    HapticsService.medium()
                    showCompletion = false
                    appState.pop()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        appState.navigateInCurrentTab(to: .nexus(mode: .puzzle(index: index + 1)))
                    }
                }
            }
            GlassButton("Home", icon: "house.fill", style: .secondary) {
                HapticsService.light()
                showCompletion = false
                appState.popToRoot()
            }
        }
    }

    // MARK: - Helpers

    private var levelForMode: Int {
        switch mode {
        case .puzzle(let index): index
        case .daily: dailyLevel
        case .quickPlay: Int.random(in: 0..<NexusConfig.totalLevels)
        }
    }

    private var dailyLevel: Int {
        let c = Calendar.current.dateComponents([.year, .month, .day], from: .now)
        return ((c.year ?? 2026) * 10000 + (c.month ?? 1) * 100 + (c.day ?? 1)) % NexusConfig.totalLevels
    }

    private var modeLabel: String {
        switch mode {
        case .puzzle(let index): "Puzzle \(index + 1)"
        case .daily: "Daily Nexus"
        case .quickPlay: "Quick Play"
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
