import Foundation
import SwiftData

@Model
final class AchievementRecordModel {
    @Attribute(.unique) var achievementId: String = ""
    var unlockedDate: Date = Date()

    init() {}

    init(achievementId: String) {
        self.achievementId = achievementId
        self.unlockedDate = Date()
    }
}
