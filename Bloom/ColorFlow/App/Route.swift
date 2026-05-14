import Foundation

enum Route: Hashable {
    case home
    case garden(mode: GardenMode)
    case settings
    case themePicker
    case achievements
    case stats
    case seasonMap
}
