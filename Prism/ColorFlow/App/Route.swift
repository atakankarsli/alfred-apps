import Foundation

enum Route: Hashable {
    case home
    case prism(mode: PrismMode)
    case settings
    case themePicker
    case achievements
    case stats
    case spectrumMap
}
