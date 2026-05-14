import Foundation
import SwiftData

@Model
final class SettingsRecord {
    var soundEffects: Bool
    var haptics: Bool
    var currentTheme: String
    var hasSeenOnboarding: Bool
    var highestUnlockedLevel: Int
    var showGuides: Bool
    var dailyReminderEnabled: Bool
    var dailyReminderHour: Int
    var dailyReminderMinute: Int
    var currentLevelIndex: Int

    init(
        soundEffects: Bool = true,
        haptics: Bool = true,
        currentTheme: String = "runestone",
        hasSeenOnboarding: Bool = false,
        highestUnlockedLevel: Int = 0,
        showGuides: Bool = true,
        dailyReminderEnabled: Bool = false,
        dailyReminderHour: Int = 10,
        dailyReminderMinute: Int = 0,
        currentLevelIndex: Int = 0
    ) {
        self.soundEffects = soundEffects
        self.haptics = haptics
        self.currentTheme = currentTheme
        self.hasSeenOnboarding = hasSeenOnboarding
        self.highestUnlockedLevel = highestUnlockedLevel
        self.showGuides = showGuides
        self.dailyReminderEnabled = dailyReminderEnabled
        self.dailyReminderHour = dailyReminderHour
        self.dailyReminderMinute = dailyReminderMinute
        self.currentLevelIndex = currentLevelIndex
    }
}
