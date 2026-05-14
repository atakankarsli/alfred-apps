import SwiftUI

struct Season: Identifiable {
    let id: Int
    let name: String
    let subtitle: String
    let icon: String
    let challengeRange: Range<Int>
    let accentHex: String
    let modes: [ChallengeMode]

    var challengeCount: Int { challengeRange.count }
    var firstChallenge: Int { challengeRange.lowerBound }

    static let all: [Season] = [
        Season(id: 0, name: "Spark", subtitle: "Finding Inspiration", icon: "sparkle", challengeRange: 0..<16,
               accentHex: "E85D3A", modes: [.sketch, .write]),
        Season(id: 1, name: "Flow", subtitle: "Building Momentum", icon: "wind", challengeRange: 16..<32,
               accentHex: "6B7FD6", modes: [.sketch, .write, .photo]),
        Season(id: 2, name: "Bloom", subtitle: "Creative Growth", icon: "leaf.fill", challengeRange: 32..<48,
               accentHex: "4CAF50", modes: [.sketch, .write, .photo, .sound]),
        Season(id: 3, name: "Storm", subtitle: "Bold Expression", icon: "bolt.fill", challengeRange: 48..<64,
               accentHex: "FF9800", modes: [.sketch, .write, .photo, .sound]),
        Season(id: 4, name: "Opus", subtitle: "Master Creator", icon: "star.fill", challengeRange: 64..<80,
               accentHex: "9C27B0", modes: ChallengeMode.allCases),
    ]

    static func seasonForChallenge(_ idx: Int) -> Season {
        all.first { $0.challengeRange.contains(idx) } ?? all[0]
    }

    static func localIndex(forChallenge idx: Int) -> Int {
        let season = seasonForChallenge(idx)
        return idx - season.firstChallenge
    }
}
