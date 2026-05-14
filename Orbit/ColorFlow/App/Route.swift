import Foundation

enum Route: Hashable {
    case home
    case orbit(mode: OrbitMode)
    case settings
    case themePicker
    case achievements
    case stats
    case sectorMap
}
