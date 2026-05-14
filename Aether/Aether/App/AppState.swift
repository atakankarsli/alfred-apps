import SwiftUI
import Observation

@Observable
final class AppState {
    var path = NavigationPath()
    var selectedThemeId: String = "aether"

    var currentTheme: Theme {
        Themes.theme(for: selectedThemeId)
    }

    func navigate(to route: Route) {
        path.append(route)
    }

    func popToRoot() {
        path = NavigationPath()
    }
}
