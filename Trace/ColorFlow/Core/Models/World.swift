import SwiftUI

struct MemoryZone: Identifiable {
    let id: Int; let name: String; let subtitle: String; let icon: String; let accentHex: String; let firstPuzzle: Int; let puzzleCount: Int
    var puzzleRange: Range<Int> { firstPuzzle..<(firstPuzzle + puzzleCount) }

    static let all: [MemoryZone] = [
        MemoryZone(id: 0, name: "Glimpse", subtitle: "Quick flash patterns", icon: "eye.fill", accentHex: "5BC0EB", firstPuzzle: 0, puzzleCount: 20),
        MemoryZone(id: 1, name: "Sequence", subtitle: "Ordered recall", icon: "arrow.right.arrow.left", accentHex: "FFA62B", firstPuzzle: 20, puzzleCount: 20),
        MemoryZone(id: 2, name: "Spatial", subtitle: "Position memory", icon: "square.grid.3x3.fill", accentHex: "9B5DE5", firstPuzzle: 40, puzzleCount: 20),
        MemoryZone(id: 3, name: "Cipher", subtitle: "Complex patterns", icon: "lock.fill", accentHex: "FF6B6B", firstPuzzle: 60, puzzleCount: 20),
    ]

    static func zoneForPuzzle(_ p: Int) -> MemoryZone { all[min(p / 20, all.count - 1)] }
    static func localIndex(forPuzzle p: Int) -> Int { p % 20 }
}
