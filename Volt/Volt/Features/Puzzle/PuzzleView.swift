import SwiftUI
import SwiftData

struct PuzzleView: View {
    @Environment(\.theme) private var theme
    @Environment(AppState.self) private var appState
    @Environment(\.modelContext) private var modelContext
    @Query private var stats: [StatsRecord]
    @Query private var settings: [SettingsRecord]
    @State private var vm: PuzzleViewModel

    init(puzzleIndex: Int) {
        _vm = State(initialValue: PuzzleViewModel(puzzleIndex: puzzleIndex))
    }

    var body: some View {
        VStack(spacing: 0) {
            headerBar
            ScrollView {
                VStack(spacing: 16) {
                    puzzleInfo
                    circuitGrid
                    if vm.showHint { hintCard }
                    componentPalette
                    if vm.isSolved { completionCard }
                }
                .padding(16)
            }
        }
        .themedBackground()
        .navigationBarBackButtonHidden(vm.isSolved)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack(spacing: 12) {
                    Button { vm.toggleHint() } label: {
                        Image(systemName: "lightbulb.fill").foregroundStyle(theme.colors.accent)
                    }
                    Button { vm.clearGrid() } label: {
                        Image(systemName: "arrow.counterclockwise").foregroundStyle(theme.colors.textSecondary)
                    }
                }
            }
        }
        .onAppear { vm.startTimer() }
        .onDisappear { vm.stopTimer() }
    }

    private var headerBar: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Puzzle \(vm.puzzle.index + 1)")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .primaryText()
                Text(vm.puzzle.season.name)
                    .font(.system(size: 12, weight: .medium))
                    .secondaryText()
            }
            Spacer()
            HStack(spacing: 12) {
                Label("\(vm.componentCount)", systemImage: "cpu.fill")
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .secondaryText()
                Label(timeString, systemImage: "clock.fill")
                    .font(.system(size: 13, weight: .medium, design: .monospaced))
                    .secondaryText()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }

    private var timeString: String {
        let m = vm.elapsedSeconds / 60
        let s = vm.elapsedSeconds % 60
        return String(format: "%d:%02d", m, s)
    }

    private var puzzleInfo: some View {
        HStack(spacing: 8) {
            ForEach(0..<3, id: \.self) { i in
                Image(systemName: i < vm.stars ? "star.fill" : "star")
                    .foregroundStyle(i < vm.stars ? theme.colors.accent : theme.colors.textMuted)
                    .font(.system(size: 16))
            }
            Spacer()
            Text("Optimal: \(vm.puzzle.optimalComponentCount)")
                .font(.system(size: 12, weight: .medium))
                .mutedText()
        }
    }

    private var circuitGrid: some View {
        let size = vm.puzzle.gridSize
        return VStack(spacing: 2) {
            ForEach(0..<size, id: \.self) { row in
                HStack(spacing: 2) {
                    ForEach(0..<size, id: \.self) { col in
                        gridCell(row: row, col: col)
                    }
                }
            }
        }
        .padding(8)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(theme.colors.surface.opacity(0.3))
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(theme.colors.cardBorder.opacity(0.15), lineWidth: 1)
                }
        }
    }

    private func gridCell(row: Int, col: Int) -> some View {
        let cell = vm.grid[row][col]
        let key = row * vm.puzzle.gridSize + col
        let isLit = vm.litCells.contains(key)

        return Button {
            if cell.placed != nil && vm.selectedComponent == nil {
                vm.removeComponent(row: row, col: col)
            } else {
                vm.placeComponent(row: row, col: col)
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(cellBackground(cell: cell, isLit: isLit))
                    .frame(minWidth: 44, minHeight: 44)
                    .aspectRatio(1, contentMode: .fit)

                if cell.isSource {
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(.orange)
                } else if cell.isTarget {
                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(isLit ? .yellow : theme.colors.textMuted)
                } else if let placed = cell.placed {
                    Image(systemName: placed.type.icon)
                        .font(.system(size: 16))
                        .foregroundStyle(isLit ? placed.type.color : placed.type.color.opacity(0.6))
                }
            }
        }
        .buttonStyle(.plain)
        .disabled(cell.isSource)
    }

    private func cellBackground(cell: PuzzleViewModel.CellState, isLit: Bool) -> Color {
        if cell.isSource { return theme.colors.accent.opacity(0.15) }
        if cell.isTarget {
            if isLit && cell.targetExpected { return Color.green.opacity(0.15) }
            if isLit && !cell.targetExpected { return Color.red.opacity(0.15) }
            return theme.colors.surface.opacity(0.5)
        }
        if isLit { return theme.colors.accent.opacity(0.08) }
        return theme.colors.surface.opacity(0.15)
    }

    private var hintCard: some View {
        HStack(spacing: 8) {
            Image(systemName: "lightbulb.fill").foregroundStyle(.yellow)
            Text(vm.puzzle.hint)
                .font(.system(size: 13, weight: .medium))
                .secondaryText()
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(theme.colors.accent.opacity(0.06))
                .overlay { RoundedRectangle(cornerRadius: 12).strokeBorder(theme.colors.accent.opacity(0.15), lineWidth: 1) }
        }
    }

    private var componentPalette: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Components")
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .primaryText()

            let components = vm.puzzle.availableComponents.sorted(by: { $0.key.rawValue < $1.key.rawValue })
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))], spacing: 8) {
                ForEach(components, id: \.key) { comp, _ in
                    componentButton(comp)
                }
            }
        }
    }

    private func componentButton(_ comp: ComponentType) -> some View {
        let remaining = vm.inventory[comp] ?? 0
        let selected = vm.selectedComponent == comp

        return Button {
            vm.selectedComponent = selected ? nil : comp
            HapticsService.selection()
        } label: {
            VStack(spacing: 4) {
                Image(systemName: comp.icon)
                    .font(.system(size: 18))
                    .foregroundStyle(remaining > 0 ? comp.color : theme.colors.textMuted)
                Text("\(remaining)")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundStyle(remaining > 0 ? theme.colors.text : theme.colors.textMuted)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .fill(selected ? comp.color.opacity(0.15) : theme.colors.surface.opacity(0.2))
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(selected ? comp.color.opacity(0.4) : theme.colors.cardBorder.opacity(0.08), lineWidth: selected ? 2 : 1)
                    }
            }
        }
        .buttonStyle(.plain)
        .disabled(remaining == 0)
        .opacity(remaining > 0 ? 1 : 0.5)
    }

    private var completionCard: some View {
        VStack(spacing: 14) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 44))
                .foregroundStyle(theme.colors.accent)
                .symbolEffect(.bounce)

            Text("Puzzle Solved!")
                .font(.system(size: 22, weight: .black, design: .rounded))
                .primaryText()

            HStack(spacing: 16) {
                statBubble("Stars", value: "\(vm.stars)/3", icon: "star.fill")
                statBubble("XP", value: "+\(vm.earnedXP)", icon: "bolt.fill")
                statBubble("Time", value: timeString, icon: "clock.fill")
            }

            GlassButton("Continue", icon: "arrow.right") {
                vm.recordCompletion(stats: stats.first, settings: settings.first, modelContext: modelContext)
                appState.pop()
            }
            .padding(.horizontal, 24)
        }
        .padding(20)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(theme.colors.accent.opacity(0.06))
                .overlay { RoundedRectangle(cornerRadius: 20).strokeBorder(theme.colors.accent.opacity(0.2), lineWidth: 1) }
        }
    }

    private func statBubble(_ title: String, value: String, icon: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon).font(.system(size: 14)).foregroundStyle(theme.colors.accent)
            Text(value).font(.system(size: 16, weight: .bold, design: .rounded)).primaryText()
            Text(title).font(.system(size: 10)).mutedText()
        }
    }
}
