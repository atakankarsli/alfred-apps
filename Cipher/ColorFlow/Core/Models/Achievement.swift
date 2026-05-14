import Foundation

struct Achievement: Identifiable {
    let id: String
    let name: String
    let description: String
    let icon: String
    let tier: Tier
    let isHidden: Bool

    var title: String { name }

    init(id: String, name: String, description: String, icon: String, tier: Tier, isHidden: Bool = false) {
        self.id = id
        self.name = name
        self.description = description
        self.icon = icon
        self.tier = tier
        self.isHidden = isHidden
    }

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
        Achievement(id: "first_decrypt", name: "First Decrypt", description: "Decode your first cipher", icon: "lock.open.fill", tier: .bronze),
        Achievement(id: "scrolls_complete", name: "Scroll Keeper", description: "Complete Ancient Scrolls vault", icon: "scroll.fill", tier: .bronze),
        Achievement(id: "society_complete", name: "Society Member", description: "Complete Secret Society vault", icon: "eye.fill", tier: .silver),
        Achievement(id: "warroom_complete", name: "War Hero", description: "Complete War Room vault", icon: "shield.checkered", tier: .gold),
        Achievement(id: "enigma_complete", name: "Enigma Master", description: "Complete Enigma Lab vault", icon: "gearshape.2.fill", tier: .diamond),

        Achievement(id: "perfectionist", name: "Perfectionist", description: "Get 3 stars on 10 puzzles", icon: "star.circle.fill", tier: .bronze),
        Achievement(id: "star_collector", name: "Star Collector", description: "Get 3 stars on 40 puzzles", icon: "medal.fill", tier: .gold),
        Achievement(id: "speed_decoder", name: "Speed Decoder", description: "Decode a cipher in under 30 seconds", icon: "bolt.fill", tier: .silver),
        Achievement(id: "no_hints", name: "Pure Logic", description: "Solve 20 ciphers without hints", icon: "brain.fill", tier: .silver),

        Achievement(id: "streak_3", name: "Getting Started", description: "Reach a 3-day streak", icon: "flame.fill", tier: .bronze),
        Achievement(id: "streak_7", name: "On Fire", description: "Reach a 7-day streak", icon: "flame.fill", tier: .silver),
        Achievement(id: "streak_30", name: "Unstoppable", description: "Reach a 30-day streak", icon: "flame.circle.fill", tier: .gold),
        Achievement(id: "streak_100", name: "Legendary", description: "Reach a 100-day streak", icon: "trophy.fill", tier: .diamond, isHidden: true),

        Achievement(id: "xp_100", name: "Beginner Agent", description: "Earn 100 XP", icon: "lock.circle.fill", tier: .bronze),
        Achievement(id: "xp_500", name: "Field Agent", description: "Earn 500 XP", icon: "lock.circle.fill", tier: .silver),
        Achievement(id: "xp_2000", name: "Senior Agent", description: "Earn 2000 XP", icon: "lock.circle.fill", tier: .gold),
        Achievement(id: "xp_10000", name: "Director", description: "Earn 10,000 XP", icon: "crown.fill", tier: .diamond, isHidden: true),

        Achievement(id: "daily_first", name: "Daily Decoder", description: "Complete your first daily cipher", icon: "calendar.circle.fill", tier: .bronze),
        Achievement(id: "daily_30", name: "Dedicated Agent", description: "Complete 30 daily ciphers", icon: "calendar.badge.checkmark", tier: .gold),

        Achievement(id: "caesar_master", name: "Caesar's Heir", description: "Master all Caesar cipher levels", icon: "laurel.leading", tier: .silver, isHidden: true),
        Achievement(id: "vigenere_master", name: "Vigenère Scholar", description: "Master all Vigenère levels", icon: "book.closed.fill", tier: .gold, isHidden: true),
        Achievement(id: "all_types", name: "Polyglot", description: "Solve at least one of each cipher type", icon: "globe", tier: .gold, isHidden: true),
    ]

    static func find(_ id: String) -> Achievement? {
        all.first { $0.id == id }
    }
}
