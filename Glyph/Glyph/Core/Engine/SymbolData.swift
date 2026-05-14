import CoreGraphics

struct SymbolDefinition {
    let id: String
    let name: String
    let meaning: String
    let category: SymbolCategory
    let strokes: [[CGPoint]]
    let difficulty: Int
}

enum SymbolData {
    static func symbol(for index: Int) -> SymbolDefinition {
        let cat = SymbolCategory.categoryForChallenge(index)
        let local = SymbolCategory.localIndex(forChallenge: index)
        let symbols = symbolsFor(cat)
        let s = symbols[local % symbols.count]
        return s
    }

    private static func p(_ x: Double, _ y: Double) -> CGPoint {
        CGPoint(x: x, y: y)
    }

    private static func symbolsFor(_ category: SymbolCategory) -> [SymbolDefinition] {
        switch category {
        case .runes: runeSymbols
        case .hieroglyphs: hieroglyphSymbols
        case .kanji: kanjiSymbols
        case .geometry: geometrySymbols
        case .alchemy: alchemySymbols
        }
    }

    static let runeSymbols: [SymbolDefinition] = [
        SymbolDefinition(id: "fehu", name: "Fehu", meaning: "Wealth", category: .runes, strokes: [
            [p(0.3, 0.1), p(0.3, 0.9)],
            [p(0.3, 0.1), p(0.7, 0.3)],
            [p(0.3, 0.35), p(0.7, 0.55)],
        ], difficulty: 1),
        SymbolDefinition(id: "uruz", name: "Uruz", meaning: "Strength", category: .runes, strokes: [
            [p(0.2, 0.1), p(0.2, 0.7), p(0.5, 0.9)],
            [p(0.5, 0.9), p(0.8, 0.7), p(0.8, 0.1)],
        ], difficulty: 1),
        SymbolDefinition(id: "thurisaz", name: "Thurisaz", meaning: "Thor", category: .runes, strokes: [
            [p(0.3, 0.1), p(0.3, 0.9)],
            [p(0.3, 0.3), p(0.7, 0.5), p(0.3, 0.7)],
        ], difficulty: 2),
        SymbolDefinition(id: "ansuz", name: "Ansuz", meaning: "Wisdom", category: .runes, strokes: [
            [p(0.5, 0.1), p(0.5, 0.9)],
            [p(0.5, 0.3), p(0.2, 0.5)],
            [p(0.5, 0.5), p(0.2, 0.7)],
        ], difficulty: 2),
        SymbolDefinition(id: "raido", name: "Raido", meaning: "Journey", category: .runes, strokes: [
            [p(0.3, 0.1), p(0.3, 0.9)],
            [p(0.3, 0.1), p(0.7, 0.4)],
            [p(0.7, 0.4), p(0.3, 0.55)],
            [p(0.45, 0.5), p(0.7, 0.9)],
        ], difficulty: 3),
        SymbolDefinition(id: "kenaz", name: "Kenaz", meaning: "Torch", category: .runes, strokes: [
            [p(0.6, 0.1), p(0.3, 0.5), p(0.6, 0.9)],
        ], difficulty: 1),
        SymbolDefinition(id: "gebo", name: "Gebo", meaning: "Gift", category: .runes, strokes: [
            [p(0.2, 0.2), p(0.8, 0.8)],
            [p(0.8, 0.2), p(0.2, 0.8)],
        ], difficulty: 1),
        SymbolDefinition(id: "wunjo", name: "Wunjo", meaning: "Joy", category: .runes, strokes: [
            [p(0.3, 0.1), p(0.3, 0.5)],
            [p(0.3, 0.1), p(0.7, 0.4)],
            [p(0.7, 0.4), p(0.7, 0.9)],
        ], difficulty: 2),
        SymbolDefinition(id: "hagalaz", name: "Hagalaz", meaning: "Hail", category: .runes, strokes: [
            [p(0.3, 0.1), p(0.3, 0.9)],
            [p(0.7, 0.1), p(0.7, 0.9)],
            [p(0.3, 0.4), p(0.7, 0.6)],
        ], difficulty: 2),
        SymbolDefinition(id: "naudhiz", name: "Naudhiz", meaning: "Need", category: .runes, strokes: [
            [p(0.5, 0.1), p(0.5, 0.9)],
            [p(0.3, 0.3), p(0.7, 0.6)],
        ], difficulty: 1),
        SymbolDefinition(id: "isa", name: "Isa", meaning: "Ice", category: .runes, strokes: [
            [p(0.5, 0.1), p(0.5, 0.9)],
        ], difficulty: 1),
        SymbolDefinition(id: "jera", name: "Jera", meaning: "Harvest", category: .runes, strokes: [
            [p(0.5, 0.1), p(0.7, 0.3), p(0.5, 0.5)],
            [p(0.5, 0.5), p(0.3, 0.7), p(0.5, 0.9)],
        ], difficulty: 3),
        SymbolDefinition(id: "eihwaz", name: "Eihwaz", meaning: "Yew", category: .runes, strokes: [
            [p(0.5, 0.1), p(0.5, 0.9)],
            [p(0.5, 0.3), p(0.7, 0.5)],
            [p(0.5, 0.7), p(0.3, 0.5)],
        ], difficulty: 2),
        SymbolDefinition(id: "perthro", name: "Perthro", meaning: "Fate", category: .runes, strokes: [
            [p(0.3, 0.1), p(0.3, 0.9)],
            [p(0.3, 0.1), p(0.6, 0.3), p(0.3, 0.5)],
        ], difficulty: 2),
        SymbolDefinition(id: "algiz", name: "Algiz", meaning: "Protection", category: .runes, strokes: [
            [p(0.5, 0.9), p(0.5, 0.1)],
            [p(0.5, 0.3), p(0.2, 0.1)],
            [p(0.5, 0.3), p(0.8, 0.1)],
        ], difficulty: 2),
        SymbolDefinition(id: "sowilo", name: "Sowilo", meaning: "Sun", category: .runes, strokes: [
            [p(0.6, 0.1), p(0.3, 0.4), p(0.7, 0.6), p(0.4, 0.9)],
        ], difficulty: 2),
    ]

