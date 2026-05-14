import Foundation

enum Route: Hashable {
    case game(type: GameType)
    case dailyPlan
    case settings
    case themePicker
    case achievements
    case stats
}
