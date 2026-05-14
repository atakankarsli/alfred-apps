import Foundation

enum Route: Hashable {
    case home
    case imprint(mode: ImprintMode)
    case settings
    case themePicker
    case achievements
    case stats
    case momentMap
}