    static let hieroglyphSymbols: [SymbolDefinition] = (0..<16).map { i in
        let names = ["Eye of Horus", "Ankh", "Djed", "Was Scepter", "Scarab", "Lotus", "Feather of Ma'at", "Cartouche",
                     "Cobra", "Vulture", "Owl", "Water", "Reed", "Foot", "Mouth", "Sun Disc"]
        let meanings = ["Protection", "Life", "Stability", "Power", "Rebirth", "Creation", "Truth", "Royal Name",
                        "Sovereignty", "Mother", "Wisdom", "Primordial", "Growth", "Movement", "Speech", "Divinity"]
        let strokes = hieroglyphStrokes(i)
        return SymbolDefinition(id: "hiero_\(i)", name: names[i], meaning: meanings[i], category: .hieroglyphs, strokes: strokes, difficulty: i / 4 + 1)
    }

    private static func hieroglyphStrokes(_ i: Int) -> [[CGPoint]] {
        let base: [[[CGPoint]]] = [
            [[p(0.2, 0.5), p(0.4, 0.3), p(0.6, 0.3), p(0.8, 0.5), p(0.6, 0.7), p(0.4, 0.7), p(0.2, 0.5)], [p(0.45, 0.45), p(0.55, 0.45), p(0.55, 0.55), p(0.45, 0.55)]],
            [[p(0.5, 0.1), p(0.3, 0.4), p(0.2, 0.4)], [p(0.5, 0.1), p(0.7, 0.4), p(0.8, 0.4)], [p(0.5, 0.4), p(0.5, 0.9)], [p(0.3, 0.65), p(0.7, 0.65)]],
            [[p(0.5, 0.1), p(0.5, 0.9)], [p(0.35, 0.2), p(0.65, 0.2)], [p(0.35, 0.4), p(0.65, 0.4)], [p(0.35, 0.6), p(0.65, 0.6)]],
            [[p(0.5, 0.1), p(0.5, 0.65)], [p(0.35, 0.65), p(0.65, 0.65), p(0.65, 0.9), p(0.35, 0.9)]],
            [[p(0.3, 0.4), p(0.5, 0.2), p(0.7, 0.4), p(0.5, 0.6), p(0.3, 0.4)], [p(0.3, 0.6), p(0.5, 0.8), p(0.7, 0.6)]],
            [[p(0.5, 0.9), p(0.5, 0.4)], [p(0.3, 0.4), p(0.5, 0.2), p(0.7, 0.4)], [p(0.25, 0.55), p(0.5, 0.35), p(0.75, 0.55)]],
            [[p(0.5, 0.1), p(0.5, 0.9)], [p(0.3, 0.2), p(0.5, 0.1), p(0.7, 0.2)], [p(0.35, 0.3), p(0.65, 0.3)]],
            [[p(0.3, 0.2), p(0.7, 0.2), p(0.7, 0.8), p(0.3, 0.8), p(0.3, 0.2)], [p(0.3, 0.9), p(0.5, 0.8), p(0.7, 0.9)]],
            [[p(0.5, 0.1), p(0.4, 0.3), p(0.5, 0.5), p(0.6, 0.7), p(0.5, 0.9)]],
            [[p(0.3, 0.5), p(0.5, 0.2), p(0.7, 0.5)], [p(0.35, 0.5), p(0.5, 0.8), p(0.65, 0.5)]],
            [[p(0.4, 0.2), p(0.4, 0.8)], [p(0.4, 0.2), p(0.6, 0.3), p(0.6, 0.5)], [p(0.4, 0.6), p(0.6, 0.7)]],
            [[p(0.2, 0.3), p(0.4, 0.5), p(0.2, 0.7)], [p(0.5, 0.3), p(0.7, 0.5), p(0.5, 0.7)]],
            [[p(0.5, 0.1), p(0.5, 0.9)], [p(0.4, 0.15), p(0.6, 0.3)]],
            [[p(0.3, 0.6), p(0.5, 0.9), p(0.7, 0.6)], [p(0.3, 0.6), p(0.3, 0.3), p(0.7, 0.3), p(0.7, 0.6)]],
            [[p(0.3, 0.3), p(0.7, 0.3), p(0.7, 0.7), p(0.3, 0.7)]],
            [[p(0.3, 0.5), p(0.5, 0.3), p(0.7, 0.5), p(0.5, 0.3)]],
        ]
        return base[i % base.count]
    }

