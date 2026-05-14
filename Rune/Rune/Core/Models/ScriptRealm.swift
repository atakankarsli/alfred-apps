import Foundation

enum ScriptRealm: Int, CaseIterable, Sendable {
    case futhark = 0
    case hieroglyph = 1
    case cuneiform = 2
    case greek = 3
    case ogham = 4

    var name: String {
        switch self {
        case .futhark: "Futhark"
        case .hieroglyph: "Hieroglyph"
        case .cuneiform: "Cuneiform"
        case .greek: "Greek"
        case .ogham: "Ogham"
        }
    }

    var icon: String {
        switch self {
        case .futhark: "shield.lefthalf.filled"
        case .hieroglyph: "pyramid.fill"
        case .cuneiform: "square.grid.3x3.fill"
        case .greek: "building.columns.fill"
        case .ogham: "tree.fill"
        }
    }

    var subtitle: String {
        switch self {
        case .futhark: "Elder Futhark runes of the Norse"
        case .hieroglyph: "Sacred carvings of ancient Egypt"
        case .cuneiform: "Wedge writing of Sumer"
        case .greek: "Letters of ancient Hellas"
        case .ogham: "Tree alphabet of the Celts"
        }
    }

    var levelRange: Range<Int> {
        let start = rawValue * 16
        return start..<(start + 16)
    }
}
