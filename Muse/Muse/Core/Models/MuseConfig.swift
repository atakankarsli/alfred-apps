import Foundation

enum MuseConfig {
    static let totalChallenges = 80
    static let xpPerLevel: [Int] = [50, 150, 350, 700, 1200, 2000, 3200, 5000, 8000, 12000]

    static func starsForAccuracy(_ accuracy: Double) -> Int {
        if accuracy >= 0.85 { return 3 }
        if accuracy >= 0.60 { return 2 }
        if accuracy >= 0.30 { return 1 }
        return 0
    }

    static func xpForChallenge(stars: Int, seasonId: Int) -> Int {
        let base = stars * 12
        let seasonBonus = min(seasonId * 3, 12)
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
        ["Spark", "Doodler", "Sketcher", "Creator", "Artist",
         "Visionary", "Maestro", "Virtuoso", "Luminary", "Legend",
         "Muse"][min(level, 10)]
    }
}
