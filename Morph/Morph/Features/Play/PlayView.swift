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

            VStack(spacing: 12) {
                topBar
                statusBar
                canvas
                toolBar
            }
            .padding(16)

            if viewModel.isComplete && !viewModel.isEndless {
                completionOverlay
            }
        }
        .navigationBarHidden(true)
        .onAppear { viewModel.startLevel(levelIndex) }
    }

    private var topBar: some View {
        HStack {
            Button { appState.pop() } label: {
                Image(systemName: "chevron.left").font(.system(size: 18, weight: .bold))
                    .foregroundStyle(theme.colors.text).frame(width: 40, height: 40)
            }
            Spacer()
            if viewModel.isEndless {
                Text("Endless: Round \(viewModel.endlessRound)")
                    .font(.system(size: 18, weight: .black, design: .rounded)).primaryText()
            } else if viewModel.isDailyMorph {
                Text("Daily Morph").font(.system(size: 18, weight: .black, design: .rounded)).primaryText()
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
                Image(systemName: "arrow.triangle.2.circlepath").font(.system(size: 14))
                Text("\(viewModel.engine.moveCount) moves").font(.system(size: 14, weight: .semibold))
            }
            .foregroundStyle(theme.colors.accent)

            Spacer()

            let pct = Int(viewModel.engine.matchScore() * 100)
            Text("\(pct)% match")
                .font(.system(size: 14, weight: .bold, design: .monospaced))
                .foregroundStyle(pct > 90 ? theme.colors.success : theme.colors.textSecondary)

            Spacer()

            HStack(spacing: 4) {
                Button { viewModel.undo() } label: {
                    Image(systemName: "arrow.uturn.backward").font(.system(size: 16, weight: .bold))
                        .foregroundStyle(theme.colors.textSecondary).frame(width: 32, height: 32)
                }
                Button { viewModel.resetShape() } label: {
                    Image(systemName: "arrow.counterclockwise").font(.system(size: 16, weight: .bold))
                        .foregroundStyle(theme.colors.textSecondary).frame(width: 32, height: 32)
                }
            }
        }
        .padding(.horizontal, 8)
    }

    private var canvas: some View {
        ShapeCanvasView(
            currentShape: viewModel.engine.currentShape,
            targetShape: viewModel.engine.targetShape,
            matchScore: viewModel.engine.matchScore()
        )
        .aspectRatio(1, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(theme.colors.accent.opacity(0.2), lineWidth: 1)
        }
        .padding(.horizontal, 8)
    }

    private var toolBar: some View {
        let tools = viewModel.level?.availableTools ?? []
        return ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(tools) { tool in
                    Button {
                        viewModel.applyTool(tool)
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: tool.icon)
                                .font(.system(size: 18, weight: .bold))
                            Text(tool.label)
                                .font(.system(size: 9, weight: .semibold))
                        }
                        .foregroundStyle(theme.colors.text)
                        .frame(width: 56, height: 56)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(theme.colors.surface.opacity(0.4))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 12)
                                        .strokeBorder(theme.colors.accent.opacity(0.2), lineWidth: 1)
                                }
                        }
                    }
                    .buttonStyle(ScaleButtonStyle())
                }
            }
            .padding(.horizontal, 8)
        }
        .padding(.bottom, 8)
    }

    private var completionOverlay: some View {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea()
            if viewModel.stars > 0 { ConfettiView() }

            VStack(spacing: 20) {
                Text(viewModel.stars > 0 ? "Complete!" : "Try Again")
                    .font(.system(size: 28, weight: .black, design: .rounded)).foregroundStyle(.white)

                HStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { i in
                        Image(systemName: i < viewModel.stars ? "star.fill" : "star")
                            .font(.system(size: 36))
                            .foregroundStyle(i < viewModel.stars ? .yellow : .white.opacity(0.3))
                    }
                }

                Text("\(viewModel.engine.moveCount) moves")
                    .font(.system(size: 16, weight: .semibold, design: .monospaced))
                    .foregroundStyle(theme.colors.textSecondary)

                if let level = viewModel.level, viewModel.stars > 0 {
                    let xp = MorphConfig.xpForLevel(stars: viewModel.stars, realmIndex: level.realm.rawValue)
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
                    } else if !viewModel.isEndless && !viewModel.isDailyMorph,
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
