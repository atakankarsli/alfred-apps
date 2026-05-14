import Foundation

enum HelixConfig {
    static let totalLevels = 80
    static let levelsPerRealm = 16

    static let xpPerLevel = 50
    static let xpPerCorrectBase = 10
    static let xpBonusPerfect = 50
    static let xpBonusNoHint = 30
    static let xpBonusSpeed = 20

    static func starsForAccuracy(_ accuracy: Double) -> Int {
        if accuracy >= 1.0 { return 3 }
        if accuracy >= 0.8 { return 2 }
        return 1
    }

    static func sequenceLength(forLevel index: Int) -> Int {
        let base = 4
        let growth = index / 8
        return min(base + growth, 16)
    }

    static func levelTitle(forXP xp: Int) -> String {
        switch xp {
        case 0..<200: "Intern"
        case 200..<600: "Lab Tech"
        case 600..<1200: "Researcher"
        case 1200..<2000: "Geneticist"
        case 2000..<3500: "Biologist"
        case 3500..<5000: "Professor"
        case 5000..<7500: "Nobel Nominee"
        case 7500..<10000: "Pioneer"
        case 10000..<15000: "Helix Master"
        default: "Transcendent"
        }
    }
}
