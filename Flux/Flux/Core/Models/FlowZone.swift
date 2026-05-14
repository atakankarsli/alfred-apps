import SwiftUI

enum FlowZone: String, CaseIterable, Identifiable, Sendable {
    case ripple, current, cascade, vortex, tsunami

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .ripple: "Ripple"; case .current: "Current"; case .cascade: "Cascade"
        case .vortex: "Vortex"; case .tsunami: "Tsunami"
        }
    }

    var icon: String {
        switch self {
        case .ripple: "water.waves"; case .current: "wind"; case .cascade: "arrow.down.to.line"
        case .vortex: "tornado"; case .tsunami: "tropicalstorm"
        }
    }

    var color: Color {
        switch self {
        case .ripple: Color(hex: "00D4FF"); case .current: Color(hex: "00FF88")
        case .cascade: Color(hex: "FF6B6B"); case .vortex: Color(hex: "FF00FF")
        case .tsunami: Color(hex: "FFD700")
        }
    }

    var levelRange: Range<Int> {
        switch self {
        case .ripple: 0..<16; case .current: 16..<32; case .cascade: 32..<48
        case .vortex: 48..<64; case .tsunami: 64..<80
        }
    }

    var particleCount: Int {
        switch self {
        case .ripple: 80; case .current: 120; case .cascade: 160
        case .vortex: 200; case .tsunami: 250
        }
    }
}
