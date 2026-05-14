import UserNotifications

enum NotificationService {
    static func requestPermission() { UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in } }
    static func scheduleDailyReminder(hour: Int) {
        let c = UNUserNotificationCenter.current(); c.removePendingNotificationRequests(withIdentifiers: ["atlas_daily"])
        let content = UNMutableNotificationContent(); content.title = "Daily Quiz Ready"; content.body = "Test your world knowledge!"; content.sound = .default
        var d = DateComponents(); d.hour = hour
        c.add(UNNotificationRequest(identifier: "atlas_daily", content: content, trigger: UNCalendarNotificationTrigger(dateMatching: d, repeats: true)))
    }
}
