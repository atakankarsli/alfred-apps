import Foundation

enum EmberConfig {
    static let totalLevels = 80
    static let levelsPerRealm = 16

    static let xpPerLevel = 50
    static let xpPerStar = 25
    static let xpBonusPerfect = 50
    static let xpBonusNoMiss = 30

    static func starsForAccuracy(_ accuracy: Double) -> Int {
        if accuracy >= 0.95 { return 3 }
        if accuracy >= 0.75 { return 2 }
        return 1
    }

    static func levelTitle(forXP xp: Int) -> String {
        switch xp {
        case 0..<200: "Spark"
        case 200..<600: "Kindling"
        case 600..<1200: "Flame"
        case 1200..<2000: "Blaze"
        case 2000..<3500: "Inferno"
        case 3500..<5000: "Phoenix"
        case 5000..<7500: "Eternal"
        case 7500..<10000: "Ascended"
        case 10000..<15000: "Radiant"
        default: "Transcendent"
        }
    }

    static func session(forLevel index: Int) -> FocusSession {
        let realm = FireRealm(rawValue: index / 16) ?? .hearth
        let lvl = index % 16
        let patternIndex = lvl % BreathPattern.all.count
        let pattern = BreathPattern.all[patternIndex]
        let cycles = max(2, pattern.cycles - 1 + lvl / 4)
        let difficulty = 1 + lvl / 4
        return FocusSession(pattern: pattern, realm: realm, targetCycles: cycles, difficulty: difficulty)
    }
}
