import Foundation

struct Achievement: Identifiable {
    let id: String
    let title: String
    let description: String
    let icon: String

    static let all: [Achievement] = [
        Achievement(id: "first_crystal", title: "First Shard", description: "Grow your first crystal", icon: "diamond.fill"),
        Achievement(id: "quartz_10", title: "Quartz Collector", description: "Grow 10 quartz crystals", icon: "hexagon.fill"),
        Achievement(id: "beryl_10", title: "Beryl Hunter", description: "Grow 10 beryl crystals", icon: "hexagon.fill"),
        Achievement(id: "corundum_10", title: "Gem Seeker", description: "Grow 10 corundum crystals", icon: "seal.fill"),
        Achievement(id: "all_families", title: "Mineralogist", description: "Grow crystals from all 5 families", icon: "star.circle.fill"),
        Achievement(id: "triple_star", title: "Flawless", description: "Grow a 3-star crystal", icon: "star.fill"),
        Achievement(id: "star_10", title: "Quality Control", description: "Grow 10 three-star crystals", icon: "stars.fill"),
        Achievement(id: "star_50", title: "Master Grower", description: "Grow 50 three-star crystals", icon: "sparkles"),
        Achievement(id: "streak_3", title: "Daily Growth", description: "3-day streak", icon: "flame.fill"),
        Achievement(id: "streak_7", title: "Weekly Ritual", description: "7-day streak", icon: "flame.fill"),
        Achievement(id: "streak_30", title: "Crystal Habit", description: "30-day streak", icon: "flame.circle.fill"),
        Achievement(id: "streak_100", title: "Eternal Grower", description: "100-day streak", icon: "trophy.fill"),
        Achievement(id: "xp_100", title: "Mineral Dust", description: "Earn 100 XP", icon: "bolt.circle.fill"),
        Achievement(id: "xp_500", title: "Crystal Core", description: "Earn 500 XP", icon: "bolt.circle.fill"),
        Achievement(id: "xp_2000", title: "Gem Vein", description: "Earn 2000 XP", icon: "bolt.circle.fill"),
        Achievement(id: "xp_10000", title: "Mother Lode", description: "Earn 10,000 XP", icon: "crown.fill"),
        Achievement(id: "diamond", title: "Diamond Grower", description: "Successfully grow a diamond", icon: "sparkle"),
        Achievement(id: "hot_crystal", title: "Pyromaniac", description: "Grow a crystal at max temperature", icon: "flame.fill"),
        Achievement(id: "cold_crystal", title: "Ice Former", description: "Grow a crystal at min temperature", icon: "snowflake"),
        Achievement(id: "collection_20", title: "Showcase", description: "Add 20 crystals to collection", icon: "tray.full.fill"),
    ]
}
