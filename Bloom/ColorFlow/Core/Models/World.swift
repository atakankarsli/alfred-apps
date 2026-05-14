import SwiftUI

struct Season: Identifiable {
    let id: Int
    let name: String
    let subtitle: String
    let icon: String
    let gardenRange: Range<Int>
    let accentHex: String

    var gardenCount: Int { gardenRange.count }
    var firstGarden: Int { gardenRange.lowerBound }

    static let all: [Season] = [
        Season(id: 0, name: "Spring", subtitle: "New Beginnings", icon: "leaf.fill", gardenRange: 0..<20, accentHex: "6BCB77"),
        Season(id: 1, name: "Summer", subtitle: "Full Bloom", icon: "sun.max.fill", gardenRange: 20..<40, accentHex: "FFD93D"),
        Season(id: 2, name: "Autumn", subtitle: "Golden Harvest", icon: "wind", gardenRange: 40..<60, accentHex: "FF8C42"),
        Season(id: 3, name: "Winter", subtitle: "Inner Warmth", icon: "snowflake", gardenRange: 60..<80, accentHex: "5BC0EB"),
    ]

    static func seasonForGarden(_ garden: Int) -> Season {
        all.first { $0.gardenRange.contains(garden) } ?? all[0]
    }

    static func localIndex(forGarden garden: Int) -> Int {
        let season = seasonForGarden(garden)
        return garden - season.firstGarden
    }
}
