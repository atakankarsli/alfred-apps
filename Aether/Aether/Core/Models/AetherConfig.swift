import Foundation

enum AetherConfig {
    static let totalLevels = 80
    static let levelsPerRealm = 16

    static let xpPerLevel = 50
    static let xpPerDiscovery = 25
    static let xpBonusPerfect = 50
    static let xpBonusNoHint = 30

    static func starsForMoves(_ moves: Int, target: Int) -> Int {
        if moves <= target { return 3 }
        if moves <= target + 2 { return 2 }
        return 1
    }

    static func levelTitle(forXP xp: Int) -> String {
        switch xp {
        case 0..<200: "Novice"
        case 200..<600: "Apprentice"
        case 600..<1200: "Alchemist"
        case 1200..<2000: "Adept"
        case 2000..<3500: "Sage"
        case 3500..<5000: "Master"
        case 5000..<7500: "Archmage"
        case 7500..<10000: "Philosopher"
        case 10000..<15000: "Ethereal"
        default: "Transcendent"
        }
    }
}
