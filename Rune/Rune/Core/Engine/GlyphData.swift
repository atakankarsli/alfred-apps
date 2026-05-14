import Foundation

enum GlyphData {
    static let futharkGlyphs: [Glyph] = [
        Glyph(id: "f1", symbol: "ᚠ", latinLetter: "F", name: "Fehu"),
        Glyph(id: "f2", symbol: "ᚢ", latinLetter: "U", name: "Uruz"),
        Glyph(id: "f3", symbol: "ᚦ", latinLetter: "TH", name: "Thurisaz"),
        Glyph(id: "f4", symbol: "ᚨ", latinLetter: "A", name: "Ansuz"),
        Glyph(id: "f5", symbol: "ᚱ", latinLetter: "R", name: "Raidho"),
        Glyph(id: "f6", symbol: "ᚲ", latinLetter: "K", name: "Kenaz"),
        Glyph(id: "f7", symbol: "ᚷ", latinLetter: "G", name: "Gebo"),
        Glyph(id: "f8", symbol: "ᚹ", latinLetter: "W", name: "Wunjo"),
        Glyph(id: "f9", symbol: "ᚺ", latinLetter: "H", name: "Hagalaz"),
        Glyph(id: "f10", symbol: "ᚾ", latinLetter: "N", name: "Naudiz"),
        Glyph(id: "f11", symbol: "ᛁ", latinLetter: "I", name: "Isaz"),
        Glyph(id: "f12", symbol: "ᛃ", latinLetter: "J", name: "Jera"),
        Glyph(id: "f13", symbol: "ᛈ", latinLetter: "P", name: "Perthro"),
        Glyph(id: "f14", symbol: "ᛉ", latinLetter: "Z", name: "Algiz"),
        Glyph(id: "f15", symbol: "ᛊ", latinLetter: "S", name: "Sowilo"),
        Glyph(id: "f16", symbol: "ᛏ", latinLetter: "T", name: "Tiwaz"),
        Glyph(id: "f17", symbol: "ᛒ", latinLetter: "B", name: "Berkanan"),
        Glyph(id: "f18", symbol: "ᛖ", latinLetter: "E", name: "Ehwaz"),
        Glyph(id: "f19", symbol: "ᛗ", latinLetter: "M", name: "Mannaz"),
        Glyph(id: "f20", symbol: "ᛚ", latinLetter: "L", name: "Laguz"),
        Glyph(id: "f21", symbol: "ᛜ", latinLetter: "NG", name: "Ingwaz"),
        Glyph(id: "f22", symbol: "ᛞ", latinLetter: "D", name: "Dagaz"),
        Glyph(id: "f23", symbol: "ᛟ", latinLetter: "O", name: "Othala"),
    ]

    static let hieroglyphGlyphs: [Glyph] = [
        Glyph(id: "h1", symbol: "𓄿", latinLetter: "A", name: "Vulture"),
        Glyph(id: "h2", symbol: "𓇋", latinLetter: "I", name: "Reed"),
        Glyph(id: "h3", symbol: "𓅱", latinLetter: "W", name: "Quail"),
        Glyph(id: "h4", symbol: "𓃀", latinLetter: "B", name: "Foot"),
        Glyph(id: "h5", symbol: "𓊪", latinLetter: "P", name: "Stool"),
        Glyph(id: "h6", symbol: "𓆑", latinLetter: "F", name: "Viper"),
        Glyph(id: "h7", symbol: "𓅓", latinLetter: "M", name: "Owl"),
        Glyph(id: "h8", symbol: "𓈖", latinLetter: "N", name: "Water"),
        Glyph(id: "h9", symbol: "𓂋", latinLetter: "R", name: "Mouth"),
        Glyph(id: "h10", symbol: "𓉔", latinLetter: "H", name: "Shelter"),
        Glyph(id: "h11", symbol: "𓎛", latinLetter: "X", name: "Wick"),
        Glyph(id: "h12", symbol: "𓋴", latinLetter: "S", name: "Cloth"),
        Glyph(id: "h13", symbol: "𓈎", latinLetter: "Q", name: "Slope"),
        Glyph(id: "h14", symbol: "𓎡", latinLetter: "K", name: "Basket"),
        Glyph(id: "h15", symbol: "𓏏", latinLetter: "T", name: "Bread"),
        Glyph(id: "h16", symbol: "𓂧", latinLetter: "D", name: "Hand"),
        Glyph(id: "h17", symbol: "𓆓", latinLetter: "G", name: "Jar"),
        Glyph(id: "h18", symbol: "𓃭", latinLetter: "L", name: "Lion"),
        Glyph(id: "h19", symbol: "𓇌", latinLetter: "Y", name: "Reeds"),
        Glyph(id: "h20", symbol: "𓊛", latinLetter: "J", name: "Snake"),
    ]

