import SwiftUI

enum ShapeRealm: Int, CaseIterable, Identifiable, Hashable {
    case prisms = 0
    case polygons = 1
    case fractals = 2
    case symmetry = 3
    case chaos = 4

    var id: Int { rawValue }

    var displayName: String {
        switch self {
        case .prisms: "Prisms"
        case .polygons: "Polygons"
        case .fractals: "Fractals"
        case .symmetry: "Symmetry"
        case .chaos: "Chaos"
        }
    }

    var subtitle: String {
        switch self {
        case .prisms: "Basic shape transforms"
        case .polygons: "Multi-sided morphing"
        case .fractals: "Recursive patterns"
        case .symmetry: "Mirror & reflect"
        case .chaos: "All tools, no mercy"
        }
    }

    var icon: String {
        switch self {
        case .prisms: "triangle.fill"
        case .polygons: "hexagon.fill"
        case .fractals: "seal.fill"
        case .symmetry: "arrow.left.and.right"
        case .chaos: "burst.fill"
        }
    }

    var color: Color {
        switch self {
        case .prisms: Color(hex: "4FC3F7")
        case .polygons: Color(hex: "69F0AE")
        case .fractals: Color(hex: "E040FB")
        case .symmetry: Color(hex: "FF7043")
        case .chaos: Color(hex: "FF5252")
        }
    }

    var levelsPerRealm: Int { 16 }
    var levelRange: Range<Int> { (rawValue * 16)..<((rawValue + 1) * 16) }
}
