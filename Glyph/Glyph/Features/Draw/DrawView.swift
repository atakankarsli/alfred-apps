import SwiftUI
import SwiftData

struct DrawView: View {
    @Environment(\.theme) private var theme
    @Environment(\.modelContext) private var modelContext
    @Environment(AppState.self) private var appState

    let challengeIndex: Int
    var isDaily: Bool = false

    @State private var viewModel = DrawViewModel()

    var body: some View {
        ZStack {
            FloatingOrbsView().ignoresSafeArea()

            if viewModel.isComplete {
                completionView
            } else {
                drawContent
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .themedBackground()
        .navigationBarBackButtonHidden(viewModel.isRunning)
        .onAppear { viewModel.startChallenge(index: challengeIndex, isDaily: isDaily) }
        .onDisappear { viewModel.cleanup() }
    }

    private var drawContent: some View {
        VStack(spacing: 12) {
            header.padding(.horizontal, 16)

            if let symbol = viewModel.symbol {
                VStack(spacing: 4) {
                    Text(symbol.name)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .primaryText()
                    Text("\"\(symbol.meaning)\"")
                        .font(.system(size: 14, weight: .medium))
                        .italic()
                        .secondaryText()
                }
            }

            canvas.padding(.horizontal, 16)

            HStack(spacing: 16) {
                GlassButton("Undo", icon: "arrow.uturn.backward", style: .subtle) {
                    viewModel.undoLastStroke()
                }
                GlassButton("Done", icon: "checkmark") {
                    viewModel.submitDrawing()
                }
            }
            .padding(.horizontal, 24)

            Spacer()
        }
        .padding(.top, 8)
    }

    private var header: some View {
        HStack {
            if let symbol = viewModel.symbol {
                HStack(spacing: 6) {
                    Image(systemName: SymbolCategory.categoryForChallenge(challengeIndex).icon)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(SymbolCategory.categoryForChallenge(challengeIndex).color)
                    Text(SymbolCategory.categoryForChallenge(challengeIndex).displayName)
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .primaryText()
                    Text("★\(symbol.difficulty)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(theme.colors.accent)
                }
            }

            Spacer()

            HStack(spacing: 4) {
                Image(systemName: "clock.fill").font(.system(size: 12))
                Text("\(viewModel.timeRemaining)s")
                    .font(.system(size: 18, weight: .black, design: .monospaced))
            }
            .foregroundStyle(viewModel.timeRemaining <= 5 ? .red : theme.colors.accent)
        }
        .padding(12)
        .background {
            RoundedRectangle(cornerRadius: 14)
                .fill(theme.colors.surface.opacity(0.5))
                .overlay { RoundedRectangle(cornerRadius: 14).strokeBorder(theme.colors.cardBorder.opacity(0.12), lineWidth: 1) }
        }
    }

    private var canvas: some View {
        GeometryReader { geo in
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(theme.colors.cardBackground.opacity(0.8))
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(theme.colors.cardBorder.opacity(0.2), lineWidth: 1)
                    }

                if viewModel.showGuide, let symbol = viewModel.symbol {
                    guideOverlay(symbol: symbol, size: geo.size)
                }

                Canvas { context, size in
                    for stroke in viewModel.userStrokes {
                        drawStroke(stroke, in: &context, color: theme.colors.accent)
                    }
                    if !viewModel.currentStroke.isEmpty {
                        drawStroke(viewModel.currentStroke, in: &context, color: theme.colors.accent.opacity(0.7))
                    }
                }

                Color.clear
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                let pt = value.location
                                if viewModel.currentStroke.isEmpty {
                                    viewModel.beginStroke(at: pt)
                                } else {
                                    viewModel.continueStroke(to: pt)
                                }
                            }
                            .onEnded { _ in
                                viewModel.endStroke()
                            }
                    )
            }
            .onAppear { viewModel.canvasSize = geo.size }
            .onChange(of: geo.size) { _, newSize in viewModel.canvasSize = newSize }
        }
        .aspectRatio(1, contentMode: .fit)
    }

    private func guideOverlay(symbol: SymbolDefinition, size: CGSize) -> some View {
        Canvas { context, canvasSize in
            for stroke in symbol.strokes {
                var path = Path()
                for (i, point) in stroke.enumerated() {
                    let x = point.x * canvasSize.width
                    let y = point.y * canvasSize.height
                    if i == 0 { path.move(to: CGPoint(x: x, y: y)) }
                    else { path.addLine(to: CGPoint(x: x, y: y)) }
                }
                context.stroke(path, with: .color(theme.colors.accent.opacity(viewModel.guideOpacity)), lineWidth: 3)
            }
        }
    }

    private func drawStroke(_ points: [CGPoint], in context: inout GraphicsContext, color: Color) {
        guard points.count >= 2 else { return }
        var path = Path()
        path.move(to: points[0])
        for i in 1..<points.count {
            path.addLine(to: points[i])
        }
        context.stroke(path, with: .color(color), style: StrokeStyle(lineWidth: 4, lineCap: .round, lineJoin: .round))
    }

    private var completionView: some View {
        VStack(spacing: 24) {
            Spacer()

            ZStack {
                Circle()
                    .fill(theme.colors.accent.opacity(0.1))
                    .frame(width: 120, height: 120)
                Image(systemName: viewModel.stars >= 2 ? "sparkles" : "pencil.tip")
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

            if let symbol = viewModel.symbol {
                Text(symbol.name)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .secondaryText()
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
        if viewModel.stars >= 3 { return "Masterwork!" }
        if viewModel.stars >= 2 { return "Well Drawn!" }
        if viewModel.stars >= 1 { return "Good Start!" }
        return "Keep Practicing!"
    }
}
