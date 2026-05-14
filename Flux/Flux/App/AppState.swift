import SwiftUI
import SwiftData

@Observable
final class AppState {
    var currentTheme: Theme = Themes.default
    var path = NavigationPath()
    func loadTheme(from settings: SettingsRecord?) {
        let id = settings?.themeId ?? "liquid"
        currentTheme = Themes.all.first { $0.id == id } ?? Themes.default
    }
}
