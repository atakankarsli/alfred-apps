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
        Achievement(id: "first_echo", title: "First Echo", description: "Complete your first sequence", icon: "ear.fill", tier: .bronze, isHidden: false),
        Achievement(id: "tone_master", title: "Tone Master", description: "Complete all Tones levels", icon: "waveform", tier: .bronze, isHidden: false),
        Achievement(id: "melody_master", title: "Melodist", description: "Complete all Melody levels", icon: "pianokeys", tier: .bronze, isHidden: false),
        Achievement(id: "rhythm_master", title: "Drummer", description: "Complete all Rhythm levels", icon: "drum.fill", tier: .bronze, isHidden: false),
        Achievement(id: "harmony_master", title: "Harmonist", description: "Complete all Harmony levels", icon: "music.quarternote.3", tier: .bronze, isHidden: false),

        Achievement(id: "all_realms", title: "Sound Explorer", description: "Complete all 5 realms", icon: "globe.americas.fill", tier: .silver, isHidden: false),
        Achievement(id: "perfectionist", title: "Perfect Ear", description: "Get 3 stars on 10 levels", icon: "star.fill", tier: .silver, isHidden: false),
        Achievement(id: "star_collector", title: "Star Chorus", description: "Get 3 stars on 50 levels", icon: "medal.fill", tier: .gold, isHidden: false),

        Achievement(id: "streak_3", title: "Tuning Up", description: "3-day streak", icon: "flame.fill", tier: .bronze, isHidden: false),
        Achievement(id: "streak_7", title: "In The Groove", description: "7-day streak", icon: "flame.fill", tier: .silver, isHidden: false),
        Achievement(id: "streak_30", title: "Perfect Pitch", description: "30-day streak", icon: "flame.circle.fill", tier: .gold, isHidden: false),
        Achievement(id: "streak_100", title: "Eternal Echo", description: "100-day streak", icon: "trophy.fill", tier: .diamond, isHidden: true),

        Achievement(id: "xp_100", title: "Sound Curious", description: "Earn 100 XP", icon: "bolt.circle.fill", tier: .bronze, isHidden: false),
        Achievement(id: "xp_500", title: "Sound Focused", description: "Earn 500 XP", icon: "bolt.circle.fill", tier: .silver, isHidden: false),
        Achievement(id: "xp_2000", title: "Sound Master", description: "Earn 2000 XP", icon: "bolt.circle.fill", tier: .gold, isHidden: false),
        Achievement(id: "xp_10000", title: "Maestro", description: "Earn 10,000 XP", icon: "crown.fill", tier: .diamond, isHidden: true),

        Achievement(id: "no_replay", title: "No Replay Needed", description: "Complete 10 levels without replay", icon: "bolt.fill", tier: .gold, isHidden: true),
        Achievement(id: "speed_echo", title: "Speed Echo", description: "Complete a level in under 5 seconds", icon: "hare.fill", tier: .gold, isHidden: true),
        Achievement(id: "endless_10", title: "Endless Memory", description: "Reach sequence 10 in Endless mode", icon: "infinity", tier: .silver, isHidden: false),
        Achievement(id: "chaos_master", title: "Chaos Theory", description: "Complete all Chaos levels", icon: "waveform.path.ecg", tier: .diamond, isHidden: true),
    ]

    static func find(_ id: String) -> Achievement? {
        all.first { $0.id == id }
    }
}
