import SwiftUI

struct Region: Identifiable {
    let id: Int
    let name: String
    let subtitle: String
    let icon: String
    let missionRange: Range<Int>
    let accentHex: String
    let missionTypes: [MissionType]

    var missionCount: Int { missionRange.count }
    var firstMission: Int { missionRange.lowerBound }
    var levelRange: Range<Int> { missionRange }
    var description: String { subtitle }

    func color(_ theme: Theme) -> Color { Color(hex: accentHex) }

    static let all: [Region] = [
        Region(id: 0, name: "Neighborhood", subtitle: "Know Your Block", icon: "house.fill",
               missionRange: 0..<16, accentHex: "4CAF50", missionTypes: [.explore, .discover]),
        Region(id: 1, name: "Downtown", subtitle: "City Core", icon: "building.2.fill",
               missionRange: 16..<32, accentHex: "2196F3", missionTypes: [.explore, .photo, .checkpoint]),
        Region(id: 2, name: "Parklands", subtitle: "Green Spaces", icon: "leaf.fill",
               missionRange: 32..<48, accentHex: "FF9800", missionTypes: [.explore, .photo, .observe]),
        Region(id: 3, name: "Waterfront", subtitle: "Coastal Paths", icon: "water.waves",
               missionRange: 48..<64, accentHex: "00BCD4", missionTypes: [.explore, .photo, .checkpoint, .discover]),
        Region(id: 4, name: "Unknown", subtitle: "Terra Incognita", icon: "map.fill",
               missionRange: 64..<80, accentHex: "9C27B0", missionTypes: MissionType.allCases),
    ]

    static func regionForMission(_ idx: Int) -> Region {
        all.first { $0.missionRange.contains(idx) } ?? all[0]
    }
}
