import Foundation
import SwiftData

@Model
final class SettingsRecord {
    var soundEffects: Bool
    var haptics: Bool
    var currentTheme: String
    var hasSeenOnboarding: Bool
    var dailyReminderEnabled: Bool
    var dailyReminderHour: Int
    var dailyReminderMinute: Int

    init(
        soundEffects: Bool = true,
        haptics: Bool = true,
        currentTheme: String = "deepocean",
        hasSeenOnboarding: Bool = false,
        dailyReminderEnabled: Bool = false,
        dailyReminderHour: Int = 9,
        dailyReminderMinute: Int = 0
    ) {
        self.soundEffects = soundEffects
        self.haptics = haptics
        self.currentTheme = currentTheme
        self.hasSeenOnboarding = hasSeenOnboarding
        self.dailyReminderEnabled = dailyReminderEnabled
        self.dailyReminderHour = dailyReminderHour
        self.dailyReminderMinute = dailyReminderMinute
    }
}