    static let cuneiformGlyphs: [Glyph] = [
        Glyph(id: "c1", symbol: "𒀀", latinLetter: "A", name: "A"),
        Glyph(id: "c2", symbol: "𒁀", latinLetter: "B", name: "BA"),
        Glyph(id: "c3", symbol: "𒁕", latinLetter: "D", name: "DA"),
        Glyph(id: "c4", symbol: "𒂊", latinLetter: "E", name: "E"),
        Glyph(id: "c5", symbol: "𒄀", latinLetter: "G", name: "GA"),
        Glyph(id: "c6", symbol: "𒄩", latinLetter: "H", name: "HA"),
        Glyph(id: "c7", symbol: "𒄿", latinLetter: "I", name: "I"),
        Glyph(id: "c8", symbol: "𒆠", latinLetter: "K", name: "KI"),
        Glyph(id: "c9", symbol: "𒇻", latinLetter: "L", name: "LA"),
        Glyph(id: "c10", symbol: "𒈠", latinLetter: "M", name: "MA"),
        Glyph(id: "c11", symbol: "𒈾", latinLetter: "N", name: "NA"),
        Glyph(id: "c12", symbol: "𒊑", latinLetter: "R", name: "RI"),
        Glyph(id: "c13", symbol: "𒊓", latinLetter: "S", name: "SA"),
        Glyph(id: "c14", symbol: "𒋗", latinLetter: "SH", name: "SHU"),
        Glyph(id: "c15", symbol: "𒌅", latinLetter: "T", name: "TU"),
        Glyph(id: "c16", symbol: "𒌋", latinLetter: "U", name: "U"),
        Glyph(id: "c17", symbol: "𒍣", latinLetter: "Z", name: "ZA"),
        Glyph(id: "c18", symbol: "𒉺", latinLetter: "P", name: "PA"),
        Glyph(id: "c19", symbol: "𒆳", latinLetter: "F", name: "KUR"),
        Glyph(id: "c20", symbol: "𒃻", latinLetter: "W", name: "GAL"),
    ]

    static let greekGlyphs: [Glyph] = [
        Glyph(id: "g1", symbol: "Α", latinLetter: "A", name: "Alpha"),
        Glyph(id: "g2", symbol: "Β", latinLetter: "B", name: "Beta"),
        Glyph(id: "g3", symbol: "Γ", latinLetter: "G", name: "Gamma"),
        Glyph(id: "g4", symbol: "Δ", latinLetter: "D", name: "Delta"),
        Glyph(id: "g5", symbol: "Ε", latinLetter: "E", name: "Epsilon"),
        Glyph(id: "g6", symbol: "Ζ", latinLetter: "Z", name: "Zeta"),
        Glyph(id: "g7", symbol: "Η", latinLetter: "H", name: "Eta"),
        Glyph(id: "g8", symbol: "Θ", latinLetter: "TH", name: "Theta"),
        Glyph(id: "g9", symbol: "Ι", latinLetter: "I", name: "Iota"),
        Glyph(id: "g10", symbol: "Κ", latinLetter: "K", name: "Kappa"),
        Glyph(id: "g11", symbol: "Λ", latinLetter: "L", name: "Lambda"),
        Glyph(id: "g12", symbol: "Μ", latinLetter: "M", name: "Mu"),
        Glyph(id: "g13", symbol: "Ν", latinLetter: "N", name: "Nu"),
        Glyph(id: "g14", symbol: "Ξ", latinLetter: "X", name: "Xi"),
        Glyph(id: "g15", symbol: "Ο", latinLetter: "O", name: "Omicron"),
        Glyph(id: "g16", symbol: "Π", latinLetter: "P", name: "Pi"),
        Glyph(id: "g17", symbol: "Ρ", latinLetter: "R", name: "Rho"),
        Glyph(id: "g18", symbol: "Σ", latinLetter: "S", name: "Sigma"),
        Glyph(id: "g19", symbol: "Τ", latinLetter: "T", name: "Tau"),
        Glyph(id: "g20", symbol: "Υ", latinLetter: "U", name: "Upsilon"),
        Glyph(id: "g21", symbol: "Φ", latinLetter: "F", name: "Phi"),
        Glyph(id: "g22", symbol: "Χ", latinLetter: "C", name: "Chi"),
        Glyph(id: "g23", symbol: "Ψ", latinLetter: "PS", name: "Psi"),
        Glyph(id: "g24", symbol: "Ω", latinLetter: "W", name: "Omega"),
    ]

