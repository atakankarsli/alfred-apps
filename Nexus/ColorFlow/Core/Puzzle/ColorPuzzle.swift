import Foundation

struct WordCluster: Identifiable {
    let id: Int
    let category: String
    let words: [String]
    let difficulty: ClusterDifficulty
    let colorHex: String
}

enum ClusterDifficulty: Int, CaseIterable {
    case easy = 0, medium = 1, hard = 2

    var label: String {
        switch self {
        case .easy: "Easy"
        case .medium: "Medium"
        case .hard: "Hard"
        }
    }

    var hex: String {
        switch self {
        case .easy: "22C55E"
        case .medium: "3B82F6"
        case .hard: "A855F7"
        }
    }
}

struct NexusPuzzle {
    let level: Int
    let clusters: [WordCluster]

    var allWords: [String] {
        clusters.flatMap(\.words)
    }

    var shuffledWords: [String] {
        var rng = SeededRNG(seed: UInt64(level * 7919 + 104729))
        var words = allWords
        for i in stride(from: words.count - 1, through: 1, by: -1) {
            let j = Int(rng.next() % UInt64(i + 1))
            words.swapAt(i, j)
        }
        return words
    }

    func clusterFor(word: String) -> WordCluster? {
        clusters.first { $0.words.contains(word) }
    }

    func checkGroup(_ words: [String]) -> WordCluster? {
        for cluster in clusters {
            if Set(words) == Set(cluster.words) { return cluster }
        }
        return nil
    }

    func isOneAway(_ words: [String]) -> Bool {
        for cluster in clusters {
            let overlap = Set(words).intersection(Set(cluster.words)).count
            if overlap == 3 { return true }
        }
        return false
    }

    static func generate(level: Int) -> NexusPuzzle {
        let bank = puzzleBank(for: level)
        return NexusPuzzle(level: level, clusters: bank)
    }

    // MARK: - Puzzle Bank

    private static func puzzleBank(for level: Int) -> [WordCluster] {
        let allPuzzles: [[[String: Any]]] = puzzleData()
        let idx = level % allPuzzles.count
        let data = allPuzzles[idx]

        return data.enumerated().map { i, entry in
            let cat = entry["category"] as? String ?? "Group \(i+1)"
            let words = entry["words"] as? [String] ?? []
            let diff = ClusterDifficulty(rawValue: i) ?? .easy
            return WordCluster(id: i, category: cat, words: words, difficulty: diff, colorHex: diff.hex)
        }
    }

