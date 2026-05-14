import Foundation

enum ElementData {
    static let baseElements: [Element] = [
        Element(id: "water", name: "Water", icon: "drop.fill", realm: .primordial, tier: 0, recipe: nil),
        Element(id: "fire", name: "Fire", icon: "flame.fill", realm: .primordial, tier: 0, recipe: nil),
        Element(id: "earth", name: "Earth", icon: "mountain.2.fill", realm: .primordial, tier: 0, recipe: nil),
        Element(id: "air", name: "Air", icon: "wind", realm: .primordial, tier: 0, recipe: nil),
    ]

    static let allElements: [Element] = baseElements + [
        // Primordial (tier 1-3)
        Element(id: "steam", name: "Steam", icon: "cloud.fill", realm: .primordial, tier: 1, recipe: ("water", "fire")),
        Element(id: "mud", name: "Mud", icon: "circle.bottomhalf.filled", realm: .primordial, tier: 1, recipe: ("water", "earth")),
        Element(id: "dust", name: "Dust", icon: "aqi.medium", realm: .primordial, tier: 1, recipe: ("earth", "air")),
        Element(id: "lava", name: "Lava", icon: "waveform.path", realm: .primordial, tier: 1, recipe: ("fire", "earth")),
        Element(id: "mist", name: "Mist", icon: "cloud.fog.fill", realm: .primordial, tier: 1, recipe: ("water", "air")),
        Element(id: "energy", name: "Energy", icon: "bolt.fill", realm: .primordial, tier: 1, recipe: ("fire", "air")),
        Element(id: "stone", name: "Stone", icon: "cube.fill", realm: .primordial, tier: 2, recipe: ("lava", "water")),
        Element(id: "rain", name: "Rain", icon: "cloud.rain.fill", realm: .primordial, tier: 2, recipe: ("steam", "air")),
        Element(id: "ice", name: "Ice", icon: "snowflake", realm: .primordial, tier: 2, recipe: ("water", "water")),
        Element(id: "lightning", name: "Lightning", icon: "bolt.horizontal.fill", realm: .primordial, tier: 2, recipe: ("energy", "air")),
        Element(id: "obsidian", name: "Obsidian", icon: "diamond.fill", realm: .primordial, tier: 3, recipe: ("lava", "air")),
        Element(id: "crystal", name: "Crystal", icon: "pyramid.fill", realm: .primordial, tier: 3, recipe: ("stone", "lightning")),

        // Nature (tier 1-3)
        Element(id: "plant", name: "Plant", icon: "leaf.fill", realm: .nature, tier: 1, recipe: ("earth", "water")),
        Element(id: "moss", name: "Moss", icon: "leaf.arrow.circlepath", realm: .nature, tier: 1, recipe: ("plant", "stone")),
        Element(id: "seed", name: "Seed", icon: "allergens.fill", realm: .nature, tier: 1, recipe: ("plant", "earth")),
        Element(id: "tree", name: "Tree", icon: "tree.fill", realm: .nature, tier: 2, recipe: ("plant", "rain")),
        Element(id: "flower", name: "Flower", icon: "camera.macro", realm: .nature, tier: 2, recipe: ("plant", "energy")),
        Element(id: "forest", name: "Forest", icon: "tree.circle.fill", realm: .nature, tier: 2, recipe: ("tree", "tree")),
        Element(id: "mushroom", name: "Mushroom", icon: "pill.fill", realm: .nature, tier: 2, recipe: ("mud", "plant")),
        Element(id: "swamp", name: "Swamp", icon: "humidity.fill", realm: .nature, tier: 2, recipe: ("water", "mud")),
        Element(id: "fruit", name: "Fruit", icon: "apple.logo", realm: .nature, tier: 2, recipe: ("tree", "flower")),
        Element(id: "wood", name: "Wood", icon: "square.stack.3d.up.fill", realm: .nature, tier: 2, recipe: ("tree", "air")),
        Element(id: "vine", name: "Vine", icon: "leaf.circle.fill", realm: .nature, tier: 3, recipe: ("plant", "tree")),
        Element(id: "coral", name: "Coral", icon: "waveform.badge.plus", realm: .nature, tier: 3, recipe: ("stone", "plant")),

        // Civilization (tier 1-3)
        Element(id: "brick", name: "Brick", icon: "square.fill", realm: .civilization, tier: 1, recipe: ("mud", "fire")),
        Element(id: "glass", name: "Glass", icon: "rectangle.portrait.fill", realm: .civilization, tier: 1, recipe: ("dust", "fire")),
        Element(id: "metal", name: "Metal", icon: "wrench.fill", realm: .civilization, tier: 1, recipe: ("stone", "fire")),
        Element(id: "tool", name: "Tool", icon: "hammer.fill", realm: .civilization, tier: 2, recipe: ("metal", "wood")),
        Element(id: "wheel", name: "Wheel", icon: "circle.circle.fill", realm: .civilization, tier: 2, recipe: ("wood", "tool")),
        Element(id: "house", name: "House", icon: "house.fill", realm: .civilization, tier: 2, recipe: ("brick", "wood")),
        Element(id: "pottery", name: "Pottery", icon: "cup.and.saucer.fill", realm: .civilization, tier: 2, recipe: ("mud", "tool")),
        Element(id: "blade", name: "Blade", icon: "scissors", realm: .civilization, tier: 2, recipe: ("metal", "stone")),
        Element(id: "cloth", name: "Cloth", icon: "tshirt.fill", realm: .civilization, tier: 2, recipe: ("plant", "tool")),
        Element(id: "paper", name: "Paper", icon: "doc.fill", realm: .civilization, tier: 2, recipe: ("wood", "water")),
        Element(id: "city", name: "City", icon: "building.2.fill", realm: .civilization, tier: 3, recipe: ("house", "house")),
        Element(id: "ship", name: "Ship", icon: "sailboat.fill", realm: .civilization, tier: 3, recipe: ("wood", "cloth")),

        // Arcane (tier 1-3)
        Element(id: "potion", name: "Potion", icon: "flask.fill", realm: .arcane, tier: 1, recipe: ("water", "mushroom")),
        Element(id: "spirit", name: "Spirit", icon: "figure.mind.and.body", realm: .arcane, tier: 1, recipe: ("energy", "mist")),
        Element(id: "rune", name: "Rune", icon: "textformat.alt", realm: .arcane, tier: 1, recipe: ("stone", "energy")),
        Element(id: "aura", name: "Aura", icon: "circle.hexagongrid.fill", realm: .arcane, tier: 2, recipe: ("spirit", "energy")),
        Element(id: "elixir", name: "Elixir", icon: "cross.vial.fill", realm: .arcane, tier: 2, recipe: ("potion", "crystal")),
        Element(id: "enchant", name: "Enchantment", icon: "wand.and.stars", realm: .arcane, tier: 2, recipe: ("rune", "aura")),
        Element(id: "golem", name: "Golem", icon: "figure.stand", realm: .arcane, tier: 2, recipe: ("stone", "spirit")),
        Element(id: "phoenix", name: "Phoenix", icon: "bird.fill", realm: .arcane, tier: 3, recipe: ("fire", "spirit")),
        Element(id: "philosopher", name: "Philosopher's Stone", icon: "seal.fill", realm: .arcane, tier: 3, recipe: ("crystal", "elixir")),
        Element(id: "wand", name: "Wand", icon: "wand.and.rays", realm: .arcane, tier: 2, recipe: ("wood", "crystal")),
        Element(id: "scroll", name: "Scroll", icon: "scroll.fill", realm: .arcane, tier: 2, recipe: ("paper", "rune")),
        Element(id: "alchemy", name: "Alchemy", icon: "atom", realm: .arcane, tier: 3, recipe: ("philosopher", "enchant")),

        // Cosmos (tier 1-3)
        Element(id: "star", name: "Star", icon: "star.fill", realm: .cosmos, tier: 1, recipe: ("fire", "energy")),
        Element(id: "moon", name: "Moon", icon: "moon.fill", realm: .cosmos, tier: 1, recipe: ("stone", "star")),
        Element(id: "sun", name: "Sun", icon: "sun.max.fill", realm: .cosmos, tier: 1, recipe: ("star", "star")),
        Element(id: "comet", name: "Comet", icon: "sparkle", realm: .cosmos, tier: 2, recipe: ("star", "ice")),
        Element(id: "nebula", name: "Nebula", icon: "cloud.sun.fill", realm: .cosmos, tier: 2, recipe: ("star", "dust")),
        Element(id: "planet", name: "Planet", icon: "globe.americas.fill", realm: .cosmos, tier: 2, recipe: ("earth", "star")),
        Element(id: "galaxy", name: "Galaxy", icon: "hurricane", realm: .cosmos, tier: 3, recipe: ("nebula", "star")),
        Element(id: "blackhole", name: "Black Hole", icon: "circle.fill", realm: .cosmos, tier: 3, recipe: ("sun", "sun")),
        Element(id: "aurora", name: "Aurora", icon: "rainbow", realm: .cosmos, tier: 2, recipe: ("sun", "air")),
        Element(id: "meteor", name: "Meteor", icon: "bolt.shield.fill", realm: .cosmos, tier: 2, recipe: ("stone", "comet")),
        Element(id: "eclipse", name: "Eclipse", icon: "moon.circle.fill", realm: .cosmos, tier: 2, recipe: ("sun", "moon")),
        Element(id: "void", name: "Void", icon: "circle.dashed", realm: .cosmos, tier: 3, recipe: ("blackhole", "energy")),
    ]

