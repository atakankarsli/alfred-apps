import Foundation

struct Achievement: Identifiable {
    let id: String
    let title: String
    let description: String
    let icon: String
    let tier: Tier
    let isHidden: Bool

    enum Tier { case bronze, silver, gold, diamond }

    static let all: [Achievement] = [
        Achievement(id: "first_glyph", title: "First Mark", description: "Draw your first symbol", icon: "pencil.tip", tier: .bronze, isHidden: false),
        Achievement(id: "runes_done", title: "Rune Reader", description: "Complete all Runes", icon: "shield.fill", tier: .silver, isHidden: false),
        Achievement(id: "hieroglyphs_done", title: "Pharaoh's Scribe", description: "Complete all Hieroglyphs", icon: "building.columns.fill", tier: .silver, isHidden: false),
        Achievement(id: "kanji_done", title: "Kanji Master", description: "Complete all Kanji", icon: "character.ja", tier: .silver, isHidden: false),
        Achievement(id: "geometry_done", title: "Sacred Architect", description: "Complete Sacred Geometry", icon: "hexagon.fill", tier: .silver, isHidden: false),
        Achievement(id: "alchemy_done", title: "Grand Alchemist", description: "Complete all Alchemy symbols", icon: "flame.fill", tier: .gold, isHidden: false),
        Achievement(id: "all_done", title: "Runemaster", description: "Complete all 80 symbols", icon: "crown.fill", tier: .diamond, isHidden: false),
        Achievement(id: "perfectionist", title: "Perfectionist", description: "Get 3 stars on 10 symbols", icon: "star.fill", tier: .silver, isHidden: false),
        Achievement(id: "star_collector", title: "Star Collector", description: "Get 3 stars on 50 symbols", icon: "star.circle.fill", tier: .gold, isHidden: false),
        Achievement(id: "streak_3", title: "Warm Up", description: "3-day streak", icon: "flame", tier: .bronze, isHidden: false),
        Achievement(id: "streak_7", title: "Dedicated", description: "7-day streak", icon: "flame.fill", tier: .silver, isHidden: false),
        Achievement(id: "streak_30", title: "Devoted", description: "30-day streak", icon: "flame.circle.fill", tier: .gold, isHidden: false),
        Achievement(id: "streak_100", title: "Eternal Flame", description: "100-day streak", icon: "sun.max.fill", tier: .diamond, isHidden: true),
        Achievement(id: "xp_100", title: "Getting Started", description: "Earn 100 XP", icon: "bolt", tier: .bronze, isHidden: false),
        Achievement(id: "xp_500", title: "Rising Scholar", description: "Earn 500 XP", icon: "bolt.fill", tier: .silver, isHidden: false),
        Achievement(id: "xp_2000", title: "Mystic Power", description: "Earn 2000 XP", icon: "bolt.circle.fill", tier: .gold, isHidden: false),
        Achievement(id: "xp_10000", title: "Legendary", description: "Earn 10000 XP", icon: "bolt.shield.fill", tier: .diamond, isHidden: true),
        Achievement(id: "all_categories", title: "Explorer", description: "Draw from all 5 categories", icon: "globe", tier: .silver, isHidden: false),
        Achievement(id: "speed_draw", title: "Lightning Stroke", description: "3 stars under 10 seconds", icon: "hare.fill", tier: .gold, isHidden: true),
        Achievement(id: "daily_first", title: "Daily Practitioner", description: "Complete a daily challenge", icon: "calendar", tier: .bronze, isHidden: false),
    ]
}
