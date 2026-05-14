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
        Achievement(id: "first_light", title: "First Reaction", description: "Complete your first puzzle", icon: "bolt.fill", tier: .bronze, isHidden: false),
        Achievement(id: "spark_complete", title: "Spark Master", description: "Complete World 1: Spark", icon: "bolt.circle.fill", tier: .bronze, isHidden: false),
        Achievement(id: "pulse_complete", title: "Pulse Master", description: "Complete World 2: Pulse", icon: "waveform.path", tier: .silver, isHidden: false),
        Achievement(id: "wave_complete", title: "Wave Rider", description: "Complete World 3: Wave", icon: "water.waves", tier: .silver, isHidden: false),
        Achievement(id: "storm_complete", title: "Storm Chaser", description: "Complete World 4: Storm", icon: "cloud.bolt.fill", tier: .gold, isHidden: false),
        Achievement(id: "supernova_complete", title: "Supernova", description: "Complete World 5: Supernova", icon: "sparkles", tier: .diamond, isHidden: false),

        Achievement(id: "perfectionist", title: "Perfectionist", description: "Get 3 stars on 10 puzzles", icon: "star.circle.fill", tier: .bronze, isHidden: false),
        Achievement(id: "star_collector", title: "Star Collector", description: "Get 3 stars on 50 puzzles", icon: "medal.fill", tier: .gold, isHidden: false),
        Achievement(id: "par_master", title: "Par Master", description: "Solve 5 puzzles at par", icon: "target", tier: .silver, isHidden: false),
        Achievement(id: "no_help", title: "No Help Needed", description: "Complete 20 puzzles without hints", icon: "brain.fill", tier: .silver, isHidden: false),

        Achievement(id: "streak_3", title: "Getting Started", description: "Reach a 3-day streak", icon: "flame.fill", tier: .bronze, isHidden: false),
        Achievement(id: "streak_7", title: "On Fire", description: "Reach a 7-day streak", icon: "flame.fill", tier: .silver, isHidden: false),
        Achievement(id: "streak_30", title: "Unstoppable", description: "Reach a 30-day streak", icon: "flame.circle.fill", tier: .gold, isHidden: false),
        Achievement(id: "streak_100", title: "Legendary", description: "Reach a 100-day streak", icon: "trophy.fill", tier: .diamond, isHidden: true),

        Achievement(id: "xp_100", title: "Beginner", description: "Earn 100 XP", icon: "bolt.circle.fill", tier: .bronze, isHidden: false),
        Achievement(id: "xp_500", title: "Intermediate", description: "Earn 500 XP", icon: "bolt.circle.fill", tier: .silver, isHidden: false),
        Achievement(id: "xp_2000", title: "Expert", description: "Earn 2000 XP", icon: "bolt.circle.fill", tier: .gold, isHidden: false),
        Achievement(id: "xp_10000", title: "Grandmaster", description: "Earn 10,000 XP", icon: "crown.fill", tier: .diamond, isHidden: true),

        Achievement(id: "daily_first", title: "Daily Player", description: "Complete your first daily puzzle", icon: "calendar.circle.fill", tier: .bronze, isHidden: false),
        Achievement(id: "daily_30", title: "Dedicated", description: "Complete 30 daily puzzles", icon: "calendar.badge.checkmark", tier: .gold, isHidden: false),

        Achievement(id: "speed_demon", title: "Speed Demon", description: "Clear a puzzle in under 10 seconds", icon: "hare.fill", tier: .gold, isHidden: true),
        Achievement(id: "chain_master", title: "Chain Master", description: "Trigger an 8+ step chain reaction", icon: "link.circle.fill", tier: .gold, isHidden: true),
        Achievement(id: "hidden_zen", title: "Zen Master", description: "Complete 50 puzzles without hints", icon: "leaf.fill", tier: .diamond, isHidden: true),
    ]

    static func find(_ id: String) -> Achievement? {
        all.first { $0.id == id }
    }
}