    static let elementMap: [String: Element] = {
        var map: [String: Element] = [:]
        for element in allElements {
            map[element.id] = element
        }
        return map
    }()

    static func combine(_ a: String, _ b: String) -> Element? {
        let pair1 = (a, b)
        let pair2 = (b, a)
        return allElements.first { element in
            guard let recipe = element.recipe else { return false }
            return (recipe.0 == pair1.0 && recipe.1 == pair1.1) ||
                   (recipe.0 == pair2.0 && recipe.1 == pair2.1)
        }
    }

    static func levelPuzzle(forLevel index: Int) -> LevelPuzzle {
        let realm = AlchemyRealm(rawValue: index / 16) ?? .primordial
        let lvl = index % 16
        let realmElements = allElements.filter { $0.realm == realm && !$0.isBase }
        let sortedByTier = realmElements.sorted { $0.tier < $1.tier }

        let targetIdx = min(lvl, sortedByTier.count - 1)
        let target = sortedByTier[max(0, targetIdx)]

        let hints = lvl < 4 ? 2 : (lvl < 10 ? 1 : 0)
        let targetMoves = max(1, target.tier + lvl / 6)

        return LevelPuzzle(
            levelIndex: index,
            targetElement: target,
            realm: realm,
            hintCount: hints,
            targetMoves: targetMoves
        )
    }
}

struct LevelPuzzle: Sendable {
    let levelIndex: Int
    let targetElement: Element
    let realm: AlchemyRealm
    let hintCount: Int
    let targetMoves: Int
}
