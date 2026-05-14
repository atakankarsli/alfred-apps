import SwiftData
import Foundation

@Model
final class AchievementRecord {
    @Attribute(.unique) var achievementId: String = ""
    var unlockedAt: Date = Date()

    init() {}

    init(achievementId: String) {
        self.achievementId = achievementId
        self.unlockedAt = Date()
    }
}