    private static func puzzleData() -> [[[String: Any]]] {
        [
            [["category": "Fruits", "words": ["Apple", "Mango", "Grape", "Peach"]],
             ["category": "Planets", "words": ["Mars", "Venus", "Earth", "Pluto"]],
             ["category": "Colors", "words": ["Coral", "Ivory", "Amber", "Jade"]]],

            [["category": "Card Games", "words": ["Bridge", "Poker", "Hearts", "Spades"]],
             ["category": "Dances", "words": ["Waltz", "Tango", "Salsa", "Rumba"]],
             ["category": "Fabrics", "words": ["Satin", "Denim", "Tweed", "Linen"]]],

            [["category": "Trees", "words": ["Maple", "Cedar", "Birch", "Aspen"]],
             ["category": "Metals", "words": ["Steel", "Brass", "Bronze", "Copper"]],
             ["category": "Winds", "words": ["Gust", "Gale", "Breeze", "Squall"]]],

            [["category": "Pasta", "words": ["Penne", "Rigatoni", "Fusilli", "Orzo"]],
             ["category": "Gems", "words": ["Topaz", "Opal", "Garnet", "Onyx"]],
             ["category": "Rivers", "words": ["Thames", "Danube", "Rhine", "Seine"]]],

            [["category": "Chess Pieces", "words": ["Knight", "Bishop", "Castle", "Pawn"]],
             ["category": "Musical Keys", "words": ["Sharp", "Flat", "Major", "Minor"]],
             ["category": "Weather", "words": ["Hail", "Sleet", "Drizzle", "Frost"]]],

            [["category": "Spices", "words": ["Cumin", "Thyme", "Sage", "Clove"]],
             ["category": "Oceans", "words": ["Arctic", "Indian", "Pacific", "Atlantic"]],
             ["category": "Shapes", "words": ["Prism", "Sphere", "Helix", "Cube"]]],

            [["category": "Dog Breeds", "words": ["Poodle", "Beagle", "Corgi", "Husky"]],
             ["category": "Currencies", "words": ["Euro", "Pound", "Rupee", "Franc"]],
             ["category": "Mountains", "words": ["Everest", "Fuji", "Alps", "Andes"]]],

            [["category": "Instruments", "words": ["Cello", "Flute", "Harp", "Drum"]],
             ["category": "Flowers", "words": ["Lily", "Rose", "Tulip", "Daisy"]],
             ["category": "Zodiac", "words": ["Aries", "Leo", "Virgo", "Libra"]]],

            [["category": "Capitals", "words": ["Tokyo", "Paris", "Seoul", "Lima"]],
             ["category": "Elements", "words": ["Neon", "Iron", "Gold", "Lead"]],
             ["category": "Sports", "words": ["Rugby", "Polo", "Hockey", "Squash"]]],

            [["category": "Mythical", "words": ["Dragon", "Phoenix", "Kraken", "Griffin"]],
             ["category": "Dances", "words": ["Jive", "Foxtrot", "Mambo", "Samba"]],
             ["category": "Cheeses", "words": ["Brie", "Gouda", "Feta", "Cheddar"]]],

            [["category": "Constellations", "words": ["Orion", "Gemini", "Lyra", "Draco"]],
             ["category": "Herbs", "words": ["Basil", "Dill", "Mint", "Chive"]],
             ["category": "Boats", "words": ["Kayak", "Canoe", "Yacht", "Ferry"]]],

            [["category": "Authors", "words": ["Twain", "Austen", "Orwell", "Wilde"]],
             ["category": "Deserts", "words": ["Sahara", "Gobi", "Mojave", "Kalahari"]],
             ["category": "Textiles", "words": ["Silk", "Wool", "Velvet", "Cotton"]]],

            [["category": "Bones", "words": ["Femur", "Tibia", "Radius", "Ulna"]],
             ["category": "Greek Gods", "words": ["Zeus", "Athena", "Hermes", "Apollo"]],
             ["category": "Knots", "words": ["Bowline", "Cleat", "Hitch", "Loop"]]],

            [["category": "Vitamins", "words": ["Biotin", "Folate", "Niacin", "Riboflavin"]],
             ["category": "Layers", "words": ["Mantle", "Crust", "Core", "Surface"]],
             ["category": "Codes", "words": ["Morse", "Binary", "Cipher", "Braille"]]],

            [["category": "Clouds", "words": ["Cirrus", "Nimbus", "Stratus", "Cumulus"]],
             ["category": "Berries", "words": ["Acai", "Goji", "Elder", "Juniper"]],
             ["category": "Inks", "words": ["Sepia", "Indigo", "Carmine", "Sienna"]]],

            [["category": "Acids", "words": ["Citric", "Lactic", "Acetic", "Nitric"]],
             ["category": "Epochs", "words": ["Jurassic", "Triassic", "Permian", "Devonian"]],
             ["category": "Fibers", "words": ["Hemp", "Jute", "Linen", "Flax"]]],

            [["category": "Teas", "words": ["Matcha", "Oolong", "Chai", "Rooibos"]],
             ["category": "Bridges", "words": ["Tower", "Golden", "Brooklyn", "London"]],
             ["category": "Modes", "words": ["Dorian", "Lydian", "Ionian", "Phrygian"]]],

            [["category": "Fonts", "words": ["Arial", "Futura", "Garamond", "Bodoni"]],
             ["category": "Volcanoes", "words": ["Etna", "Vesuvius", "Rainier", "Stromboli"]],
             ["category": "Coins", "words": ["Penny", "Dime", "Nickel", "Quarter"]]],

            [["category": "Martial Arts", "words": ["Judo", "Karate", "Aikido", "Kendo"]],
             ["category": "Whales", "words": ["Orca", "Beluga", "Narwhal", "Humpback"]],
             ["category": "Grains", "words": ["Millet", "Quinoa", "Barley", "Spelt"]]],

            [["category": "Painters", "words": ["Monet", "Renoir", "Degas", "Cezanne"]],
             ["category": "Alloys", "words": ["Pewter", "Solder", "Electrum", "Invar"]],
             ["category": "Dyes", "words": ["Madder", "Woad", "Saffron", "Cochineal"]]],

            [["category": "Philosophers", "words": ["Plato", "Locke", "Hume", "Kant"]],
             ["category": "Galaxies", "words": ["Andromeda", "Pinwheel", "Sombrero", "Whirlpool"]],
             ["category": "Weaves", "words": ["Twill", "Satin", "Dobby", "Jacquard"]]],

            [["category": "Operas", "words": ["Carmen", "Tosca", "Aida", "Norma"]],
             ["category": "Fossils", "words": ["Amber", "Trilobite", "Ammonite", "Coprolite"]],
             ["category": "Lichens", "words": ["Cladonia", "Usnea", "Peltigera", "Xanthoria"]]],

            [["category": "Dances", "words": ["Polka", "Mazurka", "Bolero", "Fandango"]],
             ["category": "Pigments", "words": ["Ochre", "Umber", "Vermilion", "Cerulean"]],
             ["category": "Knives", "words": ["Bowie", "Stiletto", "Machete", "Cleaver"]]],

            [["category": "Clocks", "words": ["Sundial", "Pendulum", "Quartz", "Atomic"]],
             ["category": "Peppers", "words": ["Jalapeno", "Habanero", "Serrano", "Cayenne"]],
             ["category": "Locks", "words": ["Deadbolt", "Padlock", "Tumbler", "Latch"]]],

            [["category": "Sauces", "words": ["Pesto", "Aioli", "Chimichurri", "Romesco"]],
             ["category": "Orbits", "words": ["Lunar", "Solar", "Polar", "Elliptical"]],
             ["category": "Scripts", "words": ["Kanji", "Cyrillic", "Devanagari", "Arabic"]]],

            [["category": "Soils", "words": ["Loam", "Clay", "Peat", "Silt"]],
             ["category": "Masks", "words": ["Kabuki", "Venetian", "Lucha", "Noh"]],
             ["category": "Tides", "words": ["Neap", "Spring", "Ebb", "Flood"]]],

            [["category": "Sugars", "words": ["Glucose", "Sucrose", "Fructose", "Maltose"]],
             ["category": "Horns", "words": ["French", "Bugle", "Cornet", "Tuba"]],
             ["category": "Vaults", "words": ["Barrel", "Groin", "Ribbed", "Fan"]]],

            [["category": "Silks", "words": ["Charmeuse", "Chiffon", "Organza", "Crepe"]],
             ["category": "Eras", "words": ["Baroque", "Gothic", "Tudor", "Deco"]],
             ["category": "Roots", "words": ["Ginger", "Turmeric", "Burdock", "Chicory"]]],

            [["category": "Lenses", "words": ["Convex", "Concave", "Bifocal", "Fresnel"]],
             ["category": "Reefs", "words": ["Barrier", "Atoll", "Fringe", "Patch"]],
             ["category": "Hammers", "words": ["Ball-peen", "Claw", "Mallet", "Sledge"]]],

            [["category": "Breads", "words": ["Naan", "Focaccia", "Brioche", "Ciabatta"]],
             ["category": "Waves", "words": ["Gamma", "Radio", "Micro", "Infrared"]],
             ["category": "Arches", "words": ["Gothic", "Roman", "Lancet", "Tudor"]]],

            [["category": "Bows", "words": ["Longbow", "Crossbow", "Recurve", "Compound"]],
             ["category": "Mosses", "words": ["Sphagnum", "Peat", "Sheet", "Club"]],
             ["category": "Bells", "words": ["Liberty", "Big Ben", "Taco", "Jingle"]]],

            [["category": "Feathers", "words": ["Plume", "Down", "Quill", "Contour"]],
             ["category": "Towers", "words": ["Babel", "Eiffel", "Pisa", "Rapunzel"]],
             ["category": "Gears", "words": ["Spur", "Worm", "Bevel", "Helical"]]],

            [["category": "Pastas", "words": ["Linguine", "Tagliatelle", "Ravioli", "Gnocchi"]],
             ["category": "Moons", "words": ["Titan", "Europa", "Ganymede", "Io"]],
             ["category": "Scales", "words": ["Major", "Pentatonic", "Chromatic", "Blues"]]],

            [["category": "Clays", "words": ["Kaolin", "Bentonite", "Terracotta", "Porcelain"]],
             ["category": "Capes", "words": ["Horn", "Good Hope", "Cod", "Fear"]],
             ["category": "Bolts", "words": ["Carriage", "Anchor", "Eye", "Toggle"]]],

            [["category": "Pickles", "words": ["Gherkin", "Kimchi", "Relish", "Sauerkraut"]],
             ["category": "Passes", "words": ["Khyber", "Brenner", "Simplon", "Donner"]],
             ["category": "Stitches", "words": ["Chain", "Cross", "Running", "Blanket"]]],

            [["category": "Salts", "words": ["Himalayan", "Kosher", "Fleur", "Smoked"]],
             ["category": "Ports", "words": ["Shanghai", "Rotterdam", "Hamburg", "Singapore"]],
             ["category": "Joints", "words": ["Hinge", "Ball", "Pivot", "Saddle"]]],

            [["category": "Ropes", "words": ["Manila", "Nylon", "Sisal", "Hemp"]],
             ["category": "Craters", "words": ["Tycho", "Copernicus", "Aristarchus", "Kepler"]],
             ["category": "Braids", "words": ["French", "Dutch", "Fishtail", "Crown"]]],

            [["category": "Waxes", "words": ["Beeswax", "Paraffin", "Carnauba", "Soy"]],
             ["category": "Canyons", "words": ["Grand", "Bryce", "Zion", "Antelope"]],
             ["category": "Folds", "words": ["Pleat", "Tuck", "Dart", "Gather"]]],

            [["category": "Sands", "words": ["Quartz", "Coral", "Volcanic", "Feldspar"]],
             ["category": "Masks", "words": ["N95", "Surgical", "Cloth", "Respirator"]],
             ["category": "Loops", "words": ["For", "While", "Do", "Foreach"]]],

            [["category": "Stones", "words": ["Granite", "Marble", "Slate", "Basalt"]],
             ["category": "Islands", "words": ["Crete", "Bali", "Fiji", "Malta"]],
             ["category": "Winds", "words": ["Monsoon", "Mistral", "Chinook", "Sirocco"]]],
        ]
    }
}

struct SeededRNG: RandomNumberGenerator {
    private var state: UInt64

    init(seed: UInt64) { state = seed == 0 ? 1 : seed }

    mutating func next() -> UInt64 {
        state &+= 0x9E3779B97F4A7C15
        var z = state
        z = (z ^ (z >> 30)) &* 0xBF58476D1CE4E5B9
        z = (z ^ (z >> 27)) &* 0x94D049BB133111EB
        return z ^ (z >> 31)
    }
}
