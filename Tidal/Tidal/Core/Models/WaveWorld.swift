import SwiftUI

enum WaveWorld: Int, CaseIterable, Identifiable, Hashable {
    case ripples = 0
    case echoes = 1
    case resonance = 2
    case harmonics = 3
    case chaos = 4

    var id: Int { rawValue }

    var displayName: String {
        switch self {
        case .ripples: "Ripples"
        case .echoes: "Echoes"
        case .resonance: "Resonance"
        case .harmonics: "Harmonics"
        case .chaos: "Chaos"
        }
    }

    var subtitle: String {
        switch self {
        case .ripples: "Single source basics"
        case .echoes: "Reflections & interference"
        case .resonance: "Frequency matching"
        case .harmonics: "Multi-source patterns"
        case .chaos: "Obstacles & diffraction"
        }
    }

    var icon: String {
        switch self {
        case .ripples: "drop.fill"
        case .echoes: "wave.3.right"
        case .resonance: "tuningfork"
        case .harmonics: "waveform.path.ecg"
        case .chaos: "tornado"
        }
    }

    var color: Color {
        switch self {
        case .ripples: Color(hex: "4FC3F7")
        case .echoes: Color(hex: "7C4DFF")
        case .resonance: Color(hex: "FFD740")
        case .harmonics: Color(hex: "00E676")
        case .chaos: Color(hex: "FF5252")
        }
    }

    var levelsPerWorld: Int { 16 }
    var levelRange: Range<Int> { (rawValue * 16)..<((rawValue + 1) * 16) }
}
