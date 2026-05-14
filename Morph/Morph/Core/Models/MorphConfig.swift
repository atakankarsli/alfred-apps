import Foundation

enum MorphConfig {
    static let totalLevels = 80

    static let xpPerLevel: [Int] = [
        0, 50, 120, 220, 350, 520, 740, 1020,
        1360, 1780, 2300, 2940, 3720, 4660, 5800, 7200,
        8900, 11000, 13600, 16800, 20000
    ]

    static func levelForXP(_ xp: Int) -> Int {
        xpPerLevel.lastIndex(where: { xp >= $0 }) ?? 0
    }

    static func xpProgressInLevel(_ xp: Int) -> Double {
        let level = levelForXP(xp)
        guard level < xpPerLevel.count - 1 else { return 1.0 }
        let current = xp - xpPerLevel[level]
        let needed = xpPerLevel[level + 1] - xpPerLevel[level]
        return Double(current) / Double(needed)
    }

    static func levelTitle(_ level: Int) -> String {
        switch level {
        case 0: "Novice"
        case 1...3: "Shaper"
        case 4...6: "Former"
        case 7...9: "Sculptor"
        case 10...12: "Architect"
        case 13...15: "Geometer"
        case 16...18: "Virtuoso"
        case 19...: "Eternal"
        default: "Novice"
        }
    }

    static func starsForMoves(used: Int, optimal: Int) -> Int {
        if used <= optimal { return 3 }
        if used <= optimal + 2 { return 2 }
        return 1
    }

    static func xpForLevel(stars: Int, realmIndex: Int) -> Int {
        let base = 10 + realmIndex * 5
        return base * stars
    }
}
