import Foundation

struct Achievement: Identifiable {
    let id: String
    let title: String
    let description: String
    let icon: String

    static let all: [Achievement] = [
        Achievement(id: "first_game", title: "First Steps", description: "Complete your first game", icon: "figure.walk"),
        Achievement(id: "eye_10", title: "Eagle Eye", description: "Complete 10 Eye Focus games", icon: "eye.fill"),
        Achievement(id: "breath_10", title: "Zen Master", description: "Complete 10 Breath Sync games", icon: "wind"),
        Achievement(id: "reflex_10", title: "Lightning Reflexes", description: "Complete 10 Reflex Rush games", icon: "bolt.fill"),
        Achievement(id: "posture_10", title: "Standing Tall", description: "Complete 10 Posture Check games", icon: "figure.stand"),
        Achievement(id: "all_types", title: "Well-Rounded", description: "Play all 4 game types", icon: "star.circle.fill"),
        Achievement(id: "triple_star", title: "Perfectionist", description: "Get 3 stars on any game", icon: "star.fill"),
        Achievement(id: "star_10", title: "Star Collector", description: "Get 3 stars on 10 games", icon: "stars.fill"),
        Achievement(id: "star_50", title: "Star Master", description: "Get 3 stars on 50 games", icon: "sparkles"),
        Achievement(id: "streak_3", title: "Getting Healthy", description: "3-day streak", icon: "flame.fill"),
        Achievement(id: "streak_7", title: "Habit Forming", description: "7-day streak", icon: "flame.fill"),
        Achievement(id: "streak_30", title: "Health Warrior", description: "30-day streak", icon: "flame.circle.fill"),
        Achievement(id: "streak_100", title: "Vitality Legend", description: "100-day streak", icon: "trophy.fill"),
        Achievement(id: "xp_100", title: "Warming Up", description: "Earn 100 XP", icon: "bolt.circle.fill"),
        Achievement(id: "xp_500", title: "In the Zone", description: "Earn 500 XP", icon: "bolt.circle.fill"),
        Achievement(id: "xp_2000", title: "Peak Performance", description: "Earn 2000 XP", icon: "bolt.circle.fill"),
        Achievement(id: "xp_10000", title: "Transcendent", description: "Earn 10,000 XP", icon: "crown.fill"),
        Achievement(id: "daily_first", title: "Daily Dose", description: "Complete a daily plan", icon: "calendar.badge.checkmark"),
        Achievement(id: "daily_30", title: "Monthly Ritual", description: "Complete 30 daily plans", icon: "calendar.badge.checkmark"),
        Achievement(id: "speed_demon", title: "Speed Demon", description: "Score 95%+ on Reflex Rush", icon: "hare.fill"),
    ]
}
