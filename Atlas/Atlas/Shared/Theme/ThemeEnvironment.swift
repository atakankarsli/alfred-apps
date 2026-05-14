import SwiftUI

private struct ThemeKey: EnvironmentKey { static let defaultValue: Theme = Themes.default }
extension EnvironmentValues {
    var theme: Theme { get { self[ThemeKey.self] } set { self[ThemeKey.self] = newValue } }
}
extension View {
    func theme(_ theme: Theme) -> some View {
        environment(\.theme, theme).environment(\.colorScheme, theme.isDark ? .dark : .light)
    }
}
