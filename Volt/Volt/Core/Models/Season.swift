import SwiftUI

struct Season: Identifiable {
    let id: Int
    let name: String
    let subtitle: String
    let icon: String
    let puzzleRange: Range<Int>
    let accentHex: String
    let availableComponents: [ComponentType]

    var puzzleCount: Int { puzzleRange.count }
    func color(_ theme: Theme) -> Color { Color(hex: accentHex) }

    static let all: [Season] = [
        Season(id: 0, name: "Basics", subtitle: "Signal Flow", icon: "bolt.fill",
               puzzleRange: 0..<16, accentHex: "FF9500",
               availableComponents: [.wire, .switchToggle, .led, .notGate]),
        Season(id: 1, name: "Logic", subtitle: "Gate Mastery", icon: "cpu.fill",
               puzzleRange: 16..<32, accentHex: "30D158",
               availableComponents: [.wire, .switchToggle, .led, .notGate, .andGate, .orGate]),
        Season(id: 2, name: "Advanced", subtitle: "Complex Routing", icon: "network",
               puzzleRange: 32..<48, accentHex: "0A84FF",
               availableComponents: [.wire, .switchToggle, .led, .notGate, .andGate, .orGate, .xorGate, .splitter]),
        Season(id: 3, name: "Master", subtitle: "Multi-Output", icon: "sparkles",
               puzzleRange: 48..<64, accentHex: "BF5AF2",
               availableComponents: ComponentType.allCases),
        Season(id: 4, name: "Expert", subtitle: "Circuit Sage", icon: "crown.fill",
               puzzleRange: 64..<80, accentHex: "FFD60A",
               availableComponents: ComponentType.allCases),
    ]

    static func seasonForPuzzle(_ index: Int) -> Season {
        all.first { $0.puzzleRange.contains(index) } ?? all[0]
    }
}
