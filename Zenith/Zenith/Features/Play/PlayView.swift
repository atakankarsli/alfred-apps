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
            StarFieldView()
            FloatingOrbsView()

            VStack(spacing: 16) {
                topBar
                statusBar
                Spacer()
                starCanvas
                Spacer()
                bottomBar
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
                Text(viewModel.constellation.name)
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

            Text("\(viewModel.engine.correctCount)/\(viewModel.engine.totalConnections)")
                .font(.subheadline.weight(.medium).monospacedDigit())
                .foregroundStyle(theme.colors.primary)

            Spacer()

            Button {
                viewModel.engine.showHint.toggle()
            } label: {
                Label("Hint", systemImage: "lightbulb.fill")
                    .font(.subheadline)
                    .foregroundStyle(viewModel.engine.showHint ? theme.colors.warning : theme.colors.textMuted)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(theme.colors.surface.opacity(0.5))
        }
    }

    private var starCanvas: some View {
        StarCanvasView(
            constellation: viewModel.constellation,
            engine: viewModel.engine,
            onStarTap: { viewModel.selectStar($0) }
        )
        .padding(8)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(theme.colors.surface.opacity(0.3))
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(theme.colors.cardBorder.opacity(0.3), lineWidth: 1)
                }
        }
    }

    private var bottomBar: some View {
        HStack(spacing: 16) {
            GlassButton("Hint", icon: "lightbulb.fill", style: .secondary) {
                viewModel.useHint()
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
                    Text("Constellation Complete!")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(theme.colors.text)

                    Text(viewModel.constellation.name)
                        .font(.title.weight(.heavy))
                        .foregroundStyle(theme.colors.primary)

                    HStack(spacing: 4) {
                        ForEach(0..<3, id: \.self) { i in
                            Image(systemName: i < viewModel.stars ? "star.fill" : "star")
                                .font(.title2)
                                .foregroundStyle(i < viewModel.stars ? theme.colors.warning : theme.colors.textMuted)
                        }
                    }

                    HStack(spacing: 24) {
                        VStack {
                            Text(viewModel.formattedTime)
                                .font(.title3.weight(.semibold).monospacedDigit())
                                .foregroundStyle(theme.colors.text)
                            Text("Time")
                                .font(.caption)
                                .foregroundStyle(theme.colors.textSecondary)
                        }
                        VStack {
                            Text("+\(viewModel.xpEarned)")
                                .font(.title3.weight(.semibold))
                                .foregroundStyle(theme.colors.success)
                            Text("XP")
                                .font(.caption)
                                .foregroundStyle(theme.colors.textSecondary)
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
