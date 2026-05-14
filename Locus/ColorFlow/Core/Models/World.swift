import SwiftUI

struct Palace: Identifiable {
    let id: Int; let name: String; let subtitle: String; let icon: String; let accentHex: String; let firstPuzzle: Int; let puzzleCount: Int
    var puzzleRange: Range<Int> { firstPuzzle..<(firstPuzzle + puzzleCount) }

    static let all: [Palace] = [
        Palace(id: 0, name: "Study", subtitle: "Books & scrolls", icon: "book.fill", accentHex: "5BC0EB", firstPuzzle: 0, puzzleCount: 20),
        Palace(id: 1, name: "Kitchen", subtitle: "Tools & ingredients", icon: "fork.knife", accentHex: "FFA62B", firstPuzzle: 20, puzzleCount: 20),
        Palace(id: 2, name: "Garden", subtitle: "Nature & growth", icon: "leaf.fill", accentHex: "4ECB71", firstPuzzle: 40, puzzleCount: 20),
        Palace(id: 3, name: "Vault", subtitle: "Treasures & secrets", icon: "lock.shield.fill", accentHex: "9B5DE5", firstPuzzle: 60, puzzleCount: 20),
    ]

    static func palaceForPuzzle(_ p: Int) -> Palace { all[min(p / 20, all.count - 1)] }
    static func localIndex(forPuzzle p: Int) -> Int { p % 20 }
}
