import Foundation

enum DriftMode: Hashable {
    case mix(index: Int)
    case daily
    case freeform
}