    static let oghamGlyphs: [Glyph] = [
        Glyph(id: "o1", symbol: "ᚁ", latinLetter: "B", name: "Beith"),
        Glyph(id: "o2", symbol: "ᚂ", latinLetter: "L", name: "Luis"),
        Glyph(id: "o3", symbol: "ᚃ", latinLetter: "F", name: "Fearn"),
        Glyph(id: "o4", symbol: "ᚄ", latinLetter: "S", name: "Sail"),
        Glyph(id: "o5", symbol: "ᚅ", latinLetter: "N", name: "Nion"),
        Glyph(id: "o6", symbol: "ᚆ", latinLetter: "H", name: "Uath"),
        Glyph(id: "o7", symbol: "ᚇ", latinLetter: "D", name: "Dair"),
        Glyph(id: "o8", symbol: "ᚈ", latinLetter: "T", name: "Tinne"),
        Glyph(id: "o9", symbol: "ᚉ", latinLetter: "C", name: "Coll"),
        Glyph(id: "o10", symbol: "ᚊ", latinLetter: "Q", name: "Ceirt"),
        Glyph(id: "o11", symbol: "ᚋ", latinLetter: "M", name: "Muin"),
        Glyph(id: "o12", symbol: "ᚌ", latinLetter: "G", name: "Gort"),
        Glyph(id: "o13", symbol: "ᚍ", latinLetter: "NG", name: "Ngetal"),
        Glyph(id: "o14", symbol: "ᚎ", latinLetter: "Z", name: "Straif"),
        Glyph(id: "o15", symbol: "ᚏ", latinLetter: "R", name: "Ruis"),
        Glyph(id: "o16", symbol: "ᚐ", latinLetter: "A", name: "Ailm"),
        Glyph(id: "o17", symbol: "ᚑ", latinLetter: "O", name: "Onn"),
        Glyph(id: "o18", symbol: "ᚒ", latinLetter: "U", name: "Ur"),
        Glyph(id: "o19", symbol: "ᚓ", latinLetter: "E", name: "Eadhadh"),
        Glyph(id: "o20", symbol: "ᚔ", latinLetter: "I", name: "Iodhadh"),
    ]

    static func glyphs(for realm: ScriptRealm) -> [Glyph] {
        switch realm {
        case .futhark: futharkGlyphs
        case .hieroglyph: hieroglyphGlyphs
        case .cuneiform: cuneiformGlyphs
        case .greek: greekGlyphs
        case .ogham: oghamGlyphs
        }
    }

    private static let words: [String] = [
        "SUN", "MOON", "STAR", "FIRE", "WATER", "EARTH", "WIND", "STORM",
        "KING", "LAND", "RUNE", "FATE", "HERO", "SAGE", "DAWN", "DUSK",
        "GIFT", "HOME", "HUNT", "HALL", "IRON", "MEAD", "SHIP", "WOLF",
        "BEAR", "HAWK", "TREE", "HILL", "LAKE", "RAIN", "SNOW", "GOLD",
        "LIGHT", "NIGHT", "STONE", "SWORD", "SHIELD", "RIVER", "FROST",
        "THUNDER", "WISDOM", "DRAGON", "TEMPLE", "SPIRIT", "ANCIENT",
        "HARVEST", "WARRIOR", "VILLAGE", "MOUNTAIN", "FOREST",
        "THE SUN RISES", "SEEK WISDOM", "HONOR THE LAND",
        "FIRE AND WATER", "SPIRIT OF STONE", "DAWN OF KINGS",
        "THE ANCIENT PATH", "UNDER THE STARS", "THROUGH THE STORM",
        "PROTECT THE HOME", "SEEK THE TRUTH", "LIGHT IN DARKNESS",
        "STRENGTH OF IRON", "GIFT OF THE MOON", "WISDOM OF THE SAGE",
    ]

    static func puzzle(forLevel index: Int) -> DecodePuzzle {
        let realm = ScriptRealm(rawValue: index / 16) ?? .futhark
        let lvl = index % 16
        let allGlyphs = glyphs(for: realm)

        let wordIndex = index % words.count
        let text = words[wordIndex]

        let uniqueLetters = Set(text.filter { $0.isLetter }).sorted()
        let glyphCount = min(uniqueLetters.count, allGlyphs.count)
        let offset = lvl * 3

        var letterToGlyph: [Character: Glyph] = [:]
        for (i, letter) in uniqueLetters.prefix(glyphCount).enumerated() {
            let glyphIdx = (i + offset) % allGlyphs.count
            letterToGlyph[letter] = allGlyphs[glyphIdx]
        }

        var pairs: [(glyph: Glyph, letter: Character)] = []
        for ch in text {
            if let glyph = letterToGlyph[ch] {
                pairs.append((glyph, ch))
            }
        }

        let difficulty = 1 + lvl / 4

        return DecodePuzzle(
            plainText: text,
            glyphs: allGlyphs,
            encodedPairs: pairs,
            difficulty: difficulty
        )
    }
}
