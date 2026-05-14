import SwiftUI
import SwiftData

struct ImprintView: View {
    @Environment(\.theme) private var theme
    @Environment(AppState.self) private var appState
    @Environment(\.modelContext) private var modelContext
    @Query private var stats: [StatsRecord]
    @Query private var settings: [SettingsRecord]

    @State private var vm: ImprintViewModel

    init(mode: ImprintMode) {
        _vm = State(wrappedValue: ImprintViewModel(mode: mode))
    }

    var body: some View {
        ZStack {
            FloatingOrbsView()
                .ignoresSafeArea()

            VStack(spacing: 16) {
                headerBar
                mosaicGrid
                if vm.phase == .playing {
                    colorPalette
                    submitButton
                }
                if vm.phase == .completed {
                    completionView
                }
            }
            .padding(16)

            if vm.phase == .preview {
                previewOverlay
            }
        }
        .themedBackground()
        .navigationBarBackButtonHidden(vm.phase == .playing)
        .onAppear { vm.startPreview() }
        .onDisappear { vm.cleanup() }
    }

    private var headerBar: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Mosaic \(vm.puzzle.level + 1)")
                    .font(.system(size: 20, weight: .black, design: .rounded))
                    .primaryText()
                Text(vm.puzzle.momentType.displayName)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(theme.colors.accent)
            }
            Spacer()
            if vm.showTimer && vm.phase == .playing {
                Text(formatTime(vm.elapsedTime))
                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                    .secondaryText()
            }
        }
    }

    private var mosaicGrid: some View {
        let size = vm.gridSize
        return VStack(spacing: 3) {
            ForEach(0..<size, id: \.self) { row in
                gridRow(row: row, size: size)
            }
        }
        .padding(12)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(theme.colors.surface.opacity(0.3))
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(theme.colors.boardBorder.opacity(0.2), lineWidth: 1)
                }
        }
    }

    private func gridRow(row: Int, size: Int) -> some View {
        HStack(spacing: 3) {
            ForEach(0..<size, id: \.self) { col in
                let idx = row * size + col
                ImprintCellView(
                    theme: theme,
                    phase: vm.phase,
                    targetColorIndex: vm.puzzle.colorIndices[idx],
                    answerColorIndex: vm.answer[idx],
                    isCorrect: vm.phase == .completed ? vm.answer[idx] == vm.puzzle.colorIndices[idx] : nil
                ) {
                    vm.tapCell(idx)
                }
            }
        }
    }

    private var colorPalette: some View {
        let colors = Array(0..<vm.availableColors)
        return HStack(spacing: 8) {
            ForEach(colors, id: \.self) { idx in
                paletteButton(idx)
            }
        }
        .padding(.vertical, 8)
    }

    private func paletteButton(_ idx: Int) -> some View {
        let hex = ImprintPuzzle.palette[idx]
        let isSelected = vm.selectedColorIndex == idx
        return Button {
            vm.selectedColorIndex = idx
            HapticsService.selection()
        } label: {
            Circle()
                .fill(Color(hex: hex))
                .frame(width: isSelected ? 44 : 36, height: isSelected ? 44 : 36)
                .overlay {
                    Circle()
                        .strokeBorder(.white.opacity(isSelected ? 0.8 : 0), lineWidth: 3)
                }
                .shadow(color: Color(hex: hex).opacity(isSelected ? 0.5 : 0), radius: 6)
        }
        .animation(.spring(response: 0.3), value: isSelected)
    }

    private var submitButton: some View {
        GlassButton("Check Mosaic", icon: "checkmark.circle.fill") {
            vm.submit(stats: stats.first, settings: settings.first, modelContext: modelContext)
        }
    }

    private var completionView: some View {
        VStack(spacing: 12) {
            HStack(spacing: 4) {
                ForEach(0..<3, id: \.self) { i in
                    Image(systemName: i < vm.stars ? "star.fill" : "star")
                        .foregroundStyle(i < vm.stars ? Color.yellow : theme.colors.textSecondary.opacity(0.3))
                        .font(.system(size: 28))
                }
            }

            Text("\(Int(vm.accuracy * 100))% Accuracy")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .primaryText()

            HStack(spacing: 16) {
                GlassButton("Home", icon: "house.fill") {
                    appState.popToRoot()
                }
                GlassButton("Next", icon: "arrow.right") {
                    if case .mosaic(let idx) = vm.mode, idx + 1 < ImprintConfig.totalPuzzles {
                        appState.pop()
                        appState.navigate(to: .imprint(mode: .mosaic(index: idx + 1)))
                    } else {
                        appState.popToRoot()
                    }
                }
            }
        }
    }

    private var previewOverlay: some View {
        VStack(spacing: 12) {
            Image(systemName: "eye.fill")
                .font(.system(size: 32))
                .foregroundStyle(theme.colors.accent)
            Text("Memorize the colors!")
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .primaryText()
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 40)
    }

    private func formatTime(_ seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%d:%02d", m, s)
    }
}

struct ImprintCellView: View {
    let theme: Theme
    let phase: ImprintPhase
    let targetColorIndex: Int
    let answerColorIndex: Int
    let isCorrect: Bool?
    let onTap: () -> Void

    var body: some View {
        let displayColor = cellColor
        Button(action: onTap) {
            RoundedRectangle(cornerRadius: 8)
                .fill(displayColor)
                .aspectRatio(1, contentMode: .fit)
                .overlay {
                    cellOverlay
                }
                .shadow(color: displayColor.opacity(0.3), radius: 3)
        }
        .buttonStyle(.plain)
        .disabled(phase != .playing)
    }

    private var cellColor: Color {
        switch phase {
        case .preview:
            return Color(hex: ImprintPuzzle.palette[targetColorIndex])
        case .playing:
            return Color(hex: ImprintPuzzle.palette[answerColorIndex])
        case .completed:
            return Color(hex: ImprintPuzzle.palette[targetColorIndex])
        }
    }

    @ViewBuilder
    private var cellOverlay: some View {
        if let isCorrect, phase == .completed {
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(isCorrect ? Color.green : Color.red, lineWidth: 2)
        } else {
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(theme.colors.boardBorder.opacity(0.15), lineWidth: 0.5)
        }
    }
}
