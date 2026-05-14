import SwiftUI

@MainActor
@Observable
final class AppState {
    var navigationPath = NavigationPath()
    var currentThemeId: String = "parchment"

    func navigate(to route: Route) { navigationPath.append(route) }
    func navigateInCurrentTab(to route: Route) { navigationPath.append(route) }
    func popToRoot() { navigationPath = NavigationPath() }
    func pop() { if !navigationPath.isEmpty { navigationPath.removeLast() } }
}
