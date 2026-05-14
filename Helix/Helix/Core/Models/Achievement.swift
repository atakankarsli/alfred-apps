import Foundation

struct Achievement: Identifiable, Sendable {
    let id: String
    let name: String
    let desc: String
    let icon: String

    static let all: [Achievement] = [
        Achievement(id: "first_match", name: "First Pair", desc: "Match your first base pair", icon: "sparkle"),
        Achievement(id: "ten_levels", name: "Lab Rat", desc: "Complete 10 levels", icon: "flask.fill"),
        Achievement(id: "twenty_levels", name: "Researcher", desc: "Complete 20 levels", icon: "graduationcap.fill"),
        Achievement(id: "fifty_levels", name: "Scientist", desc: "Complete 50 levels", icon: "atom"),
        Achievement(id: "all_levels", name: "Nobel Prize", desc: "Complete all 80 levels", icon: "trophy.fill"),
        Achievement(id: "realm_nucleus", name: "Nuclear", desc: "Complete the Nucleus realm", icon: "circle.hexagongrid.fill"),
        Achievement(id: "realm_ribosome", name: "Translator", desc: "Complete the Ribosome realm", icon: "circle.grid.3x3.fill"),
        Achievement(id: "realm_membrane", name: "Gatekeeper", desc: "Complete the Membrane realm", icon: "circle.dashed"),
        Achievement(id: "realm_helicase", name: "Unwinder", desc: "Complete the Helicase realm", icon: "arrow.triangle.swap"),
        Achievement(id: "realm_evolution", name: "Evolved", desc: "Complete the Evolution realm", icon: "leaf.arrow.circlepath"),
        Achievement(id: "three_star_10", name: "Precise", desc: "Get 3 stars on 10 levels", icon: "star.leadinghalf.filled"),
        Achievement(id: "three_star_25", name: "Flawless", desc: "Get 3 stars on 25 levels", icon: "seal.fill"),
        Achievement(id: "no_hint_10", name: "Intuition", desc: "Complete 10 levels without hints", icon: "brain.head.profile.fill"),
        Achievement(id: "streak_3", name: "Consistent", desc: "Maintain a 3-day streak", icon: "flame.fill"),
        Achievement(id: "streak_7", name: "Dedicated", desc: "Maintain a 7-day streak", icon: "flame.circle.fill"),
        Achievement(id: "streak_30", name: "Devoted", desc: "Maintain a 30-day streak", icon: "trophy.fill"),
        Achievement(id: "speed_30", name: "Speed Helix", desc: "Complete a level in under 30 seconds", icon: "bolt.fill"),
        Achievement(id: "perfect_5", name: "Perfect Strand", desc: "Get 5 perfect sequences in a row", icon: "checkmark.seal.fill"),
        Achievement(id: "daily_7", name: "Weekly Strand", desc: "Complete 7 daily strands", icon: "calendar.badge.checkmark"),
        Achievement(id: "combo_10", name: "Chain Reaction", desc: "Get a 10x combo", icon: "link"),
    ]
}
