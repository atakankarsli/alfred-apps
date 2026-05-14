import Foundation

enum PulseConfig {
    static let totalTracks = 80
    static let lanesCount = 3
    static let xpPerLevel: [Int] = [50, 150, 350, 700, 1200, 2000, 3200, 5000, 8000, 12000]

    static func starsForAccuracy(_ accuracy: Double) -> Int {
        if accuracy >= 0.90 { return 3 }
        if accuracy >= 0.70 { return 2 }
        if accuracy >= 0.40 { return 1 }
        return 0
    }

    static func xpForTrack(stars: Int, seasonId: Int, maxCombo: Int) -> Int {
        let base = stars * 12
        let seasonBonus = min(seasonId * 3, 12)
        let comboBonus = min(maxCombo / 5, 10)
        return base + seasonBonus + comboBonus + 5
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
        ["Listener", "Tapper", "Drummer", "Beatmaker", "Rhythmist",
         "Groover", "Maestro", "Virtuoso", "Legend", "Pulse Master",
         "Transcendent"][min(level, 10)]
    }
}
