import Foundation

struct Achievement: Identifiable {
    let id: String
    let title: String
    let description: String
    let icon: String
    let tier: Tier
    let isHidden: Bool

    enum Tier: Int, Comparable {
        case bronze = 1, silver = 2, gold = 3, diamond = 4
        static func < (lhs: Tier, rhs: Tier) -> Bool { lhs.rawValue < rhs.rawValue }
    }

    static let all: [Achievement] = [
        Achievement(id: "first_beat", title: "First Beat", description: "Complete your first track", icon: "waveform", tier: .bronze, isHidden: false),
        Achievement(id: "perfect_10", title: "Precision", description: "Get 10 Perfect hits in a row", icon: "scope", tier: .bronze, isHidden: false),
        Achievement(id: "combo_25", title: "Combo Chain", description: "Reach a 25-hit combo", icon: "link", tier: .bronze, isHidden: false),
        Achievement(id: "combo_50", title: "Chain Master", description: "Reach a 50-hit combo", icon: "link.circle.fill", tier: .silver, isHidden: false),
        Achievement(id: "combo_100", title: "Unstoppable", description: "Reach a 100-hit combo", icon: "bolt.shield.fill", tier: .gold, isHidden: true),

        Achievement(id: "triple_star", title: "Three Stars", description: "Get 3 stars on any track", icon: "star.fill", tier: .bronze, isHidden: false),
        Achievement(id: "star_10", title: "Star Collector", description: "Get 3 stars on 10 tracks", icon: "stars.fill", tier: .silver, isHidden: false),
        Achievement(id: "star_50", title: "Star Hoarder", description: "Get 3 stars on 50 tracks", icon: "sparkles", tier: .gold, isHidden: false),

        Achievement(id: "streak_3", title: "Getting Groovy", description: "3-day streak", icon: "flame.fill", tier: .bronze, isHidden: false),
        Achievement(id: "streak_7", title: "On Fire", description: "7-day streak", icon: "flame.fill", tier: .silver, isHidden: false),
        Achievement(id: "streak_30", title: "Rhythm Habit", description: "30-day streak", icon: "flame.circle.fill", tier: .gold, isHidden: false),
        Achievement(id: "streak_100", title: "Legendary Pulse", description: "100-day streak", icon: "trophy.fill", tier: .diamond, isHidden: true),

        Achievement(id: "xp_100", title: "Warming Up", description: "Earn 100 XP", icon: "bolt.circle.fill", tier: .bronze, isHidden: false),
        Achievement(id: "xp_500", title: "Dedicated", description: "Earn 500 XP", icon: "bolt.circle.fill", tier: .silver, isHidden: false),
        Achievement(id: "xp_2000", title: "Passionate", description: "Earn 2000 XP", icon: "bolt.circle.fill", tier: .gold, isHidden: false),
        Achievement(id: "xp_10000", title: "Transcendent", description: "Earn 10,000 XP", icon: "crown.fill", tier: .diamond, isHidden: true),

        Achievement(id: "daily_first", title: "Daily Pulse", description: "Complete a daily beat", icon: "calendar.badge.checkmark", tier: .bronze, isHidden: false),
        Achievement(id: "daily_30", title: "Daily Devotee", description: "Complete 30 daily beats", icon: "calendar.badge.checkmark", tier: .gold, isHidden: false),
        Achievement(id: "all_seasons", title: "World Tour", description: "Complete a track in every season", icon: "globe.americas.fill", tier: .silver, isHidden: false),
        Achievement(id: "full_combo", title: "Full Combo", description: "No misses on any track", icon: "checkmark.seal.fill", tier: .gold, isHidden: true),
    ]
}
