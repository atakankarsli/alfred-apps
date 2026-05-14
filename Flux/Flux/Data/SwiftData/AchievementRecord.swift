import SwiftData
import Foundation

@Model final class AchievementRecord {
    @Attribute(.unique) var id: String
    var unlockedAt: Date
    init(id: String, unlockedAt: Date = .now) { self.id = id; self.unlockedAt = unlockedAt }
}
