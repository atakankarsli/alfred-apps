import SwiftUI
import SwiftData

struct PlayView: View {
    @Environment(\.theme) private var theme
    @Environment(AppState.self) private var appState
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = PlayViewModel()
    let levelIndex: Int

    var body: some View {
        ZStack {
            theme.gradient.ignoresSafeArea()

            VStack(spacing: 16) {
                topBar
                statusBar
                Spacer()
                buttonGrid
                Spacer()
                bottomControls
            }
            .padding(16)

            if viewModel.isComplete {
                completionOverlay
            }
        }
        .navigationBarHidden(true)
        .onAppear { viewModel.startLevel(levelIndex) }
    }

    private var topBar: some View {
        HStack {
            Button { appState.pop() } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(theme.colors.text)
                    .frame(width: 40, height: 40)
            }

            Spacer()

            if viewModel.isEndless {
                Text("Endless: Round \(viewModel.endlessRound)")
                    .font(.system(size: 18, weight: .black, design: .rounded)).primaryText()
            } else if viewModel.isDailyEcho {
                Text("Daily Echo").font(.system(size: 18, weight: .black, design: .rounded)).primaryText()
            } else if let level = viewModel.level {
                Text("Level \(level.displayNumber)")
                    .font(.system(size: 18, weight: .black, design: .rounded)).primaryText()
            }

            Spacer()
            Color.clear.frame(width: 40, height: 40)
        }
    }

    private var statusBar: some View {
        HStack(spacing: 16) {
            HStack(spacing: 4) {
                ForEach(0..<3, id: \.self) { i in
                    Image(systemName: i < viewModel.engine.lives ? "heart.fill" : "heart")
                        .font(.system(size: 16))
                        .foregroundStyle(i < viewModel.engine.lives ? .red : theme.colors.textMuted)
                }
            }

            Spacer()

            if viewModel.engine.isPlaying {
                HStack(spacing: 6) {
                    Image(systemName: "speaker.wave.2.fill").font(.system(size: 14))
                    Text("Listen...").font(.system(size: 14, weight: .semibold))
                }
                .foregroundStyle(theme.colors.accent)
            } else if viewModel.engine.isPlayerTurn {
                HStack(spacing: 6) {
                    Image(systemName: "hand.tap.fill").font(.system(size: 14))
                    Text("Your turn!").font(.system(size: 14, weight: .semibold))
                }
                .foregroundStyle(.green)
            }

            Spacer()

            Text("\(viewModel.engine.playerInput.count)/\(viewModel.engine.sequence.count)")
                .font(.system(size: 14, weight: .bold, design: .monospaced))
                .secondaryText()
        }
        .padding(.horizontal, 8)
    }

    private var buttonGrid: some View {
        SoundButtonGrid(
            buttonCount: viewModel.level?.buttonCount ?? 4,
            activeButton: viewModel.engine.isPlaying ? viewModel.engine.currentPlayIndex : viewModel.activeButton,
            realm: viewModel.level?.realm ?? .tones,
            isEnabled: viewModel.engine.isPlayerTurn && !viewModel.isComplete
        ) { index in
            viewModel.handleButtonTap(index)
        }
        .padding(.horizontal, 16)
        .overlay {
            if let flash = viewModel.flashColor {
                RoundedRectangle(cornerRadius: 20)
                    .fill(flash.opacity(0.15))
                    .allowsHitTesting(false)
                    .padding(.horizontal, 16)
            }
        }
    }

    private var bottomControls: some View {
        HStack(spacing: 16) {
            if viewModel.engine.replaysRemaining > 0 && !viewModel.engine.isPlaying {
                GlassButton("Replay (\(viewModel.engine.replaysRemaining))", icon: "arrow.counterclockwise", style: .secondary) {
                    viewModel.replay()
                }
            }
        }
        .padding(.bottom, 8)
    }

    private var completionOverlay: some View {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea()
            if viewModel.stars > 0 { ConfettiView() }

            VStack(spacing: 20) {
                Text(viewModel.stars > 0 ? (viewModel.isEndless ? "Game Over" : "Complete!") : "Try Again")
                    .font(.system(size: 28, weight: .black, design: .rounded)).foregroundStyle(.white)

                if viewModel.isEndless {
                    Text("Round \(viewModel.endlessRound)")
                        .font(.system(size: 22, weight: .bold, design: .rounded)).foregroundStyle(theme.colors.accent)
                }

                HStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { i in
                        Image(systemName: i < viewModel.stars ? "star.fill" : "star")
                            .font(.system(size: 36))
                            .foregroundStyle(i < viewModel.stars ? .yellow : .white.opacity(0.3))
                    }
                }

                if let level = viewModel.level, viewModel.stars > 0 {
                    let xp = EchoConfig.xpForLevel(stars: viewModel.stars, realmIndex: level.realm.rawValue)
                    Text("+\(xp) XP")
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                        .foregroundStyle(theme.colors.accent)
                }

                HStack(spacing: 16) {
                    GlassButton("Home", icon: "house", style: .secondary) {
                        viewModel.saveResult(modelContext: modelContext)
                        appState.popToRoot()
                    }
                    if viewModel.stars == 0 {
                        GlassButton("Retry", icon: "arrow.counterclockwise") {
                            viewModel.startLevel(levelIndex)
                        }
                    } else if !viewModel.isEndless && !viewModel.isDailyEcho,
                              let level = viewModel.level, level.index < 79 {
                        GlassButton("Next", icon: "arrow.right") {
                            viewModel.saveResult(modelContext: modelContext)
                            viewModel.startLevel(level.index + 1)
                        }
                    }
                }
                .padding(.horizontal, 32)
            }
            .padding(32)
        }
    }
}
