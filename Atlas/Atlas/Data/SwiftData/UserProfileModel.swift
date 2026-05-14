import Foundation
import SwiftData

@Model
final class UserProfileModel {
    var totalXP: Int = 0
    var currentStreak: Int = 0
    var bestStreak: Int = 0
    var lastPlayedDate: Date?
    var totalQuizzes: Int = 0
    var perfectQuizzes: Int = 0
    var selectedThemeId: String = "atlas"
    var soundEnabled: Bool = true
    var hapticsEnabled: Bool = true
    var notificationHour: Int = 9
    var onboardingDone: Bool = false
    var quizCounts: [String: Int] = [:]

    init() {}

    var level: Int { AtlasConfig.level(forXP: totalXP) }
    var title: String { AtlasConfig.title(forXP: totalXP) }
    var xpProgress: Double { AtlasConfig.xpProgress(forXP: totalXP) }

    func quizCount(for type: QuizType) -> Int { quizCounts[type.rawValue] ?? 0 }
    func typesPlayed() -> Set<String> { Set(quizCounts.keys.filter { (quizCounts[$0] ?? 0) > 0 }) }

    func updateStreak() {
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        guard let last = lastPlayedDate else {
            currentStreak = 1; bestStreak = max(bestStreak, 1); lastPlayedDate = today; return
        }
        let lastDay = cal.startOfDay(for: last)
        if lastDay == today { return }
        if cal.dateComponents([.day], from: lastDay, to: today).day == 1 {
            currentStreak += 1
        } else {
            currentStreak = 1
        }
        bestStreak = max(bestStreak, currentStreak)
        lastPlayedDate = today
    }
}
