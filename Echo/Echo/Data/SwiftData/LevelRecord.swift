import Foundation
import SwiftData

@Model
final class LevelRecord {
    @Attribute(.unique) var levelIndex: Int
    var stars: Int
    var bestScore: Double
    var completedAt: Date

    init(levelIndex: Int, stars: Int, bestScore: Double, completedAt: Date = .now) {
        self.levelIndex = levelIndex
        self.stars = stars
        self.bestScore = bestScore
        self.completedAt = completedAt
    }
}
