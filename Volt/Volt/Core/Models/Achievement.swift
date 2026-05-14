import Foundation

struct Achievement: Identifiable {
    let id: String
    let title: String
    let description: String
    let icon: String

    static let all: [Achievement] = [
        Achievement(id: "first_circuit", title: "First Circuit", description: "Complete your first puzzle", icon: "bolt.fill"),
        Achievement(id: "basics_done", title: "Signal Starter", description: "Complete all Basics puzzles", icon: "checkmark.seal.fill"),
        Achievement(id: "logic_done", title: "Logic Master", description: "Complete all Logic puzzles", icon: "cpu.fill"),
        Achievement(id: "triple_star", title: "Optimal", description: "Get 3 stars on a puzzle", icon: "star.fill"),
        Achievement(id: "star_10", title: "Efficient", description: "Get 10 three-star puzzles", icon: "stars.fill"),
        Achievement(id: "star_50", title: "Perfectionist", description: "Get 50 three-star puzzles", icon: "sparkles"),
        Achievement(id: "streak_3", title: "Daily Builder", description: "3-day streak", icon: "flame.fill"),
        Achievement(id: "streak_7", title: "Weekly Ritual", description: "7-day streak", icon: "flame.fill"),
        Achievement(id: "streak_30", title: "Circuit Habit", description: "30-day streak", icon: "flame.circle.fill"),
        Achievement(id: "streak_100", title: "Eternal Engineer", description: "100-day streak", icon: "trophy.fill"),
        Achievement(id: "xp_100", title: "Spark", description: "Earn 100 XP", icon: "bolt.circle.fill"),
        Achievement(id: "xp_500", title: "Current", description: "Earn 500 XP", icon: "bolt.circle.fill"),
        Achievement(id: "xp_2000", title: "Voltage", description: "Earn 2000 XP", icon: "bolt.circle.fill"),
        Achievement(id: "xp_10000", title: "Megawatt", description: "Earn 10,000 XP", icon: "crown.fill"),
        Achievement(id: "sandbox_5", title: "Free Builder", description: "Build 5 sandbox circuits", icon: "hammer.fill"),
        Achievement(id: "all_components", title: "Full Toolkit", description: "Use all component types", icon: "wrench.and.screwdriver.fill"),
        Achievement(id: "no_hints", title: "No Help Needed", description: "Complete 10 puzzles without hints", icon: "brain.fill"),
        Achievement(id: "speed_30", title: "Speed Builder", description: "Solve a puzzle in under 30 seconds", icon: "hare.fill"),
        Achievement(id: "puzzles_20", title: "Wired Up", description: "Complete 20 puzzles", icon: "cable.connector"),
        Achievement(id: "puzzles_50", title: "Circuit Board", description: "Complete 50 puzzles", icon: "square.grid.3x3.fill"),
    ]
}
