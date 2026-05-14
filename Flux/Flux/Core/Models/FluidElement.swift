import SwiftUI

enum FluidElement: String, CaseIterable, Identifiable, Sendable {
    case water, lava, plasma, mercury, ether

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .water: "Water"; case .lava: "Lava"; case .plasma: "Plasma"
        case .mercury: "Mercury"; case .ether: "Ether"
        }
    }

    var icon: String {
        switch self {
        case .water: "drop.fill"; case .lava: "flame.fill"; case .plasma: "bolt.fill"
        case .mercury: "circle.fill"; case .ether: "sparkles"
        }
    }

    var baseColor: Color {
        switch self {
        case .water: Color(hex: "00D4FF"); case .lava: Color(hex: "FF4500")
        case .plasma: Color(hex: "FF00FF"); case .mercury: Color(hex: "C0C0C0")
        case .ether: Color(hex: "00FF88")
        }
    }

    var viscosity: Double {
        switch self {
        case .water: 0.3; case .lava: 0.8; case .plasma: 0.1
        case .mercury: 0.5; case .ether: 0.2
        }
    }

    var particleSize: CGFloat {
        switch self {
        case .water: 6; case .lava: 10; case .plasma: 4
        case .mercury: 8; case .ether: 5
        }
    }

    var trailLength: Int {
        switch self {
        case .water: 8; case .lava: 12; case .plasma: 15
        case .mercury: 6; case .ether: 20
        }
    }
}
