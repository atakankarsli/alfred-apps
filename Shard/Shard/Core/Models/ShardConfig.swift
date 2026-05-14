import Foundation

enum ShardConfig {
    static let totalCrystals = 80
    static let xpPerLevel: [Int] = [40, 120, 280, 550, 1000, 1700, 2800, 4500, 7000, 10000]

    static func starsForQuality(_ quality: Double) -> Int {
        if quality >= 0.90 { return 3 }
        if quality >= 0.65 { return 2 }
        if quality >= 0.35 { return 1 }
        return 0
    }

    static func xpForCrystal(stars: Int, familyId: Int) -> Int {
        let base = stars * 15
        let familyBonus = min(familyId * 5, 20)
        return base + familyBonus + 5
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
        ["Novice", "Collector", "Miner", "Geologist", "Crystallographer",
         "Mineralogist", "Gemologist", "Master Cutter", "Gem Lord", "Legend",
         "Crystal Sage"][min(level, 10)]
    }
}
