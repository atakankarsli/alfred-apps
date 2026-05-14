import Foundation
import SwiftData

@Model
final class StatsRecord {
    var puzzlesCompleted: Int = 0
    var totalXP: Int = 0
    var threeStarCount: Int = 0
    var currentStreak: Int = 0
    var longestStreak: Int = 0
    var lastPlayedDate: String?
    var totalTimePlayed: Int = 0
    var sandboxBuilds: Int = 0
    var hintsUsed: Int = 0
    var puzzlesWithoutHints: Int = 0
    var fastestSolveTime: Int = 0

    var componentsUsedData: Data?
    var seasonsPlayedData: Data?

    var componentsUsed: Set<String> {
        get { (try? componentsUsedData.flatMap { try JSONDecoder().decode(Set<String>.self, from: $0) }) ?? [] }
        set { componentsUsedData = try? JSONEncoder().encode(newValue) }
    }

    var seasonsPlayed: Set<String> {
        get { (try? seasonsPlayedData.flatMap { try JSONDecoder().decode(Set<String>.self, from: $0) }) ?? [] }
        set { seasonsPlayedData = try? JSONEncoder().encode(newValue) }
    }

    init() {}

    func updateStreak() {
        let fmt = DateFormatter(); fmt.dateFormat = "yyyy-MM-dd"
        let today = fmt.string(from: .now)
        guard lastPlayedDate != today else { return }
        if let last = lastPlayedDate, let d = fmt.date(from: last), Calendar.current.isDateInYesterday(d) {
            currentStreak += 1
        } else { currentStreak = 1 }
        longestStreak = max(longestStreak, currentStreak)
        lastPlayedDate = today
    }
}
