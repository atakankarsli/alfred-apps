import SwiftUI

enum GameType: String, CaseIterable, Identifiable, Codable, Hashable {
    case eyeFocus
    case breathSync
    case reflexRush
    case postureCheck

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .eyeFocus: "Eye Focus"
        case .breathSync: "Breath Sync"
        case .reflexRush: "Reflex Rush"
        case .postureCheck: "Posture Check"
        }
    }

    var icon: String {
        switch self {
        case .eyeFocus: "eye.fill"
        case .breathSync: "wind"
        case .reflexRush: "bolt.fill"
        case .postureCheck: "figure.stand"
        }
    }

    var color: Color {
        switch self {
        case .eyeFocus: Color(hex: "5B8DEF")
        case .breathSync: Color(hex: "4CAF50")
        case .reflexRush: Color(hex: "FF9800")
        case .postureCheck: Color(hex: "AB47BC")
        }
    }

    var subtitle: String {
        switch self {
        case .eyeFocus: "Track the moving target"
        case .breathSync: "Match the breathing rhythm"
        case .reflexRush: "Tap as fast as you can"
        case .postureCheck: "Hold the balance"
        }
    }

    var durationSeconds: Int {
        switch self {
        case .eyeFocus: 120
        case .breathSync: 120
        case .reflexRush: 60
        case .postureCheck: 90
        }
    }
}