    static let kanjiSymbols: [SymbolDefinition] = (0..<16).map { i in
        let names = ["One", "Two", "Three", "Big", "Small", "Mountain", "River", "Fire",
                     "Water", "Tree", "Forest", "Moon", "Sun", "Earth", "Person", "Heart"]
        let meanings = ["一", "二", "三", "大", "小", "山", "川", "火", "水", "木", "森", "月", "日", "土", "人", "心"]
        let strokes = kanjiStrokes(i)
        return SymbolDefinition(id: "kanji_\(i)", name: names[i], meaning: meanings[i], category: .kanji, strokes: strokes, difficulty: i / 4 + 1)
    }

    private static func kanjiStrokes(_ i: Int) -> [[CGPoint]] {
        let base: [[[CGPoint]]] = [
            [[p(0.2, 0.5), p(0.8, 0.5)]],
            [[p(0.2, 0.35), p(0.8, 0.35)], [p(0.2, 0.65), p(0.8, 0.65)]],
            [[p(0.2, 0.25), p(0.8, 0.25)], [p(0.2, 0.5), p(0.8, 0.5)], [p(0.2, 0.75), p(0.8, 0.75)]],
            [[p(0.2, 0.35), p(0.8, 0.35)], [p(0.5, 0.1), p(0.2, 0.9)], [p(0.5, 0.1), p(0.8, 0.9)]],
            [[p(0.5, 0.2), p(0.5, 0.6)], [p(0.3, 0.35), p(0.7, 0.35)], [p(0.35, 0.7), p(0.5, 0.9), p(0.65, 0.7)]],
            [[p(0.5, 0.15), p(0.5, 0.6)], [p(0.2, 0.5), p(0.5, 0.15), p(0.8, 0.5)], [p(0.15, 0.85), p(0.85, 0.85)]],
            [[p(0.3, 0.1), p(0.3, 0.9)], [p(0.5, 0.1), p(0.5, 0.9)], [p(0.7, 0.1), p(0.7, 0.9)]],
            [[p(0.5, 0.15), p(0.5, 0.5)], [p(0.3, 0.35), p(0.7, 0.35)], [p(0.5, 0.5), p(0.2, 0.9)], [p(0.5, 0.5), p(0.8, 0.9)]],
            [[p(0.2, 0.2), p(0.4, 0.5), p(0.2, 0.8)], [p(0.5, 0.15), p(0.5, 0.85)], [p(0.6, 0.3), p(0.8, 0.5), p(0.6, 0.7)]],
            [[p(0.2, 0.35), p(0.8, 0.35)], [p(0.5, 0.1), p(0.5, 0.9)], [p(0.2, 0.7), p(0.5, 0.9)], [p(0.8, 0.7), p(0.5, 0.9)]],
            [[p(0.15, 0.35), p(0.5, 0.35)], [p(0.35, 0.15), p(0.35, 0.65)], [p(0.15, 0.55), p(0.35, 0.65)], [p(0.55, 0.35), p(0.85, 0.35)], [p(0.7, 0.15), p(0.7, 0.65)], [p(0.55, 0.55), p(0.7, 0.65)]],
            [[p(0.3, 0.15), p(0.3, 0.85)], [p(0.3, 0.15), p(0.7, 0.3)], [p(0.3, 0.5), p(0.7, 0.5)], [p(0.7, 0.3), p(0.7, 0.85)]],
            [[p(0.3, 0.2), p(0.7, 0.2), p(0.7, 0.8), p(0.3, 0.8), p(0.3, 0.2)], [p(0.3, 0.5), p(0.7, 0.5)]],
            [[p(0.2, 0.35), p(0.8, 0.35)], [p(0.5, 0.15), p(0.5, 0.65)], [p(0.2, 0.85), p(0.8, 0.85)]],
            [[p(0.5, 0.1), p(0.3, 0.9)], [p(0.5, 0.1), p(0.7, 0.9)]],
            [[p(0.2, 0.3), p(0.5, 0.5), p(0.2, 0.7)], [p(0.5, 0.15), p(0.5, 0.45)], [p(0.5, 0.55), p(0.5, 0.85)], [p(0.8, 0.6), p(0.5, 0.85)]],
        ]
        return base[i % base.count]
    }

