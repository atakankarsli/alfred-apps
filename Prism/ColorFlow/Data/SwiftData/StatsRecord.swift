import Foundation
import SwiftData

@Model
final class StatsRecord {
    var puzzlesCompleted: Int
    var totalMoves: Int
    var threeStarCount: Int
    var currentStreak: Int
    var longestStreak: Int
    var lastPlayedDate: String?
    var bestMovesData: Data?
    var totalXP: Int
    var totalTimePlayed: Int
    var dailyPuzzlesCompleted: Int
    var hintsUsed: Int
    var undosUsed: Int
    var noHintCompletions: Int
    var streakFreezes: Int
    var themesUsedData: Data?

    init(
        puzzlesCompleted: Int = 0,
        totalMoves: Int = 0,
        threeStarCount: Int = 0,
        currentStreak: Int = 0,
        longestStreak: Int = 0,
        lastPlayedDate: String? = nil,
        bestMovesData: Data? = nil,
        totalXP: Int = 0,
        totalTimePlayed: Int = 0,
        dailyPuzzlesCompleted: Int = 0,
        hintsUsed: Int = 0,
        undosUsed: Int = 0,
        noHintCompletions: Int = 0,
        streakFreezes: Int = 0,
        themesUsedData: Data? = nil
    ) {
        self.puzzlesCompleted = puzzlesCompleted
        self.totalMoves = totalMoves
        self.threeStarCount = threeStarCount
        self.currentStreak = currentStreak
        self.longestStreak = longestStreak
        self.lastPlayedDate = lastPlayedDate
        self.bestMovesData = bestMovesData
        self.totalXP = totalXP
        self.totalTimePlayed = totalTimePlayed
        self.dailyPuzzlesCompleted = dailyPuzzlesCompleted
        self.hintsUsed = hintsUsed
        self.undosUsed = undosUsed
        self.noHintCompletions = noHintCompletions
        self.streakFreezes = streakFreezes
        self.themesUsedData = themesUsedData
    }

    var themesUsed: Set<String> {
        get {
            guard let data = themesUsedData else { return [] }
            return (try? JSONDecoder().decode(Set<String>.self, from: data)) ?? []
        }
        set {
            themesUsedData = try? JSONEncoder().encode(newValue)
        }
    }

    var bestMoves: [Int: Int] {
        get {
            guard let data = bestMovesData else { return [:] }
            return (try? JSONDecoder().decode([Int: Int].self, from: data)) ?? [:]
        }
        set {
            bestMovesData = try? JSONEncoder().encode(newValue)
        }
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
