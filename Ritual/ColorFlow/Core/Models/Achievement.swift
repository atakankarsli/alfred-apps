import Foundation

struct Achievement: Identifiable {
    enum Tier { case bronze, silver, gold, diamond }
    let id: String; let title: String; let description: String; let icon: String
    var tier: Tier = .bronze; var isHidden: Bool = false

    static let all: [Achievement] = [
        Achievement(id: "first_ritual", title: "First Ritual", description: "Complete your first ritual set", icon: "sparkles"),
        Achievement(id: "dawn_master", title: "Dawn Master", description: "Complete all Dawn rituals", icon: "sunrise.fill", tier: .gold),
        Achievement(id: "vitality_master", title: "Vitality Master", description: "Complete all Vitality rituals", icon: "heart.fill", tier: .gold),
        Achievement(id: "flow_master", title: "Flow Master", description: "Complete all Flow rituals", icon: "brain.head.profile", tier: .gold),
        Achievement(id: "dusk_master", title: "Dusk Master", description: "Complete all Dusk rituals", icon: "moon.stars.fill", tier: .gold),
        Achievement(id: "triple_star", title: "Triple Star", description: "Get 3 stars on any ritual", icon: "star.fill"),
        Achievement(id: "star_collector", title: "Star Collector", description: "Earn 30 stars total", icon: "stars.fill", tier: .silver),
        Achievement(id: "streak_3", title: "Building Habits", description: "3-day streak", icon: "flame.fill"),
        Achievement(id: "streak_7", title: "Ritual Keeper", description: "7-day streak", icon: "flame.circle.fill", tier: .silver),
        Achievement(id: "streak_30", title: "Unbreakable", description: "30-day streak", icon: "bolt.shield.fill", tier: .diamond),
        Achievement(id: "xp_100", title: "Getting Started", description: "Earn 100 XP", icon: "arrow.up.circle.fill"),
        Achievement(id: "xp_500", title: "Devoted", description: "Earn 500 XP", icon: "star.circle.fill", tier: .silver),
        Achievement(id: "xp_2000", title: "Ritual Master", description: "Earn 2000 XP", icon: "bolt.circle.fill", tier: .gold),
        Achievement(id: "all_phases", title: "Full Circle", description: "Complete a ritual in every phase", icon: "globe.americas.fill"),
        Achievement(id: "half_way", title: "Halfway There", description: "Complete 40 rituals", icon: "flag.checkered", tier: .silver),
        Achievement(id: "completionist", title: "Completionist", description: "Complete all 80 rituals", icon: "crown.fill", tier: .diamond),
        Achievement(id: "night_owl", title: "Night Owl", description: "Complete a ritual after midnight", icon: "moon.stars.fill", isHidden: true),
        Achievement(id: "early_bird", title: "Early Bird", description: "Complete before 6 AM", icon: "sunrise.fill", isHidden: true),
        Achievement(id: "perfect_phase", title: "Flawless Phase", description: "3 stars on entire phase", icon: "seal.fill", tier: .gold),
    ]
}
