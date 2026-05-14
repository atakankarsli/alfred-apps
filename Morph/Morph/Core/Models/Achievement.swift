import Foundation

struct Achievement: Identifiable {
    let id: String
    let title: String
    let description: String
    let icon: String
    let tier: Tier
    let isHidden: Bool

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
        Achievement(id: "first_morph", title: "First Transform", description: "Complete your first morph", icon: "arrow.triangle.2.circlepath", tier: .bronze, isHidden: false),
        Achievement(id: "prism_master", title: "Prism Pro", description: "Complete all Prism levels", icon: "triangle.fill", tier: .bronze, isHidden: false),
        Achievement(id: "polygon_master", title: "Polygon Expert", description: "Complete all Polygon levels", icon: "hexagon.fill", tier: .bronze, isHidden: false),
        Achievement(id: "fractal_master", title: "Fractal Mind", description: "Complete all Fractal levels", icon: "seal.fill", tier: .bronze, isHidden: false),
        Achievement(id: "symmetry_master", title: "Mirror Master", description: "Complete all Symmetry levels", icon: "arrow.left.and.right", tier: .bronze, isHidden: false),

        Achievement(id: "all_realms", title: "Shape Shifter", description: "Complete all 5 realms", icon: "globe.americas.fill", tier: .silver, isHidden: false),
        Achievement(id: "perfectionist", title: "Perfect Form", description: "Get 3 stars on 10 levels", icon: "star.fill", tier: .silver, isHidden: false),
        Achievement(id: "star_collector", title: "Star Geometer", description: "Get 3 stars on 50 levels", icon: "medal.fill", tier: .gold, isHidden: false),

        Achievement(id: "streak_3", title: "Warming Up", description: "3-day streak", icon: "flame.fill", tier: .bronze, isHidden: false),
        Achievement(id: "streak_7", title: "On A Roll", description: "7-day streak", icon: "flame.fill", tier: .silver, isHidden: false),
        Achievement(id: "streak_30", title: "Dedicated", description: "30-day streak", icon: "flame.circle.fill", tier: .gold, isHidden: false),
        Achievement(id: "streak_100", title: "Shape Master", description: "100-day streak", icon: "trophy.fill", tier: .diamond, isHidden: true),

        Achievement(id: "xp_100", title: "Curious", description: "Earn 100 XP", icon: "bolt.circle.fill", tier: .bronze, isHidden: false),
        Achievement(id: "xp_500", title: "Focused", description: "Earn 500 XP", icon: "bolt.circle.fill", tier: .silver, isHidden: false),
        Achievement(id: "xp_2000", title: "Expert", description: "Earn 2000 XP", icon: "bolt.circle.fill", tier: .gold, isHidden: false),
        Achievement(id: "xp_10000", title: "Grandmaster", description: "Earn 10,000 XP", icon: "crown.fill", tier: .diamond, isHidden: true),

        Achievement(id: "min_moves", title: "Efficiency", description: "Solve 10 levels in minimum moves", icon: "bolt.fill", tier: .gold, isHidden: true),
        Achievement(id: "speed_morph", title: "Speed Former", description: "Complete a level in under 5 seconds", icon: "hare.fill", tier: .gold, isHidden: true),
        Achievement(id: "endless_10", title: "Infinite Form", description: "Reach round 10 in Endless", icon: "infinity", tier: .silver, isHidden: false),
        Achievement(id: "chaos_master", title: "Chaos Theory", description: "Complete all Chaos levels", icon: "burst.fill", tier: .diamond, isHidden: true),
    ]

    static func find(_ id: String) -> Achievement? {
        all.first { $0.id == id }
    }
}
