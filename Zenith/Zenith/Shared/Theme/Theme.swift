import SwiftUI

struct Theme: Identifiable, Sendable {
    let id: String
    let name: String
    let isDark: Bool
    let gradientColors: [Color]
    let iconName: String
    let colors: ThemeColors

    var gradient: LinearGradient {
        LinearGradient(
            colors: gradientColors,
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

extension Theme: Equatable {
    static func == (lhs: Theme, rhs: Theme) -> Bool { lhs.id == rhs.id }
}

extension Theme: Hashable {
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}
