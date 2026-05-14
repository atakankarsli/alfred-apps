import SwiftUI

struct Season: Identifiable {
    let id: Int
    let name: String
    let subtitle: String
    let icon: String
    let trackRange: Range<Int>
    let accentHex: String

    var trackCount: Int { trackRange.count }
    var firstTrack: Int { trackRange.lowerBound }

    static let all: [Season] = [
        Season(id: 0, name: "Metronome", subtitle: "Basic Rhythms", icon: "metronome.fill",
               trackRange: 0..<16, accentHex: "FF6B6B"),
        Season(id: 1, name: "Syncopation", subtitle: "Off-beat Patterns", icon: "waveform.path",
               trackRange: 16..<32, accentHex: "6B7FD6"),
        Season(id: 2, name: "Polyrhythm", subtitle: "Cross Rhythms", icon: "waveform.badge.plus",
               trackRange: 32..<48, accentHex: "4CAF50"),
        Season(id: 3, name: "Crescendo", subtitle: "Rising Tempo", icon: "arrow.up.right",
               trackRange: 48..<64, accentHex: "FF9800"),
        Season(id: 4, name: "Virtuoso", subtitle: "Master the Flow", icon: "star.fill",
               trackRange: 64..<80, accentHex: "9C27B0"),
    ]

    static func seasonForTrack(_ idx: Int) -> Season {
        all.first { $0.trackRange.contains(idx) } ?? all[0]
    }

    static func localIndex(forTrack idx: Int) -> Int {
        let season = seasonForTrack(idx)
        return idx - season.firstTrack
    }
}
