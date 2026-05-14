import Foundation
import SwiftData

@Model
final class StatsRecord {
    var poemsCompleted: Int
    var threeStarCount: Int
    var currentStreak: Int
    var longestStreak: Int
    var lastPlayedDate: String?
    var bestStarsData: Data?
    var totalXP: Int
    var totalTimePlayed: Int
    var dailyPoemsCompleted: Int

    init(
        poemsCompleted: Int = 0,
        threeStarCount: Int = 0,
        currentStreak: Int = 0,
        longestStreak: Int = 0,
        lastPlayedDate: String? = nil,
        bestStarsData: Data? = nil,
        totalXP: Int = 0,
        totalTimePlayed: Int = 0,
        dailyPoemsCompleted: Int = 0
    ) {
        self.poemsCompleted = poemsCompleted
        self.threeStarCount = threeStarCount
        self.currentStreak = currentStreak
        self.longestStreak = longestStreak
        self.lastPlayedDate = lastPlayedDate
        self.bestStarsData = bestStarsData
        self.totalXP = totalXP
        self.totalTimePlayed = totalTimePlayed
        self.dailyPoemsCompleted = dailyPoemsCompleted
    }

    var bestStars: [Int: Int] {
        get {
            guard let data = bestStarsData else { return [:] }
            return (try? JSONDecoder().decode([Int: Int].self, from: data)) ?? [:]
        }
        set { bestStarsData = try? JSONEncoder().encode(newValue) }
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
}
