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
    }

    static let all: [Achievement] = [
        Achievement(id: "first_step", title: "First Step", description: "Complete your first mission", icon: "figure.walk", tier: .bronze, isHidden: false),
        Achievement(id: "photo_10", title: "Shutterbug", description: "Complete 10 photo missions", icon: "camera.fill", tier: .bronze, isHidden: false),
        Achievement(id: "explore_10", title: "Street Wanderer", description: "Complete 10 explore missions", icon: "map.fill", tier: .bronze, isHidden: false),
        Achievement(id: "checkpoint_10", title: "Wayfinder", description: "Complete 10 checkpoint missions", icon: "mappin.and.ellipse", tier: .bronze, isHidden: false),
        Achievement(id: "all_types", title: "Jack of All Quests", description: "Complete all 5 mission types", icon: "star.circle.fill", tier: .silver, isHidden: false),
        Achievement(id: "triple_star", title: "Perfectionist", description: "Get 3 stars on any mission", icon: "star.fill", tier: .bronze, isHidden: false),
        Achievement(id: "star_10", title: "Star Explorer", description: "Get 3 stars on 10 missions", icon: "stars.fill", tier: .silver, isHidden: false),
        Achievement(id: "star_50", title: "Star Mapper", description: "Get 3 stars on 50 missions", icon: "sparkles", tier: .gold, isHidden: false),
        Achievement(id: "streak_3", title: "Getting Out", description: "3-day streak", icon: "flame.fill", tier: .bronze, isHidden: false),
        Achievement(id: "streak_7", title: "Daily Explorer", description: "7-day streak", icon: "flame.fill", tier: .silver, isHidden: false),
        Achievement(id: "streak_30", title: "Adventure Habit", description: "30-day streak", icon: "flame.circle.fill", tier: .gold, isHidden: false),
        Achievement(id: "streak_100", title: "Legendary Explorer", description: "100-day streak", icon: "trophy.fill", tier: .diamond, isHidden: true),
        Achievement(id: "xp_100", title: "Curious", description: "Earn 100 XP", icon: "bolt.circle.fill", tier: .bronze, isHidden: false),
        Achievement(id: "xp_500", title: "Dedicated", description: "Earn 500 XP", icon: "bolt.circle.fill", tier: .silver, isHidden: false),
        Achievement(id: "xp_2000", title: "Passionate", description: "Earn 2000 XP", icon: "bolt.circle.fill", tier: .gold, isHidden: false),
        Achievement(id: "xp_10000", title: "Transcendent", description: "Earn 10,000 XP", icon: "crown.fill", tier: .diamond, isHidden: true),
        Achievement(id: "daily_first", title: "Daily Quest", description: "Complete a daily mission", icon: "calendar.badge.checkmark", tier: .bronze, isHidden: false),
        Achievement(id: "daily_30", title: "Daily Devotee", description: "Complete 30 daily missions", icon: "calendar.badge.checkmark", tier: .gold, isHidden: false),
        Achievement(id: "all_regions", title: "World Explorer", description: "Complete a mission in every region", icon: "globe.americas.fill", tier: .silver, isHidden: false),
        Achievement(id: "fog_clear", title: "Fog Lifter", description: "Clear all fog on any mission map", icon: "cloud.sun.fill", tier: .gold, isHidden: true),
    ]
}
