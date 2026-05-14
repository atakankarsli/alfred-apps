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

    var prismsCompleted: Int
    var polygonsCompleted: Int
    var fractalsCompleted: Int
    var symmetryCompleted: Int
    var chaosCompleted: Int

    var endlessBest: Int
    var dailyMorphsCompleted: Int
    var minMovesCount: Int

    init(
        levelsCompleted: Int = 0, threeStarCount: Int = 0,
        currentStreak: Int = 0, longestStreak: Int = 0, lastPlayedDate: String? = nil,
        totalXP: Int = 0, totalTimePlayed: Int = 0,
        prismsCompleted: Int = 0, polygonsCompleted: Int = 0,
        fractalsCompleted: Int = 0, symmetryCompleted: Int = 0,
        chaosCompleted: Int = 0,
        endlessBest: Int = 0, dailyMorphsCompleted: Int = 0,
        minMovesCount: Int = 0
    ) {
        self.levelsCompleted = levelsCompleted
        self.threeStarCount = threeStarCount
        self.currentStreak = currentStreak
        self.longestStreak = longestStreak
        self.lastPlayedDate = lastPlayedDate
        self.totalXP = totalXP
        self.totalTimePlayed = totalTimePlayed
        self.prismsCompleted = prismsCompleted
        self.polygonsCompleted = polygonsCompleted
        self.fractalsCompleted = fractalsCompleted
        self.symmetryCompleted = symmetryCompleted
        self.chaosCompleted = chaosCompleted
        self.endlessBest = endlessBest
        self.dailyMorphsCompleted = dailyMorphsCompleted
        self.minMovesCount = minMovesCount
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

    func incrementRealm(_ realm: ShapeRealm) {
        switch realm {
        case .prisms: prismsCompleted += 1
        case .polygons: polygonsCompleted += 1
        case .fractals: fractalsCompleted += 1
        case .symmetry: symmetryCompleted += 1
        case .chaos: chaosCompleted += 1
        }
    }
}
