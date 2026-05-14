import Foundation

struct Achievement: Identifiable, Sendable {
    let id: String
    let name: String
    let description: String
    let icon: String

    static let all: [Achievement] = [
        Achievement(id: "first_breath", name: "First Breath", description: "Complete your first session", icon: "flame"),
        Achievement(id: "spark_lit", name: "Spark Lit", description: "Reach Kindling rank", icon: "flame.fill"),
        Achievement(id: "perfect_cycle", name: "Perfect Cycle", description: "Complete a session with 100% accuracy", icon: "star.fill"),
        Achievement(id: "hearth_master", name: "Hearth Master", description: "Complete all Hearth levels", icon: "house.fire"),
        Achievement(id: "forge_master", name: "Forge Master", description: "Complete all Forge levels", icon: "hammer.fill"),
        Achievement(id: "volcano_master", name: "Volcano Master", description: "Complete all Volcano levels", icon: "mountain.2.fill"),
        Achievement(id: "aurora_master", name: "Aurora Master", description: "Complete all Aurora levels", icon: "sun.horizon.fill"),
        Achievement(id: "phoenix_master", name: "Phoenix Master", description: "Complete all Phoenix levels", icon: "bird.fill"),
        Achievement(id: "week_streak", name: "Week of Fire", description: "7-day meditation streak", icon: "flame.circle.fill"),
        Achievement(id: "box_breather", name: "Box Breather", description: "Complete 10 Box breathing sessions", icon: "square"),
        Achievement(id: "deep_diver", name: "Deep Diver", description: "Complete 10 Deep breathing sessions", icon: "arrow.down.circle.fill"),
        Achievement(id: "calm_spirit", name: "Calm Spirit", description: "Complete 10 Calm breathing sessions", icon: "leaf.fill"),
        Achievement(id: "speed_breath", name: "Quick Fire", description: "Complete an Energize session perfectly", icon: "bolt.fill"),
        Achievement(id: "no_miss_10", name: "Focused Flame", description: "Complete 10 sessions without missing", icon: "target"),
        Achievement(id: "endless_10", name: "Eternal Flame", description: "Reach round 10 in Endless mode", icon: "infinity"),
        Achievement(id: "daily_7", name: "Daily Devotion", description: "Complete 7 daily embers", icon: "calendar.badge.clock"),
        Achievement(id: "three_star_20", name: "Star Collector", description: "Earn 3 stars on 20 levels", icon: "star.circle.fill"),
        Achievement(id: "xp_5000", name: "Fire Walker", description: "Earn 5000 total XP", icon: "figure.walk"),
        Achievement(id: "all_patterns", name: "Pattern Master", description: "Use every breathing pattern", icon: "waveform.path"),
        Achievement(id: "completionist", name: "Transcendent", description: "Complete all 80 levels", icon: "crown.fill"),
    ]
}
