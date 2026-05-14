import Foundation
import SwiftData

@Model
final class SettingsRecord {
    var soundEffects: Bool
    var haptics: Bool
    var currentTheme: String
    var hasSeenOnboarding: Bool
    var highestUnlockedLevel: Int
    var showTimer: Bool
    var dailyReminderEnabled: Bool
    var dailyReminderHour: Int
    var dailyReminderMinute: Int
    var currentLevelIndex: Int

    init(
        soundEffects: Bool = true,
        haptics: Bool = true,
        currentTheme: String = "parchment",
        hasSeenOnboarding: Bool = false,
        highestUnlockedLevel: Int = 0,
        showTimer: Bool = true,
        dailyReminderEnabled: Bool = false,
        dailyReminderHour: Int = 19,
        dailyReminderMinute: Int = 0,
        currentLevelIndex: Int = 0
    ) {
        self.soundEffects = soundEffects
        self.haptics = haptics
        self.currentTheme = currentTheme
        self.hasSeenOnboarding = hasSeenOnboarding
        self.highestUnlockedLevel = highestUnlockedLevel
        self.showTimer = showTimer
        self.dailyReminderEnabled = dailyReminderEnabled
        self.dailyReminderHour = dailyReminderHour
        self.dailyReminderMinute = dailyReminderMinute
        self.currentLevelIndex = currentLevelIndex
    }
}
