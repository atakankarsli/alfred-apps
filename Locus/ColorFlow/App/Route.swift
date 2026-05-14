import Foundation

enum Route: Hashable {
    case home
    case locus(mode: LocusMode)
    case settings
    case themePicker
    case achievements
    case stats
    case palaceMap
}
