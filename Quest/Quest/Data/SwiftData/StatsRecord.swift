import Foundation
import SwiftData

@Model
final class StatsRecord {
    var missionsCompleted: Int = 0
    var objectivesCompleted: Int = 0
    var threeStarCount: Int = 0
    var currentStreak: Int = 0
    var longestStreak: Int = 0
    var lastPlayedDate: String?
    var bestStarsData: Data?
    var totalXP: Int = 0
    var totalTimePlayed: Int = 0
    var dailyMissionsCompleted: Int = 0
    var typesUsedData: Data?
    var regionsPlayedData: Data?
    var fogCellsCleared: Int = 0

    var bestStars: [Int: Int] {
        get { (try? bestStarsData.flatMap { try JSONDecoder().decode([Int: Int].self, from: $0) }) ?? [:] }
        set { bestStarsData = try? JSONEncoder().encode(newValue) }
    }
    var typesUsed: Set<String> {
        get { (try? typesUsedData.flatMap { try JSONDecoder().decode(Set<String>.self, from: $0) }) ?? [] }
        set { typesUsedData = try? JSONEncoder().encode(newValue) }
    }
    var regionsPlayed: Set<String> {
        get { (try? regionsPlayedData.flatMap { try JSONDecoder().decode(Set<String>.self, from: $0) }) ?? [] }
        set { regionsPlayedData = try? JSONEncoder().encode(newValue) }
    }

    var totalObjectivesCompleted: Int = 0

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
