import Foundation

struct Achievement: Identifiable, Sendable {
    let id: String
    let name: String
    let description: String
    let icon: String

    static let all: [Achievement] = [
        Achievement(id: "first_decode", name: "First Decode", description: "Decode your first message", icon: "character.magnify"),
        Achievement(id: "futhark_done", name: "Norse Scholar", description: "Complete all Futhark levels", icon: "shield.lefthalf.filled"),
        Achievement(id: "hieroglyph_done", name: "Egyptologist", description: "Complete all Hieroglyph levels", icon: "pyramid.fill"),
        Achievement(id: "cuneiform_done", name: "Sumerian Sage", description: "Complete all Cuneiform levels", icon: "square.grid.3x3.fill"),
        Achievement(id: "greek_done", name: "Hellenist", description: "Complete all Greek levels", icon: "building.columns.fill"),
        Achievement(id: "ogham_done", name: "Druid", description: "Complete all Ogham levels", icon: "tree.fill"),
        Achievement(id: "three_star_10", name: "Sharp Mind", description: "Earn 3 stars on 10 levels", icon: "star.leadinghalf.filled"),
        Achievement(id: "three_star_40", name: "Perfect Eye", description: "Earn 3 stars on 40 levels", icon: "star.circle.fill"),
        Achievement(id: "no_hint_10", name: "Unaided", description: "Complete 10 levels without hints", icon: "eye.fill"),
        Achievement(id: "no_hint_30", name: "Pure Memory", description: "Complete 30 levels without hints", icon: "brain.fill"),
        Achievement(id: "streak_3", name: "Consistent", description: "3-day play streak", icon: "flame.fill"),
        Achievement(id: "streak_7", name: "Dedicated", description: "7-day play streak", icon: "flame.circle.fill"),
        Achievement(id: "streak_30", name: "Scholar", description: "30-day play streak", icon: "star.square.on.square.fill"),
        Achievement(id: "speed_decode", name: "Speed Reader", description: "Decode a message in under 10 seconds", icon: "bolt.fill"),
        Achievement(id: "daily_10", name: "Daily Scribe", description: "Complete 10 daily scrolls", icon: "calendar.badge.checkmark"),
        Achievement(id: "endless_10", name: "Deep Reader", description: "Reach round 10 in endless mode", icon: "infinity"),
        Achievement(id: "quiz_perfect", name: "Quick Mind", description: "Get a perfect quiz score", icon: "checkmark.seal.fill"),
        Achievement(id: "all_realms", name: "Polyglot", description: "Complete one level in each realm", icon: "globe.americas.fill"),
        Achievement(id: "half_done", name: "Halfway", description: "Complete 40 levels", icon: "flag.checkered"),
        Achievement(id: "all_done", name: "Rune Master", description: "Complete all 80 levels", icon: "crown.fill"),
    ]
}
