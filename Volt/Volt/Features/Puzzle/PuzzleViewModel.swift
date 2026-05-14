import SwiftUI
import SwiftData

@MainActor @Observable
final class PuzzleViewModel {
    let puzzle: Puzzle
    var grid: [[CellState]]
    var selectedComponent: ComponentType?
    var inventory: [ComponentType: Int]
    var isSolved = false
    var litCells = Set<Int>()
    var componentCount = 0
    var elapsedSeconds = 0
    var showHint = false
    var hintUsed = false
    private var timer: Timer?

    struct CellState {
        var placed: PlacedComponent?
        var isSource: Bool = false
        var sourceSignal: Bool = false
        var isTarget: Bool = false
        var targetExpected: Bool = false
    }

    init(puzzleIndex: Int) {
        let p = Puzzle.generate(index: puzzleIndex)
        self.puzzle = p
        self.inventory = p.availableComponents

        var g = Array(repeating: Array(repeating: CellState(), count: p.gridSize), count: p.gridSize)
        for src in p.sourcePositions {
            g[src.row][src.col].isSource = true
            g[src.row][src.col].sourceSignal = src.signal
        }
        for tgt in p.targetPositions {
            g[tgt.row][tgt.col].isTarget = true
            g[tgt.row][tgt.col].targetExpected = tgt.expected
        }
        self.grid = g
    }

    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.elapsedSeconds += 1
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func placeComponent(row: Int, col: Int) {
        guard let comp = selectedComponent else { return }
        guard row >= 0, row < puzzle.gridSize, col >= 0, col < puzzle.gridSize else { return }
        guard !grid[row][col].isSource else { return }

        if grid[row][col].placed != nil {
            removeComponent(row: row, col: col)
        }

        guard (inventory[comp] ?? 0) > 0 else { return }

        let placed = PlacedComponent(type: comp, row: row, col: col)
        grid[row][col].placed = placed
        inventory[comp, default: 0] -= 1
        componentCount += 1

        HapticsService.light()
        SoundService.shared.playPlace()
        evaluateCircuit()
    }

    func removeComponent(row: Int, col: Int) {
        guard let placed = grid[row][col].placed else { return }
        grid[row][col].placed = nil
        inventory[placed.type, default: 0] += 1
        componentCount -= 1
        evaluateCircuit()
    }

    func clearGrid() {
        for r in 0..<puzzle.gridSize {
            for c in 0..<puzzle.gridSize {
                if let placed = grid[r][c].placed {
                    inventory[placed.type, default: 0] += 1
                    grid[r][c].placed = nil
                }
            }
        }
        componentCount = 0
        litCells.removeAll()
        isSolved = false
    }

    func toggleHint() {
        showHint.toggle()
        if showHint { hintUsed = true }
    }

    func evaluateCircuit() {
        var solverGrid = Array(repeating: Array(repeating: CircuitSolver.CellState(), count: puzzle.gridSize), count: puzzle.gridSize)

        for r in 0..<puzzle.gridSize {
            for c in 0..<puzzle.gridSize {
                solverGrid[r][c].component = grid[r][c].placed
                solverGrid[r][c].isSource = grid[r][c].isSource
                solverGrid[r][c].isTarget = grid[r][c].isTarget
                solverGrid[r][c].targetExpected = grid[r][c].targetExpected
            }
        }

        let result = CircuitSolver.evaluate(grid: solverGrid, gridSize: puzzle.gridSize)
        litCells = result.litCells

        if result.solved && !isSolved {
            isSolved = true
            stopTimer()
            HapticsService.heavy()
            SoundService.shared.playSolve()
        }
    }

    var stars: Int { VoltConfig.starsForSolution(componentCount: componentCount, optimalCount: puzzle.optimalComponentCount) }
    var earnedXP: Int { VoltConfig.xpForPuzzle(stars: stars, seasonId: puzzle.season.id) }

    func recordCompletion(stats: StatsRecord?, settings: SettingsRecord?, modelContext: ModelContext) {
        guard let stats else { return }
        stats.puzzlesCompleted = max(stats.puzzlesCompleted, puzzle.index + 1)
        stats.totalXP += earnedXP
        if stars == 3 { stats.threeStarCount += 1 }
        if !hintUsed { stats.puzzlesWithoutHints += 1 } else { stats.hintsUsed += 1 }
        if stats.fastestSolveTime == 0 || elapsedSeconds < stats.fastestSolveTime {
            stats.fastestSolveTime = elapsedSeconds
        }
        stats.updateStreak()

        var comps = stats.componentsUsed
        for r in 0..<puzzle.gridSize {
            for c in 0..<puzzle.gridSize {
                if let placed = grid[r][c].placed { comps.insert(placed.type.rawValue) }
            }
        }
        stats.componentsUsed = comps

        var seasons = stats.seasonsPlayed
        seasons.insert(puzzle.season.name)
        stats.seasonsPlayed = seasons

        settings?.highestUnlockedLevel = max(settings?.highestUnlockedLevel ?? 0, puzzle.index + 1)

        checkAchievements(stats: stats, modelContext: modelContext)
    }

    private func checkAchievements(stats: StatsRecord, modelContext: ModelContext) {
        let existing = (try? modelContext.fetch(FetchDescriptor<AchievementRecord>()))?.map(\.achievementId) ?? []
        var toUnlock: [String] = []

        if stats.puzzlesCompleted >= 1 { toUnlock.append("first_circuit") }
        if stats.puzzlesCompleted >= 16 { toUnlock.append("basics_done") }
        if stats.puzzlesCompleted >= 32 { toUnlock.append("logic_done") }
        if stars == 3 { toUnlock.append("triple_star") }
        if stats.threeStarCount >= 10 { toUnlock.append("star_10") }
        if stats.threeStarCount >= 50 { toUnlock.append("star_50") }
        if stats.currentStreak >= 3 { toUnlock.append("streak_3") }
        if stats.currentStreak >= 7 { toUnlock.append("streak_7") }
        if stats.currentStreak >= 30 { toUnlock.append("streak_30") }
        if stats.currentStreak >= 100 { toUnlock.append("streak_100") }
        if stats.totalXP >= 100 { toUnlock.append("xp_100") }
        if stats.totalXP >= 500 { toUnlock.append("xp_500") }
        if stats.totalXP >= 2000 { toUnlock.append("xp_2000") }
        if stats.totalXP >= 10000 { toUnlock.append("xp_10000") }
        if stats.sandboxBuilds >= 5 { toUnlock.append("sandbox_5") }
        if stats.componentsUsed.count >= ComponentType.allCases.count { toUnlock.append("all_components") }
        if stats.puzzlesWithoutHints >= 10 { toUnlock.append("no_hints") }
        if elapsedSeconds > 0 && elapsedSeconds <= 30 { toUnlock.append("speed_30") }
        if stats.puzzlesCompleted >= 20 { toUnlock.append("puzzles_20") }
        if stats.puzzlesCompleted >= 50 { toUnlock.append("puzzles_50") }

        for id in toUnlock where !existing.contains(id) {
            modelContext.insert(AchievementRecord(achievementId: id))
        }
    }
}
