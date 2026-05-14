import Foundation

enum EchoConfig {
    static let totalLevels = 80
    static let levelsPerRealm = 16
    static let xpPerLevel: [Int] = [50, 150, 350, 700, 1200, 2000, 3200, 5000, 8000, 12000]

    static func starsForAccuracy(_ accuracy: Double) -> Int {
        if accuracy >= 0.95 { return 3 }
        if accuracy >= 0.75 { return 2 }
        if accuracy >= 0.50 { return 1 }
        return 0
    }

    static func xpForLevel(stars: Int, realmIndex: Int) -> Int {
        let base = stars * 15
        let realmBonus = realmIndex * 3
        return base + realmBonus
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
        ["Listener", "Novice", "Trainee", "Adept", "Skilled",
         "Expert", "Virtuoso", "Maestro", "Prodigy", "Savant",
         "Eternal"][min(level, 10)]
    }
}
