import Foundation

enum ZenithConfig {
    static let totalLevels = 80
    static let levelsPerRealm = 16

    static let xpPerLevel = 50
    static let xpPerStar = 25
    static let xpBonusNoHint = 30
    static let xpBonusPerfectTime = 40

    static let hintCostSeconds = 5

    static func starsForTime(elapsed: TimeInterval, optimal: TimeInterval) -> Int {
        if elapsed <= optimal { return 3 }
        if elapsed <= optimal * 1.5 { return 2 }
        return 1
    }

    static func levelTitle(forXP xp: Int) -> String {
        switch xp {
        case 0..<200: "Stargazer"
        case 200..<600: "Observer"
        case 600..<1200: "Navigator"
        case 1200..<2000: "Astronomer"
        case 2000..<3500: "Celestial"
        case 3500..<5000: "Astral"
        case 5000..<7500: "Cosmic"
        case 7500..<10000: "Galactic"
        case 10000..<15000: "Constellation Master"
        default: "Eternal"
        }
    }

    static func optimalTime(forLevel index: Int) -> TimeInterval {
        let base: TimeInterval = 8
        let perLevel: TimeInterval = 2
        let realmBonus = Double(index / 16) * 3
        return base + Double(index % 16) * perLevel + realmBonus
    }
}
