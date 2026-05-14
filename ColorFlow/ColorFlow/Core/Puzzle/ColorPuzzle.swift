import Foundation

struct NovaPuzzle {
    let gridSize: Int
    let initialEnergy: [Int]
    let solution: [Int]
    let level: Int
    let parTaps: Int

    var totalCells: Int { gridSize * gridSize }

    func criticalMass(at index: Int) -> Int {
        let row = index / gridSize
        let col = index % gridSize
        var neighbors = 4
        if row == 0 || row == gridSize - 1 { neighbors -= 1 }
        if col == 0 || col == gridSize - 1 { neighbors -= 1 }
        return neighbors
    }

    func orthogonalNeighbors(of index: Int) -> [Int] {
        let row = index / gridSize
        let col = index % gridSize
        var result: [Int] = []
        if row > 0 { result.append((row - 1) * gridSize + col) }
        if row < gridSize - 1 { result.append((row + 1) * gridSize + col) }
        if col > 0 { result.append(row * gridSize + (col - 1)) }
        if col < gridSize - 1 { result.append(row * gridSize + (col + 1)) }
        return result
    }

    static func gridSizeForLevel(_ level: Int) -> Int {
        switch level {
        case 0..<10: return 3
        case 10..<25: return 4
        case 25..<50: return 5
        case 50..<75: return 6
        default: return 7
        }
    }

    static func simulate(energy: inout [Int], gridSize: Int) -> [[Int]] {
        var explosionSteps: [[Int]] = []
        var maxIterations = 200

        while maxIterations > 0 {
            maxIterations -= 1
            var explodingCells: [Int] = []

            for i in 0..<energy.count {
                let row = i / gridSize
                let col = i % gridSize
                var cm = 4
                if row == 0 || row == gridSize - 1 { cm -= 1 }
                if col == 0 || col == gridSize - 1 { cm -= 1 }
                if energy[i] >= cm {
                    explodingCells.append(i)
                }
            }

            if explodingCells.isEmpty { break }
            explosionSteps.append(explodingCells)

            var delta = [Int](repeating: 0, count: energy.count)
            for cell in explodingCells {
                let row = cell / gridSize
                let col = cell % gridSize
                var cm = 4
                if row == 0 || row == gridSize - 1 { cm -= 1 }
                if col == 0 || col == gridSize - 1 { cm -= 1 }
                delta[cell] -= cm
                if row > 0 { delta[(row - 1) * gridSize + col] += 1 }
                if row < gridSize - 1 { delta[(row + 1) * gridSize + col] += 1 }
                if col > 0 { delta[row * gridSize + (col - 1)] += 1 }
                if col < gridSize - 1 { delta[row * gridSize + (col + 1)] += 1 }
            }

            for i in 0..<energy.count {
                energy[i] = max(0, energy[i] + delta[i])
            }
        }

        return explosionSteps
    }

    static func isClear(_ energy: [Int]) -> Bool {
        energy.allSatisfy { $0 == 0 }
    }

    static func generate(level: Int) -> NovaPuzzle {
        let gridSize = gridSizeForLevel(level)
        let totalCells = gridSize * gridSize
        var rng = SeededRNG(seed: UInt64(level * 7919 + 104729))

        let maxTaps: Int
        switch level {
        case 0..<5: maxTaps = 1
        case 5..<15: maxTaps = 2
        case 15..<35: maxTaps = 3
        case 35..<60: maxTaps = 3
        default: maxTaps = 4
        }

        for attempt in 0..<500 {
            let seed = UInt64(level * 7919 + 104729 + attempt * 31)
            var tryRng = SeededRNG(seed: seed)

            var energy = [Int](repeating: 0, count: totalCells)
            for i in 0..<totalCells {
                let row = i / gridSize
                let col = i % gridSize
                var cm = 4
                if row == 0 || row == gridSize - 1 { cm -= 1 }
                if col == 0 || col == gridSize - 1 { cm -= 1 }
                energy[i] = Int.random(in: 0..<cm, using: &tryRng)
            }

            let nonZeroCount = energy.filter { $0 > 0 }.count
            if nonZeroCount < totalCells / 2 { continue }

            if let solution = findSolution(energy: energy, gridSize: gridSize, maxTaps: maxTaps) {
                return NovaPuzzle(
                    gridSize: gridSize,
                    initialEnergy: energy,
                    solution: solution,
                    level: level,
                    parTaps: solution.count
                )
            }
        }

        return generateFallback(level: level, gridSize: gridSize, rng: &rng)
    }

    private static func findSolution(energy: [Int], gridSize: Int, maxTaps: Int) -> [Int]? {
        let totalCells = energy.count

        if maxTaps >= 1 {
            for tap in 0..<totalCells {
                var state = energy
                state[tap] += 1
                _ = simulate(energy: &state, gridSize: gridSize)
                if isClear(state) { return [tap] }
            }
        }

        if maxTaps >= 2 {
            for tap1 in 0..<totalCells {
                var state1 = energy
                state1[tap1] += 1
                _ = simulate(energy: &state1, gridSize: gridSize)
                if isClear(state1) { continue }

                for tap2 in tap1..<totalCells {
                    var state2 = state1
                    state2[tap2] += 1
                    _ = simulate(energy: &state2, gridSize: gridSize)
                    if isClear(state2) { return [tap1, tap2] }
                }
            }
        }

        if maxTaps >= 3 && totalCells <= 25 {
            for tap1 in 0..<totalCells {
                var s1 = energy
                s1[tap1] += 1
                _ = simulate(energy: &s1, gridSize: gridSize)
                if isClear(s1) { continue }
                for tap2 in tap1..<totalCells {
                    var s2 = s1
                    s2[tap2] += 1
                    _ = simulate(energy: &s2, gridSize: gridSize)
                    if isClear(s2) { continue }
                    for tap3 in tap2..<totalCells {
                        var s3 = s2
                        s3[tap3] += 1
                        _ = simulate(energy: &s3, gridSize: gridSize)
                        if isClear(s3) { return [tap1, tap2, tap3] }
                    }
                }
            }
        }

        return nil
    }

    private static func generateFallback(level: Int, gridSize: Int, rng: inout SeededRNG) -> NovaPuzzle {
        let totalCells = gridSize * gridSize

        let tapCell = Int.random(in: 0..<totalCells, using: &rng)

        var energy = [Int](repeating: 0, count: totalCells)
        for i in 0..<totalCells {
            let row = i / gridSize
            let col = i % gridSize
            var cm = 4
            if row == 0 || row == gridSize - 1 { cm -= 1 }
            if col == 0 || col == gridSize - 1 { cm -= 1 }
            energy[i] = cm - 1
        }

        energy[tapCell] = max(0, energy[tapCell] - 1)

        return NovaPuzzle(
            gridSize: gridSize,
            initialEnergy: energy,
            solution: [tapCell],
            level: level,
            parTaps: 1
        )
    }
}

struct SeededRNG: RandomNumberGenerator {
    private var state: UInt64

    init(seed: UInt64) {
        state = seed == 0 ? 1 : seed
    }

    mutating func next() -> UInt64 {
        state &+= 0x9E3779B97F4A7C15
        var z = state
        z = (z ^ (z >> 30)) &* 0xBF58476D1CE4E5B9
        z = (z ^ (z >> 27)) &* 0x94D049BB133111EB
        return z ^ (z >> 31)
    }
}
