import SwiftUI

enum MissionType: String, CaseIterable, Identifiable, Codable {
    case explore
    case photo
    case checkpoint
    case discover
    case observe

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .explore: "Explore"
        case .photo: "Photo"
        case .checkpoint: "Checkpoint"
        case .discover: "Discover"
        case .observe: "Observe"
        }
    }

    var icon: String {
        switch self {
        case .explore: "figure.walk"
        case .photo: "camera.fill"
        case .checkpoint: "mappin.and.ellipse"
        case .discover: "sparkle.magnifyingglass"
        case .observe: "eye.fill"
        }
    }

    var color: Color {
        switch self {
        case .explore: Color(hex: "4CAF50")
        case .photo: Color(hex: "FF9800")
        case .checkpoint: Color(hex: "2196F3")
        case .discover: Color(hex: "9C27B0")
        case .observe: Color(hex: "00BCD4")
        }
    }

    func color(_ theme: Theme) -> Color { color }

    var verb: String {
        switch self {
        case .explore: "Wander"
        case .photo: "Capture"
        case .checkpoint: "Reach"
        case .discover: "Find"
        case .observe: "Watch"
        }
    }
}
