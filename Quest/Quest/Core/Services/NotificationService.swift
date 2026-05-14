import UserNotifications

enum NotificationService {
    static func requestPermission() async -> Bool {
        (try? await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound])) ?? false
    }

    static func scheduleDailyReminder(hour: Int, minute: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Quest Awaits!"
        content.body = "A new daily mission is ready. Go explore!"
        content.sound = .default
        var c = DateComponents(); c.hour = hour; c.minute = minute
        let req = UNNotificationRequest(identifier: "quest_daily", content: content, trigger: UNCalendarNotificationTrigger(dateMatching: c, repeats: true))
        UNUserNotificationCenter.current().add(req)
    }

    static func cancelAll() { UNUserNotificationCenter.current().removeAllPendingNotificationRequests() }
}
