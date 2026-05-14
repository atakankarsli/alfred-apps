import SwiftData
import Foundation

@Model
final class StatsRecord {
    var totalXP: Int = 0
    var levelsCompleted: Int = 0
    var elementsDiscovered: Int = 4
    var totalCombinations: Int = 0
    var threeStarCount: Int = 0
    var noHintCount: Int = 0
    var totalTimePlayed: Int = 0
    var currentStreak: Int = 0
    var bestStreak: Int = 0
    var lastPlayedDate: Date?
    var sandboxCombinations: Int = 0

    var realmPrimordial: Int = 0
    var realmNature: Int = 0
    var realmCivilization: Int = 0
    var realmArcane: Int = 0
    var realmCosmos: Int = 0

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

    func incrementRealm(_ realm: AlchemyRealm) {
        switch realm {
        case .primordial: realmPrimordial += 1
        case .nature: realmNature += 1
        case .civilization: realmCivilization += 1
        case .arcane: realmArcane += 1
        case .cosmos: realmCosmos += 1
        }
    }
}
