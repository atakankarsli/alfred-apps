import Foundation

enum AtlasConfig {
    static func starsForScore(_ score: Double) -> Int {
        switch score { case 0.9...: 3; case 0.7...: 2; case 0.4...: 1; default: 0 }
    }
    static func xpForQuiz(stars: Int, continentId: String) -> Int {
        let base = stars * 15
        let bonus: Int = switch continentId {
        case "europa": 0; case "terra": 5; case "sahara": 10; case "nova": 15; case "oceania": 25; default: 0
        }
        return base + bonus
    }
    static let levelThresholds = [0, 100, 250, 500, 900, 1500, 2400, 3800, 5500, 8000]
    static let levelTitles = ["Tourist", "Traveler", "Explorer", "Navigator", "Voyager", "Cartographer", "Geographer", "Ambassador", "World Citizen", "Atlas Master"]
    static func level(forXP xp: Int) -> Int { for (i, t) in levelThresholds.enumerated().reversed() { if xp >= t { return i } }; return 0 }
    static func title(forXP xp: Int) -> String { levelTitles[level(forXP: xp)] }
    static func xpProgress(forXP xp: Int) -> Double {
        let l = level(forXP: xp); guard l < levelThresholds.count - 1 else { return 1.0 }
        return Double(xp - levelThresholds[l]) / Double(levelThresholds[l + 1] - levelThresholds[l])
    }
}
