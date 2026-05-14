import UserNotifications

enum NotificationService {
    static func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }
    }
    static func scheduleDailyReminder(hour: Int) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["flux_daily"])
        let content = UNMutableNotificationContent()
        content.title = "Your Daily Flow Awaits"
        content.body = "New colors and patterns to explore!"
        content.sound = .default
        var date = DateComponents(); date.hour = hour
        center.add(UNNotificationRequest(identifier: "flux_daily", content: content,
                                          trigger: UNCalendarNotificationTrigger(dateMatching: date, repeats: true)))
    }
}
