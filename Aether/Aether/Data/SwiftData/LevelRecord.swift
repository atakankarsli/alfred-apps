import SwiftData
import Foundation

@Model
final class LevelRecord {
    @Attribute(.unique) var levelIndex: Int = 0
    var stars: Int = 0
    var moves: Int = 0
    var bestMoves: Int = 999
    var elementsFound: Int = 0
    var completedAt: Date?
    var hintsUsed: Int = 0

    init() {}

    init(levelIndex: Int, stars: Int, moves: Int, elementsFound: Int, hintsUsed: Int) {
        self.levelIndex = levelIndex
        self.stars = stars
        self.moves = moves
        self.bestMoves = moves
        self.elementsFound = elementsFound
        self.completedAt = Date()
        self.hintsUsed = hintsUsed
    }
}