    static let geometrySymbols: [SymbolDefinition] = (0..<16).map { i in
        let names = ["Circle", "Triangle", "Square", "Pentagon", "Hexagon", "Star", "Vesica Piscis", "Flower of Life",
                     "Seed of Life", "Metatron's Cube", "Sri Yantra", "Torus", "Fibonacci Spiral", "Platonic Solid", "Merkaba", "Infinity"]
        let meanings = ["Unity", "Balance", "Foundation", "Humanity", "Harmony", "Spirit", "Creation", "Genesis",
                        "Origin", "Blueprint", "Cosmos", "Flow", "Growth", "Perfection", "Light Body", "Eternity"]
        return SymbolDefinition(id: "geo_\(i)", name: names[i], meaning: meanings[i], category: .geometry, strokes: geometryStrokes(i), difficulty: i / 4 + 1)
    }

    private static func geometryStrokes(_ i: Int) -> [[CGPoint]] {
        let base: [[[CGPoint]]] = [
            [circlePoints(cx: 0.5, cy: 0.5, r: 0.35, n: 24)],
            [[p(0.5, 0.15), p(0.15, 0.85), p(0.85, 0.85), p(0.5, 0.15)]],
            [[p(0.2, 0.2), p(0.8, 0.2), p(0.8, 0.8), p(0.2, 0.8), p(0.2, 0.2)]],
            [pentagonPoints(cx: 0.5, cy: 0.5, r: 0.38)],
            [hexagonPoints(cx: 0.5, cy: 0.5, r: 0.38)],
            [[p(0.5, 0.1), p(0.38, 0.4), p(0.1, 0.4), p(0.3, 0.6), p(0.22, 0.9), p(0.5, 0.72), p(0.78, 0.9), p(0.7, 0.6), p(0.9, 0.4), p(0.62, 0.4), p(0.5, 0.1)]],
            [circlePoints(cx: 0.35, cy: 0.5, r: 0.25, n: 20), circlePoints(cx: 0.65, cy: 0.5, r: 0.25, n: 20)],
            [circlePoints(cx: 0.5, cy: 0.5, r: 0.35, n: 24), circlePoints(cx: 0.5, cy: 0.3, r: 0.2, n: 16), circlePoints(cx: 0.5, cy: 0.7, r: 0.2, n: 16)],
            [circlePoints(cx: 0.5, cy: 0.5, r: 0.1, n: 12), circlePoints(cx: 0.5, cy: 0.5, r: 0.25, n: 16)],
            [[p(0.5, 0.1), p(0.15, 0.9), p(0.85, 0.9), p(0.5, 0.1)], [p(0.5, 0.9), p(0.15, 0.1), p(0.85, 0.1), p(0.5, 0.9)]],
            [[p(0.5, 0.1), p(0.2, 0.5), p(0.5, 0.9), p(0.8, 0.5), p(0.5, 0.1)], [p(0.5, 0.25), p(0.3, 0.5), p(0.5, 0.75), p(0.7, 0.5), p(0.5, 0.25)]],
            [circlePoints(cx: 0.5, cy: 0.5, r: 0.38, n: 24), circlePoints(cx: 0.5, cy: 0.5, r: 0.2, n: 16)],
            [[p(0.5, 0.5), p(0.52, 0.45), p(0.56, 0.4), p(0.62, 0.38), p(0.7, 0.38), p(0.78, 0.42), p(0.82, 0.5), p(0.82, 0.6), p(0.78, 0.7), p(0.7, 0.78)]],
            [[p(0.5, 0.15), p(0.15, 0.85), p(0.85, 0.85), p(0.5, 0.15)], circlePoints(cx: 0.5, cy: 0.6, r: 0.22, n: 16)],
            [[p(0.5, 0.1), p(0.2, 0.6), p(0.8, 0.6), p(0.5, 0.1)], [p(0.5, 0.9), p(0.2, 0.4), p(0.8, 0.4), p(0.5, 0.9)]],
            [[p(0.15, 0.5), p(0.35, 0.35), p(0.5, 0.5), p(0.65, 0.65), p(0.85, 0.5), p(0.65, 0.35), p(0.5, 0.5), p(0.35, 0.65), p(0.15, 0.5)]],
        ]
        return base[i % base.count]
    }

