import Foundation
import SwiftData

@Model
final class StatsRecord {
    var levelsCompleted: Int
    var threeStarCount: Int
    var currentStreak: Int
    var longestStreak: Int
    var lastPlayedDate: String?
    var totalXP: Int
    var totalTimePlayed: Int

    var zodiacCompleted: Int
    var mythicalCompleted: Int
    var animalsCompleted: Int
    var ancientCompleted: Int
    var modernCompleted: Int

    var endlessBest: Int
    var dailyChallengesCompleted: Int
    var noHintCount: Int

    init(
        levelsCompleted: Int = 0, threeStarCount: Int = 0,
        currentStreak: Int = 0, longestStreak: Int = 0, lastPlayedDate: String? = nil,
        totalXP: Int = 0, totalTimePlayed: Int = 0,
        zodiacCompleted: Int = 0, mythicalCompleted: Int = 0,
        animalsCompleted: Int = 0, ancientCompleted: Int = 0,
        modernCompleted: Int = 0,
        endlessBest: Int = 0, dailyChallengesCompleted: Int = 0,
        noHintCount: Int = 0
    ) {
        self.levelsCompleted = levelsCompleted
        self.threeStarCount = threeStarCount
        self.currentStreak = currentStreak
        self.longestStreak = longestStreak
        self.lastPlayedDate = lastPlayedDate
        self.totalXP = totalXP
        self.totalTimePlayed = totalTimePlayed
        self.zodiacCompleted = zodiacCompleted
        self.mythicalCompleted = mythicalCompleted
        self.animalsCompleted = animalsCompleted
        self.ancientCompleted = ancientCompleted
        self.modernCompleted = modernCompleted
        self.endlessBest = endlessBest
        self.dailyChallengesCompleted = dailyChallengesCompleted
        self.noHintCount = noHintCount
    }

    func updateStreak() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = formatter.string(from: .now)
        guard lastPlayedDate != today else { return }

        if let last = lastPlayedDate,
           let lastDate = formatter.date(from: last),
           Calendar.current.isDateInYesterday(lastDate) {
            currentStreak += 1
        } else {
            currentStreak = 1
        }
        longestStreak = max(longestStreak, currentStreak)
        lastPlayedDate = today
    }

    func incrementRealm(_ realm: SkyRealm) {
        switch realm {
        case .zodiac: zodiacCompleted += 1
        case .mythical: mythicalCompleted += 1
        case .animals: animalsCompleted += 1
        case .ancient: ancientCompleted += 1
        case .modern: modernCompleted += 1
        }
    }
}
