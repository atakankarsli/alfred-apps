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
        Achievement(id: "first_seed", title: "First Seed", description: "Plant your first emotion", icon: "leaf.fill", tier: .bronze, isHidden: false),
        Achievement(id: "spring_complete", title: "Spring Awakening", description: "Complete all Spring gardens", icon: "leaf.circle.fill", tier: .bronze, isHidden: false),
        Achievement(id: "summer_complete", title: "Summer Bloom", description: "Complete all Summer gardens", icon: "sun.max.fill", tier: .silver, isHidden: false),
        Achievement(id: "autumn_complete", title: "Autumn Harvest", description: "Complete all Autumn gardens", icon: "wind", tier: .silver, isHidden: false),
        Achievement(id: "winter_complete", title: "Winter Soul", description: "Complete all Winter gardens", icon: "snowflake", tier: .gold, isHidden: false),

        Achievement(id: "gardener_10", title: "Budding Gardener", description: "Grow 10 plants to full bloom", icon: "camera.macro", tier: .bronze, isHidden: false),
        Achievement(id: "gardener_50", title: "Master Gardener", description: "Grow 50 plants to full bloom", icon: "tree.fill", tier: .gold, isHidden: false),
        Achievement(id: "garden_perfect", title: "Perfect Garden", description: "Get 3 stars on 10 gardens", icon: "star.circle.fill", tier: .silver, isHidden: false),

        Achievement(id: "emotion_variety", title: "Emotional Range", description: "Use all 8 emotions", icon: "heart.circle.fill", tier: .bronze, isHidden: false),
        Achievement(id: "joy_lover", title: "Joy Seeker", description: "Plant 20 Joy flowers", icon: "sun.max.fill", tier: .silver, isHidden: false),

        Achievement(id: "streak_3", title: "Growing Habit", description: "Reach a 3-day streak", icon: "flame.fill", tier: .bronze, isHidden: false),
        Achievement(id: "streak_7", title: "Rooted", description: "Reach a 7-day streak", icon: "flame.fill", tier: .silver, isHidden: false),
        Achievement(id: "streak_30", title: "Deep Roots", description: "Reach a 30-day streak", icon: "flame.circle.fill", tier: .gold, isHidden: false),
        Achievement(id: "streak_100", title: "Ancient Oak", description: "Reach a 100-day streak", icon: "trophy.fill", tier: .diamond, isHidden: true),

        Achievement(id: "xp_100", title: "Seedling", description: "Earn 100 XP", icon: "leaf.circle.fill", tier: .bronze, isHidden: false),
        Achievement(id: "xp_500", title: "Sapling", description: "Earn 500 XP", icon: "leaf.circle.fill", tier: .silver, isHidden: false),
        Achievement(id: "xp_2000", title: "Mighty Tree", description: "Earn 2000 XP", icon: "tree.fill", tier: .gold, isHidden: false),
        Achievement(id: "xp_10000", title: "Forest Spirit", description: "Earn 10,000 XP", icon: "crown.fill", tier: .diamond, isHidden: true),

        Achievement(id: "daily_first", title: "Daily Bloom", description: "Complete your first daily garden", icon: "calendar.circle.fill", tier: .bronze, isHidden: false),
        Achievement(id: "daily_30", title: "Devoted", description: "Complete 30 daily gardens", icon: "calendar.badge.checkmark", tier: .gold, isHidden: false),

        Achievement(id: "night_gardener", title: "Night Gardener", description: "Plant after 10 PM", icon: "moon.fill", tier: .gold, isHidden: true),
        Achievement(id: "zen_garden", title: "Zen Garden", description: "Complete a garden using only Calm and Peace", icon: "wind", tier: .gold, isHidden: true),
        Achievement(id: "rainbow_garden", title: "Rainbow Garden", description: "Fill a garden with all 8 emotions", icon: "rainbow", tier: .diamond, isHidden: true),
    ]

    static func find(_ id: String) -> Achievement? {
        all.first { $0.id == id }
    }
}
