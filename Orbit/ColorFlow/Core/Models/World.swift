import SwiftUI

struct Sector: Identifiable {
    let id: Int
    let name: String
    let subtitle: String
    let icon: String
    let levelRange: Range<Int>
    let accentHex: String

    var levelCount: Int { levelRange.count }
    var firstLevel: Int { levelRange.lowerBound }

    static let all: [Sector] = [
        Sector(id: 0, name: "Inner System", subtitle: "Simple Orbits", icon: "sun.max.fill", levelRange: 0..<16, accentHex: "F59E0B"),
        Sector(id: 1, name: "Asteroid Belt", subtitle: "Tight Passages", icon: "circle.hexagongrid.fill", levelRange: 16..<32, accentHex: "6B7280"),
        Sector(id: 2, name: "Gas Giants", subtitle: "Multi-Body Gravity", icon: "globe.americas.fill", levelRange: 32..<48, accentHex: "8B5CF6"),
        Sector(id: 3, name: "Binary Stars", subtitle: "Dual Pull Systems", icon: "star.leadinghalf.filled", levelRange: 48..<64, accentHex: "EF4444"),
        Sector(id: 4, name: "Dark Matter", subtitle: "Invisible Forces", icon: "moon.stars.fill", levelRange: 64..<80, accentHex: "3B82F6"),
    ]

    static func worldForLevel(_ level: Int) -> Sector {
        all.first { $0.levelRange.contains(level) } ?? all[0]
    }

    static func localIndex(forLevel level: Int) -> Int {
        let world = worldForLevel(level)
        return level - world.firstLevel
    }
}
