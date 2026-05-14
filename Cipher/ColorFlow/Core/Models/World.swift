import SwiftUI

struct Vault: Identifiable {
    let id: Int
    let name: String
    let subtitle: String
    let icon: String
    let levelRange: Range<Int>
    let accentHex: String

    var levelCount: Int { levelRange.count }
    var firstLevel: Int { levelRange.lowerBound }

    static let all: [Vault] = [
        Vault(id: 0, name: "Ancient Scrolls", subtitle: "Caesar & Atbash", icon: "scroll.fill", levelRange: 0..<20, accentHex: "C9A96E"),
        Vault(id: 1, name: "Secret Society", subtitle: "Substitution & ROT13", icon: "eye.trianglebadge.exclamationmark.fill", levelRange: 20..<40, accentHex: "8B5CF6"),
        Vault(id: 2, name: "War Room", subtitle: "Rail Fence & Keyword", icon: "shield.checkered", levelRange: 40..<60, accentHex: "EF4444"),
        Vault(id: 3, name: "Enigma Lab", subtitle: "Vigenère & Columnar", icon: "gearshape.2.fill", levelRange: 60..<80, accentHex: "06B6D4"),
    ]

    static func vaultForLevel(_ level: Int) -> Vault {
        all.first { $0.levelRange.contains(level) } ?? all[0]
    }

    static func localIndex(forLevel level: Int) -> Int {
        let vault = vaultForLevel(level)
        return level - vault.firstLevel
    }
}
