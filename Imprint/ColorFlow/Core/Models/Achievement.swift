import Foundation

struct Achievement: Identifiable {
    let id: String
    let name: String
    let description: String
    let icon: String
    let tier: Tier
    var isHidden: Bool = false

    var title: String { name }

    enum Tier: String {
        case bronze, silver, gold, diamond
    }

    static let all: [Achievement] = [
        Achievement(id: "first_snap", name: "First Snap", description: "Complete your first mosaic", icon: "camera.fill", tier: .bronze),
        Achievement(id: "sharp_eye", name: "Sharp Eye", description: "Get 95%+ accuracy", icon: "eye.fill", tier: .bronze),
        Achievement(id: "dawn_walker", name: "Dawn Walker", description: "Complete all Dawn mosaics", icon: "sunrise.fill", tier: .silver),
        Achievement(id: "golden_light", name: "Golden Light", description: "Complete all Golden Hour mosaics", icon: "sun.max.fill", tier: .silver),
        Achievement(id: "twilight_artist", name: "Twilight Artist", description: "Complete all Twilight mosaics", icon: "sunset.fill", tier: .silver),
        Achievement(id: "midnight_master", name: "Midnight Master", description: "Complete all Midnight mosaics", icon: "moon.stars.fill", tier: .gold),
        Achievement(id: "perfect_10", name: "Perfect 10", description: "Get 10 perfect scores", icon: "star.fill", tier: .silver),
        Achievement(id: "streak_3", name: "On a Roll", description: "3-day streak", icon: "flame.fill", tier: .bronze),
        Achievement(id: "streak_7", name: "Weekly Ritual", description: "7-day streak", icon: "flame.fill", tier: .silver),
        Achievement(id: "streak_30", name: "Monthly Devotion", description: "30-day streak", icon: "flame.fill", tier: .gold),
        Achievement(id: "speed_snap", name: "Speed Snap", description: "Complete a mosaic in under 10 seconds", icon: "bolt.fill", tier: .bronze),
        Achievement(id: "no_mistakes", name: "Flawless Frame", description: "10 mosaics with 100% accuracy", icon: "checkmark.seal.fill", tier: .gold),
        Achievement(id: "daily_10", name: "Daily Devotee", description: "Complete 10 daily mosaics", icon: "calendar.badge.checkmark", tier: .silver),
        Achievement(id: "all_stars", name: "Star Collector", description: "Earn 100 stars", icon: "star.circle.fill", tier: .silver),
        Achievement(id: "color_master", name: "Color Master", description: "Use all 8 palette colors correctly", icon: "paintpalette.fill", tier: .bronze),
        Achievement(id: "quick_50", name: "Quick Snapper", description: "Complete 50 Quick Snap mosaics", icon: "camera.badge.clock.fill", tier: .silver),
        Achievement(id: "half_way", name: "Half the Journey", description: "Complete 40 mosaics", icon: "flag.checkered", tier: .silver),
        Achievement(id: "completionist", name: "Completionist", description: "Complete all 80 mosaics", icon: "trophy.fill", tier: .diamond),
        Achievement(id: "xp_max", name: "Transcendent", description: "Reach max XP level", icon: "sparkles", tier: .diamond, isHidden: true),
    ]
}
