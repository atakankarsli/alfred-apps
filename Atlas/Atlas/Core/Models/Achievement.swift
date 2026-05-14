import Foundation

struct AchievementDef: Identifiable, Sendable {
    let id: String; let name: String; let description: String; let icon: String; let tier: Tier
    enum Tier: Int, Sendable { case bronze = 1, silver, gold, diamond }
}
enum Achievements {
    static let all: [AchievementDef] = [
        .init(id: "first_quiz", name: "First Steps", description: "Complete your first quiz", icon: "globe.americas.fill", tier: .bronze),
        .init(id: "five_quizzes", name: "Getting Around", description: "Complete 5 quizzes", icon: "map.fill", tier: .bronze),
        .init(id: "ten_quizzes", name: "Globetrotter", description: "Complete 10 quizzes", icon: "airplane", tier: .bronze),
        .init(id: "fifty_quizzes", name: "World Traveler", description: "Complete 50 quizzes", icon: "globe.europe.africa.fill", tier: .silver),
        .init(id: "hundred_quizzes", name: "Atlas Master", description: "Complete 100 quizzes", icon: "trophy.fill", tier: .gold),
        .init(id: "streak_3", name: "On Track", description: "3-day streak", icon: "flame.fill", tier: .bronze),
        .init(id: "streak_7", name: "Weekly Explorer", description: "7-day streak", icon: "flame.fill", tier: .silver),
        .init(id: "streak_30", name: "Dedicated Voyager", description: "30-day streak", icon: "flame.fill", tier: .gold),
        .init(id: "streak_100", name: "World Champion", description: "100-day streak", icon: "flame.fill", tier: .diamond),
        .init(id: "flag_expert", name: "Vexillologist", description: "50 flag quizzes", icon: "flag.fill", tier: .silver),
        .init(id: "capital_expert", name: "Diplomat", description: "50 capital quizzes", icon: "building.columns.fill", tier: .silver),
        .init(id: "map_expert", name: "Cartographer", description: "50 map quizzes", icon: "map.fill", tier: .silver),
        .init(id: "landmark_expert", name: "Photographer", description: "50 landmark quizzes", icon: "photo.fill", tier: .silver),
        .init(id: "all_types", name: "Renaissance", description: "Play all 4 quiz types", icon: "circle.grid.2x2.fill", tier: .bronze),
        .init(id: "level_5", name: "Navigator", description: "Reach level 5", icon: "star.fill", tier: .silver),
        .init(id: "level_max", name: "Atlas Legend", description: "Reach max level", icon: "crown.fill", tier: .diamond),
        .init(id: "perfect_10", name: "Perfect Score", description: "3 stars on 10 quizzes", icon: "star.circle.fill", tier: .gold),
        .init(id: "europa_done", name: "European", description: "Complete Europa", icon: "globe.europe.africa.fill", tier: .bronze),
        .init(id: "all_continents", name: "Pangaea", description: "Complete all continents", icon: "globe.americas.fill", tier: .gold),
        .init(id: "speed_demon", name: "Speed Demon", description: "10 perfect speed rounds", icon: "bolt.fill", tier: .gold),
    ]
}
