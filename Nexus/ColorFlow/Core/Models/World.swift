import SwiftUI

struct WordRealm: Identifiable {
    let id: Int
    let name: String
    let subtitle: String
    let icon: String
    let levelRange: Range<Int>
    let accentHex: String

    var levelCount: Int { levelRange.count }
    var firstLevel: Int { levelRange.lowerBound }

    static let all: [WordRealm] = [
        WordRealm(id: 0, name: "Library", subtitle: "Common Connections", icon: "books.vertical.fill", levelRange: 0..<16, accentHex: "5BC0EB"),
        WordRealm(id: 1, name: "Laboratory", subtitle: "Scientific Links", icon: "flask.fill", levelRange: 16..<32, accentHex: "22C55E"),
        WordRealm(id: 2, name: "Observatory", subtitle: "Hidden Patterns", icon: "binoculars.fill", levelRange: 32..<48, accentHex: "A855F7"),
        WordRealm(id: 3, name: "Archive", subtitle: "Deep Associations", icon: "archivebox.fill", levelRange: 48..<64, accentHex: "F59E0B"),
        WordRealm(id: 4, name: "Nexus Core", subtitle: "Ultimate Mastery", icon: "brain.head.profile.fill", levelRange: 64..<80, accentHex: "EF4444"),
    ]

    static func worldForLevel(_ level: Int) -> WordRealm {
        all.first { $0.levelRange.contains(level) } ?? all[0]
    }

    static func localIndex(forLevel level: Int) -> Int {
        let world = worldForLevel(level)
        return level - world.firstLevel
    }
}
