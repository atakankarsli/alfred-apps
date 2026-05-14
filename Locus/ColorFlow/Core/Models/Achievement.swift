import Foundation

struct Achievement: Identifiable {
    let id: String; let title: String; let description: String; let icon: String; let requirement: Int; let tier: Tier; var isHidden: Bool = false

    enum Tier: String, Codable { case bronze, silver, gold, diamond }

    static let all: [Achievement] = [
        Achievement(id: "first_place", title: "First Placement", description: "Complete your first puzzle", icon: "mappin.circle.fill", requirement: 1, tier: .bronze),
        Achievement(id: "ten_rooms", title: "Room Explorer", description: "Complete 10 rooms", icon: "door.left.hand.open", requirement: 10, tier: .bronze),
        Achievement(id: "twenty_five", title: "Palace Builder", description: "Complete 25 rooms", icon: "building.columns.fill", requirement: 25, tier: .silver),
        Achievement(id: "fifty", title: "Memory Architect", description: "Complete 50 rooms", icon: "square.stack.3d.up.fill", requirement: 50, tier: .gold),
        Achievement(id: "all_rooms", title: "Grand Palace", description: "Complete all 80 rooms", icon: "crown.fill", requirement: 80, tier: .diamond),
        Achievement(id: "perfect_one", title: "Perfect Recall", description: "Get 3 stars on a room", icon: "star.fill", requirement: 1, tier: .bronze),
        Achievement(id: "perfect_ten", title: "Sharp Memory", description: "Get 3 stars on 10 rooms", icon: "sparkles", requirement: 10, tier: .silver),
        Achievement(id: "perfect_twenty", title: "Eidetic", description: "Get 3 stars on 20 rooms", icon: "camera.fill", requirement: 20, tier: .gold),
        Achievement(id: "streak_three", title: "Daily Visit", description: "3-day streak", icon: "flame.fill", requirement: 3, tier: .bronze),
        Achievement(id: "streak_seven", title: "Weekly Walker", description: "7-day streak", icon: "flame.fill", requirement: 7, tier: .silver),
        Achievement(id: "streak_thirty", title: "Palace Resident", description: "30-day streak", icon: "flame.fill", requirement: 30, tier: .gold),
        Achievement(id: "study_done", title: "Bookworm", description: "Complete the Study", icon: "book.fill", requirement: 20, tier: .silver),
        Achievement(id: "kitchen_done", title: "Head Chef", description: "Complete the Kitchen", icon: "fork.knife", requirement: 20, tier: .silver),
        Achievement(id: "garden_done", title: "Green Thumb", description: "Complete the Garden", icon: "leaf.fill", requirement: 20, tier: .silver),
        Achievement(id: "vault_done", title: "Vault Keeper", description: "Complete the Vault", icon: "lock.open.fill", requirement: 20, tier: .gold),
        Achievement(id: "speed_place", title: "Quick Hands", description: "Complete under 5 seconds", icon: "bolt.fill", requirement: 1, tier: .silver),
        Achievement(id: "daily_five", title: "Daily Practice", description: "Complete 5 daily puzzles", icon: "calendar", requirement: 5, tier: .bronze),
        Achievement(id: "level_five", title: "Rising Scholar", description: "Reach level 5", icon: "arrow.up.circle.fill", requirement: 5, tier: .silver),
        Achievement(id: "xp_thousand", title: "Mind Palace", description: "Earn 1000 XP", icon: "bolt.circle.fill", requirement: 1000, tier: .gold, isHidden: true),
    ]
}
