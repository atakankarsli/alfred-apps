import Foundation

struct AchievementDef: Identifiable, Sendable {
    let id: String; let name: String; let description: String; let icon: String; let tier: Tier
    enum Tier: Int, Sendable { case bronze = 1, silver, gold, diamond }
}

enum Achievements {
    static let all: [AchievementDef] = [
        .init(id: "first_flow", name: "First Drop", description: "Complete your first flow", icon: "drop.fill", tier: .bronze),
        .init(id: "five_flows", name: "Flowing", description: "Complete 5 flows", icon: "water.waves", tier: .bronze),
        .init(id: "ten_flows", name: "Fluid", description: "Complete 10 flows", icon: "wind", tier: .bronze),
        .init(id: "fifty_flows", name: "Torrent", description: "Complete 50 flows", icon: "tornado", tier: .silver),
        .init(id: "hundred_flows", name: "Tsunami", description: "Complete 100 flows", icon: "tropicalstorm", tier: .gold),
        .init(id: "streak_3", name: "Drip Drip", description: "3-day streak", icon: "flame.fill", tier: .bronze),
        .init(id: "streak_7", name: "Steady Stream", description: "7-day streak", icon: "flame.fill", tier: .silver),
        .init(id: "streak_30", name: "Unbroken Flow", description: "30-day streak", icon: "flame.fill", tier: .gold),
        .init(id: "streak_100", name: "Eternal Current", description: "100-day streak", icon: "flame.fill", tier: .diamond),
        .init(id: "water_master", name: "Aqua Master", description: "50 flows with Water", icon: "drop.fill", tier: .silver),
        .init(id: "lava_master", name: "Pyroclast", description: "50 flows with Lava", icon: "flame.fill", tier: .silver),
        .init(id: "plasma_master", name: "Ion Storm", description: "50 flows with Plasma", icon: "bolt.fill", tier: .silver),
        .init(id: "mercury_master", name: "Quicksilver", description: "50 flows with Mercury", icon: "circle.fill", tier: .silver),
        .init(id: "ether_master", name: "Ethereal", description: "50 flows with Ether", icon: "sparkles", tier: .silver),
        .init(id: "all_elements", name: "Elemental", description: "Use all 5 elements", icon: "circle.grid.2x2.fill", tier: .bronze),
        .init(id: "level_5", name: "Rapids", description: "Reach level 5", icon: "star.fill", tier: .silver),
        .init(id: "level_max", name: "Force of Nature", description: "Reach max level", icon: "crown.fill", tier: .diamond),
        .init(id: "three_stars_10", name: "Pure Flow", description: "3 stars on 10 flows", icon: "star.circle.fill", tier: .gold),
        .init(id: "gallery_20", name: "Collector", description: "Save 20 creations", icon: "photo.on.rectangle", tier: .bronze),
        .init(id: "all_zones", name: "Full Spectrum", description: "Complete a flow in every zone", icon: "rainbow", tier: .gold),
    ]
}
