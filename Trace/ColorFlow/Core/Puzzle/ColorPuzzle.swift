import Foundation

enum TraceCategory: String, Codable, CaseIterable {
    case glimpse, sequence, spatial, cipher

    var displayName: String {
        switch self { case .glimpse: "Glimpse"; case .sequence: "Sequence"; case .spatial: "Spatial"; case .cipher: "Cipher" }
    }
    var icon: String {
        switch self { case .glimpse: "eye.fill"; case .sequence: "arrow.right.arrow.left"; case .spatial: "square.grid.3x3.fill"; case .cipher: "lock.fill" }
    }
}

struct TracePuzzle {
    let gridSize: Int
    let category: TraceCategory
    let level: Int
    let pattern: Set<Int>
    let previewDuration: TimeInterval

    static func generate(level: Int) -> TracePuzzle {
        var rng = SeededRNG(seed: UInt64(level * 7919 + 31))
        let categories = TraceCategory.allCases
        let cat = categories[level % categories.count]
        let gridSize: Int
        let cellCount: Int
        let preview: TimeInterval

        switch level {
        case 0..<20: gridSize = 4; cellCount = 3 + level / 5; preview = max(1.2, 2.5 - Double(level) * 0.06)
        case 20..<40: gridSize = 5; cellCount = 4 + (level - 20) / 4; preview = max(1.0, 2.2 - Double(level - 20) * 0.05)
        case 40..<60: gridSize = 5; cellCount = 6 + (level - 40) / 5; preview = max(0.8, 1.8 - Double(level - 40) * 0.04)
        default: gridSize = 6; cellCount = 7 + (level - 60) / 5; preview = max(0.6, 1.5 - Double(level - 60) * 0.04)
        }

        let total = gridSize * gridSize
        var cells = Set<Int>()
        while cells.count < min(cellCount, total) {
            cells.insert(Int(rng.next() % UInt64(total)))
        }
        return TracePuzzle(gridSize: gridSize, category: cat, level: level, pattern: cells, previewDuration: preview)
    }

    func accuracy(selected: Set<Int>) -> Double {
        guard !pattern.isEmpty else { return 0 }
        let correct = selected.intersection(pattern).count
        let wrong = selected.subtracting(pattern).count
        let score = Double(correct) - Double(wrong) * 0.5
        return max(0, min(1, score / Double(pattern.count)))
    }
}

struct SeededRNG: RandomNumberGenerator {
    var state: UInt64
    init(seed: UInt64) { state = seed == 0 ? 1 : seed }
    mutating func next() -> UInt64 {
        state ^= state << 13; state ^= state >> 7; state ^= state << 17; return state
    }
}
