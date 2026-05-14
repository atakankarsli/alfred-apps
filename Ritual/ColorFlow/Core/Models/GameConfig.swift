import Foundation

enum RitualConfig {
    static let totalRituals = 80
    static let ritualsPerPhase = 20
    static let xpPerLevel: [Int] = [100, 250, 500, 1000, 2000, 3500, 5500, 8000, 12000, 18000]
    static let xpLevelTitles = ["Beginner", "Practitioner", "Devotee", "Ritualist", "Disciplined", "Steadfast", "Ascetic", "Sage", "Enlightened", "Master", "Transcendent"]

    static func xpLevelTitle(_ level: Int) -> String { xpLevelTitles[min(level, xpLevelTitles.count - 1)] }
    static func levelForXP(_ xp: Int) -> Int { for (i, t) in xpPerLevel.enumerated() { if xp < t { return i } }; return xpPerLevel.count }
    static func xpProgressInLevel(_ xp: Int) -> Double {
        let level = levelForXP(xp); guard level < xpPerLevel.count else { return 1.0 }
        let prev = level > 0 ? xpPerLevel[level - 1] : 0; let needed = xpPerLevel[level] - prev
        return needed > 0 ? Double(xp - prev) / Double(needed) : 0
    }
    static func starsForCompletion(_ ratio: Double) -> Int { ratio >= 1.0 ? 3 : ratio >= 0.7 ? 2 : ratio >= 0.4 ? 1 : 0 }
    static func xpForRitual(stars: Int, phase: Int) -> Int { stars * 15 + phase * 3 }
}
