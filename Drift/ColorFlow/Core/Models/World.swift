import SwiftUI

struct SoundWorld: Identifiable {
    let id: Int
    let name: String
    let subtitle: String
    let icon: String
    let levelRange: Range<Int>
    let accentHex: String

    var levelCount: Int { levelRange.count }
    var firstLevel: Int { levelRange.lowerBound }

    static let all: [SoundWorld] = [
        SoundWorld(id: 0, name: "Nature", subtitle: "Rain, Wind & Wildlife", icon: "leaf.fill", levelRange: 0..<16, accentHex: "22C55E"),
        SoundWorld(id: 1, name: "Urban", subtitle: "City, Café & Transit", icon: "building.2.fill", levelRange: 16..<32, accentHex: "8B5CF6"),
        SoundWorld(id: 2, name: "Space", subtitle: "Cosmos & Beyond", icon: "sparkles", levelRange: 32..<48, accentHex: "06B6D4"),
        SoundWorld(id: 3, name: "Indoor", subtitle: "Home & Comfort", icon: "house.fill", levelRange: 48..<64, accentHex: "F59E0B"),
        SoundWorld(id: 4, name: "Mystic", subtitle: "Temple & Meditation", icon: "moon.stars.fill", levelRange: 64..<80, accentHex: "EC4899"),
    ]

    static func worldForLevel(_ level: Int) -> SoundWorld {
        all.first { $0.levelRange.contains(level) } ?? all[0]
    }

    static func localIndex(forLevel level: Int) -> Int {
        let world = worldForLevel(level)
        return level - world.firstLevel
    }
}
