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
        Achievement(id: "first_wave", title: "First Ripple", description: "Complete your first puzzle", icon: "drop.fill", tier: .bronze, isHidden: false),
        Achievement(id: "ripple_master", title: "Ripple Master", description: "Complete all Ripples levels", icon: "water.waves", tier: .bronze, isHidden: false),
        Achievement(id: "echo_master", title: "Echo Chamber", description: "Complete all Echoes levels", icon: "wave.3.right", tier: .bronze, isHidden: false),
        Achievement(id: "resonance_master", title: "Resonator", description: "Complete all Resonance levels", icon: "tuningfork", tier: .bronze, isHidden: false),
        Achievement(id: "harmonics_master", title: "Harmonist", description: "Complete all Harmonics levels", icon: "waveform.path.ecg", tier: .bronze, isHidden: false),

        Achievement(id: "all_worlds", title: "Ocean Explorer", description: "Complete all 5 worlds", icon: "globe.americas.fill", tier: .silver, isHidden: false),
        Achievement(id: "perfectionist", title: "Perfect Wave", description: "Get 3 stars on 10 levels", icon: "star.fill", tier: .silver, isHidden: false),
        Achievement(id: "star_collector", title: "Star Tide", description: "Get 3 stars on 50 levels", icon: "medal.fill", tier: .gold, isHidden: false),

        Achievement(id: "streak_3", title: "Rising Tide", description: "3-day streak", icon: "flame.fill", tier: .bronze, isHidden: false),
        Achievement(id: "streak_7", title: "Tidal Force", description: "7-day streak", icon: "flame.fill", tier: .silver, isHidden: false),
        Achievement(id: "streak_30", title: "Ocean Current", description: "30-day streak", icon: "flame.circle.fill", tier: .gold, isHidden: false),
        Achievement(id: "streak_100", title: "Eternal Tide", description: "100-day streak", icon: "trophy.fill", tier: .diamond, isHidden: true),

        Achievement(id: "xp_100", title: "Wave Curious", description: "Earn 100 XP", icon: "bolt.circle.fill", tier: .bronze, isHidden: false),
        Achievement(id: "xp_500", title: "Wave Rider", description: "Earn 500 XP", icon: "bolt.circle.fill", tier: .silver, isHidden: false),
        Achievement(id: "xp_2000", title: "Wave Master", description: "Earn 2000 XP", icon: "bolt.circle.fill", tier: .gold, isHidden: false),
        Achievement(id: "xp_10000", title: "Poseidon", description: "Earn 10,000 XP", icon: "crown.fill", tier: .diamond, isHidden: true),

        Achievement(id: "speed_solver", title: "Speed Solver", description: "Solve a puzzle in under 10 seconds", icon: "hare.fill", tier: .gold, isHidden: true),
        Achievement(id: "sandbox_play", title: "Free Spirit", description: "Play 10 sandbox sessions", icon: "paintbrush.fill", tier: .silver, isHidden: false),
        Achievement(id: "daily_wave", title: "Daily Surfer", description: "Complete 7 daily waves", icon: "calendar.badge.checkmark", tier: .silver, isHidden: false),
        Achievement(id: "chaos_master", title: "Chaos Theory", description: "Complete all Chaos levels", icon: "tornado", tier: .diamond, isHidden: true),
    ]

    static func find(_ id: String) -> Achievement? {
        all.first { $0.id == id }
    }
}
