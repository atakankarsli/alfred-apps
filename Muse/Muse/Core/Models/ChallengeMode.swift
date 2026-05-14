import SwiftUI

enum ChallengeMode: String, CaseIterable, Identifiable, Codable {
    case sketch
    case write
    case photo
    case sound
    case remix

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .sketch: "Sketch"
        case .write: "Write"
        case .photo: "Snap"
        case .sound: "Hum"
        case .remix: "Remix"
        }
    }

    var icon: String {
        switch self {
        case .sketch: "pencil.tip"
        case .write: "text.cursor"
        case .photo: "camera.fill"
        case .sound: "waveform"
        case .remix: "arrow.triangle.2.circlepath"
        }
    }

    var color: Color {
        switch self {
        case .sketch: Color(hex: "E85D3A")
        case .write: Color(hex: "6B7FD6")
        case .photo: Color(hex: "4CAF50")
        case .sound: Color(hex: "FF9800")
        case .remix: Color(hex: "9C27B0")
        }
    }

    var verb: String {
        switch self {
        case .sketch: "Draw"
        case .write: "Write"
        case .photo: "Photograph"
        case .sound: "Record"
        case .remix: "Reimagine"
        }
    }

    var timeLimit: Int {
        switch self {
        case .sketch: 60
        case .write: 60
        case .photo: 60
        case .sound: 60
        case .remix: 90
        }
    }
}
