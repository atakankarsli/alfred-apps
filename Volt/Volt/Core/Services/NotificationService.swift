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
        content.title = "Volt"; content.body = "Today's circuit puzzle is waiting."; content.sound = .default
        var dc = DateComponents(); dc.hour = hour; dc.minute = minute
        center.add(UNNotificationRequest(identifier: "daily_reminder", content: content, trigger: UNCalendarNotificationTrigger(dateMatching: dc, repeats: true)))
    }

    static func cancelAll() { UNUserNotificationCenter.current().removeAllPendingNotificationRequests() }
}
