import Foundation

struct Achievement: Identifiable {
    let id: String
    let name: String
    let description: String
    let icon: String
    let tier: Tier
    var isHidden: Bool = false

    var title: String { name }

    enum Tier: Int, Comparable {
        case bronze = 1, silver = 2, gold = 3, diamond = 4
        static func < (lhs: Tier, rhs: Tier) -> Bool { lhs.rawValue < rhs.rawValue }
        var xpReward: Int {
            switch self {
            case .bronze: 25
            case .silver: 50
            case .gold: 100
            case .diamond: 250
            }
        }
    }

    static let all: [Achievement] = [
        Achievement(id: "first_verse", name: "First Verse", description: "Complete your first poem", icon: "pencil.circle.fill", tier: .bronze),
        Achievement(id: "whisper_done", name: "Whispered", description: "Complete the Whisper chapter", icon: "leaf.fill", tier: .bronze),
        Achievement(id: "murmur_done", name: "Murmured", description: "Complete the Murmur chapter", icon: "wind", tier: .silver),
        Achievement(id: "rhythm_done", name: "Rhythmic", description: "Complete the Rhythm chapter", icon: "music.note", tier: .silver),
        Achievement(id: "verse_done", name: "Versed", description: "Complete the Verse chapter", icon: "text.quote", tier: .gold),
        Achievement(id: "opus_done", name: "Opus", description: "Complete all chapters", icon: "book.fill", tier: .diamond),

        Achievement(id: "perfectionist", name: "Perfect Poet", description: "Get 3 stars on 10 poems", icon: "star.circle.fill", tier: .bronze),
        Achievement(id: "star_collector", name: "Star Weaver", description: "Get 3 stars on 50 poems", icon: "medal.fill", tier: .gold),

        Achievement(id: "streak_3", name: "Daily Ink", description: "Reach a 3-day streak", icon: "flame.fill", tier: .bronze),
        Achievement(id: "streak_7", name: "Weekly Muse", description: "Reach a 7-day streak", icon: "flame.fill", tier: .silver),
        Achievement(id: "streak_30", name: "Monthly Ode", description: "Reach a 30-day streak", icon: "flame.circle.fill", tier: .gold),
        Achievement(id: "streak_100", name: "Century Sonnet", description: "Reach a 100-day streak", icon: "trophy.fill", tier: .diamond, isHidden: true),

        Achievement(id: "xp_100", name: "Inkwell", description: "Earn 100 XP", icon: "bolt.circle.fill", tier: .bronze),
        Achievement(id: "xp_500", name: "Quill", description: "Earn 500 XP", icon: "bolt.circle.fill", tier: .silver),
        Achievement(id: "xp_2000", name: "Tome", description: "Earn 2000 XP", icon: "bolt.circle.fill", tier: .gold),
        Achievement(id: "xp_10000", name: "Anthology", description: "Earn 10,000 XP", icon: "crown.fill", tier: .diamond, isHidden: true),

        Achievement(id: "daily_first", name: "Daily Muse", description: "Complete your first daily poem", icon: "calendar.circle.fill", tier: .bronze),
        Achievement(id: "daily_30", name: "Dedicated Poet", description: "Complete 30 daily poems", icon: "calendar.badge.checkmark", tier: .gold),

        Achievement(id: "speed_poet", name: "Speed Poet", description: "Complete a poem in under 15 seconds", icon: "hare.fill", tier: .gold, isHidden: true),
        Achievement(id: "all_forms", name: "Polyglot Poet", description: "Complete poems in all 5 forms", icon: "globe.americas.fill", tier: .gold, isHidden: true),
    ]

    static func find(_ id: String) -> Achievement? {
        all.first { $0.id == id }
    }
}
