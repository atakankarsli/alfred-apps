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

            VStack(spacing: 0) {
                topBar
                waveCanvas
                if !viewModel.isComplete {
                    controlPanel
                }
            }

            if viewModel.isComplete {
                completionOverlay
            }
        }
        .navigationBarHidden(true)
        .onAppear { viewModel.startLevel(levelIndex) }
        .onDisappear { viewModel.stopTimers() }
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

            if viewModel.isSandbox {
                Text("Sandbox").font(.system(size: 18, weight: .black, design: .rounded)).primaryText()
            } else if viewModel.isDailyWave {
                Text("Daily Wave").font(.system(size: 18, weight: .black, design: .rounded)).primaryText()
            } else if let level = viewModel.level {
                Text("Level \(level.displayNumber)")
                    .font(.system(size: 18, weight: .black, design: .rounded)).primaryText()
            }

            Spacer()

            if let time = viewModel.timeRemaining {
                HStack(spacing: 4) {
                    Image(systemName: "clock").font(.system(size: 14))
                    Text("\(time)s").font(.system(size: 16, weight: .bold, design: .monospaced))
                }
                .foregroundStyle(time <= 10 ? theme.colors.error : theme.colors.textSecondary)
                .frame(width: 70)
            } else {
                Color.clear.frame(width: 40, height: 40)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }

    private var waveCanvas: some View {
        GeometryReader { geo in
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(theme.colors.surface.opacity(0.2))

                WaveCanvasView(
                    engine: viewModel.engine,
                    targets: viewModel.level?.targets ?? [],
                    obstacles: viewModel.level?.obstacles ?? []
                )
                .clipShape(.rect(cornerRadius: 16))
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onEnded { value in
                        let normalized = CGPoint(
                            x: value.location.x / geo.size.width,
                            y: value.location.y / geo.size.height
                        )
                        let clamped = CGPoint(
                            x: max(0.05, min(0.95, normalized.x)),
                            y: max(0.05, min(0.95, normalized.y))
                        )
                        viewModel.addSource(at: clamped)
                    }
            )
        }
        .padding(.horizontal, 16)
        .aspectRatio(1, contentMode: .fit)
    }

    private var controlPanel: some View {
        VStack(spacing: 12) {
            if let idx = viewModel.selectedSourceIndex, idx < viewModel.engine.sources.count {
                let source = viewModel.engine.sources[idx]

                HStack {
                    Text("Source \(idx + 1)").font(.system(size: 14, weight: .bold, design: .rounded)).primaryText()
                    Spacer()
                    if viewModel.level == nil || idx >= (viewModel.level?.fixedSources.count ?? 0) {
                        Button { viewModel.removeSelectedSource() } label: {
                            Image(systemName: "trash").font(.system(size: 14)).foregroundStyle(theme.colors.error)
                        }
                    }
                }

                if viewModel.level?.frequencyLocked != true {
                    HStack {
                        Text("Freq").font(.system(size: 12, weight: .medium)).secondaryText().frame(width: 40)
                        Slider(value: Binding(
                            get: { source.frequency },
                            set: { viewModel.updateFrequency($0) }
                        ), in: 0.5...4.0, step: 0.1)
                        .tint(theme.colors.accent)
                        Text(String(format: "%.1f", source.frequency))
                            .font(.system(size: 12, weight: .bold, design: .monospaced)).primaryText().frame(width: 30)
                    }
                }

                if viewModel.level?.amplitudeLocked != true {
                    HStack {
                        Text("Amp").font(.system(size: 12, weight: .medium)).secondaryText().frame(width: 40)
                        Slider(value: Binding(
                            get: { source.amplitude },
                            set: { viewModel.updateAmplitude($0) }
                        ), in: 0.1...2.0, step: 0.1)
                        .tint(theme.colors.secondary)
                        Text(String(format: "%.1f", source.amplitude))
                            .font(.system(size: 12, weight: .bold, design: .monospaced)).primaryText().frame(width: 30)
                    }
                }
            } else {
                Text("Tap the canvas to place a wave source")
                    .font(.system(size: 14, weight: .medium)).secondaryText()
            }

            if !viewModel.isSandbox {
                HStack(spacing: 12) {
                    let sourcesPlaced = viewModel.engine.sources.count - (viewModel.level?.fixedSources.count ?? 0)
                    let maxSources = viewModel.level?.maxSources ?? 10
                    Text("\(sourcesPlaced)/\(maxSources) sources")
                        .font(.system(size: 12, weight: .medium)).mutedText()
                    Spacer()
                    GlassButton("Check", icon: "checkmark.circle", style: .primary) {
                        viewModel.checkSolution()
                    }
                }
            }
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(theme.colors.surface.opacity(0.4))
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(theme.colors.cardBorder.opacity(0.15), lineWidth: 1)
                }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }

    private var completionOverlay: some View {
        ZStack {
            Color.black.opacity(0.5).ignoresSafeArea()
            ConfettiView()

            VStack(spacing: 20) {
                Text("Level Complete!").font(.system(size: 28, weight: .black, design: .rounded)).foregroundStyle(.white)

                HStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { i in
                        Image(systemName: i < viewModel.stars ? "star.fill" : "star")
                            .font(.system(size: 36))
                            .foregroundStyle(i < viewModel.stars ? .yellow : .white.opacity(0.3))
                    }
                }

                Text("\(Int(viewModel.score * 100))% accuracy")
                    .font(.system(size: 18, weight: .semibold)).foregroundStyle(.white.opacity(0.8))

                if let level = viewModel.level {
                    let xp = TidalConfig.xpForLevel(stars: viewModel.stars, worldIndex: level.world.rawValue)
                    Text("+\(xp) XP")
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                        .foregroundStyle(theme.colors.accent)
                }

                HStack(spacing: 16) {
                    GlassButton("Home", icon: "house", style: .secondary) {
                        viewModel.saveResult(modelContext: modelContext)
                        appState.popToRoot()
                    }
                    if !viewModel.isDailyWave, let level = viewModel.level, level.index < 79 {
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
