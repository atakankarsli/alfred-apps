import Foundation

enum GameMode: Hashable {
    case level(index: Int)
    case daily
    case infinite
}
