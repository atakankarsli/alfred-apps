import Foundation

enum FluxConfig {
    static func starsForScore(_ score: Double) -> Int {
        switch score { case 0.9...: 3; case 0.7...: 2; case 0.4...: 1; default: 0 }
    }

    static func xpForFlow(stars: Int, zoneId: String) -> Int {
        let base = stars * 15
        let bonus: Int = switch zoneId {
        case "ripple": 0; case "current": 5; case "cascade": 10
        case "vortex": 15; case "tsunami": 25; default: 0
        }
        return base + bonus
    }

    static let levelThresholds = [0, 100, 250, 500, 900, 1500, 2400, 3800, 5500, 8000]
    static let levelTitles = ["Droplet", "Stream", "Brook", "River", "Rapids", "Torrent", "Maelstrom", "Tsunami", "Tempest", "Force of Nature"]

    static func level(forXP xp: Int) -> Int {
        for (i, t) in levelThresholds.enumerated().reversed() { if xp >= t { return i } }
        return 0
    }
    static func title(forXP xp: Int) -> String { levelTitles[level(forXP: xp)] }
    static func xpProgress(forXP xp: Int) -> Double {
        let lvl = level(forXP: xp)
        guard lvl < levelThresholds.count - 1 else { return 1.0 }
        return Double(xp - levelThresholds[lvl]) / Double(levelThresholds[lvl + 1] - levelThresholds[lvl])
    }
}
