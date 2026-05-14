import SwiftData
import Foundation

@Model
final class SettingsRecord {
    var hasSeenOnboarding: Bool = false
    var selectedThemeId: String = "helix"
    var hapticsEnabled: Bool = true
    var soundEnabled: Bool = true
    var createdAt: Date = Date()

    init() {}
}
