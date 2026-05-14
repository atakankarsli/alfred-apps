import Foundation

enum BloomConfig {
    static let totalGardens = 80
    static let gardensPerSeason = 20
    static let xpPerLevel: [Int] = [50, 150, 300, 600, 1200, 2000, 3200, 5000, 8000, 12000]

    static func starsForGarden(grownCount: Int, totalCells: Int) -> Int {
        let ratio = Double(grownCount) / Double(totalCells)
        if ratio >= 1.0 { return 3 }
        if ratio >= 0.7 { return 2 }
        return 1
    }

    static func xpForPlanting(emotion: Emotion, season: Int) -> Int {
        10 + season * 2
    }

    static func xpForFullGarden(stars: Int, season: Int) -> Int {
        let base = stars * 15
        let seasonBonus = season * 5
        return base + seasonBonus
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
        ["Seedling", "Sprout", "Bud", "Bloom", "Petal",
         "Blossom", "Flourish", "Radiant", "Garden Sage", "Eternal Gardener",
         "Nature's Heart"][min(level, 10)]
    }
}
