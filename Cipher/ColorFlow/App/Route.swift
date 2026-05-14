import Foundation

enum Route: Hashable {
    case home
    case cipher(mode: CipherMode)
    case settings
    case themePicker
    case achievements
    case stats
    case vaultMap
}
