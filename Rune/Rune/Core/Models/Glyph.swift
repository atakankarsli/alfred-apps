import Foundation

struct Glyph: Identifiable, Sendable {
    let id: String
    let symbol: String
    let latinLetter: String
    let name: String
}

struct DecodePuzzle: Sendable {
    let plainText: String
    let glyphs: [Glyph]
    let encodedPairs: [(glyph: Glyph, letter: Character)]
    let difficulty: Int

    var uniqueGlyphs: [Glyph] {
        var seen = Set<String>()
        return encodedPairs.compactMap { pair in
            guard seen.insert(pair.glyph.id).inserted else { return nil }
            return pair.glyph
        }
    }
}
