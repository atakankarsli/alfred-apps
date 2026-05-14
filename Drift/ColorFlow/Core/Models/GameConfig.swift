import Foundation

enum DriftConfig {
    static let totalLevels = 80
    static let xpPerLevel: [Int] = [100, 250, 500, 1000, 2000, 3500, 5500, 8000, 12000, 18000]

    static func xpForPuzzle(stars: Int, env: Int) -> Int {
        stars * 10 + env * 5
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
        ["Listener", "Tuner", "Mixer", "Composer", "Curator",
         "Soundsmith", "Audiophile", "Maestro", "Resonance", "Sound Sage",
         "Legendary"][min(level, 10)]
    }
}
