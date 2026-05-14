import Foundation

struct Achievement: Identifiable, Sendable {
    let id: String
    let name: String
    let description: String
    let icon: String

    static let all: [Achievement] = [
        Achievement(id: "first_star", name: "First Light", description: "Complete your first constellation", icon: "star.fill"),
        Achievement(id: "zodiac_complete", name: "Zodiac Master", description: "Complete all Zodiac levels", icon: "sparkles"),
        Achievement(id: "mythical_complete", name: "Legend Seeker", description: "Complete all Mythical levels", icon: "shield.fill"),
        Achievement(id: "animals_complete", name: "Sky Safari", description: "Complete all Animal levels", icon: "hare.fill"),
        Achievement(id: "ancient_complete", name: "Ptolemy's Heir", description: "Complete all Ancient levels", icon: "scroll.fill"),
        Achievement(id: "modern_complete", name: "Modern Eye", description: "Complete all Modern levels", icon: "telescope.fill"),
        Achievement(id: "three_star_10", name: "Bright Sky", description: "Earn 3 stars on 10 levels", icon: "star.leadinghalf.filled"),
        Achievement(id: "three_star_40", name: "Stellar", description: "Earn 3 stars on 40 levels", icon: "star.circle.fill"),
        Achievement(id: "no_hint_10", name: "Sharp Eyes", description: "Complete 10 levels without hints", icon: "eye.fill"),
        Achievement(id: "no_hint_30", name: "Star Memory", description: "Complete 30 levels without hints", icon: "brain.fill"),
        Achievement(id: "streak_3", name: "Consistent", description: "3-day play streak", icon: "flame.fill"),
        Achievement(id: "streak_7", name: "Dedicated", description: "7-day play streak", icon: "flame.circle.fill"),
        Achievement(id: "streak_30", name: "Astronomer", description: "30-day play streak", icon: "star.square.on.square.fill"),
        Achievement(id: "speed_demon", name: "Speed Demon", description: "Complete a level in under 5 seconds", icon: "bolt.fill"),
        Achievement(id: "daily_10", name: "Daily Observer", description: "Complete 10 daily challenges", icon: "calendar.badge.checkmark"),
        Achievement(id: "endless_10", name: "Sky Explorer", description: "Reach round 10 in endless mode", icon: "infinity"),
        Achievement(id: "endless_25", name: "Deep Space", description: "Reach round 25 in endless mode", icon: "moon.stars.fill"),
        Achievement(id: "all_realms", name: "Sky Wanderer", description: "Complete at least one level in each realm", icon: "globe.americas.fill"),
        Achievement(id: "half_done", name: "Halfway There", description: "Complete 40 levels", icon: "flag.checkered"),
        Achievement(id: "all_done", name: "Zenith", description: "Complete all 80 levels", icon: "crown.fill"),
    ]
}
