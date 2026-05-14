import Foundation

struct Achievement: Identifiable {
    let id: String
    let name: String
    let description: String
    let icon: String
    let tier: Tier
    let isHidden: Bool

    var title: String { name }

    init(id: String, name: String, description: String, icon: String, tier: Tier, isHidden: Bool = false) {
        self.id = id; self.name = name; self.description = description
        self.icon = icon; self.tier = tier; self.isHidden = isHidden
    }

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
        Achievement(id: "first_mix", name: "First Mix", description: "Complete your first soundscape", icon: "speaker.wave.2.fill", tier: .bronze),
        Achievement(id: "nature_complete", name: "Nature Lover", description: "Complete Nature environment", icon: "leaf.fill", tier: .bronze),
        Achievement(id: "urban_complete", name: "City Dweller", description: "Complete Urban environment", icon: "building.2.fill", tier: .silver),
        Achievement(id: "space_complete", name: "Star Gazer", description: "Complete Space environment", icon: "sparkles", tier: .silver),
        Achievement(id: "indoor_complete", name: "Homebody", description: "Complete Indoor environment", icon: "house.fill", tier: .gold),
        Achievement(id: "mystic_complete", name: "Zen Master", description: "Complete Mystic environment", icon: "moon.stars.fill", tier: .diamond),

        Achievement(id: "perfectionist", name: "Perfect Ear", description: "Get 3 stars on 10 mixes", icon: "star.circle.fill", tier: .bronze),
        Achievement(id: "star_collector", name: "Star Collector", description: "Get 3 stars on 40 mixes", icon: "medal.fill", tier: .gold),
        Achievement(id: "golden_ear", name: "Golden Ear", description: "95%+ accuracy on a mix", icon: "ear.fill", tier: .silver),
        Achievement(id: "no_hints", name: "Pure Instinct", description: "Solve 20 without hints", icon: "brain.fill", tier: .silver),

        Achievement(id: "streak_3", name: "Getting Started", description: "Reach a 3-day streak", icon: "flame.fill", tier: .bronze),
        Achievement(id: "streak_7", name: "On Fire", description: "Reach a 7-day streak", icon: "flame.fill", tier: .silver),
        Achievement(id: "streak_30", name: "Unstoppable", description: "Reach a 30-day streak", icon: "flame.circle.fill", tier: .gold),
        Achievement(id: "streak_100", name: "Legendary", description: "100-day streak", icon: "trophy.fill", tier: .diamond, isHidden: true),

        Achievement(id: "xp_100", name: "Listener", description: "Earn 100 XP", icon: "headphones", tier: .bronze),
        Achievement(id: "xp_500", name: "Audiophile", description: "Earn 500 XP", icon: "headphones", tier: .silver),
        Achievement(id: "xp_2000", name: "Sound Engineer", description: "Earn 2000 XP", icon: "headphones", tier: .gold),
        Achievement(id: "xp_10000", name: "Maestro", description: "Earn 10,000 XP", icon: "crown.fill", tier: .diamond, isHidden: true),

        Achievement(id: "daily_first", name: "Daily Listener", description: "First daily mix", icon: "calendar.circle.fill", tier: .bronze),
        Achievement(id: "daily_30", name: "Devoted", description: "30 daily mixes", icon: "calendar.badge.checkmark", tier: .gold),

        Achievement(id: "all_envs", name: "World Traveler", description: "Solve one in each environment", icon: "globe", tier: .gold, isHidden: true),
        Achievement(id: "speed_mix", name: "Quick Mix", description: "Under 15 seconds", icon: "hare.fill", tier: .gold, isHidden: true),
    ]

    static func find(_ id: String) -> Achievement? { all.first { $0.id == id } }
}
