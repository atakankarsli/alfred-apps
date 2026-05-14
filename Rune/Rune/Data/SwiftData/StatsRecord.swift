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

    var futharkCompleted: Int
    var hieroglyphCompleted: Int
    var cuneiformCompleted: Int
    var greekCompleted: Int
    var oghamCompleted: Int

    var endlessBest: Int
    var dailyScrollsCompleted: Int
    var noHintCount: Int

    init(
        levelsCompleted: Int = 0, threeStarCount: Int = 0,
        currentStreak: Int = 0, longestStreak: Int = 0, lastPlayedDate: String? = nil,
        totalXP: Int = 0, totalTimePlayed: Int = 0,
        futharkCompleted: Int = 0, hieroglyphCompleted: Int = 0,
        cuneiformCompleted: Int = 0, greekCompleted: Int = 0,
        oghamCompleted: Int = 0,
        endlessBest: Int = 0, dailyScrollsCompleted: Int = 0,
        noHintCount: Int = 0
    ) {
        self.levelsCompleted = levelsCompleted
        self.threeStarCount = threeStarCount
        self.currentStreak = currentStreak
        self.longestStreak = longestStreak
        self.lastPlayedDate = lastPlayedDate
        self.totalXP = totalXP
        self.totalTimePlayed = totalTimePlayed
        self.futharkCompleted = futharkCompleted
        self.hieroglyphCompleted = hieroglyphCompleted
        self.cuneiformCompleted = cuneiformCompleted
        self.greekCompleted = greekCompleted
        self.oghamCompleted = oghamCompleted
        self.endlessBest = endlessBest
        self.dailyScrollsCompleted = dailyScrollsCompleted
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

    func incrementRealm(_ realm: ScriptRealm) {
        switch realm {
        case .futhark: futharkCompleted += 1
        case .hieroglyph: hieroglyphCompleted += 1
        case .cuneiform: cuneiformCompleted += 1
        case .greek: greekCompleted += 1
        case .ogham: oghamCompleted += 1
        }
    }
}
