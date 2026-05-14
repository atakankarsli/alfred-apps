import Foundation

enum VoltConfig {
    static let totalPuzzles = 80
    static let xpPerLevel: [Int] = [40, 120, 280, 550, 1000, 1700, 2800, 4500, 7000, 10000]

    static func starsForSolution(componentCount: Int, optimalCount: Int) -> Int {
        if componentCount <= optimalCount { return 3 }
        if componentCount <= optimalCount + 2 { return 2 }
        return 1
    }

    static func xpForPuzzle(stars: Int, seasonId: Int) -> Int {
        let base = stars * 15
        let seasonBonus = min(seasonId * 5, 20)
        return base + seasonBonus + 5
    }

    static func levelForXP(_ xp: Int) -> Int {
        for (i, threshold) in xpPerLevel.enumerated() {
            if xp < threshold { return i }
        }
        return xpPerLevel.count
    }

    static func xpProgressInLevel(_ xp: Int) -> Double {
        let level = levelForXP(xp)
        if level >= xpPerLevel.count { return 1.0 }
        let prev = level > 0 ? xpPerLevel[level - 1] : 0
        let next = xpPerLevel[level]
        return Double(xp - prev) / Double(next - prev)
    }

    static func xpLevelTitle(_ level: Int) -> String {
        ["Novice", "Tinkerer", "Builder", "Technician", "Engineer",
         "Architect", "Inventor", "Mastermind", "Genius", "Legend",
         "Circuit Sage"][min(level, 10)]
    }

    static func gridSizeForSeason(_ seasonId: Int) -> Int {
        [4, 5, 5, 6, 6][min(seasonId, 4)]
    }
}
