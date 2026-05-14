import Foundation

enum TidalConfig {
    static let totalLevels = 80
    static let levelsPerWorld = 16
    static let xpPerLevel: [Int] = [50, 150, 350, 700, 1200, 2000, 3200, 5000, 8000, 12000]

    static func starsForAccuracy(_ accuracy: Double) -> Int {
        if accuracy >= 0.85 { return 3 }
        if accuracy >= 0.60 { return 2 }
        if accuracy >= 0.30 { return 1 }
        return 0
    }

    static func xpForLevel(stars: Int, worldIndex: Int) -> Int {
        let base = stars * 15
        let worldBonus = worldIndex * 3
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

    static func levelTitle(_ level: Int) -> String {
        ["Droplet", "Ripple", "Current", "Tide", "Surge",
         "Tsunami", "Maelstrom", "Leviathan", "Poseidon", "Oceanus",
         "Eternal"][min(level, 10)]
    }
}
