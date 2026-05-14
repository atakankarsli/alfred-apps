import Foundation
import SwiftData

@Model
final class AchievementRecord {
    @Attribute(.unique) var achievementId: String
    var unlockedAt: Date
    init(achievementId: String, unlockedAt: Date = .now) {
        self.achievementId = achievementId; self.unlockedAt = unlockedAt
    }
}
