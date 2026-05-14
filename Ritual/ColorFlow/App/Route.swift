import Foundation

enum Route: Hashable {
    case home
    case ritual(mode: RitualMode)
    case settings
    case themePicker
    case achievements
    case stats
    case phaseMap
}
