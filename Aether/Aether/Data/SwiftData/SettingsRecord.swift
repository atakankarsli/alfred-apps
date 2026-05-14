import SwiftData
import Foundation

@Model
final class SettingsRecord {
    var hasSeenOnboarding: Bool = false
    var selectedThemeId: String = "aether"
    var hapticsEnabled: Bool = true
    var soundEnabled: Bool = true
    var createdAt: Date = Date()

    init() {}
}
