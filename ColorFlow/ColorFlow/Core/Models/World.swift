import SwiftUI

struct World: Identifiable {
    let id: Int
    let name: String
    let subtitle: String
    let icon: String
    let levelRange: Range<Int>
    let accentHex: String

    var levelCount: Int { levelRange.count }
    var firstLevel: Int { levelRange.lowerBound }

    static let all: [World] = [
        World(id: 0, name: "Spark", subtitle: "First Contact", icon: "bolt.fill", levelRange: 0..<20, accentHex: "5BC0EB"),
        World(id: 1, name: "Pulse", subtitle: "Building Momentum", icon: "waveform.path", levelRange: 20..<40, accentHex: "FDE74C"),
        World(id: 2, name: "Wave", subtitle: "Cascading Power", icon: "water.waves", levelRange: 40..<60, accentHex: "9B5DE5"),
        World(id: 3, name: "Storm", subtitle: "Unstable Elements", icon: "cloud.bolt.fill", levelRange: 60..<80, accentHex: "F15BB5"),
        World(id: 4, name: "Supernova", subtitle: "Total Annihilation", icon: "sparkles", levelRange: 80..<100, accentHex: "FF6B35"),
    ]

    static func worldForLevel(_ level: Int) -> World {
        all.first { $0.levelRange.contains(level) } ?? all[0]
    }

    static func localIndex(forLevel level: Int) -> Int {
        let world = worldForLevel(level)
        return level - world.firstLevel
    }
}
