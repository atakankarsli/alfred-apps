import Foundation
import SwiftData

@Model
final class LevelRecord {
    @Attribute(.unique) var levelIndex: Int
    var stars: Int
    var bestTime: Double
    var bestAccuracy: Double

    init(levelIndex: Int, stars: Int = 0, bestTime: Double = .infinity, bestAccuracy: Double = 0) {
        self.levelIndex = levelIndex
        self.stars = stars
        self.bestTime = bestTime
        self.bestAccuracy = bestAccuracy
    }
}
