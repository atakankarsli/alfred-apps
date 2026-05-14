import Foundation

enum LocusConfig {
    static let totalPuzzles = 80
    static let puzzlesPerRoom = 20
    static let xpPerLevel: [Int] = [100, 250, 500, 1000, 2000, 3500, 5500, 8000, 12000, 18000]
    static let xpLevelTitles = ["Novice", "Student", "Scholar", "Architect", "Curator", "Sage", "Oracle", "Keeper", "Grand Master", "Transcendent"]

    static func starsForScore(_ score: Double) -> Int {
        if score >= 0.95 { return 3 } else if score >= 0.7 { return 2 } else if score >= 0.4 { return 1 } else { return 0 }
    }

    static func xpForPuzzle(stars: Int, room: Int) -> Int {
        let base = [0, 10, 25, 50]; let mult = 1.0 + Double(room) * 0.15
        return Int(Double(base[min(stars, 3)]) * mult)
    }

    static func levelForXP(_ xp: Int) -> Int {
        var total = 0
        for (i, req) in xpPerLevel.enumerated() { total += req; if xp < total { return i } }
        return xpPerLevel.count - 1
    }

    static func xpProgressInLevel(_ xp: Int) -> Double {
        var total = 0
        for req in xpPerLevel { if xp < total + req { return Double(xp - total) / Double(req) }; total += req }
        return 1.0
    }

    static func xpLevelTitle(_ level: Int) -> String { xpLevelTitles[min(level, xpLevelTitles.count - 1)] }
}
