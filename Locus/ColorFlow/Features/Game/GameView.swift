import SwiftUI
import SwiftData

struct LocusView: View {
    @Environment(\.theme) private var theme
    @Environment(\.modelContext) private var modelContext
    @Environment(AppState.self) private var appState
    let mode: LocusMode
    @State private var vm: LocusViewModel?

    var body: some View {
        ZStack {
            FloatingOrbsView().ignoresSafeArea()
            if let vm { VStack(spacing: 16) { headerBar(vm); Spacer(); gridView(vm); Spacer(); bottomBar(vm) }.padding(16) }
        }.frame(maxWidth: .infinity, maxHeight: .infinity).themedBackground()
        .navigationBarBackButtonHidden(true)
        .onAppear { let v = LocusViewModel(mode: mode); v.configure(context: modelContext); vm = v }
        .onDisappear { vm?.cleanup() }
    }

    private func headerBar(_ vm: LocusViewModel) -> some View {
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
            Text("Room \(vm.puzzle.level + 1)").font(.system(size: 14, weight: .bold, design: .rounded)).secondaryText()
        }
    }

    private func gridView(_ vm: LocusViewModel) -> some View {
        let size = vm.puzzle.gridSize
        return VStack(spacing: 6) {
            ForEach(0..<size, id: \.self) { row in gridRow(vm: vm, row: row, size: size) }
        }.padding(12).background {
            RoundedRectangle(cornerRadius: 20).fill(theme.colors.surface.opacity(0.3))
                .overlay { RoundedRectangle(cornerRadius: 20).strokeBorder(theme.colors.boardBorder.opacity(0.15), lineWidth: 1) }
        }
    }

    private func gridRow(vm: LocusViewModel, row: Int, size: Int) -> some View {
        HStack(spacing: 6) {
            ForEach(0..<size, id: \.self) { col in
                let idx = row * size + col
                LocusCellView(index: idx, vm: vm, theme: theme)
            }
        }
    }

    private func bottomBar(_ vm: LocusViewModel) -> some View {
        Group {
            if vm.phase == .playing {
                GlassButton("Check Placement", icon: "checkmark.circle.fill") { vm.submit() }
            } else if vm.phase == .completed {
                completionView(vm)
            }
        }
    }

    private func completionView(_ vm: LocusViewModel) -> some View {
        VStack(spacing: 12) {
            starsRow(vm.stars)
            if vm.xpEarned > 0 { Text("+\(vm.xpEarned) XP").font(.system(size: 15, weight: .bold, design: .rounded)).foregroundStyle(theme.colors.accent) }
            if vm.isNewBest { Text("New Best!").font(.system(size: 13, weight: .bold)).foregroundStyle(.orange) }
            HStack(spacing: 12) {
                GlassButton("Home", icon: "house.fill") { vm.cleanup(); appState.navigationPath.removeLast() }
                if case .room(let i) = mode, i + 1 < LocusConfig.totalPuzzles {
                    GlassButton("Next", icon: "arrow.right") { vm.cleanup(); appState.navigationPath.removeLast(); appState.navigationPath.append(Route.locus(mode: .room(index: i + 1))) }
                }
            }
        }.padding(20).background { RoundedRectangle(cornerRadius: 22).fill(theme.colors.surface.opacity(0.5)).overlay { RoundedRectangle(cornerRadius: 22).strokeBorder(theme.colors.accent.opacity(0.2), lineWidth: 1) } }
    }

    private func starsRow(_ count: Int) -> some View {
        HStack(spacing: 4) {
            ForEach(0..<3, id: \.self) { i in
                Image(systemName: i < count ? "star.fill" : "star").font(.system(size: 28))
                    .foregroundStyle(i < count ? .yellow : theme.colors.textSecondary.opacity(0.3))
            }
        }
    }
}

struct LocusCellView: View {
    let index: Int
    let vm: LocusViewModel
    let theme: Theme

    var body: some View {
        Button { vm.toggleCell(index) } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8).fill(cellColor)
                    .overlay { RoundedRectangle(cornerRadius: 8).strokeBorder(borderColor, lineWidth: 1.5) }
                    .aspectRatio(1, contentMode: .fit)
                cellContent
            }
        }.buttonStyle(BounceButtonStyle()).disabled(vm.phase != .playing)
    }

    private var isItem: Bool { vm.itemPositions.contains(index) }
    private var isSelected: Bool { vm.selectedCells.contains(index) }

    @ViewBuilder private var cellContent: some View {
        switch vm.phase {
        case .preview:
            if let sym = vm.symbolAt(index) { Image(systemName: sym).font(.system(size: 16, weight: .bold)).foregroundStyle(theme.colors.accent) }
        case .playing:
            if isSelected { Image(systemName: "mappin.circle.fill").font(.system(size: 16, weight: .bold)).foregroundStyle(theme.colors.accent) }
        case .completed:
            if isItem, let sym = vm.symbolAt(index) {
                Image(systemName: sym).font(.system(size: 14, weight: .bold)).foregroundStyle(isSelected ? .green : .orange)
            } else if isSelected {
                Image(systemName: "xmark").font(.system(size: 12, weight: .bold)).foregroundStyle(.red.opacity(0.7))
            }
        }
    }

    private var cellColor: Color {
        switch vm.phase {
        case .preview: return isItem ? theme.colors.accent.opacity(0.2) : theme.colors.cellBackground
        case .playing: return isSelected ? theme.colors.accent.opacity(0.15) : theme.colors.cellBackground
        case .completed:
            if isItem && isSelected { return Color.green.opacity(0.15) }
            if isItem { return Color.orange.opacity(0.15) }
            if isSelected { return Color.red.opacity(0.1) }
            return theme.colors.cellBackground
        }
    }

    private var borderColor: Color {
        switch vm.phase {
        case .preview: return isItem ? theme.colors.accent.opacity(0.3) : theme.colors.boardBorder.opacity(0.1)
        case .playing: return isSelected ? theme.colors.accent.opacity(0.3) : theme.colors.boardBorder.opacity(0.1)
        case .completed:
            if isItem && isSelected { return Color.green.opacity(0.3) }
            if isItem || isSelected { return Color.orange.opacity(0.3) }
            return theme.colors.boardBorder.opacity(0.1)
        }
    }
}
