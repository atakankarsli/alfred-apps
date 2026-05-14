import SwiftUI
import SwiftData

struct CipherView: View {
    @Environment(\.theme) private var theme
    @Environment(\.modelContext) private var modelContext
    @Environment(AppState.self) private var appState

    let mode: CipherMode

    @State private var viewModel = CipherViewModel()
    @State private var showCompletion = false
    @State private var showAchievementToast = false
    @State private var latestAchievement: Achievement?

    var body: some View {
        ZStack {
            mainContent
            if viewModel.showConfetti { ConfettiView().ignoresSafeArea() }
            if showAchievementToast, let ach = latestAchievement {
                achievementToast(ach)
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .zIndex(10)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .themedBackground()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { toolbarContent }
        .task { viewModel.startGame(level: levelForMode, modelContext: modelContext) }
        .onDisappear { viewModel.cleanup() }
        .onChange(of: viewModel.isComplete) { _, done in
            if done {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) { showCompletion = true }
                if case .decrypt = mode {
                    updateHighestLevel()
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

    // MARK: - Main Content

    private var mainContent: some View {
        VStack(spacing: 0) {
            header.padding(.horizontal, 16).padding(.top, 8)
            Spacer(minLength: 8)
            cipherTypeLabel.padding(.horizontal, 16)
            Spacer(minLength: 8)
            cipherTextArea.padding(.horizontal, 16)
            Spacer(minLength: 12)
            alphabetKeyboard.padding(.horizontal, 12)
            Spacer(minLength: 8)
            bottomControls.padding(.horizontal, 20).padding(.bottom, 16)
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack(spacing: 12) {
            headerPill(icon: "clock.fill", value: TimeInterval(viewModel.timerSeconds).formattedMMSS, color: theme.colors.textMuted)
            Spacer()
            if let puzzle = viewModel.puzzle {
                headerPill(icon: "key.fill", value: puzzle.cipherType.rawValue.capitalized, color: theme.colors.accent)
            }
            Spacer()
            headerPill(icon: "star.fill", value: starsLabel, color: theme.colors.secondary)
        }
    }

    private var starsLabel: String {
        guard let puzzle = viewModel.puzzle else { return "—" }
        let par = CipherPuzzle.parTime(for: puzzle.level)
        return "\(par)s"
    }

    private func headerPill(icon: String, value: String, color: Color) -> some View {
        HStack(spacing: 5) {
            Image(systemName: icon).font(.system(size: 11, weight: .bold))
            Text(value).font(.system(size: 14, weight: .bold, design: .rounded)).monospacedDigit()
        }
        .foregroundStyle(color)
        .padding(.horizontal, 12).padding(.vertical, 6)
        .background {
            Capsule().fill(color.opacity(0.1))
                .overlay { Capsule().strokeBorder(color.opacity(0.15), lineWidth: 1) }
        }
    }

    // MARK: - Cipher Type Label

    private var cipherTypeLabel: some View {
        Group {
            if let puzzle = viewModel.puzzle {
                Text(puzzle.hint)
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundStyle(theme.colors.accent.opacity(0.8))
                    .padding(.horizontal, 14).padding(.vertical, 6)
                    .background {
                        Capsule().fill(theme.colors.accent.opacity(0.08))
                    }
            }
        }
    }

    // MARK: - Cipher Text Area

    private var cipherTextArea: some View {
        VStack(spacing: 4) {
            let words = splitIntoWords()
            ForEach(Array(words.enumerated()), id: \.offset) { _, word in
                wordRow(word)
            }
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 18).fill(theme.colors.surface.opacity(0.4))
                .overlay { RoundedRectangle(cornerRadius: 18).strokeBorder(theme.colors.boardBorder.opacity(0.12), lineWidth: 1) }
        }
    }

    private func splitIntoWords() -> [[Character]] {
        var words: [[Character]] = []
        var current: [Character] = []
        for ch in viewModel.encryptedChars {
            if ch == " " {
                if !current.isEmpty { words.append(current) }
                current = []
            } else {
                current.append(ch)
            }
        }
        if !current.isEmpty { words.append(current) }
        return words
    }

    private func wordRow(_ chars: [Character]) -> some View {
        HStack(spacing: 3) {
            ForEach(Array(chars.enumerated()), id: \.offset) { _, ch in
                letterCell(ch)
            }
        }
        .padding(.vertical, 2)
    }

    private func letterCell(_ ch: Character) -> some View {
        let isSelected = viewModel.selectedCipherChar == ch
        let guess = viewModel.guessMap[ch]
        let isCorrect = viewModel.isCorrectGuess(for: ch)
        let isRevealed = viewModel.revealedLetters.contains(ch)
        let cellColor = cellColorFor(ch: ch, isSelected: isSelected, isCorrect: isCorrect, isRevealed: isRevealed)

        return VStack(spacing: 1) {
            Text(guess.map(String.init) ?? "")
                .font(.system(size: 16, weight: .bold, design: .monospaced))
                .foregroundStyle(guessTextColor(isCorrect: isCorrect, isRevealed: isRevealed))
                .frame(width: 26, height: 24)

            Text(String(ch))
                .font(.system(size: 11, weight: .medium, design: .monospaced))
                .foregroundStyle(theme.colors.textMuted)
                .frame(width: 26, height: 14)
        }
        .background {
            RoundedRectangle(cornerRadius: 6)
                .fill(cellColor)
                .overlay {
                    RoundedRectangle(cornerRadius: 6)
                        .strokeBorder(isSelected ? theme.colors.accent : Color.clear, lineWidth: 2)
                }
        }
        .onTapGesture { viewModel.selectCipherChar(ch) }
    }

    private func cellColorFor(ch: Character, isSelected: Bool, isCorrect: Bool, isRevealed: Bool) -> Color {
        if isRevealed { return Color.green.opacity(0.15) }
        if isCorrect { return Color.green.opacity(0.1) }
        if isSelected { return theme.colors.accent.opacity(0.15) }
        if viewModel.guessMap[ch] != nil { return theme.colors.surface.opacity(0.6) }
        return theme.colors.cellBackground.opacity(0.3)
    }

    private func guessTextColor(isCorrect: Bool, isRevealed: Bool) -> Color {
        if isRevealed { return .green }
        if isCorrect { return .green.opacity(0.9) }
        return theme.colors.text
    }

    // MARK: - Alphabet Keyboard

    private var alphabetKeyboard: some View {
        VStack(spacing: 6) {
            alphabetRow(Array("QWERTYUIOP"))
            alphabetRow(Array("ASDFGHJKL"))
            HStack(spacing: 6) {
                clearButton
                alphabetRow(Array("ZXCVBNM"))
            }
        }
    }

    private func alphabetRow(_ letters: [Character]) -> some View {
        HStack(spacing: 4) {
            ForEach(letters, id: \.self) { letter in
                keyButton(letter)
            }
        }
    }

    private func keyButton(_ letter: Character) -> some View {
        let isUsed = viewModel.usedPlainLetters.contains(letter)
        return Button {
            viewModel.guessLetter(letter)
        } label: {
            Text(String(letter))
                .font(.system(size: 16, weight: .bold, design: .monospaced))
                .foregroundStyle(isUsed ? theme.colors.textMuted.opacity(0.4) : theme.colors.text)
                .frame(width: 30, height: 38)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isUsed ? theme.colors.cellBackground.opacity(0.2) : theme.colors.surface.opacity(0.5))
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(theme.colors.boardBorder.opacity(0.12), lineWidth: 1)
                        }
                }
        }
        .buttonStyle(BounceButtonStyle())
        .disabled(viewModel.selectedCipherChar == nil)
    }

    private var clearButton: some View {
        Button { viewModel.clearGuess() } label: {
            Image(systemName: "delete.backward.fill")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(theme.colors.textSecondary)
                .frame(width: 40, height: 38)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(theme.colors.surface.opacity(0.4))
                }
        }
        .buttonStyle(BounceButtonStyle())
    }

    // MARK: - Bottom Controls

    private var bottomControls: some View {
        HStack(spacing: 16) {
            controlButton(icon: "arrow.counterclockwise", label: "Reset", color: theme.colors.textSecondary) {
                viewModel.startGame(level: levelForMode, modelContext: modelContext)
            }
            controlButton(icon: "lightbulb.fill", label: "Hint", color: .orange) {
                viewModel.useHint()
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

    // MARK: - Toolbar

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text(modeLabel)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .primaryText()
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
            completionTitle
            completionStars
            xpBadge
            completionStats
            completionAchievements
            Spacer()
            completionButtons.padding(.horizontal, 32).padding(.bottom, 32)
        }
    }

    private var completionTitle: some View {
        Text(viewModel.stars >= 3 ? "Cracked!" : "Decoded!")
            .font(.system(size: 32, weight: .black, design: .rounded))
            .primaryText()
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

    @ViewBuilder
    private var xpBadge: some View {
        if viewModel.xpEarned > 0 {
            HStack(spacing: 4) {
                Image(systemName: "lock.open.fill").font(.system(size: 16))
                Text("+\(viewModel.xpEarned) XP").font(.system(size: 20, weight: .black, design: .rounded))
            }
            .foregroundStyle(theme.colors.accent)
            .padding(.horizontal, 16).padding(.vertical, 8)
            .background { Capsule().fill(theme.colors.accent.opacity(0.12)) }
        }
    }

    private var completionStats: some View {
        VStack(spacing: 8) {
            statRow("Time", TimeInterval(viewModel.timerSeconds).formattedMMSS)
            if let puzzle = viewModel.puzzle {
                statRow("Par Time", "\(CipherPuzzle.parTime(for: puzzle.level))s")
                statRow("Cipher", puzzle.cipherType.rawValue.capitalized)
            }
            statRow("Hints", "\(viewModel.revealedLetters.count)")
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 16).fill(theme.colors.surface.opacity(0.4))
                .overlay { RoundedRectangle(cornerRadius: 16).strokeBorder(theme.colors.boardBorder.opacity(0.12), lineWidth: 1) }
        }
        .padding(.horizontal, 32)
    }

    @ViewBuilder
    private var completionAchievements: some View {
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
    }

    private var completionButtons: some View {
        VStack(spacing: 12) {
            if case .decrypt(let index) = mode {
                GlassButton("Next Cipher", icon: "arrow.right") {
                    HapticsService.medium()
                    showCompletion = false
                    appState.pop()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        appState.navigateInCurrentTab(to: .cipher(mode: .decrypt(index: index + 1)))
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
        case .decrypt(let index): index
        case .daily: dailyLevel
        case .quickCrack: Int.random(in: 0..<CipherConfig.totalLevels)
        }
    }

    private var dailyLevel: Int {
        let c = Calendar.current.dateComponents([.year, .month, .day], from: .now)
        return ((c.year ?? 2026) * 10000 + (c.month ?? 1) * 100 + (c.day ?? 1)) % CipherConfig.totalLevels
    }

    private var modeLabel: String {
        switch mode {
        case .decrypt(let index): "Cipher \(index + 1)"
        case .daily: "Daily Cipher"
        case .quickCrack: "Quick Crack"
        }
    }

    private func updateHighestLevel() {
        let descriptor = FetchDescriptor<SettingsRecord>()
        guard let settings = try? modelContext.fetch(descriptor).first else { return }
        if levelForMode >= settings.currentLevelIndex {
            settings.currentLevelIndex = levelForMode + 1
        }
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
