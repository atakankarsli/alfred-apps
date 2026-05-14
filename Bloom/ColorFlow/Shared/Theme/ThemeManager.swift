import SwiftUI

@MainActor
@Observable
final class ThemeManager {
    var currentTheme: Theme = Themes.default

    func setTheme(_ themeId: String) {
        currentTheme = Themes.theme(for: themeId)
    }

    func setTheme(_ theme: Theme) {
        currentTheme = theme
    }
}
