import Foundation

enum Route: Hashable {
    case home
    case play(levelIndex: Int)
    case daily
    case worlds
    case settings
    case themePicker
    case achievements
    case stats
}
