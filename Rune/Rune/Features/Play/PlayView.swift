import SwiftUI
import SwiftData

struct PlayView: View {
    @Environment(\.theme) private var theme
    @Environment(AppState.self) private var appState
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel: PlayViewModel

    init(levelIndex: Int) {
        _viewModel = State(initialValue: PlayViewModel(levelIndex: levelIndex))
    }

    var body: some View {
        ZStack {
            theme.gradient.ignoresSafeArea()
            FloatingOrbsView()

            VStack(spacing: 16) {
                topBar
                statusBar
                encodedMessage
                Spacer()
                letterGrid
                bottomActions
            }
            .padding()

            if viewModel.showConfetti {
                completionOverlay
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear { viewModel.startTimer() }
        .onDisappear { viewModel.stopTimer() }
    }

    private var topBar: some View {
        HStack {
            Button { appState.pop() } label: {
                Image(systemName: "chevron.left")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(theme.colors.text)
            }
            Spacer()
            VStack(spacing: 2) {
                Text("Decode")
                    .font(.headline)
                    .foregroundStyle(theme.colors.text)
                if viewModel.levelIndex >= 0 {
                    Text("Level \(viewModel.levelIndex + 1)")
                        .font(.caption)
                        .foregroundStyle(theme.colors.textSecondary)
                }
            }
            Spacer()
            Button { viewModel.engine.reset(); viewModel.startTimer() } label: {
                Image(systemName: "arrow.counterclockwise")
                    .font(.title3)
                    .foregroundStyle(theme.colors.textSecondary)
            }
        }
    }

    private var statusBar: some View {
        HStack(spacing: 20) {
            Label(viewModel.formattedTime, systemImage: "clock")
                .font(.subheadline.monospacedDigit())
                .foregroundStyle(theme.colors.textSecondary)
            Spacer()
            Text("\(viewModel.engine.decodedCount)/\(viewModel.engine.totalGlyphs)")
                .font(.subheadline.weight(.medium).monospacedDigit())
                .foregroundStyle(theme.colors.primary)
            Spacer()
            if viewModel.engine.wrongAttempts > 0 {
                Label("\(viewModel.engine.wrongAttempts)", systemImage: "xmark.circle")
                    .font(.subheadline)
                    .foregroundStyle(theme.colors.error)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(theme.colors.surface.opacity(0.5))
        }
    }

    private var encodedMessage: some View {
        GlassCard {
            VStack(spacing: 12) {
                Text("Ancient Message")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(theme.colors.textMuted)

                FlowLayout(spacing: 6) {
                    ForEach(Array(viewModel.puzzle.encodedPairs.enumerated()), id: \.offset) { idx, pair in
                        glyphCell(pair.glyph, letter: pair.letter, index: idx)
                    }
                }
            }
        }
    }

    private func glyphCell(_ glyph: Glyph, letter: Character, index: Int) -> some View {
        let isDecoded = viewModel.engine.isDecoded(glyph.id)
        let isSelected = viewModel.engine.selectedGlyphId == glyph.id

        return Button {
            if !isDecoded {
                viewModel.engine.selectGlyph(glyph.id)
            }
        } label: {
            VStack(spacing: 2) {
                Text(glyph.symbol)
                    .font(.title2)
                    .foregroundStyle(isDecoded ? theme.colors.primary : (isSelected ? theme.colors.accent : theme.colors.text))
                Text(isDecoded ? String(letter) : "?")
                    .font(.caption.weight(.bold).monospaced())
                    .foregroundStyle(isDecoded ? theme.colors.success : theme.colors.textMuted)
            }
            .frame(width: 44, height: 56)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? theme.colors.primary.opacity(0.2) : theme.colors.surface.opacity(0.3))
                    .overlay {
                        if isSelected {
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(theme.colors.primary, lineWidth: 2)
                        }
                    }
            }
        }
        .buttonStyle(ScaleButtonStyle())
        .disabled(isDecoded)
    }

    private var letterGrid: some View {
        GlassCard(padding: 12) {
            VStack(spacing: 8) {
                Text("Choose Letter")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(theme.colors.textMuted)

                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 6), count: 7), spacing: 6) {
                    ForEach(viewModel.engine.availableLetters, id: \.self) { letter in
                        let isUsed = viewModel.engine.usedLetters.contains(letter)
                        Button {
                            viewModel.engine.guessLetter(letter)
                        } label: {
                            Text(String(letter))
                                .font(.body.weight(.semibold).monospaced())
                                .frame(width: 38, height: 38)
                                .foregroundStyle(isUsed ? theme.colors.textMuted : theme.colors.text)
                                .background {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(isUsed ? theme.colors.surface.opacity(0.2) : theme.colors.surface.opacity(0.5))
                                }
                        }
                        .buttonStyle(ScaleButtonStyle())
                        .disabled(isUsed || viewModel.engine.selectedGlyphId == nil)
                    }
                }
            }
        }
    }

    private var bottomActions: some View {
        HStack(spacing: 16) {
            GlassButton("Hint", icon: "lightbulb.fill", style: .secondary) {
                viewModel.engine.useHint()
            }
            GlassButton("Reset", icon: "arrow.counterclockwise", style: .subtle) {
                viewModel.engine.reset()
                viewModel.startTimer()
            }
        }
    }

    private var completionOverlay: some View {
        ZStack {
            Color.black.opacity(0.6).ignoresSafeArea()
            ConfettiView()

            GlassCard(padding: 24) {
                VStack(spacing: 20) {
                    Text("Decoded!")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(theme.colors.text)

                    Text(viewModel.puzzle.plainText)
                        .font(.title3.weight(.heavy).monospaced())
                        .foregroundStyle(theme.colors.primary)
                        .multilineTextAlignment(.center)

                    HStack(spacing: 4) {
                        ForEach(0..<3, id: \.self) { i in
                            Image(systemName: i < viewModel.stars ? "star.fill" : "star")
                                .font(.title2)
                                .foregroundStyle(i < viewModel.stars ? theme.colors.warning : theme.colors.textMuted)
                        }
                    }

                    HStack(spacing: 24) {
                        VStack {
                            Text(viewModel.formattedTime).font(.title3.weight(.semibold).monospacedDigit()).foregroundStyle(theme.colors.text)
                            Text("Time").font(.caption).foregroundStyle(theme.colors.textSecondary)
                        }
                        VStack {
                            Text("+\(viewModel.xpEarned)").font(.title3.weight(.semibold)).foregroundStyle(theme.colors.success)
                            Text("XP").font(.caption).foregroundStyle(theme.colors.textSecondary)
                        }
                    }

                    GlassButton("Continue", icon: "arrow.right") {
                        viewModel.saveResults(context: modelContext)
                        appState.pop()
                    }
                }
            }
            .frame(maxWidth: 320)
        }
        .transition(.opacity)
    }
}

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrange(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: proposal, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y), proposal: .unspecified)
        }
    }

    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (positions: [CGPoint], size: CGSize) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth && x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            positions.append(CGPoint(x: x, y: y))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
        }

        return (positions, CGSize(width: maxWidth, height: y + rowHeight))
    }
}
