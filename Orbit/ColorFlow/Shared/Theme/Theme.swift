import SwiftUI

enum NumberFont: String, CaseIterable, Codable, Sendable {
    case `default`
    case serif
    case monospace
    case rounded
    case handwritten

    var fontDesign: Font.Design {
        switch self {
        case .default: .default
        case .serif: .serif
        case .monospace: .default
        case .rounded: .rounded
        case .handwritten: .serif
        }
    }

    var fontName: String? {
        switch self {
        case .monospace: "Menlo"
        case .handwritten: "Noteworthy"
        default: nil
        }
    }

    var displayName: String {
        switch self {
        case .default: "Default"
        case .serif: "Serif"
        case .monospace: "Monospace"
        case .rounded: "Rounded"
        case .handwritten: "Handwritten"
        }
    }
}

struct Theme: Identifiable, Sendable {
    let id: String
    let name: String
    let colors: ThemeColors
    let numberFont: NumberFont
    let isDark: Bool
    let gradientColors: [Color]
    let iconName: String
    let patternOpacity: Double

    var gradient: LinearGradient {
        LinearGradient(
            colors: gradientColors,
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

extension Theme: Equatable {
    static func == (lhs: Theme, rhs: Theme) -> Bool {
        lhs.id == rhs.id
    }
}

extension Theme: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
