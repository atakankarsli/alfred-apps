import Foundation

enum Route: Hashable {
    case home
    case play(levelIndex: Int)
    case endless
    case dailyScroll
    case quiz
    case worlds
    case settings
    case themePicker
    case achievements
    case stats
}
