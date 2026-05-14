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

            VStack(spacing: 16) {
                topBar
                phaseIndicator
                Spacer()
                flameArea
                Spacer()
                cycleProgress
                bottomActions
            }
            .padding()

            if viewModel.showConfetti {
                completionOverlay
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear { viewModel.startSession() }
        .onDisappear { viewModel.stopSession() }
    }

    private var topBar: some View {
        HStack {
            Button { viewModel.stopSession(); appState.pop() } label: {
                Image(systemName: "chevron.left")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(theme.colors.text)
            }
            Spacer()
            VStack(spacing: 2) {
                Text("Focus")
                    .font(.headline)
                    .foregroundStyle(theme.colors.text)
                if viewModel.levelIndex >= 0 {
                    Text("Level \(viewModel.levelIndex + 1)")
                        .font(.caption)
                        .foregroundStyle(theme.colors.textSecondary)
                }
            }
            Spacer()
            Text(viewModel.formattedTime)
                .font(.subheadline.monospacedDigit())
                .foregroundStyle(theme.colors.textSecondary)
        }
    }

    private var phaseIndicator: some View {
        VStack(spacing: 8) {
            Text(viewModel.engine.currentPhase.displayName)
                .font(.title2.weight(.semibold))
                .foregroundStyle(theme.colors.primary)
                .animation(.easeInOut, value: viewModel.engine.currentPhase)

            Text(viewModel.engine.session.pattern.name)
                .font(.caption)
                .foregroundStyle(theme.colors.textMuted)
        }
    }

    private var flameArea: some View {
        Button {
            viewModel.engine.tapAtTransition()
        } label: {
            FlameView(intensity: viewModel.engine.flameIntensity)
                .frame(height: 300)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }

    private var cycleProgress: some View {
        GlassCard(padding: 12) {
            VStack(spacing: 8) {
                HStack {
                    Text("Cycle \(viewModel.engine.currentCycle)/\(viewModel.engine.session.targetCycles)")
                        .font(.subheadline.weight(.medium).monospacedDigit())
                        .foregroundStyle(theme.colors.text)
                    Spacer()
                    Text("\(Int(viewModel.engine.accuracy * 100))%")
                        .font(.subheadline.weight(.medium).monospacedDigit())
                        .foregroundStyle(theme.colors.primary)
                }
                ProgressView(value: viewModel.engine.cycleProgress)
                    .tint(theme.colors.primary)
            }
        }
    }

    private var bottomActions: some View {
        HStack(spacing: 16) {
            if !viewModel.engine.isRunning && !viewModel.engine.isComplete {
                GlassButton("Start", icon: "play.fill") {
                    viewModel.startSession()
                }
            }
        }
    }

    private var completionOverlay: some View {
        ZStack {
            Color.black.opacity(0.6).ignoresSafeArea()
            ConfettiView()

            GlassCard(padding: 24) {
                VStack(spacing: 20) {
                    Text("Session Complete")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(theme.colors.text)

                    FlameView(intensity: 0.8)
                        .frame(width: 100, height: 120)

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
                            Text("\(Int(viewModel.engine.accuracy * 100))%").font(.title3.weight(.semibold)).foregroundStyle(theme.colors.primary)
                            Text("Accuracy").font(.caption).foregroundStyle(theme.colors.textSecondary)
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
