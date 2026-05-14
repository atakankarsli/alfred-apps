import Foundation

struct Achievement: Identifiable {
    let id: String; let title: String; let description: String; let icon: String; let requirement: Int; let tier: Tier; var isHidden: Bool = false

    enum Tier: String, Codable { case bronze, silver, gold, diamond }

    static let all: [Achievement] = [
        Achievement(id: "first_trace", title: "First Trace", description: "Complete your first puzzle", icon: "brain.fill", requirement: 1, tier: .bronze),
        Achievement(id: "ten_traces", title: "Pattern Spotter", description: "Complete 10 puzzles", icon: "eye.fill", requirement: 10, tier: .bronze),
        Achievement(id: "twenty_five", title: "Memory Keeper", description: "Complete 25 puzzles", icon: "tray.full.fill", requirement: 25, tier: .silver),
        Achievement(id: "fifty", title: "Recall Master", description: "Complete 50 puzzles", icon: "brain.head.profile.fill", requirement: 50, tier: .gold),
        Achievement(id: "all_puzzles", title: "Total Recall", description: "Complete all 80 puzzles", icon: "crown.fill", requirement: 80, tier: .diamond),
        Achievement(id: "perfect_one", title: "Pixel Perfect", description: "Get 3 stars on a puzzle", icon: "star.fill", requirement: 1, tier: .bronze),
        Achievement(id: "perfect_ten", title: "Sharp Eye", description: "Get 3 stars on 10 puzzles", icon: "sparkles", requirement: 10, tier: .silver),
        Achievement(id: "perfect_twenty", title: "Photographic", description: "Get 3 stars on 20 puzzles", icon: "camera.fill", requirement: 20, tier: .gold),
        Achievement(id: "streak_three", title: "On a Roll", description: "3-day streak", icon: "flame.fill", requirement: 3, tier: .bronze),
        Achievement(id: "streak_seven", title: "Weekly Habit", description: "7-day streak", icon: "flame.fill", requirement: 7, tier: .silver),
        Achievement(id: "streak_thirty", title: "Iron Memory", description: "30-day streak", icon: "flame.fill", requirement: 30, tier: .gold),
        Achievement(id: "glimpse_done", title: "Quick Glance", description: "Complete Glimpse zone", icon: "eye.fill", requirement: 20, tier: .silver),
        Achievement(id: "sequence_done", title: "In Order", description: "Complete Sequence zone", icon: "arrow.right.arrow.left", requirement: 20, tier: .silver),
        Achievement(id: "spatial_done", title: "Mind Map", description: "Complete Spatial zone", icon: "square.grid.3x3.fill", requirement: 20, tier: .silver),
        Achievement(id: "cipher_done", title: "Code Breaker", description: "Complete Cipher zone", icon: "lock.open.fill", requirement: 20, tier: .gold),
        Achievement(id: "speed_demon", title: "Speed Demon", description: "Complete a puzzle under 3 seconds", icon: "bolt.fill", requirement: 1, tier: .silver),
        Achievement(id: "daily_five", title: "Daily Grind", description: "Complete 5 daily puzzles", icon: "calendar", requirement: 5, tier: .bronze),
        Achievement(id: "level_five", title: "Rising Mind", description: "Reach level 5", icon: "arrow.up.circle.fill", requirement: 5, tier: .silver),
        Achievement(id: "xp_thousand", title: "Brain Power", description: "Earn 1000 XP", icon: "bolt.circle.fill", requirement: 1000, tier: .gold, isHidden: true),
    ]
}
