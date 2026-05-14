import SwiftUI
import SwiftData

struct ChallengeView: View {
    @Environment(\.theme) private var theme
    @Environment(\.modelContext) private var modelContext
    @Environment(AppState.self) private var appState

    let challengeIndex: Int
    var isDaily: Bool = false
    var isFreeCreate: Bool = false

    @State private var viewModel = ChallengeViewModel()

    var body: some View {
        ZStack {
            FloatingOrbsView()
                .ignoresSafeArea()

            if viewModel.isComplete {
                completionView
            } else {
                challengeContent
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .themedBackground()
        .navigationBarBackButtonHidden(viewModel.isRunning)
        .onAppear {
            viewModel.startChallenge(index: challengeIndex, isDaily: isDaily, isFreeCreate: isFreeCreate)
        }
        .onDisappear {
            viewModel.cleanup()
        }
    }

    private var challengeContent: some View {
        VStack(spacing: 12) {
            header
                .padding(.horizontal, 16)

            if viewModel.showTargetPreview {
                previewOverlay
            } else {
                colorPalette
                    .padding(.horizontal, 16)

                canvasGrid
                    .padding(.horizontal, 16)

                if let prompt = viewModel.prompt {
                    Text("\(prompt.mode.verb): \"\(prompt.word)\"")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(theme.colors.accent)
                        .padding(.top, 4)
                }
            }

            Spacer()
        }
        .padding(.top, 8)
    }

    private var header: some View {
        HStack {
            if let prompt = viewModel.prompt {
                HStack(spacing: 6) {
                    Image(systemName: prompt.mode.icon)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(prompt.mode.color)
                    Text(prompt.mode.displayName)
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .primaryText()
                }
            }

            Spacer()

            HStack(spacing: 4) {
                Image(systemName: "clock.fill")
                    .font(.system(size: 12))
                Text("\(viewModel.timeRemaining)s")
                    .font(.system(size: 18, weight: .black, design: .monospaced))
            }
            .foregroundStyle(viewModel.timeRemaining <= 10 ? .red : theme.colors.accent)
        }
        .padding(12)
        .background {
            RoundedRectangle(cornerRadius: 14)
                .fill(theme.colors.surface.opacity(0.5))
                .overlay {
                    RoundedRectangle(cornerRadius: 14)
                        .strokeBorder(theme.colors.cardBorder.opacity(0.12), lineWidth: 1)
                }
        }
    }

    private var previewOverlay: some View {
        VStack(spacing: 20) {
            Text("Memorize this pattern")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .primaryText()

            if let prompt = viewModel.prompt {
                targetGrid(prompt)
            }

            Text("\(viewModel.previewCountdown)")
                .font(.system(size: 48, weight: .black, design: .rounded))
                .foregroundStyle(theme.colors.accent)
        }
        .padding(24)
    }

    private func targetGrid(_ prompt: CreativePrompt) -> some View {
        let size = prompt.gridSize
        return LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: size), spacing: 4) {
            ForEach(0..<(size * size), id: \.self) { index in
                let colorIndex = prompt.targetPattern[index]
                let hex = colorIndex < prompt.palette.count ? prompt.palette[colorIndex] : "CCCCCC"
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(hex: hex))
                    .aspectRatio(1, contentMode: .fit)
            }
        }
        .padding(8)
    }

    private var colorPalette: some View {
        HStack(spacing: 8) {
            if let prompt = viewModel.prompt {
                ForEach(0..<prompt.palette.count, id: \.self) { index in
                    Button {
                        viewModel.selectColor(index)
                    } label: {
                        ZStack {
                            Circle()
                                .fill(Color(hex: prompt.palette[index]))
                                .frame(width: 40, height: 40)
                                .shadow(
                                    color: viewModel.selectedColorIndex == index
                                        ? Color(hex: prompt.palette[index]).opacity(0.6) : .clear,
                                    radius: 6
                                )
                            if viewModel.selectedColorIndex == index {
                                Circle()
                                    .strokeBorder(.white, lineWidth: 3)
                                    .frame(width: 40, height: 40)
                            }
                        }
                    }
                    .buttonStyle(BounceButtonStyle())
                }
            }
        }
        .padding(10)
        .background {
            RoundedRectangle(cornerRadius: 14)
                .fill(theme.colors.surface.opacity(0.4))
        }
    }

    private var canvasGrid: some View {
        Group {
            if let prompt = viewModel.prompt {
                let size = prompt.gridSize
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: size), spacing: 4) {
                    ForEach(0..<(size * size), id: \.self) { index in
                        canvasCell(index: index, palette: prompt.palette)
                    }
                }
            }
        }
    }

    private func canvasCell(index: Int, palette: [String]) -> some View {
        let colorIndex = viewModel.userPattern[index]
        let cellColor: Color = (colorIndex >= 0 && colorIndex < palette.count)
            ? Color(hex: palette[colorIndex])
            : theme.colors.cardBackground.opacity(0.3)

        return Button {
            viewModel.tapCell(index)
        } label: {
            RoundedRectangle(cornerRadius: 6)
                .fill(cellColor)
                .aspectRatio(1, contentMode: .fit)
                .overlay {
                    RoundedRectangle(cornerRadius: 6)
                        .strokeBorder(
                            colorIndex >= 0
                                ? cellColor.opacity(0.6)
                                : theme.colors.cardBorder.opacity(0.15),
                            lineWidth: colorIndex >= 0 ? 1 : 0.5
                        )
                }
                .shadow(color: colorIndex >= 0 ? cellColor.opacity(0.3) : .clear, radius: 3)
        }
        .buttonStyle(.plain)
    }

    private var completionView: some View {
        VStack(spacing: 24) {
            Spacer()

            ZStack {
                Circle()
                    .fill(theme.colors.accent.opacity(0.1))
                    .frame(width: 120, height: 120)
                Image(systemName: viewModel.stars >= 2 ? "sparkles" : "paintbrush.fill")
                    .font(.system(size: 52))
                    .foregroundStyle(theme.colors.accent)
            }

            Text(completionTitle)
                .font(.system(size: 28, weight: .black, design: .rounded))
                .primaryText()

            Text("\(Int(viewModel.score * 100))% accuracy")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .secondaryText()

            HStack(spacing: 8) {
                ForEach(1...3, id: \.self) { star in
                    Image(systemName: star <= viewModel.stars ? "star.fill" : "star")
                        .font(.system(size: 32))
                        .foregroundStyle(star <= viewModel.stars ? .yellow : theme.colors.textMuted.opacity(0.3))
                }
            }

            Spacer()

            GlassButton("Continue", icon: "arrow.right") {
                viewModel.updateStats(modelContext: modelContext)
                viewModel.checkAchievements(modelContext: modelContext)
                appState.pop()
            }
            .padding(.horizontal, 32)
        }
        .padding(24)
    }

    private var completionTitle: String {
        if viewModel.stars >= 3 { return "Masterpiece!" }
        if viewModel.stars >= 2 { return "Beautiful!" }
        if viewModel.stars >= 1 { return "Nice Work!" }
        return "Keep Creating!"
    }
}
