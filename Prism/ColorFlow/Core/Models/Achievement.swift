import Foundation

struct Achievement: Identifiable {
    let id: String
    let name: String
    let description: String
    let icon: String
    let tier: Tier
    var isHidden: Bool = false

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
        Achievement(id: "first_beam", name: "First Beam", description: "Solve your first puzzle", icon: "light.beacon.min", tier: .bronze),
        Achievement(id: "first_light_complete", name: "Dawn", description: "Complete First Light spectrum", icon: "sun.max.fill", tier: .bronze),
        Achievement(id: "refraction_complete", name: "Refracted", description: "Complete Refraction spectrum", icon: "triangle.fill", tier: .silver),
        Achievement(id: "chromatic_complete", name: "Chromatic", description: "Complete Chromatic spectrum", icon: "paintpalette.fill", tier: .silver),
        Achievement(id: "prismatic_complete", name: "Prismatic", description: "Complete Prismatic spectrum", icon: "diamond.fill", tier: .gold),
        Achievement(id: "luminance_complete", name: "Luminance", description: "Complete all spectrums", icon: "sparkles", tier: .diamond),

        Achievement(id: "perfectionist", name: "Perfect Prism", description: "Get 3 stars on 10 puzzles", icon: "star.circle.fill", tier: .bronze),
        Achievement(id: "star_collector", name: "Star Collector", description: "Get 3 stars on 50 puzzles", icon: "medal.fill", tier: .gold),
        Achievement(id: "par_master", name: "Optimal Path", description: "Solve 5 puzzles at par", icon: "target", tier: .silver),
        Achievement(id: "no_help", name: "Pure Light", description: "Complete 20 puzzles without hints", icon: "brain.fill", tier: .silver),

        Achievement(id: "streak_3", name: "Steady Glow", description: "Reach a 3-day streak", icon: "flame.fill", tier: .bronze),
        Achievement(id: "streak_7", name: "Bright Flame", description: "Reach a 7-day streak", icon: "flame.fill", tier: .silver),
        Achievement(id: "streak_30", name: "Eternal Flame", description: "Reach a 30-day streak", icon: "flame.circle.fill", tier: .gold),
        Achievement(id: "streak_100", name: "Supernova", description: "Reach a 100-day streak", icon: "trophy.fill", tier: .diamond, isHidden: true),

        Achievement(id: "xp_100", name: "Spark", description: "Earn 100 XP", icon: "bolt.circle.fill", tier: .bronze),
        Achievement(id: "xp_500", name: "Beam", description: "Earn 500 XP", icon: "bolt.circle.fill", tier: .silver),
        Achievement(id: "xp_2000", name: "Ray", description: "Earn 2000 XP", icon: "bolt.circle.fill", tier: .gold),
        Achievement(id: "xp_10000", name: "Radiance", description: "Earn 10,000 XP", icon: "crown.fill", tier: .diamond, isHidden: true),

        Achievement(id: "daily_first", name: "Daily Light", description: "Complete your first daily puzzle", icon: "calendar.circle.fill", tier: .bronze),
        Achievement(id: "daily_30", name: "Dedicated", description: "Complete 30 daily puzzles", icon: "calendar.badge.checkmark", tier: .gold),

        Achievement(id: "speed_demon", name: "Speed of Light", description: "Solve a puzzle in under 10 seconds", icon: "hare.fill", tier: .gold, isHidden: true),
        Achievement(id: "color_master", name: "Full Spectrum", description: "Create all 7 colors", icon: "rainbow", tier: .gold, isHidden: true),
        Achievement(id: "hidden_zen", name: "Zen Prism", description: "Complete 50 puzzles without hints", icon: "leaf.fill", tier: .diamond, isHidden: true),
    ]

    static func find(_ id: String) -> Achievement? {
        all.first { $0.id == id }
    }
}
