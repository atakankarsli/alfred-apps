import Foundation

enum Route: Hashable {
    case challenge(index: Int)
    case daily
    case freeCreate
    case settings
    case themePicker
    case achievements
    case stats
    case seasonMap
    case gallery
}
