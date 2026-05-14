import Foundation

enum NexusConfig {
    static let totalLevels = 80
    static let wordsPerPuzzle = 12
    static let wordsPerCluster = 4
    static let clustersPerPuzzle = 3
    static let maxMistakes = 4
    static let xpPerLevel: [Int] = [100, 250, 500, 1000, 2000, 3500, 5500, 8000, 12000, 18000]

    static func starsForMistakes(_ mistakes: Int) -> Int {
        if mistakes == 0 { return 3 }
        if mistakes == 1 { return 2 }
        return 1
    }

    static func xpForPuzzle(stars: Int, world: Int) -> Int {
        let base = stars * 10
        let worldBonus = world * 5
        return base + worldBonus
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
        ["Novice", "Reader", "Thinker", "Scholar", "Analyst",
         "Strategist", "Sage", "Luminary", "Oracle", "Nexus Master",
         "Transcendent"][min(level, 10)]
    }
}
