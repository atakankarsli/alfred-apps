import Foundation
import SwiftData

@Model
final class SettingsRecord {
    var soundEffects: Bool
    var haptics: Bool
    var currentTheme: String
    var hasSeenOnboarding: Bool

    init(
        soundEffects: Bool = true,
        haptics: Bool = true,
        currentTheme: String = "papyrus",
        hasSeenOnboarding: Bool = false
    ) {
        self.soundEffects = soundEffects
        self.haptics = haptics
        self.currentTheme = currentTheme
        self.hasSeenOnboarding = hasSeenOnboarding
    }
}
