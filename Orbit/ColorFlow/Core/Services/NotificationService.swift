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
        content.title = "Orbit"
        content.body = "Your daily gravity mission awaits."
        content.sound = .default
        var dc = DateComponents(); dc.hour = hour; dc.minute = minute
        let trigger = UNCalendarNotificationTrigger(dateMatching: dc, repeats: true)
        center.add(UNNotificationRequest(identifier: "daily_reminder", content: content, trigger: trigger))
    }

    static func scheduleStreakReminder(currentStreak: Int) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["streak_reminder"])
        guard currentStreak > 0 else { return }
        let content = UNMutableNotificationContent()
        content.title = "Streak at risk!"
        content.body = "Don't lose your \(currentStreak)-day streak. Launch today."
        content.sound = .default
        var dc = DateComponents(); dc.hour = 21; dc.minute = 0
        center.add(UNNotificationRequest(identifier: "streak_reminder", content: content, trigger: UNCalendarNotificationTrigger(dateMatching: dc, repeats: false)))
    }

    static func cancelAll() { UNUserNotificationCenter.current().removeAllPendingNotificationRequests() }
}
