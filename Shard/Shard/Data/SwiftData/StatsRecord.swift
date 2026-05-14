import Foundation
import SwiftData

@Model
final class StatsRecord {
    var crystalsGrown: Int = 0
    var totalXP: Int = 0
    var threeStarCount: Int = 0
    var currentStreak: Int = 0
    var longestStreak: Int = 0
    var lastPlayedDate: String?
    var totalGrowthTime: Int = 0

    var quartzGrown: Int = 0
    var berylGrown: Int = 0
    var corundumGrown: Int = 0
    var fluoriteGrown: Int = 0
    var carbonGrown: Int = 0

    var familiesPlayedData: Data?
    var typesGrownData: Data?
    var bestQuality: Double = 0

    var familiesPlayed: Set<String> {
        get { (try? familiesPlayedData.flatMap { try JSONDecoder().decode(Set<String>.self, from: $0) }) ?? [] }
        set { familiesPlayedData = try? JSONEncoder().encode(newValue) }
    }

    var typesGrown: Set<String> {
        get { (try? typesGrownData.flatMap { try JSONDecoder().decode(Set<String>.self, from: $0) }) ?? [] }
        set { typesGrownData = try? JSONEncoder().encode(newValue) }
    }

    init() {}

    func updateStreak() {
        let fmt = DateFormatter(); fmt.dateFormat = "yyyy-MM-dd"
        let today = fmt.string(from: .now)
        guard lastPlayedDate != today else { return }
        if let last = lastPlayedDate, let d = fmt.date(from: last), Calendar.current.isDateInYesterday(d) {
            currentStreak += 1
        } else { currentStreak = 1 }
        longestStreak = max(longestStreak, currentStreak)
        lastPlayedDate = today
    }

    func recordCrystal(_ crystal: Crystal) {
        crystalsGrown += 1
        totalXP += crystal.xp
        if crystal.stars >= 3 { threeStarCount += 1 }
        bestQuality = max(bestQuality, crystal.quality)

        var families = familiesPlayed
        families.insert(MineralFamily.all[crystal.familyId].name)
        familiesPlayed = families

        var types = typesGrown
        types.insert(crystal.type.rawValue)
        typesGrown = types

        switch crystal.familyId {
        case 0: quartzGrown += 1
        case 1: berylGrown += 1
        case 2: corundumGrown += 1
        case 3: fluoriteGrown += 1
        case 4: carbonGrown += 1
        default: break
        }

        updateStreak()
    }
}