    static let alchemySymbols: [SymbolDefinition] = (0..<16).map { i in
        let names = ["Fire", "Water", "Earth", "Air", "Sulfur", "Mercury", "Salt", "Philosopher's Stone",
                     "Gold", "Silver", "Copper", "Iron", "Lead", "Tin", "Antimony", "Quintessence"]
        let meanings = ["Transformation", "Emotion", "Body", "Mind", "Soul", "Spirit", "Matter", "Perfection",
                        "Sun", "Moon", "Venus", "Mars", "Saturn", "Jupiter", "Earth", "Aether"]
        return SymbolDefinition(id: "alch_\(i)", name: names[i], meaning: meanings[i], category: .alchemy, strokes: alchemyStrokes(i), difficulty: i / 4 + 1)
    }

    private static func alchemyStrokes(_ i: Int) -> [[CGPoint]] {
        let base: [[[CGPoint]]] = [
            [[p(0.5, 0.15), p(0.2, 0.75), p(0.8, 0.75), p(0.5, 0.15)]],
            [[p(0.5, 0.85), p(0.2, 0.25), p(0.8, 0.25), p(0.5, 0.85)]],
            [[p(0.5, 0.85), p(0.2, 0.25), p(0.8, 0.25), p(0.5, 0.85)], [p(0.25, 0.7), p(0.75, 0.7)]],
            [[p(0.5, 0.15), p(0.2, 0.75), p(0.8, 0.75), p(0.5, 0.15)], [p(0.25, 0.35), p(0.75, 0.35)]],
            [[p(0.5, 0.1), p(0.2, 0.6), p(0.8, 0.6), p(0.5, 0.1)], [p(0.5, 0.6), p(0.5, 0.9)], [p(0.35, 0.9), p(0.65, 0.9)]],
            [circlePoints(cx: 0.5, cy: 0.4, r: 0.22, n: 16), [p(0.5, 0.62), p(0.5, 0.9)], [p(0.35, 0.9), p(0.65, 0.9)], [p(0.3, 0.15), p(0.7, 0.15)]],
            [circlePoints(cx: 0.5, cy: 0.45, r: 0.25, n: 16), [p(0.25, 0.8), p(0.75, 0.8)]],
            [circlePoints(cx: 0.5, cy: 0.5, r: 0.3, n: 20), [p(0.5, 0.15), p(0.2, 0.7), p(0.8, 0.7), p(0.5, 0.15)], [p(0.5, 0.85), p(0.25, 0.35), p(0.75, 0.35), p(0.5, 0.85)]],
            [circlePoints(cx: 0.5, cy: 0.5, r: 0.3, n: 20), [p(0.5, 0.5), p(0.85, 0.5)]],
            [circlePoints(cx: 0.5, cy: 0.5, r: 0.25, n: 16), [p(0.25, 0.5), p(0.1, 0.35)], [p(0.25, 0.5), p(0.1, 0.65)]],
            [circlePoints(cx: 0.5, cy: 0.4, r: 0.22, n: 16), [p(0.5, 0.62), p(0.35, 0.9)], [p(0.5, 0.62), p(0.65, 0.9)]],
            [[p(0.5, 0.15), p(0.3, 0.5)], [p(0.3, 0.5), p(0.7, 0.5)], [p(0.7, 0.5), p(0.5, 0.85)]],
            [circlePoints(cx: 0.5, cy: 0.4, r: 0.22, n: 16), [p(0.5, 0.62), p(0.5, 0.9)], [p(0.35, 0.9), p(0.65, 0.9)], [p(0.35, 0.82), p(0.65, 0.82)]],
            [circlePoints(cx: 0.5, cy: 0.5, r: 0.25, n: 16), [p(0.25, 0.5), p(0.1, 0.5)], [p(0.75, 0.5), p(0.9, 0.5)], [p(0.5, 0.25), p(0.5, 0.1)]],
            [circlePoints(cx: 0.5, cy: 0.5, r: 0.25, n: 16), [p(0.5, 0.25), p(0.5, 0.1)], [p(0.25, 0.5), p(0.4, 0.35)]],
            [circlePoints(cx: 0.5, cy: 0.5, r: 0.3, n: 20), [p(0.5, 0.2), p(0.5, 0.8)], [p(0.2, 0.5), p(0.8, 0.5)]],
        ]
        return base[i % base.count]
    }

    private static func circlePoints(cx: Double, cy: Double, r: Double, n: Int) -> [CGPoint] {
        (0...n).map { i in
            let angle = Double(i) / Double(n) * 2 * .pi - .pi / 2
            return p(cx + r * cos(angle), cy + r * sin(angle))
        }
    }

    private static func pentagonPoints(cx: Double, cy: Double, r: Double) -> [CGPoint] {
        var pts = (0..<5).map { i in
            let angle = Double(i) / 5.0 * 2 * .pi - .pi / 2
            return p(cx + r * cos(angle), cy + r * sin(angle))
        }
        pts.append(pts[0])
        return pts
    }

    private static func hexagonPoints(cx: Double, cy: Double, r: Double) -> [CGPoint] {
        var pts = (0..<6).map { i in
            let angle = Double(i) / 6.0 * 2 * .pi - .pi / 2
            return p(cx + r * cos(angle), cy + r * sin(angle))
        }
        pts.append(pts[0])
        return pts
    }
}
