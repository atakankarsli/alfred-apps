import Foundation

enum ImprintConfig {
    static let totalPuzzles = 80
    static let puzzlesPerMoment = 20

    static let xpPerLevel = [0, 100, 250, 500, 850, 1300, 1900, 2700, 3800, 5200]

    static let xpLevelTitles = [
        "Beginner", "Watcher", "Recorder", "Collector", "Curator",
        "Archivist", "Chronicler", "Historian", "Keeper", "Transcendent"
    ]

    static func starsForAccuracy(_ accuracy: Double) -> Int {
        if accuracy >= 0.95 { return 3 }
        if accuracy >= 0.80 { return 2 }
        if accuracy >= 0.60 { return 1 }
        return 0
    }

    static func xpForPuzzle(accuracy: Double, level: Int) -> Int {
        let base = 10 + level / 4
        let stars = starsForAccuracy(accuracy)
        return base * max(stars, 1)
    }

    static func levelForXP(_ xp: Int) -> Int {
        for i in stride(from: xpPerLevel.count - 1, through: 0, by: -1) {
            if xp >= xpPerLevel[i] { return i }
        }
        return 0
    }

    static func xpProgressInLevel(_ xp: Int) -> Double {
        let level = levelForXP(xp)
        if level >= xpPerLevel.count - 1 { return 1.0 }
        let current = xp - xpPerLevel[level]
        let needed = xpPerLevel[level + 1] - xpPerLevel[level]
        return Double(current) / Double(needed)
    }

    static func xpLevelTitle(_ level: Int) -> String {
        guard level < xpLevelTitles.count else { return xpLevelTitles.last ?? "" }
        return xpLevelTitles[level]
    }
}
