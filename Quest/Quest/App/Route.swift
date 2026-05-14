import Foundation

enum Route: Hashable {
    case mission(index: Int)
    case daily
    case freeRoam
    case settings
    case themePicker
    case achievements
    case stats
    case regionMap
    case journal
}
