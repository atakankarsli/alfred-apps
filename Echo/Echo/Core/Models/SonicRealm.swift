import SwiftUI

enum SonicRealm: Int, CaseIterable, Identifiable, Hashable {
    case tones = 0
    case melody = 1
    case rhythm = 2
    case harmony = 3
    case chaos = 4

    var id: Int { rawValue }

    var displayName: String {
        switch self {
        case .tones: "Tones"
        case .melody: "Melody"
        case .rhythm: "Rhythm"
        case .harmony: "Harmony"
        case .chaos: "Chaos"
        }
    }

    var subtitle: String {
        switch self {
        case .tones: "Pure sine wave sequences"
        case .melody: "Piano note patterns"
        case .rhythm: "Percussion beats"
        case .harmony: "Chord progressions"
        case .chaos: "Mixed sound madness"
        }
    }

    var icon: String {
        switch self {
        case .tones: "waveform"
        case .melody: "pianokeys"
        case .rhythm: "drum.fill"
        case .harmony: "music.quarternote.3"
        case .chaos: "waveform.path.ecg"
        }
    }

    var color: Color {
        switch self {
        case .tones: Color(hex: "4FC3F7")
        case .melody: Color(hex: "FF7043")
        case .rhythm: Color(hex: "FFD740")
        case .harmony: Color(hex: "69F0AE")
        case .chaos: Color(hex: "E040FB")
        }
    }

    var buttonCount: Int {
        switch self {
        case .tones: 4
        case .melody: 6
        case .rhythm: 4
        case .harmony: 5
        case .chaos: 8
        }
    }

    var levelsPerRealm: Int { 16 }
    var levelRange: Range<Int> { (rawValue * 16)..<((rawValue + 1) * 16) }
}
