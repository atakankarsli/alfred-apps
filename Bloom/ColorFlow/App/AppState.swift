import SwiftUI

@MainActor
@Observable
final class AppState {
    var navigationPath = NavigationPath()
    var currentThemeId: String = "dawn"
    var selectedTab: Tab = .home

    enum Tab: Int, CaseIterable {
        case home
        case settings
    }

    func navigate(to route: Route) {
        navigationPath.append(route)
    }

    func navigateInCurrentTab(to route: Route) {
        navigationPath.append(route)
    }

    func popToRoot() {
        navigationPath = NavigationPath()
    }

    func pop() {
        if !navigationPath.isEmpty { navigationPath.removeLast() }
    }
}
