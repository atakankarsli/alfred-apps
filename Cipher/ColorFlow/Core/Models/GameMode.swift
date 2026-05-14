import Foundation

enum CipherMode: Hashable {
    case decrypt(index: Int)
    case daily
    case quickCrack
}
