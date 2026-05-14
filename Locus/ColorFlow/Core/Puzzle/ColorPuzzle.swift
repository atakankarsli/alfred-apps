import Foundation

enum RoomType: String, Codable, CaseIterable {
    case study, kitchen, garden, vault

    var displayName: String {
        switch self { case .study: "Study"; case .kitchen: "Kitchen"; case .garden: "Garden"; case .vault: "Vault" }
    }
    var icon: String {
        switch self { case .study: "book.fill"; case .kitchen: "fork.knife"; case .garden: "leaf.fill"; case .vault: "lock.shield.fill" }
    }
}

struct LocusPuzzle {
    let gridSize: Int
    let roomType: RoomType
    let level: Int
    let items: [(position: Int, symbol: String)]
    let previewDuration: TimeInterval

    private static let symbols = ["star.fill", "heart.fill", "bolt.fill", "moon.fill", "sun.max.fill",
                                   "flame.fill", "drop.fill", "leaf.fill", "bell.fill", "key.fill",
                                   "crown.fill", "diamond.fill", "flag.fill", "gift.fill", "eye.fill"]

    static func generate(level: Int) -> LocusPuzzle {
        var rng = SeededRNG(seed: UInt64(level * 6121 + 47))
        let rooms = RoomType.allCases
        let room = rooms[level % rooms.count]
        let gridSize: Int
        let itemCount: Int
        let preview: TimeInterval

        switch level {
        case 0..<20: gridSize = 4; itemCount = 2 + level / 5; preview = max(1.5, 3.0 - Double(level) * 0.07)
        case 20..<40: gridSize = 5; itemCount = 3 + (level - 20) / 4; preview = max(1.2, 2.5 - Double(level - 20) * 0.06)
        case 40..<60: gridSize = 5; itemCount = 5 + (level - 40) / 5; preview = max(1.0, 2.0 - Double(level - 40) * 0.04)
        default: gridSize = 6; itemCount = 6 + (level - 60) / 4; preview = max(0.8, 1.6 - Double(level - 60) * 0.04)
        }

        let total = gridSize * gridSize
        var positions = Set<Int>()
        while positions.count < min(itemCount, total) {
            positions.insert(Int(rng.next() % UInt64(total)))
        }
        let sorted = positions.sorted()
        var items: [(Int, String)] = []
        for pos in sorted {
            let sym = LocusPuzzle.symbols[Int(rng.next() % UInt64(LocusPuzzle.symbols.count))]
            items.append((pos, sym))
        }
        return LocusPuzzle(gridSize: gridSize, roomType: room, level: level, items: items, previewDuration: preview)
    }

    func score(placed: [Int: String]) -> Double {
        guard !items.isEmpty else { return 0 }
        var correct = 0
        for item in items {
            if placed[item.position] == item.symbol { correct += 1 }
        }
        return Double(correct) / Double(items.count)
    }
}

struct SeededRNG: RandomNumberGenerator {
    var state: UInt64
    init(seed: UInt64) { state = seed == 0 ? 1 : seed }
    mutating func next() -> UInt64 {
        state ^= state << 13; state ^= state >> 7; state ^= state << 17; return state
    }
}
