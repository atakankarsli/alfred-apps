import Foundation

enum Route: Hashable {
    case home
    case verse(mode: VerseMode)
    case settings
    case themePicker
    case achievements
    case stats
    case chapterMap
}
