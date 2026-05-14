import Foundation
import SwiftData

@Model
final class StatsRecord {
    var tracksCompleted: Int
    var totalHits: Int
    var perfectHits: Int
    var greatHits: Int
    var goodHits: Int
    var missedHits: Int
    var threeStarCount: Int
    var currentStreak: Int
    var longestStreak: Int
    var lastPlayedDate: String?
    var bestStarsData: Data?
    var totalXP: Int
    var totalTimePlayed: Int
    var dailyTracksCompleted: Int
    var maxCombo: Int
    var totalCombo: Int
    var seasonsPlayedData: Data?

    init(
        tracksCompleted: Int = 0,
        totalHits: Int = 0,
        perfectHits: Int = 0,
        greatHits: Int = 0,
        goodHits: Int = 0,
        missedHits: Int = 0,
        threeStarCount: Int = 0,
        currentStreak: Int = 0,
        longestStreak: Int = 0,
        lastPlayedDate: String? = nil,
        bestStarsData: Data? = nil,
        totalXP: Int = 0,
        totalTimePlayed: Int = 0,
        dailyTracksCompleted: Int = 0,
        maxCombo: Int = 0,
        totalCombo: Int = 0,
        seasonsPlayedData: Data? = nil
    ) {
        self.tracksCompleted = tracksCompleted
        self.totalHits = totalHits
        self.perfectHits = perfectHits
        self.greatHits = greatHits
        self.goodHits = goodHits
        self.missedHits = missedHits
        self.threeStarCount = threeStarCount
        self.currentStreak = currentStreak
        self.longestStreak = longestStreak
        self.lastPlayedDate = lastPlayedDate
        self.bestStarsData = bestStarsData
        self.totalXP = totalXP
        self.totalTimePlayed = totalTimePlayed
        self.dailyTracksCompleted = dailyTracksCompleted
        self.maxCombo = maxCombo
        self.totalCombo = totalCombo
        self.seasonsPlayedData = seasonsPlayedData
    }

    var bestStars: [Int: Int] {
        get {
            guard let data = bestStarsData else { return [:] }
            return (try? JSONDecoder().decode([Int: Int].self, from: data)) ?? [:]
        }
        set { bestStarsData = try? JSONEncoder().encode(newValue) }
    }

    var seasonsPlayed: Set<Int> {
        get {
            guard let data = seasonsPlayedData else { return [] }
            return (try? JSONDecoder().decode(Set<Int>.self, from: data)) ?? []
        }
        set { seasonsPlayedData = try? JSONEncoder().encode(newValue) }
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
