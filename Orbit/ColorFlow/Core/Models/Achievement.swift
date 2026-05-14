import Foundation

struct Achievement: Identifiable {
    let id: String
    let name: String
    let description: String
    let icon: String
    let tier: Tier
    let isHidden: Bool

    var title: String { name }

    enum Tier: Int, Comparable {
        case bronze = 1, silver = 2, gold = 3, diamond = 4
        static func < (lhs: Tier, rhs: Tier) -> Bool { lhs.rawValue < rhs.rawValue }
        var xpReward: Int {
            switch self {
            case .bronze: 25
            case .silver: 50
            case .gold: 100
            case .diamond: 250
            }
        }
    }

    static let all: [Achievement] = [
        Achievement(id: "first_orbit", name: "First Orbit", description: "Complete your first mission", icon: "arrow.trianglehead.2.counterclockwise.rotate.90", tier: .bronze, isHidden: false),
        Achievement(id: "inner_complete", name: "Inner Explorer", description: "Complete Inner System", icon: "sun.max.fill", tier: .bronze, isHidden: false),
        Achievement(id: "belt_complete", name: "Belt Runner", description: "Complete Asteroid Belt", icon: "circle.hexagongrid.fill", tier: .silver, isHidden: false),
        Achievement(id: "gas_complete", name: "Giant Tamer", description: "Complete Gas Giants", icon: "globe.americas.fill", tier: .silver, isHidden: false),
        Achievement(id: "binary_complete", name: "Binary Master", description: "Complete Binary Stars", icon: "star.leadinghalf.filled", tier: .gold, isHidden: false),
        Achievement(id: "dark_complete", name: "Dark Voyager", description: "Complete Dark Matter", icon: "moon.stars.fill", tier: .diamond, isHidden: false),

        Achievement(id: "perfectionist", name: "Perfect Orbit", description: "Get 3 stars on 10 missions", icon: "star.circle.fill", tier: .bronze, isHidden: false),
        Achievement(id: "star_collector", name: "Star Collector", description: "Get 3 stars on 50 missions", icon: "medal.fill", tier: .gold, isHidden: false),
        Achievement(id: "efficient", name: "Efficient Engineer", description: "Use minimum masses 10 times", icon: "scope", tier: .silver, isHidden: false),
        Achievement(id: "no_help", name: "Solo Navigator", description: "Complete 20 missions without hints", icon: "brain.fill", tier: .silver, isHidden: false),

        Achievement(id: "streak_3", name: "Launching Streak", description: "Reach a 3-day streak", icon: "flame.fill", tier: .bronze, isHidden: false),
        Achievement(id: "streak_7", name: "In Orbit", description: "Reach a 7-day streak", icon: "flame.fill", tier: .silver, isHidden: false),
        Achievement(id: "streak_30", name: "Deep Space", description: "Reach a 30-day streak", icon: "flame.circle.fill", tier: .gold, isHidden: false),
        Achievement(id: "streak_100", name: "Eternal Orbit", description: "Reach a 100-day streak", icon: "trophy.fill", tier: .diamond, isHidden: true),

        Achievement(id: "xp_100", name: "Cadet", description: "Earn 100 XP", icon: "bolt.circle.fill", tier: .bronze, isHidden: false),
        Achievement(id: "xp_500", name: "Pilot", description: "Earn 500 XP", icon: "bolt.circle.fill", tier: .silver, isHidden: false),
        Achievement(id: "xp_2000", name: "Commander", description: "Earn 2000 XP", icon: "bolt.circle.fill", tier: .gold, isHidden: false),
        Achievement(id: "xp_10000", name: "Admiral", description: "Earn 10,000 XP", icon: "crown.fill", tier: .diamond, isHidden: true),

        Achievement(id: "daily_first", name: "Daily Mission", description: "Complete your first daily", icon: "calendar.circle.fill", tier: .bronze, isHidden: false),
        Achievement(id: "daily_30", name: "Mission Control", description: "Complete 30 dailies", icon: "calendar.badge.checkmark", tier: .gold, isHidden: false),

        Achievement(id: "speed_orbit", name: "Lightspeed", description: "Solve a mission in under 15 seconds", icon: "hare.fill", tier: .gold, isHidden: true),
        Achievement(id: "gravity_master", name: "Gravity Master", description: "Place 100 masses total", icon: "circle.grid.cross.fill", tier: .silver, isHidden: true),
    ]

    static func find(_ id: String) -> Achievement? {
        all.first { $0.id == id }
    }
}
