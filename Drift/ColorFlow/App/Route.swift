import Foundation

enum Route: Hashable {
    case home
    case drift(mode: DriftMode)
    case settings
    case themePicker
    case achievements
    case stats
    case soundscapeMap
}
