import Foundation
import SwiftUI

struct BeamColor: Equatable, Hashable {
    let r: Bool, g: Bool, b: Bool

    static let red = BeamColor(r: true, g: false, b: false)
    static let green = BeamColor(r: false, g: true, b: false)
    static let blue = BeamColor(r: false, g: false, b: true)
    static let yellow = BeamColor(r: true, g: true, b: false)
    static let cyan = BeamColor(r: false, g: true, b: true)
    static let magenta = BeamColor(r: true, g: false, b: true)
    static let white = BeamColor(r: true, g: true, b: true)
    static let off = BeamColor(r: false, g: false, b: false)

    func mixed(with other: BeamColor) -> BeamColor {
        BeamColor(r: r || other.r, g: g || other.g, b: b || other.b)
    }

    var swiftColor: Color {
        switch (r, g, b) {
        case (true, false, false): return Color(red: 1.0, green: 0.15, blue: 0.15)
        case (false, true, false): return Color(red: 0.15, green: 0.85, blue: 0.2)
        case (false, false, true): return Color(red: 0.25, green: 0.4, blue: 1.0)
        case (true, true, false): return Color(red: 1.0, green: 0.88, blue: 0.1)
        case (false, true, true): return Color(red: 0.1, green: 0.88, blue: 1.0)
        case (true, false, true): return Color(red: 1.0, green: 0.2, blue: 0.85)
        case (true, true, true): return .white
        default: return Color(white: 0.15)
        }
    }

    var label: String {
        switch (r, g, b) {
        case (true, false, false): "Red"
        case (false, true, false): "Green"
        case (false, false, true): "Blue"
        case (true, true, false): "Yellow"
        case (false, true, true): "Cyan"
        case (true, false, true): "Magenta"
        case (true, true, true): "White"
        default: "Off"
        }
    }
}

struct Emitter {
    let index: Int
    let color: BeamColor
    let solutionDir: Int
}

struct Target {
    let index: Int
    let required: BeamColor
}

struct BeamSegment {
    let fromRow: Int, fromCol: Int
    let toRow: Int, toCol: Int
    let color: BeamColor
}

struct PrismPuzzle {
    let gridSize: Int
    let level: Int
    let parMoves: Int
    let emitters: [Emitter]
    let targets: [Target]
    let walls: Set<Int>

    private static let dirDx = [0, 1, 0, -1]
    private static let dirDy = [-1, 0, 1, 0]

    static func gridSizeForLevel(_ level: Int) -> Int {
        switch level {
        case 0..<16: return 5
        case 16..<48: return 6
        default: return 7
        }
    }

    static func traceBeams(gridSize: Int, emitters: [Emitter], directions: [Int: Int], walls: Set<Int>) -> ([BeamSegment], [Int: BeamColor]) {
        var segments: [BeamSegment] = []
        var cellColors: [Int: BeamColor] = [:]
        let emitterSet = Set(emitters.map { $0.index })

        for emitter in emitters {
            let dir = directions[emitter.index] ?? 0
            let dx = dirDx[dir]
            let dy = dirDy[dir]
            let startRow = emitter.index / gridSize
            let startCol = emitter.index % gridSize

            var row = startRow + dy
            var col = startCol + dx
            var endRow = startRow
            var endCol = startCol

            while row >= 0, row < gridSize, col >= 0, col < gridSize {
                let idx = row * gridSize + col
                if walls.contains(idx) || emitterSet.contains(idx) { break }

                if let existing = cellColors[idx] {
                    cellColors[idx] = existing.mixed(with: emitter.color)
                } else {
                    cellColors[idx] = emitter.color
                }

                endRow = row
                endCol = col
                row += dy
                col += dx
            }

            if endRow != startRow || endCol != startCol {
                segments.append(BeamSegment(fromRow: startRow, fromCol: startCol, toRow: endRow, toCol: endCol, color: emitter.color))
            }
        }

        return (segments, cellColors)
    }

    // MARK: - Generation

