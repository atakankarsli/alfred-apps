import SwiftUI

private struct ThemeKey: EnvironmentKey {
    static let defaultValue: Theme = Themes.default
}

private struct ThemeManagerKey: @preconcurrency EnvironmentKey {
    @MainActor static let defaultValue = ThemeManager()
}

extension EnvironmentValues {
    var theme: Theme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }

    var themeManager: ThemeManager {
        get { self[ThemeManagerKey.self] }
        set { self[ThemeManagerKey.self] = newValue }
    }
}

extension View {
    func theme(_ theme: Theme) -> some View {
        environment(\.theme, theme)
            .environment(\.colorScheme, theme.isDark ? .dark : .light)
    }
}
