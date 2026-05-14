import SwiftUI
import SwiftData

struct TraceView: View {
    @Environment(\.theme) private var theme
    @Environment(\.modelContext) private var modelContext
    @Environment(AppState.self) private var appState
    let mode: TraceMode
    @State private var vm: TraceViewModel?

    var body: some View {
        ZStack {
            FloatingOrbsView().ignoresSafeArea()
            if let vm {
                VStack(spacing: 16) {
                    headerBar(vm)
                    Spacer()
                    gridView(vm)
                    Spacer()
                    bottomBar(vm)
                }.padding(16)
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity).themedBackground()
        .navigationBarBackButtonHidden(true)
        .onAppear {
            let v = TraceViewModel(mode: mode)
            v.configure(context: modelContext)
            vm = v
        }
        .onDisappear { vm?.cleanup() }
    }

    private func headerBar(_ vm: TraceViewModel) -> some View {
        HStack {
            Button { vm.cleanup(); appState.navigationPath.removeLast() } label: {
                Image(systemName: "xmark").font(.system(size: 16, weight: .bold)).primaryText()
                    .frame(width: 40, height: 40).background { Circle().fill(theme.colors.surface.opacity(0.4)) }
            }
            Spacer()
            if vm.phase == .preview {
                HStack(spacing: 6) { Image(systemName: "eye.fill").font(.system(size: 14)); Text("Memorize!") }
                    .font(.system(size: 15, weight: .bold, design: .rounded)).foregroundStyle(theme.colors.accent)
            } else if vm.phase == .playing {
                Text(String(format: "%.1fs", vm.timeElapsed)).font(.system(size: 17, weight: .bold, design: .monospaced)).primaryText()
            }
            Spacer()
            Text("Puzzle \(vm.puzzle.level + 1)").font(.system(size: 14, weight: .bold, design: .rounded)).secondaryText()
        }
    }

    private func gridView(_ vm: TraceViewModel) -> some View {
        let size = vm.puzzle.gridSize
        return VStack(spacing: 6) {
            ForEach(0..<size, id: \.self) { row in gridRow(vm: vm, row: row, size: size) }
        }.padding(12).background {
            RoundedRectangle(cornerRadius: 20).fill(theme.colors.surface.opacity(0.3))
                .overlay { RoundedRectangle(cornerRadius: 20).strokeBorder(theme.colors.boardBorder.opacity(0.15), lineWidth: 1) }
        }
    }

    private func gridRow(vm: TraceViewModel, row: Int, size: Int) -> some View {
        HStack(spacing: 6) {
            ForEach(0..<size, id: \.self) { col in
                let idx = row * size + col
                TraceCellView(
                    index: idx,
                    isPattern: vm.puzzle.pattern.contains(idx),
                    isSelected: vm.selectedCells.contains(idx),
                    phase: vm.phase,
                    theme: theme,
                    onTap: { vm.toggleCell(idx) }
                )
            }
        }
    }

    private func bottomBar(_ vm: TraceViewModel) -> some View {
        Group {
            if vm.phase == .playing {
                GlassButton("Check Pattern", icon: "checkmark.circle.fill") { vm.submit() }
            } else if vm.phase == .completed {
                completionView(vm)
            }
        }
    }

    private func completionView(_ vm: TraceViewModel) -> some View {
        VStack(spacing: 12) {
            HStack(spacing: 4) {
                ForEach(0..<3, id: \.self) { i in
                    Image(systemName: i < vm.stars ? "star.fill" : "star").font(.system(size: 28)).foregroundStyle(i < vm.stars ? .yellow : theme.colors.textSecondary.opacity(0.3))
                }
            }
            if vm.xpEarned > 0 { Text("+\(vm.xpEarned) XP").font(.system(size: 15, weight: .bold, design: .rounded)).foregroundStyle(theme.colors.accent) }
            if vm.isNewBest { Text("New Best!").font(.system(size: 13, weight: .bold)).foregroundStyle(.orange) }
            HStack(spacing: 12) {
                GlassButton("Home", icon: "house.fill") { vm.cleanup(); appState.navigationPath.removeLast() }
                if case .puzzle(let i) = mode, i + 1 < TraceConfig.totalPuzzles {
                    GlassButton("Next", icon: "arrow.right") { vm.cleanup(); appState.navigationPath.removeLast(); appState.navigationPath.append(Route.trace(mode: .puzzle(index: i + 1))) }
                }
            }
        }.padding(20).background { RoundedRectangle(cornerRadius: 22).fill(theme.colors.surface.opacity(0.5)).overlay { RoundedRectangle(cornerRadius: 22).strokeBorder(theme.colors.accent.opacity(0.2), lineWidth: 1) } }
    }
}

struct TraceCellView: View {
    let index: Int; let isPattern: Bool; let isSelected: Bool; let phase: TraceViewModel.GamePhase; let theme: Theme; let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            RoundedRectangle(cornerRadius: 8)
                .fill(cellColor)
                .overlay { RoundedRectangle(cornerRadius: 8).strokeBorder(borderColor, lineWidth: 1.5) }
                .aspectRatio(1, contentMode: .fit)
        }.buttonStyle(BounceButtonStyle()).disabled(phase != .playing)
    }

    private var cellColor: Color {
        switch phase {
        case .preview: return isPattern ? theme.colors.accent.opacity(0.7) : theme.colors.cellBackground
        case .playing: return isSelected ? theme.colors.accent.opacity(0.5) : theme.colors.cellBackground
        case .completed:
            if isPattern && isSelected { return Color.green.opacity(0.5) }
            if isPattern && !isSelected { return Color.orange.opacity(0.4) }
            if !isPattern && isSelected { return Color.red.opacity(0.4) }
            return theme.colors.cellBackground
        }
    }

    private var borderColor: Color {
        switch phase {
        case .preview: return isPattern ? theme.colors.accent.opacity(0.4) : theme.colors.boardBorder.opacity(0.1)
        case .playing: return isSelected ? theme.colors.accent.opacity(0.3) : theme.colors.boardBorder.opacity(0.1)
        case .completed:
            if isPattern && isSelected { return Color.green.opacity(0.3) }
            if isPattern || isSelected { return Color.orange.opacity(0.3) }
            return theme.colors.boardBorder.opacity(0.1)
        }
    }
}
