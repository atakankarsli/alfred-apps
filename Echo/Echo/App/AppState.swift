import SwiftUI

@MainActor
@Observable
final class AppState {
    var navigationPath = NavigationPath()
    var currentThemeId: String = "neongrid"

    func navigate(to route: Route) { navigationPath.append(route) }
    func pop() { if !navigationPath.isEmpty { navigationPath.removeLast() } }
    func popToRoot() { navigationPath = NavigationPath() }
}
