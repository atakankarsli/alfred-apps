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

    var tonesCompleted: Int
    var melodyCompleted: Int
    var rhythmCompleted: Int
    var harmonyCompleted: Int
    var chaosCompleted: Int

    var endlessBest: Int
    var dailyEchoesCompleted: Int
    var noReplayCount: Int

    init(
        levelsCompleted: Int = 0, threeStarCount: Int = 0,
        currentStreak: Int = 0, longestStreak: Int = 0, lastPlayedDate: String? = nil,
        totalXP: Int = 0, totalTimePlayed: Int = 0,
        tonesCompleted: Int = 0, melodyCompleted: Int = 0,
        rhythmCompleted: Int = 0, harmonyCompleted: Int = 0,
        chaosCompleted: Int = 0,
        endlessBest: Int = 0, dailyEchoesCompleted: Int = 0,
        noReplayCount: Int = 0
    ) {
        self.levelsCompleted = levelsCompleted
        self.threeStarCount = threeStarCount
        self.currentStreak = currentStreak
        self.longestStreak = longestStreak
        self.lastPlayedDate = lastPlayedDate
        self.totalXP = totalXP
        self.totalTimePlayed = totalTimePlayed
        self.tonesCompleted = tonesCompleted
        self.melodyCompleted = melodyCompleted
        self.rhythmCompleted = rhythmCompleted
        self.harmonyCompleted = harmonyCompleted
        self.chaosCompleted = chaosCompleted
        self.endlessBest = endlessBest
        self.dailyEchoesCompleted = dailyEchoesCompleted
        self.noReplayCount = noReplayCount
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

    func incrementRealm(_ realm: SonicRealm) {
        switch realm {
        case .tones: tonesCompleted += 1
        case .melody: melodyCompleted += 1
        case .rhythm: rhythmCompleted += 1
        case .harmony: harmonyCompleted += 1
        case .chaos: chaosCompleted += 1
        }
    }
}
