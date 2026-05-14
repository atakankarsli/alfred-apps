import Foundation
import SwiftData

@Model
final class StatsRecord {
    var gamesCompleted: Int = 0
    var totalXP: Int = 0
    var threeStarCount: Int = 0
    var currentStreak: Int = 0
    var longestStreak: Int = 0
    var lastPlayedDate: String?
    var totalTimePlayed: Int = 0
    var dailyPlansCompleted: Int = 0
    var bestScoresData: Data?
    var typesPlayedData: Data?

    var eyeFocusGames: Int = 0
    var breathSyncGames: Int = 0
    var reflexRushGames: Int = 0
    var postureCheckGames: Int = 0
    var bestReflexTime: Double = 0
    var totalBreathCycles: Int = 0

    var bestScores: [Int: Int] {
        get { (try? bestScoresData.flatMap { try JSONDecoder().decode([Int: Int].self, from: $0) }) ?? [:] }
        set { bestScoresData = try? JSONEncoder().encode(newValue) }
    }
    var typesPlayed: Set<String> {
        get { (try? typesPlayedData.flatMap { try JSONDecoder().decode(Set<String>.self, from: $0) }) ?? [] }
        set { typesPlayedData = try? JSONEncoder().encode(newValue) }
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
