import SwiftData
import Foundation

@Model
final class StatsRecord {
    var totalXP: Int = 0
    var levelsCompleted: Int = 0
    var totalPairsMatched: Int = 0
    var threeStarCount: Int = 0
    var noHintCount: Int = 0
    var totalTimePlayed: Int = 0
    var currentStreak: Int = 0
    var bestStreak: Int = 0
    var bestCombo: Int = 0
    var dailyCompleted: Int = 0
    var lastPlayedDate: Date?

    var realmNucleus: Int = 0
    var realmRibosome: Int = 0
    var realmMembrane: Int = 0
    var realmHelicase: Int = 0
    var realmEvolution: Int = 0

    init() {}

    func updateStreak() {
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        if let last = lastPlayedDate {
            let lastDay = cal.startOfDay(for: last)
            let diff = cal.dateComponents([.day], from: lastDay, to: today).day ?? 0
            if diff == 1 {
                currentStreak += 1
            } else if diff > 1 {
                currentStreak = 1
            }
        } else {
            currentStreak = 1
        }
        bestStreak = max(bestStreak, currentStreak)
        lastPlayedDate = today
    }

    func incrementRealm(_ realm: BioRealm) {
        switch realm {
        case .nucleus: realmNucleus += 1
        case .ribosome: realmRibosome += 1
        case .membrane: realmMembrane += 1
        case .helicase: realmHelicase += 1
        case .evolution: realmEvolution += 1
        }
    }
}
