import Foundation

enum Route: Hashable {
    case home
    case play(levelIndex: Int)
    case endless
    case dailySky
    case quiz
    case worlds
    case settings
    case themePicker
    case achievements
    case stats
}
