import Foundation
import UserNotifications

@MainActor
enum NotificationService {
    static func requestPermission() async -> Bool {
        do { return try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) }
        catch { return false }
    }

    static func scheduleDailyReminder(hour: Int, minute: Int) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["daily_locus"])
        let content = UNMutableNotificationContent()
        content.title = "Locus"
        content.body = "Visit your memory palace today"
        content.sound = .default
        var date = DateComponents(); date.hour = hour; date.minute = minute
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        center.add(UNNotificationRequest(identifier: "daily_locus", content: content, trigger: trigger))
    }

    static func cancelAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
