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
            case .bronze: 25; case .silver: 50; case .gold: 100; case .diamond: 250
            }
        }
    }

    static let all: [Achievement] = [
        Achievement(id: "first_spark", title: "First Spark", description: "Complete your first challenge", icon: "sparkle", tier: .bronze, isHidden: false),
        Achievement(id: "draw_10", title: "Sketch Artist", description: "Complete 10 Draw challenges", icon: "paintbrush.fill", tier: .bronze, isHidden: false),
        Achievement(id: "voice_10", title: "Sound Maker", description: "Complete 10 Voice challenges", icon: "mic.fill", tier: .bronze, isHidden: false),
        Achievement(id: "write_10", title: "Wordsmith", description: "Complete 10 Write challenges", icon: "pencil.line", tier: .bronze, isHidden: false),
        Achievement(id: "photo_10", title: "Snapshot", description: "Complete 10 Photo challenges", icon: "camera.fill", tier: .bronze, isHidden: false),
        Achievement(id: "remix_10", title: "Remixer", description: "Complete 10 Remix challenges", icon: "arrow.triangle.2.circlepath", tier: .bronze, isHidden: false),

        Achievement(id: "all_types", title: "Renaissance", description: "Complete all 5 challenge types", icon: "star.circle.fill", tier: .silver, isHidden: false),
        Achievement(id: "perfect_10", title: "Perfectionist", description: "Get 3 stars on 10 challenges", icon: "star.fill", tier: .silver, isHidden: false),
        Achievement(id: "perfect_50", title: "Master Creator", description: "Get 3 stars on 50 challenges", icon: "medal.fill", tier: .gold, isHidden: false),

        Achievement(id: "streak_3", title: "Getting Started", description: "3-day streak", icon: "flame.fill", tier: .bronze, isHidden: false),
        Achievement(id: "streak_7", title: "On a Roll", description: "7-day streak", icon: "flame.fill", tier: .silver, isHidden: false),
        Achievement(id: "streak_30", title: "Creative Habit", description: "30-day streak", icon: "flame.circle.fill", tier: .gold, isHidden: false),
        Achievement(id: "streak_100", title: "Legendary Muse", description: "100-day streak", icon: "trophy.fill", tier: .diamond, isHidden: true),

        Achievement(id: "xp_100", title: "Curious", description: "Earn 100 XP", icon: "bolt.circle.fill", tier: .bronze, isHidden: false),
        Achievement(id: "xp_500", title: "Dedicated", description: "Earn 500 XP", icon: "bolt.circle.fill", tier: .silver, isHidden: false),
        Achievement(id: "xp_2000", title: "Passionate", description: "Earn 2000 XP", icon: "bolt.circle.fill", tier: .gold, isHidden: false),
        Achievement(id: "xp_10000", title: "Transcendent", description: "Earn 10,000 XP", icon: "crown.fill", tier: .diamond, isHidden: true),

        Achievement(id: "speed_demon", title: "Speed Creator", description: "Finish in under 20 seconds", icon: "hare.fill", tier: .gold, isHidden: true),
        Achievement(id: "daily_30", title: "Daily Devotee", description: "Complete 30 daily challenges", icon: "calendar.badge.checkmark", tier: .gold, isHidden: false),
        Achievement(id: "gallery_25", title: "Collector", description: "Save 25 creations to gallery", icon: "photo.stack.fill", tier: .silver, isHidden: false),
    ]

    static func find(_ id: String) -> Achievement? { all.first { $0.id == id } }
}
