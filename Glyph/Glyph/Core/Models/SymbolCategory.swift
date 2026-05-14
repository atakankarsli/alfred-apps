import SwiftUI

enum SymbolCategory: String, CaseIterable, Identifiable, Codable {
    case runes
    case hieroglyphs
    case kanji
    case geometry
    case alchemy

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .runes: "Runes"
        case .hieroglyphs: "Hieroglyphs"
        case .kanji: "Kanji"
        case .geometry: "Sacred Geometry"
        case .alchemy: "Alchemy"
        }
    }

    var icon: String {
        switch self {
        case .runes: "shield.fill"
        case .hieroglyphs: "building.columns.fill"
        case .kanji: "character.ja"
        case .geometry: "hexagon.fill"
        case .alchemy: "flame.fill"
        }
    }

    var color: Color {
        switch self {
        case .runes: Color(hex: "5A6A7A")
        case .hieroglyphs: Color(hex: "C49A2A")
        case .kanji: Color(hex: "CC3333")
        case .geometry: Color(hex: "4A8EB5")
        case .alchemy: Color(hex: "7B4DFF")
        }
    }

    var subtitle: String {
        switch self {
        case .runes: "Norse Elder Futhark"
        case .hieroglyphs: "Ancient Egyptian"
        case .kanji: "Japanese Characters"
        case .geometry: "Mystical Patterns"
        case .alchemy: "Elemental Symbols"
        }
    }

    var challengeRange: Range<Int> {
        switch self {
        case .runes: 0..<16
        case .hieroglyphs: 16..<32
        case .kanji: 32..<48
        case .geometry: 48..<64
        case .alchemy: 64..<80
        }
    }

    var challengeCount: Int { challengeRange.count }
    var firstChallenge: Int { challengeRange.lowerBound }

    static func categoryForChallenge(_ idx: Int) -> SymbolCategory {
        allCases.first { $0.challengeRange.contains(idx) } ?? .runes
    }

    static func localIndex(forChallenge idx: Int) -> Int {
        let cat = categoryForChallenge(idx)
        return idx - cat.firstChallenge
    }
}
