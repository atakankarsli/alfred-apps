import Foundation

struct Puzzle {
    let index: Int
    let gridSize: Int
    let season: Season
    let sourcePositions: [(row: Int, col: Int, signal: Bool)]
    let targetPositions: [(row: Int, col: Int, expected: Bool)]
    let availableComponents: [ComponentType: Int]
    let optimalComponentCount: Int
    let hint: String

    static func generate(index: Int) -> Puzzle {
        var rng = SeededRNG(seed: UInt64(index * 31337 + 2027))
        let season = Season.seasonForPuzzle(index)
        let gridSize = VoltConfig.gridSizeForSeason(season.id)
        let localIndex = index - season.puzzleRange.lowerBound

        let sourceCount = season.id >= 3 ? 2 : 1
        var sources: [(Int, Int, Bool)] = []
        for i in 0..<sourceCount {
            let row = gridSize / (sourceCount + 1) * (i + 1)
            sources.append((row, 0, true))
        }

        let targetCount = season.id >= 3 ? min(2, sourceCount + 1) : 1
        var targets: [(Int, Int, Bool)] = []
        for i in 0..<targetCount {
            let row = gridSize / (targetCount + 1) * (i + 1)
            let expected = localIndex % 3 == 0 ? true : (i % 2 == 0)
            targets.append((row, gridSize - 1, expected))
        }

        var inventory: [ComponentType: Int] = [:]
        let baseWires = gridSize + Int.random(in: 0...2, using: &rng)
        inventory[.wire] = baseWires

        for comp in season.availableComponents where comp != .wire {
            let count: Int
            switch comp {
            case .switchToggle: count = Int.random(in: 0...1, using: &rng)
            case .led: count = targetCount
            case .notGate: count = season.id >= 0 ? Int.random(in: 1...2, using: &rng) : 0
            case .andGate, .orGate: count = season.id >= 1 ? Int.random(in: 1...2, using: &rng) : 0
            case .xorGate: count = season.id >= 2 ? 1 : 0
            case .splitter: count = season.id >= 2 ? Int.random(in: 0...1, using: &rng) : 0
            default: count = 0
            }
            if count > 0 { inventory[comp] = count }
        }

        let optimal = max(3, baseWires / 2 + targetCount + (season.id >= 1 ? 1 : 0))
        let hint = hintForPuzzle(season: season, localIndex: localIndex)

        return Puzzle(
            index: index, gridSize: gridSize, season: season,
            sourcePositions: sources, targetPositions: targets,
            availableComponents: inventory, optimalComponentCount: optimal,
            hint: hint
        )
    }

    private static func hintForPuzzle(season: Season, localIndex: Int) -> String {
        let hints: [[String]] = [
            ["Connect the source to the LED with wires", "Use NOT to invert the signal", "Switches toggle signal on/off", "Route the wire around obstacles"],
            ["AND needs both inputs ON", "OR outputs ON if either input is ON", "Combine NOT with AND for NAND logic", "Chain gates for complex logic"],
            ["XOR outputs ON when inputs differ", "Splitter sends signal two ways", "Use XOR for parity checking", "Split then recombine signals"],
            ["Multiple outputs need separate paths", "Use splitters to fan out", "Gate ordering matters", "Think about signal timing"],
            ["Combine all component types", "Minimal components = more stars", "Every wire counts", "Elegant solutions score highest"],
        ]
        let seasonHints = hints[min(season.id, hints.count - 1)]
        return seasonHints[localIndex % seasonHints.count]
    }
}

enum CircuitSolver {
    struct CellState {
        var component: PlacedComponent?
        var signalValue: Bool = false
        var isSource: Bool = false
        var isTarget: Bool = false
        var targetExpected: Bool = false
    }

    static func evaluate(grid: [[CellState]], gridSize: Int) -> (solved: Bool, litCells: Set<Int>) {
        var visited = Set<Int>()
        var litCells = Set<Int>()
        var queue: [(Int, Int)] = []

        for r in 0..<gridSize {
            for c in 0..<gridSize {
                if grid[r][c].isSource {
                    queue.append((r, c))
                    visited.insert(r * gridSize + c)
                    litCells.insert(r * gridSize + c)
                }
            }
        }

        while !queue.isEmpty {
            let (r, c) = queue.removeFirst()
            let neighbors = [(r-1, c), (r+1, c), (r, c-1), (r, c+1)]

            for (nr, nc) in neighbors {
                guard nr >= 0, nr < gridSize, nc >= 0, nc < gridSize else { continue }
                let key = nr * gridSize + nc
                guard !visited.contains(key) else { continue }
                guard grid[nr][nc].component != nil else { continue }

                visited.insert(key)
                litCells.insert(key)
                queue.append((nr, nc))
            }
        }

        var solved = true
        for r in 0..<gridSize {
            for c in 0..<gridSize {
                if grid[r][c].isTarget {
                    let key = r * gridSize + c
                    let isLit = litCells.contains(key)
                    if isLit != grid[r][c].targetExpected { solved = false }
                }
            }
        }

        return (solved, litCells)
    }
}

struct SeededRNG: RandomNumberGenerator {
    var state: UInt64
    init(seed: UInt64) { state = seed == 0 ? 1 : seed }
    mutating func next() -> UInt64 {
        state &+= 0x9e3779b97f4a7c15
        var z = state
        z = (z ^ (z >> 30)) &* 0xbf58476d1ce4e5b9
        z = (z ^ (z >> 27)) &* 0x94d049bb133111eb
        return z ^ (z >> 31)
    }
}
