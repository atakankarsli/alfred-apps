import Foundation

struct Achievement: Identifiable, Sendable {
    let id: String
    let name: String
    let desc: String
    let icon: String

    static let all: [Achievement] = [
        Achievement(id: "first_combine", name: "First Spark", desc: "Combine two elements for the first time", icon: "sparkle"),
        Achievement(id: "ten_elements", name: "Collector", desc: "Discover 10 elements", icon: "tray.full.fill"),
        Achievement(id: "twenty_elements", name: "Cataloguer", desc: "Discover 20 elements", icon: "books.vertical.fill"),
        Achievement(id: "fifty_elements", name: "Encyclopedist", desc: "Discover 50 elements", icon: "book.closed.fill"),
        Achievement(id: "hundred_elements", name: "Master Alchemist", desc: "Discover 100 elements", icon: "star.circle.fill"),
        Achievement(id: "realm_primordial", name: "Elemental", desc: "Complete the Primordial realm", icon: "drop.fill"),
        Achievement(id: "realm_nature", name: "Naturalist", desc: "Complete the Nature realm", icon: "leaf.fill"),
        Achievement(id: "realm_civilization", name: "Builder", desc: "Complete the Civilization realm", icon: "building.2.fill"),
        Achievement(id: "realm_arcane", name: "Mystic", desc: "Complete the Arcane realm", icon: "sparkles"),
        Achievement(id: "realm_cosmos", name: "Cosmic", desc: "Complete the Cosmos realm", icon: "star.fill"),
        Achievement(id: "three_star_10", name: "Perfectionist", desc: "Get 3 stars on 10 levels", icon: "star.leadinghalf.filled"),
        Achievement(id: "three_star_25", name: "Precision", desc: "Get 3 stars on 25 levels", icon: "seal.fill"),
        Achievement(id: "no_hint_10", name: "Intuition", desc: "Complete 10 levels without hints", icon: "brain.head.profile.fill"),
        Achievement(id: "streak_3", name: "Consistent", desc: "Maintain a 3-day streak", icon: "flame.fill"),
        Achievement(id: "streak_7", name: "Dedicated", desc: "Maintain a 7-day streak", icon: "flame.circle.fill"),
        Achievement(id: "streak_30", name: "Devotion", desc: "Maintain a 30-day streak", icon: "trophy.fill"),
        Achievement(id: "sandbox_50", name: "Experimenter", desc: "Make 50 combinations in sandbox", icon: "flask.fill"),
        Achievement(id: "chain_5", name: "Chain Reaction", desc: "Create a 5-step chain", icon: "link"),
        Achievement(id: "all_base", name: "Foundations", desc: "Use all base elements in combinations", icon: "square.grid.2x2.fill"),
        Achievement(id: "speed_run", name: "Swift Alchemist", desc: "Complete a level in under 30 seconds", icon: "bolt.fill"),
    ]
}
