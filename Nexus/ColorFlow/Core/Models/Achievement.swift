import Foundation

struct Achievement: Identifiable {
    let id: String
    let name: String
    let description: String
    let icon: String
    let tier: Tier
    let isHidden: Bool

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
        Achievement(id: "first_link", name: "First Link", description: "Solve your first puzzle", icon: "link.circle.fill", tier: .bronze, isHidden: false),
        Achievement(id: "library_complete", name: "Bookworm", description: "Complete the Library", icon: "books.vertical.fill", tier: .bronze, isHidden: false),
        Achievement(id: "lab_complete", name: "Scientist", description: "Complete the Laboratory", icon: "flask.fill", tier: .silver, isHidden: false),
        Achievement(id: "observatory_complete", name: "Stargazer", description: "Complete the Observatory", icon: "binoculars.fill", tier: .silver, isHidden: false),
        Achievement(id: "archive_complete", name: "Archivist", description: "Complete the Archive", icon: "archivebox.fill", tier: .gold, isHidden: false),
        Achievement(id: "nexus_complete", name: "Nexus Master", description: "Complete the Nexus Core", icon: "brain.head.profile.fill", tier: .diamond, isHidden: false),

        Achievement(id: "perfectionist", name: "Perfectionist", description: "Solve 10 puzzles without mistakes", icon: "star.circle.fill", tier: .bronze, isHidden: false),
        Achievement(id: "flawless_20", name: "Flawless Mind", description: "Solve 20 puzzles without mistakes", icon: "medal.fill", tier: .gold, isHidden: false),
        Achievement(id: "word_master", name: "Word Master", description: "Identify 100 clusters", icon: "text.bubble.fill", tier: .silver, isHidden: false),
        Achievement(id: "no_help", name: "Solo Solver", description: "Solve 20 puzzles without hints", icon: "brain.fill", tier: .silver, isHidden: false),

        Achievement(id: "streak_3", name: "Getting Linked", description: "Reach a 3-day streak", icon: "flame.fill", tier: .bronze, isHidden: false),
        Achievement(id: "streak_7", name: "Connected", description: "Reach a 7-day streak", icon: "flame.fill", tier: .silver, isHidden: false),
        Achievement(id: "streak_30", name: "Deeply Linked", description: "Reach a 30-day streak", icon: "flame.circle.fill", tier: .gold, isHidden: false),
        Achievement(id: "streak_100", name: "Legendary Nexus", description: "Reach a 100-day streak", icon: "trophy.fill", tier: .diamond, isHidden: true),

        Achievement(id: "xp_100", name: "Beginner", description: "Earn 100 XP", icon: "bolt.circle.fill", tier: .bronze, isHidden: false),
        Achievement(id: "xp_500", name: "Intermediate", description: "Earn 500 XP", icon: "bolt.circle.fill", tier: .silver, isHidden: false),
        Achievement(id: "xp_2000", name: "Expert", description: "Earn 2000 XP", icon: "bolt.circle.fill", tier: .gold, isHidden: false),
        Achievement(id: "xp_10000", name: "Grandmaster", description: "Earn 10,000 XP", icon: "crown.fill", tier: .diamond, isHidden: true),

        Achievement(id: "daily_first", name: "Daily Linker", description: "Complete your first daily puzzle", icon: "calendar.circle.fill", tier: .bronze, isHidden: false),
        Achievement(id: "daily_30", name: "Dedicated", description: "Complete 30 daily puzzles", icon: "calendar.badge.checkmark", tier: .gold, isHidden: false),

        Achievement(id: "speed_link", name: "Speed Linker", description: "Solve a puzzle in under 30 seconds", icon: "hare.fill", tier: .gold, isHidden: true),
        Achievement(id: "one_away", name: "So Close!", description: "Get 'One Away' feedback 5 times", icon: "hand.point.up.fill", tier: .silver, isHidden: true),
    ]

    static func find(_ id: String) -> Achievement? {
        all.first { $0.id == id }
    }
}
