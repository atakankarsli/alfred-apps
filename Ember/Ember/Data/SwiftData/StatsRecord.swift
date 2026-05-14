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

    var hearthCompleted: Int
    var forgeCompleted: Int
    var volcanoCompleted: Int
    var auroraCompleted: Int
    var phoenixCompleted: Int

    var endlessBest: Int
    var dailyEmbersCompleted: Int
    var noMissCount: Int

    init(
        levelsCompleted: Int = 0, threeStarCount: Int = 0,
        currentStreak: Int = 0, longestStreak: Int = 0, lastPlayedDate: String? = nil,
        totalXP: Int = 0, totalTimePlayed: Int = 0,
        hearthCompleted: Int = 0, forgeCompleted: Int = 0,
        volcanoCompleted: Int = 0, auroraCompleted: Int = 0,
        phoenixCompleted: Int = 0,
        endlessBest: Int = 0, dailyEmbersCompleted: Int = 0,
        noMissCount: Int = 0
    ) {
        self.levelsCompleted = levelsCompleted
        self.threeStarCount = threeStarCount
        self.currentStreak = currentStreak
        self.longestStreak = longestStreak
        self.lastPlayedDate = lastPlayedDate
        self.totalXP = totalXP
        self.totalTimePlayed = totalTimePlayed
        self.hearthCompleted = hearthCompleted
        self.forgeCompleted = forgeCompleted
        self.volcanoCompleted = volcanoCompleted
        self.auroraCompleted = auroraCompleted
        self.phoenixCompleted = phoenixCompleted
        self.endlessBest = endlessBest
        self.dailyEmbersCompleted = dailyEmbersCompleted
        self.noMissCount = noMissCount
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

    func incrementRealm(_ realm: FireRealm) {
        switch realm {
        case .hearth: hearthCompleted += 1
        case .forge: forgeCompleted += 1
        case .volcano: volcanoCompleted += 1
        case .aurora: auroraCompleted += 1
        case .phoenix: phoenixCompleted += 1
        }
    }
}
