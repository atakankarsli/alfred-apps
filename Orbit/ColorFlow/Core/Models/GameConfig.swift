import Foundation

enum OrbitConfig {
    static let totalLevels = 80
    static let gridSize = 8
    static let simSteps = 300
    static let xpPerLevel: [Int] = [100, 250, 500, 1000, 2000, 3500, 5500, 8000, 12000, 18000]

    static func starsForAccuracy(_ accuracy: Double) -> Int {
        if accuracy >= 0.90 { return 3 }
        if accuracy >= 0.70 { return 2 }
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
        ["Cadet", "Pilot", "Navigator", "Captain", "Commander",
         "Admiral", "Voyager", "Pioneer", "Starforger", "Cosmic Architect",
         "Eternal"][min(level, 10)]
    }
}
