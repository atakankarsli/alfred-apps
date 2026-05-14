import Foundation

enum Route: Hashable {
    case home
    case trace(mode: TraceMode)
    case settings
    case themePicker
    case achievements
    case stats
    case zoneMap
}
