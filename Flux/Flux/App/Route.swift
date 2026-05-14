import Foundation

enum Route: Hashable {
    case flow(element: FluidElement, level: Int)
    case dailyFlow
    case freePlay(element: FluidElement)
    case settings
    case themePicker
    case achievements
    case stats
    case elementMap
    case gallery
}