    static func generate(level: Int) -> PrismPuzzle {
        let gridSize = gridSizeForLevel(level)
        var rng = SeededRNG(seed: UInt64(level &* 7919 &+ 31337))

        let numTargets: Int
        let useMixed: Bool
        switch level {
        case 0..<8:  numTargets = 1; useMixed = false
        case 8..<16:  numTargets = 2; useMixed = false
        case 16..<32: numTargets = 2; useMixed = true
        case 32..<48: numTargets = 2; useMixed = true
        case 48..<64: numTargets = 3; useMixed = true
        default:      numTargets = 3; useMixed = true
        }

        let primaries: [BeamColor] = [.red, .green, .blue]
        let mixes: [(BeamColor, BeamColor, BeamColor)] = [
            (.red, .green, .yellow),
            (.red, .blue, .magenta),
            (.green, .blue, .cyan),
        ]

        for attempt in 0..<500 {
            let seed = UInt64(level &* 7919 &+ 31337 &+ attempt &* 13)
            var tryRng = SeededRNG(seed: seed)
            var usedPositions = Set<Int>()
            var emitters: [Emitter] = []
            var targets: [Target] = []
            var valid = true

            for t in 0..<numTargets {
                guard valid else { break }

                var tRow = -1, tCol = -1
                for _ in 0..<50 {
                    let r = Int.random(in: 1..<(gridSize - 1), using: &tryRng)
                    let c = Int.random(in: 1..<(gridSize - 1), using: &tryRng)
                    let idx = r * gridSize + c
                    guard !usedPositions.contains(idx) else { continue }
                    tRow = r; tCol = c; usedPositions.insert(idx); break
                }
                guard tRow >= 0 else { valid = false; break }

                let targetIdx = tRow * gridSize + tCol

                if useMixed && t > 0 {
                    let mix = mixes[t % mixes.count]
                    guard let e1 = placeOnRow(tRow, targetCol: tCol, color: mix.0, gridSize: gridSize, used: &usedPositions, rng: &tryRng) else { valid = false; break }
                    guard let e2 = placeOnCol(tCol, targetRow: tRow, color: mix.1, gridSize: gridSize, used: &usedPositions, rng: &tryRng) else { valid = false; break }
                    emitters.append(e1)
                    emitters.append(e2)
                    targets.append(Target(index: targetIdx, required: mix.2))
                } else {
                    let color = primaries[t % 3]
                    let useRow = Bool.random(using: &tryRng)
                    if useRow {
                        guard let e = placeOnRow(tRow, targetCol: tCol, color: color, gridSize: gridSize, used: &usedPositions, rng: &tryRng) else { valid = false; break }
                        emitters.append(e)
                    } else {
                        guard let e = placeOnCol(tCol, targetRow: tRow, color: color, gridSize: gridSize, used: &usedPositions, rng: &tryRng) else { valid = false; break }
                        emitters.append(e)
                    }
                    targets.append(Target(index: targetIdx, required: color))
                }
            }

            guard valid else { continue }

            var solutionDirs: [Int: Int] = [:]
            for e in emitters { solutionDirs[e.index] = e.solutionDir }
            let (_, received) = traceBeams(gridSize: gridSize, emitters: emitters, directions: solutionDirs, walls: [])

            var allMatch = true
            for target in targets {
                if received[target.index] != target.required { allMatch = false; break }
            }
            guard allMatch else { continue }

            var par = 0
            for _ in emitters {
                let scramble = Int.random(in: 1..<4, using: &tryRng)
                par += min(scramble, 4 - scramble)
            }
            par = max(par, emitters.count)

            return PrismPuzzle(gridSize: gridSize, level: level, parMoves: par, emitters: emitters, targets: targets, walls: [])
        }

        return fallback(level: level, gridSize: gridSize, rng: &rng)
    }

    private static func placeOnRow(_ row: Int, targetCol: Int, color: BeamColor, gridSize: Int, used: inout Set<Int>, rng: inout SeededRNG) -> Emitter? {
        for _ in 0..<30 {
            let col = Int.random(in: 0..<gridSize, using: &rng)
            guard col != targetCol else { continue }
            let idx = row * gridSize + col
            guard !used.contains(idx) else { continue }

            let dir = col < targetCol ? 1 : 3
            let dx = dirDx[dir]
            var c = col + dx
            var clear = true
            while c != targetCol {
                if used.contains(row * gridSize + c) { clear = false; break }
                c += dx
            }
            guard clear else { continue }

            used.insert(idx)
            return Emitter(index: idx, color: color, solutionDir: dir)
        }
        return nil
    }

    private static func placeOnCol(_ col: Int, targetRow: Int, color: BeamColor, gridSize: Int, used: inout Set<Int>, rng: inout SeededRNG) -> Emitter? {
        for _ in 0..<30 {
            let row = Int.random(in: 0..<gridSize, using: &rng)
            guard row != targetRow else { continue }
            let idx = row * gridSize + col
            guard !used.contains(idx) else { continue }

            let dir = row < targetRow ? 2 : 0
            let dy = dirDy[dir]
            var r = row + dy
            var clear = true
            while r != targetRow {
                if used.contains(r * gridSize + col) { clear = false; break }
                r += dy
            }
            guard clear else { continue }

            used.insert(idx)
            return Emitter(index: idx, color: color, solutionDir: dir)
        }
        return nil
    }

    private static func fallback(level: Int, gridSize: Int, rng: inout SeededRNG) -> PrismPuzzle {
        let row = gridSize / 2
        let eCol = 0
        let tCol = gridSize - 1
        return PrismPuzzle(
            gridSize: gridSize, level: level, parMoves: 2,
            emitters: [Emitter(index: row * gridSize + eCol, color: .red, solutionDir: 1)],
            targets: [Target(index: row * gridSize + tCol, required: .red)],
            walls: []
        )
    }
}

struct SeededRNG: RandomNumberGenerator {
    private var state: UInt64

    init(seed: UInt64) { state = seed == 0 ? 1 : seed }

    mutating func next() -> UInt64 {
        state &+= 0x9E3779B97F4A7C15
        var z = state
        z = (z ^ (z >> 30)) &* 0xBF58476D1CE4E5B9
        z = (z ^ (z >> 27)) &* 0x94D049BB133111EB
        return z ^ (z >> 31)
    }
}
