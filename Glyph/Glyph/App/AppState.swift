import SwiftUI

@MainActor
@Observable
final class AppState {
    var navigationPath = NavigationPath()
    var currentThemeId: String = "runestone"

    func navigate(to route: Route) {
        navigationPath.append(route)
    }

    func popToRoot() {
        navigationPath = NavigationPath()
    }

    func pop() {
        if !navigationPath.isEmpty { navigationPath.removeLast() }
    }
}
