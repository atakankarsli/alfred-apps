import Foundation

enum SkyRealm: Int, CaseIterable, Sendable {
    case zodiac = 0
    case mythical = 1
    case animals = 2
    case ancient = 3
    case modern = 4

    var name: String {
        switch self {
        case .zodiac: "Zodiac"
        case .mythical: "Mythical"
        case .animals: "Animals"
        case .ancient: "Ancient"
        case .modern: "Modern"
        }
    }

    var icon: String {
        switch self {
        case .zodiac: "sparkles"
        case .mythical: "shield.fill"
        case .animals: "hare.fill"
        case .ancient: "scroll.fill"
        case .modern: "telescope.fill"
        }
    }

    var subtitle: String {
        switch self {
        case .zodiac: "The 12 zodiac constellations"
        case .mythical: "Heroes and legends of the sky"
        case .animals: "Creatures among the stars"
        case .ancient: "Ptolemy's celestial catalog"
        case .modern: "IAU recognized patterns"
        }
    }

    var levelRange: Range<Int> {
        let start = rawValue * 16
        return start..<(start + 16)
    }
}
