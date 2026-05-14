import SwiftUI
import SwiftData

struct SandboxView: View {
    @Environment(\.theme) private var theme
    @Environment(\.modelContext) private var modelContext
    @Query private var stats: [StatsRecord]
    @State private var gridSize = 5
    @State private var grid: [[CellState]] = []
    @State private var selectedComponent: ComponentType?
    @State private var litCells = Set<Int>()

    struct CellState {
        var placed: PlacedComponent?
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                gridSizePicker
                sandboxGrid
                palette
                actionButtons
            }
            .padding(16)
        }
        .themedBackground()
        .navigationTitle("Sandbox")
        .onAppear { resetGrid() }
    }

    private var gridSizePicker: some View {
        HStack(spacing: 12) {
            Text("Grid Size").font(.system(size: 14, weight: .semibold)).primaryText()
            Spacer()
            ForEach([4, 5, 6], id: \.self) { size in
                Button {
                    gridSize = size
                    resetGrid()
                } label: {
                    Text("\(size)x\(size)")
                        .font(.system(size: 13, weight: .medium))
                        .padding(.horizontal, 12).padding(.vertical, 6)
                        .foregroundStyle(gridSize == size ? theme.colors.accent : theme.colors.textSecondary)
                        .background {
                            Capsule().fill(gridSize == size ? theme.colors.accent.opacity(0.12) : theme.colors.surface.opacity(0.3))
                        }
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var sandboxGrid: some View {
        VStack(spacing: 2) {
            ForEach(0..<gridSize, id: \.self) { row in
                HStack(spacing: 2) {
                    ForEach(0..<gridSize, id: \.self) { col in
                        sandboxCell(row: row, col: col)
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

    private func sandboxCell(row: Int, col: Int) -> some View {
        let key = row * gridSize + col
        let isLit = litCells.contains(key)

        return Button {
            if grid[row][col].placed != nil && selectedComponent == nil {
                grid[row][col].placed = nil
                runEvaluate()
            } else if let comp = selectedComponent {
                grid[row][col].placed = PlacedComponent(type: comp, row: row, col: col)
                HapticsService.light()
                SoundService.shared.playPlace()
                runEvaluate()
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(isLit ? theme.colors.accent.opacity(0.08) : theme.colors.surface.opacity(0.15))
                    .frame(minWidth: 44, minHeight: 44)
                    .aspectRatio(1, contentMode: .fit)

                if let placed = grid[row][col].placed {
                    Image(systemName: placed.type.icon)
                        .font(.system(size: 16))
                        .foregroundStyle(isLit ? placed.type.color : placed.type.color.opacity(0.6))
                }
            }
        }
        .buttonStyle(.plain)
    }

    private var palette: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Components")
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .primaryText()

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))], spacing: 8) {
                ForEach(ComponentType.allCases) { comp in
                    let selected = selectedComponent == comp
                    Button {
                        selectedComponent = selected ? nil : comp
                        HapticsService.selection()
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: comp.icon).font(.system(size: 18)).foregroundStyle(comp.color)
                            Text(comp.displayName).font(.system(size: 10, weight: .medium)).primaryText()
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
                }
            }
        }
    }

    private var actionButtons: some View {
        HStack(spacing: 12) {
            GlassButton("Clear", icon: "trash", style: .secondary) {
                resetGrid()
                HapticsService.light()
            }
            GlassButton("Save Build", icon: "square.and.arrow.down", style: .primary) {
                stats.first?.sandboxBuilds += 1
                HapticsService.heavy()
                SoundService.shared.playSolve()
            }
        }
    }

    private func resetGrid() {
        grid = Array(repeating: Array(repeating: CellState(), count: gridSize), count: gridSize)
        litCells.removeAll()
    }

    private func runEvaluate() {
        var solverGrid = Array(repeating: Array(repeating: CircuitSolver.CellState(), count: gridSize), count: gridSize)
        for r in 0..<gridSize {
            for c in 0..<gridSize {
                solverGrid[r][c].component = grid[r][c].placed
                if r == 0 && c == 0 {
                    solverGrid[r][c].isSource = true
                }
            }
        }
        let result = CircuitSolver.evaluate(grid: solverGrid, gridSize: gridSize)
        litCells = result.litCells
    }
}
