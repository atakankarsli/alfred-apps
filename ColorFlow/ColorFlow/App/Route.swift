import Foundation

enum Route: Hashable {
    case home
    case game(mode: GameMode)
    case settings
    case themePicker
    case achievements
    case stats
    case worldMap
}
