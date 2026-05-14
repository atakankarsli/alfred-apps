import SwiftData
import Foundation

@Model final class StatsRecord {
    @Attribute(.unique) var key: String
    var totalXP: Int
    var flowsCompleted: Int
    var currentStreak: Int
    var bestStreak: Int
    var lastPlayedDate: Date?
    var totalParticlesSpawned: Int
    var waterFlows: Int
    var lavaFlows: Int
    var plasmaFlows: Int
    var mercuryFlows: Int
    var etherFlows: Int
    var threeStarFlows: Int
    var galleryCount: Int

    init(key: String = "main") {
        self.key = key; totalXP = 0; flowsCompleted = 0; currentStreak = 0; bestStreak = 0
        totalParticlesSpawned = 0; waterFlows = 0; lavaFlows = 0; plasmaFlows = 0
        mercuryFlows = 0; etherFlows = 0; threeStarFlows = 0; galleryCount = 0
    }
}
