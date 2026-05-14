import Foundation

enum Route: Hashable {
    case puzzle(index: Int)
    case sandbox
    case settings
    case themePicker
    case achievements
    case stats
}
