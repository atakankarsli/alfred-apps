import SwiftData

@Model final class SettingsRecord {
    @Attribute(.unique) var key: String
    var themeId: String
    var soundEnabled: Bool
    var hapticsEnabled: Bool
    var notificationsEnabled: Bool
    var reminderHour: Int
    var onboardingDone: Bool

    init(key: String = "main", themeId: String = "liquid", soundEnabled: Bool = true,
         hapticsEnabled: Bool = true, notificationsEnabled: Bool = true,
         reminderHour: Int = 8, onboardingDone: Bool = false) {
        self.key = key; self.themeId = themeId; self.soundEnabled = soundEnabled
        self.hapticsEnabled = hapticsEnabled; self.notificationsEnabled = notificationsEnabled
        self.reminderHour = reminderHour; self.onboardingDone = onboardingDone
    }
}
