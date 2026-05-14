import Foundation
import UserNotifications

@MainActor
enum NotificationService {
    static func requestPermission() async -> Bool {
        do { return try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) }
        catch { return false }
    }

    static func scheduleDailyReminder(hour: Int = 19, minute: Int = 0) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["daily_reminder"])

        let content = UNMutableNotificationContent()
        content.title = "Shard"
        content.body = "Your crystals are waiting to grow."
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = hour; dateComponents.minute = minute
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        center.add(UNNotificationRequest(identifier: "daily_reminder", content: content, trigger: trigger))
    }

    static func scheduleStreakReminder(currentStreak: Int) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["streak_reminder"])
        guard currentStreak > 0 else { return }

        let content = UNMutableNotificationContent()
        content.title = "Streak at risk!"
        content.body = "Don't lose your \(currentStreak)-day streak. Grow a crystal today."
        content.sound = .default

        var dateComponents = DateComponents()
        dateComponents.hour = 21; dateComponents.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        center.add(UNNotificationRequest(identifier: "streak_reminder", content: content, trigger: trigger))
    }

    static func cancelAll() { UNUserNotificationCenter.current().removeAllPendingNotificationRequests() }
}
