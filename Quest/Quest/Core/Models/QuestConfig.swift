import Foundation

enum QuestConfig {
    static let totalMissions = 80
    static let xpPerLevel: [Int] = [50, 150, 350, 700, 1200, 2000, 3200, 5000, 8000, 12000]

    static func starsForCompletion(_ ratio: Double) -> Int {
        if ratio >= 0.90 { return 3 }
        if ratio >= 0.65 { return 2 }
        if ratio >= 0.35 { return 1 }
        return 0
    }

    static func xpForMission(stars: Int, regionId: Int) -> Int {
        let base = stars * 15
        let regionBonus = min(regionId * 4, 16)
        return base + regionBonus + 5
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

    static func starsForMission(objectivesCompleted: Int, totalObjectives: Int, timeSeconds: Int) -> Int {
        let ratio = totalObjectives > 0 ? Double(objectivesCompleted) / Double(totalObjectives) : 0
        return starsForCompletion(ratio)
    }

    static func xpLevelTitle(_ level: Int) -> String {
        ["Homebody", "Walker", "Scout", "Explorer", "Pathfinder",
         "Adventurer", "Navigator", "Pioneer", "Trailblazer", "Legend",
         "Cartographer"][min(level, 10)]
    }
}
