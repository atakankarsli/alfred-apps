import Foundation
import SwiftData

@Model
final class SettingsRecord {
    var currentTheme: String
    var soundEffects: Bool
    var haptics: Bool
    var hasSeenOnboarding: Bool

    init(currentTheme: String = "ember", soundEffects: Bool = true, haptics: Bool = true, hasSeenOnboarding: Bool = false) {
        self.currentTheme = currentTheme
        self.soundEffects = soundEffects
        self.haptics = haptics
        self.hasSeenOnboarding = hasSeenOnboarding
    }
}
