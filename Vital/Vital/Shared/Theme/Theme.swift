import SwiftUI

struct Theme: Identifiable, Sendable, Equatable, Hashable {
    let id: String
    let name: String
    let colors: ThemeColors
    let isDark: Bool
    let gradientColors: [Color]
    let iconName: String
    var gradient: LinearGradient { LinearGradient(colors: gradientColors, startPoint: .top, endPoint: .bottom) }
    static func == (lhs: Theme, rhs: Theme) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}
