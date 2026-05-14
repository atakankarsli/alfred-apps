import Foundation

enum VitalConfig {
    static let totalLevels = 80
    static let xpPerLevel: [Int] = [40, 120, 280, 550, 1000, 1700, 2800, 4500, 7000, 10000]

    static func starsForScore(_ ratio: Double) -> Int {
        if ratio >= 0.90 { return 3 }
        if ratio >= 0.65 { return 2 }
        if ratio >= 0.35 { return 1 }
        return 0
    }

    static func xpForGame(stars: Int, level: Int) -> Int {
        let base = stars * 12
        let levelBonus = min(level / 10, 8) * 3
        return base + levelBonus + 5
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
        ["Beginner", "Starter", "Active", "Focused", "Balanced",
         "Strong", "Resilient", "Vital", "Champion", "Legend",
         "Transcendent"][min(level, 10)]
    }

    static let dailyGameCount = 4
}
