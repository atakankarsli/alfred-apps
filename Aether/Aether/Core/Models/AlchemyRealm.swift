import Foundation

enum AlchemyRealm: Int, CaseIterable, Sendable {
    case primordial = 0
    case nature = 1
    case civilization = 2
    case arcane = 3
    case cosmos = 4

    var name: String {
        switch self {
        case .primordial: "Primordial"
        case .nature: "Nature"
        case .civilization: "Civilization"
        case .arcane: "Arcane"
        case .cosmos: "Cosmos"
        }
    }

    var icon: String {
        switch self {
        case .primordial: "drop.fill"
        case .nature: "leaf.fill"
        case .civilization: "building.2.fill"
        case .arcane: "sparkles"
        case .cosmos: "star.fill"
        }
    }

    var subtitle: String {
        switch self {
        case .primordial: "The four classical elements"
        case .nature: "Life, growth, and terrain"
        case .civilization: "Tools, structures, and craft"
        case .arcane: "Mystery, magic, and energy"
        case .cosmos: "Stars, void, and the infinite"
        }
    }

    var levelRange: Range<Int> {
        let start = rawValue * 16
        return start..<(start + 16)
    }
}
