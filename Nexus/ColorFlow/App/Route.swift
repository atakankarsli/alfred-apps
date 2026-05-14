import Foundation

enum Route: Hashable {
    case home
    case nexus(mode: NexusMode)
    case settings
    case themePicker
    case achievements
    case stats
    case clusterMap
}
