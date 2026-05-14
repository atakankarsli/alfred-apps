import Foundation
import SwiftData

@Model
final class SettingsRecord {
    var soundEffects: Bool
    var haptics: Bool
    var currentTheme: String
    var hasSeenOnboarding: Bool
    var highestUnlockedLevel: Int
    var currentLevelIndex: Int
    var dailyReminderEnabled: Bool
    var dailyReminderHour: Int
    var dailyReminderMinute: Int

    init(soundEffects: Bool = true, haptics: Bool = true, currentTheme: String = "vitality",
         hasSeenOnboarding: Bool = false, highestUnlockedLevel: Int = 0, currentLevelIndex: Int = 0,
         dailyReminderEnabled: Bool = false, dailyReminderHour: Int = 9, dailyReminderMinute: Int = 0) {
        self.soundEffects = soundEffects; self.haptics = haptics; self.currentTheme = currentTheme
        self.hasSeenOnboarding = hasSeenOnboarding; self.highestUnlockedLevel = highestUnlockedLevel
        self.currentLevelIndex = currentLevelIndex; self.dailyReminderEnabled = dailyReminderEnabled
        self.dailyReminderHour = dailyReminderHour; self.dailyReminderMinute = dailyReminderMinute
    }
}
