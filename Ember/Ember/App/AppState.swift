import SwiftUI

@MainActor
@Observable
final class AppState {
    var path = NavigationPath()
    var currentThemeId: String = "ember"

    func navigate(to route: Route) {
        path.append(route)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
}
