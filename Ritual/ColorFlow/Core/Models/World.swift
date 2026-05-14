import SwiftUI

struct RitualPhase: Identifiable {
    let id: Int; let name: String; let subtitle: String; let icon: String; let accentHex: String; let firstRitual: Int; let ritualCount: Int
    var ritualRange: Range<Int> { firstRitual..<(firstRitual + ritualCount) }

    static let all: [RitualPhase] = [
        RitualPhase(id: 0, name: "Dawn", subtitle: "Morning rituals", icon: "sunrise.fill", accentHex: "FFD93D", firstRitual: 0, ritualCount: 20),
        RitualPhase(id: 1, name: "Vitality", subtitle: "Wellness habits", icon: "heart.fill", accentHex: "FF6B6B", firstRitual: 20, ritualCount: 20),
        RitualPhase(id: 2, name: "Flow", subtitle: "Deep focus", icon: "brain.head.profile", accentHex: "5BC0EB", firstRitual: 40, ritualCount: 20),
        RitualPhase(id: 3, name: "Dusk", subtitle: "Evening wind-down", icon: "moon.stars.fill", accentHex: "9B5DE5", firstRitual: 60, ritualCount: 20),
    ]

    static func phaseForRitual(_ r: Int) -> RitualPhase { all[min(r / 20, all.count - 1)] }
    static func localIndex(forRitual r: Int) -> Int { r % 20 }
}
