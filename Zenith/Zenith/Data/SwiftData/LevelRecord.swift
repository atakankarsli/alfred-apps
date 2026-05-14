import Foundation
import SwiftData

@Model
final class LevelRecord {
    @Attribute(.unique) var levelIndex: Int
    var stars: Int
    var bestTime: Double
    var hintsUsed: Int
    var completedAt: Date

    init(levelIndex: Int, stars: Int, bestTime: Double, hintsUsed: Int = 0, completedAt: Date = .now) {
        self.levelIndex = levelIndex
        self.stars = stars
        self.bestTime = bestTime
        self.hintsUsed = hintsUsed
        self.completedAt = completedAt
    }
}
