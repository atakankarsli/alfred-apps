import Foundation

enum RuneConfig {
    static let totalLevels = 80
    static let levelsPerRealm = 16

    static let xpPerLevel = 50
    static let xpPerStar = 25
    static let xpBonusNoHint = 30
    static let xpBonusPerfect = 50

    static func starsForErrors(_ errors: Int, hintCount: Int) -> Int {
        let total = errors + hintCount
        if total == 0 { return 3 }
        if total <= 2 { return 2 }
        return 1
    }

    static func levelTitle(forXP xp: Int) -> String {
        switch xp {
        case 0..<200: "Scribe"
        case 200..<600: "Scholar"
        case 600..<1200: "Linguist"
        case 1200..<2000: "Sage"
        case 2000..<3500: "Decoder"
        case 3500..<5000: "Oracle"
        case 5000..<7500: "Runemaster"
        case 7500..<10000: "Archon"
        case 10000..<15000: "Elder"
        default: "Eternal"
        }
    }
}
