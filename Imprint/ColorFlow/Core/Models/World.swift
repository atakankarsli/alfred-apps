import SwiftUI

struct Moment: Identifiable {
    let id: String
    let name: String
    let icon: String
    let accentHex: String
    let levelRange: Range<Int>

    var puzzleRange: Range<Int> { levelRange }

    static let all: [Moment] = [
        Moment(id: "dawn", name: "Dawn", icon: "sunrise.fill", accentHex: "FFA62B", levelRange: 0..<20),
        Moment(id: "golden", name: "Golden Hour", icon: "sun.max.fill", accentHex: "FFD93D", levelRange: 20..<40),
        Moment(id: "twilight", name: "Twilight", icon: "sunset.fill", accentHex: "FF6B6B", levelRange: 40..<60),
        Moment(id: "midnight", name: "Midnight", icon: "moon.stars.fill", accentHex: "9B5DE5", levelRange: 60..<80),
    ]

    static func momentForPuzzle(_ index: Int) -> MomentType {
        switch index {
        case 0..<20: return .dawn
        case 20..<40: return .golden
        case 40..<60: return .twilight
        default: return .midnight
        }
    }

    static func localIndex(for puzzleIndex: Int) -> Int {
        return puzzleIndex % 20
    }
}
