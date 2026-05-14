import Foundation

enum PrismConfig {
    static let totalLevels = 80
    static let xpPerLevel: [Int] = [100, 250, 500, 1000, 2000, 3500, 5500, 8000, 12000, 18000]

    static func starsForMoves(_ moves: Int, par: Int) -> Int {
        if moves <= par { return 3 }
        if moves <= par + 2 { return 2 }
        return 1
    }

    static func xpForPuzzle(stars: Int, spectrum: Int) -> Int {
        let base = stars * 10
        let spectrumBonus = spectrum * 5
        return base + spectrumBonus
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
        ["Spark", "Ray", "Beam", "Prism", "Spectrum",
         "Rainbow", "Aurora", "Radiance", "Luminary", "Prismatic",
         "Eternal Light"][min(level, 10)]
    }
}
