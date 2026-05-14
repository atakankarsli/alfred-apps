import Foundation

enum ConstellationData {
    static func constellation(for levelIndex: Int) -> Constellation {
        let all = allConstellations
        return all[levelIndex % all.count]
    }

    static let allConstellations: [Constellation] = {
        var result: [Constellation] = []

        // Realm 0: Zodiac (16 levels)
        result.append(Constellation(name: "Aries", latinName: "Aries", stars: [
            Star(position: CGPoint(x: 0.35, y: 0.40), magnitude: 2.0),
            Star(position: CGPoint(x: 0.50, y: 0.35), magnitude: 2.6),
            Star(position: CGPoint(x: 0.65, y: 0.45), magnitude: 3.6),
            Star(position: CGPoint(x: 0.72, y: 0.55), magnitude: 4.0),
        ], connections: [
            StarConnection(from: 0, to: 1), StarConnection(from: 1, to: 2), StarConnection(from: 2, to: 3),
        ], difficulty: 1))

        result.append(Constellation(name: "Taurus", latinName: "Taurus", stars: [
            Star(position: CGPoint(x: 0.40, y: 0.35), magnitude: 0.9),
            Star(position: CGPoint(x: 0.50, y: 0.40), magnitude: 1.7),
            Star(position: CGPoint(x: 0.60, y: 0.30), magnitude: 3.0),
            Star(position: CGPoint(x: 0.55, y: 0.50), magnitude: 3.4),
            Star(position: CGPoint(x: 0.30, y: 0.55), magnitude: 2.9),
        ], connections: [
            StarConnection(from: 0, to: 1), StarConnection(from: 1, to: 2), StarConnection(from: 1, to: 3), StarConnection(from: 0, to: 4),
        ], difficulty: 1))

        result.append(Constellation(name: "Gemini", latinName: "Gemini", stars: [
            Star(position: CGPoint(x: 0.35, y: 0.25), magnitude: 1.6),
            Star(position: CGPoint(x: 0.50, y: 0.25), magnitude: 1.2),
            Star(position: CGPoint(x: 0.38, y: 0.45), magnitude: 3.0),
            Star(position: CGPoint(x: 0.52, y: 0.42), magnitude: 2.9),
            Star(position: CGPoint(x: 0.40, y: 0.65), magnitude: 3.5),
            Star(position: CGPoint(x: 0.55, y: 0.62), magnitude: 3.3),
        ], connections: [
            StarConnection(from: 0, to: 2), StarConnection(from: 1, to: 3),
            StarConnection(from: 2, to: 4), StarConnection(from: 3, to: 5),
            StarConnection(from: 2, to: 3),
        ], difficulty: 2))

        result.append(Constellation(name: "Cancer", latinName: "Cancer", stars: [
            Star(position: CGPoint(x: 0.40, y: 0.35), magnitude: 3.5),
            Star(position: CGPoint(x: 0.55, y: 0.40), magnitude: 3.8),
            Star(position: CGPoint(x: 0.48, y: 0.55), magnitude: 4.0),
            Star(position: CGPoint(x: 0.60, y: 0.60), magnitude: 3.9),
            Star(position: CGPoint(x: 0.35, y: 0.50), magnitude: 4.2),
        ], connections: [
            StarConnection(from: 0, to: 1), StarConnection(from: 1, to: 2),
            StarConnection(from: 2, to: 3), StarConnection(from: 2, to: 4),
        ], difficulty: 2))

        result.append(Constellation(name: "Leo", latinName: "Leo", stars: [
            Star(position: CGPoint(x: 0.30, y: 0.40), magnitude: 1.4),
            Star(position: CGPoint(x: 0.40, y: 0.30), magnitude: 2.6),
            Star(position: CGPoint(x: 0.55, y: 0.28), magnitude: 2.1),
            Star(position: CGPoint(x: 0.65, y: 0.35), magnitude: 2.0),
            Star(position: CGPoint(x: 0.60, y: 0.50), magnitude: 2.6),
            Star(position: CGPoint(x: 0.45, y: 0.55), magnitude: 3.4),
        ], connections: [
            StarConnection(from: 0, to: 1), StarConnection(from: 1, to: 2),
            StarConnection(from: 2, to: 3), StarConnection(from: 3, to: 4),
            StarConnection(from: 4, to: 5), StarConnection(from: 5, to: 0),
        ], difficulty: 2))

        result.append(Constellation(name: "Virgo", latinName: "Virgo", stars: [
            Star(position: CGPoint(x: 0.50, y: 0.25), magnitude: 1.0),
            Star(position: CGPoint(x: 0.45, y: 0.38), magnitude: 2.8),
            Star(position: CGPoint(x: 0.55, y: 0.42), magnitude: 2.9),
            Star(position: CGPoint(x: 0.40, y: 0.55), magnitude: 3.4),
            Star(position: CGPoint(x: 0.60, y: 0.55), magnitude: 3.6),
            Star(position: CGPoint(x: 0.35, y: 0.70), magnitude: 3.5),
            Star(position: CGPoint(x: 0.55, y: 0.68), magnitude: 3.4),
        ], connections: [
            StarConnection(from: 0, to: 1), StarConnection(from: 0, to: 2),
            StarConnection(from: 1, to: 3), StarConnection(from: 2, to: 4),
            StarConnection(from: 3, to: 5), StarConnection(from: 4, to: 6),
        ], difficulty: 3))

        result.append(Constellation(name: "Libra", latinName: "Libra", stars: [
            Star(position: CGPoint(x: 0.50, y: 0.30), magnitude: 2.6),
            Star(position: CGPoint(x: 0.35, y: 0.50), magnitude: 2.7),
            Star(position: CGPoint(x: 0.65, y: 0.50), magnitude: 2.6),
            Star(position: CGPoint(x: 0.30, y: 0.70), magnitude: 3.3),
            Star(position: CGPoint(x: 0.70, y: 0.70), magnitude: 3.5),
        ], connections: [
            StarConnection(from: 0, to: 1), StarConnection(from: 0, to: 2),
            StarConnection(from: 1, to: 3), StarConnection(from: 2, to: 4),
        ], difficulty: 2))

        result.append(Constellation(name: "Scorpius", latinName: "Scorpius", stars: [
            Star(position: CGPoint(x: 0.30, y: 0.25), magnitude: 2.9),
            Star(position: CGPoint(x: 0.35, y: 0.35), magnitude: 2.6),
            Star(position: CGPoint(x: 0.40, y: 0.45), magnitude: 1.0),
            Star(position: CGPoint(x: 0.45, y: 0.55), magnitude: 2.3),
            Star(position: CGPoint(x: 0.50, y: 0.62), magnitude: 2.7),
            Star(position: CGPoint(x: 0.58, y: 0.68), magnitude: 2.8),
            Star(position: CGPoint(x: 0.65, y: 0.72), magnitude: 1.6),
            Star(position: CGPoint(x: 0.70, y: 0.65), magnitude: 3.0),
        ], connections: [
            StarConnection(from: 0, to: 1), StarConnection(from: 1, to: 2),
            StarConnection(from: 2, to: 3), StarConnection(from: 3, to: 4),
            StarConnection(from: 4, to: 5), StarConnection(from: 5, to: 6),
            StarConnection(from: 6, to: 7),
        ], difficulty: 3))

        result.append(Constellation(name: "Sagittarius", latinName: "Sagittarius", stars: [
            Star(position: CGPoint(x: 0.40, y: 0.30), magnitude: 2.0),
            Star(position: CGPoint(x: 0.50, y: 0.25), magnitude: 2.7),
            Star(position: CGPoint(x: 0.55, y: 0.40), magnitude: 1.8),
            Star(position: CGPoint(x: 0.45, y: 0.45), magnitude: 2.6),
            Star(position: CGPoint(x: 0.50, y: 0.55), magnitude: 2.9),
            Star(position: CGPoint(x: 0.60, y: 0.55), magnitude: 3.1),
            Star(position: CGPoint(x: 0.40, y: 0.65), magnitude: 3.0),
        ], connections: [
            StarConnection(from: 0, to: 1), StarConnection(from: 0, to: 3),
            StarConnection(from: 1, to: 2), StarConnection(from: 2, to: 3),
            StarConnection(from: 3, to: 4), StarConnection(from: 2, to: 5),
            StarConnection(from: 4, to: 6),
        ], difficulty: 3))

        result.append(Constellation(name: "Capricornus", latinName: "Capricornus", stars: [
            Star(position: CGPoint(x: 0.30, y: 0.40), magnitude: 3.6),
            Star(position: CGPoint(x: 0.40, y: 0.35), magnitude: 3.1),
            Star(position: CGPoint(x: 0.55, y: 0.33), magnitude: 2.9),
            Star(position: CGPoint(x: 0.68, y: 0.40), magnitude: 3.7),
            Star(position: CGPoint(x: 0.65, y: 0.55), magnitude: 2.8),
            Star(position: CGPoint(x: 0.45, y: 0.58), magnitude: 3.3),
        ], connections: [
            StarConnection(from: 0, to: 1), StarConnection(from: 1, to: 2),
            StarConnection(from: 2, to: 3), StarConnection(from: 3, to: 4),
            StarConnection(from: 4, to: 5), StarConnection(from: 5, to: 0),
        ], difficulty: 3))

        result.append(Constellation(name: "Aquarius", latinName: "Aquarius", stars: [
            Star(position: CGPoint(x: 0.40, y: 0.25), magnitude: 2.9),
            Star(position: CGPoint(x: 0.50, y: 0.30), magnitude: 2.9),
            Star(position: CGPoint(x: 0.55, y: 0.40), magnitude: 3.3),
            Star(position: CGPoint(x: 0.48, y: 0.50), magnitude: 3.7),
            Star(position: CGPoint(x: 0.42, y: 0.60), magnitude: 3.6),
            Star(position: CGPoint(x: 0.55, y: 0.65), magnitude: 4.0),
            Star(position: CGPoint(x: 0.60, y: 0.50), magnitude: 3.8),
        ], connections: [
            StarConnection(from: 0, to: 1), StarConnection(from: 1, to: 2),
            StarConnection(from: 2, to: 3), StarConnection(from: 3, to: 4),
            StarConnection(from: 3, to: 5), StarConnection(from: 2, to: 6),
        ], difficulty: 3))

        result.append(Constellation(name: "Pisces", latinName: "Pisces", stars: [
            Star(position: CGPoint(x: 0.30, y: 0.35), magnitude: 3.6),
            Star(position: CGPoint(x: 0.38, y: 0.45), magnitude: 4.1),
            Star(position: CGPoint(x: 0.48, y: 0.50), magnitude: 3.6),
            Star(position: CGPoint(x: 0.55, y: 0.42), magnitude: 4.4),
            Star(position: CGPoint(x: 0.62, y: 0.35), magnitude: 4.0),
            Star(position: CGPoint(x: 0.68, y: 0.50), magnitude: 3.8),
            Star(position: CGPoint(x: 0.58, y: 0.58), magnitude: 4.5),
        ], connections: [
            StarConnection(from: 0, to: 1), StarConnection(from: 1, to: 2),
            StarConnection(from: 2, to: 3), StarConnection(from: 3, to: 4),
            StarConnection(from: 2, to: 6), StarConnection(from: 4, to: 5),
        ], difficulty: 4))

        // Fill remaining zodiac levels with variations
        result.append(makeVariation("Aries Rising", "Aries", result[0], offsetX: 0.05, offsetY: 0.1, difficulty: 2))
        result.append(makeVariation("Taurus Major", "Taurus", result[1], offsetX: -0.03, offsetY: 0.05, difficulty: 3))
        result.append(makeVariation("Gemini Twins", "Gemini", result[2], offsetX: 0.04, offsetY: -0.05, difficulty: 3))
        result.append(makeVariation("Leo Minor", "Leo", result[4], offsetX: -0.05, offsetY: 0.08, difficulty: 4))

        // Realm 1: Mythical (16 levels)
        result.append(Constellation(name: "Orion", latinName: "Orion", stars: [
            Star(position: CGPoint(x: 0.40, y: 0.20), magnitude: 0.5),
            Star(position: CGPoint(x: 0.60, y: 0.22), magnitude: 0.1),
            Star(position: CGPoint(x: 0.45, y: 0.38), magnitude: 1.6),
            Star(position: CGPoint(x: 0.50, y: 0.40), magnitude: 1.7),
            Star(position: CGPoint(x: 0.55, y: 0.38), magnitude: 2.2),
            Star(position: CGPoint(x: 0.38, y: 0.60), magnitude: 2.1),
            Star(position: CGPoint(x: 0.62, y: 0.58), magnitude: 0.2),
        ], connections: [
            StarConnection(from: 0, to: 2), StarConnection(from: 1, to: 4),
            StarConnection(from: 2, to: 3), StarConnection(from: 3, to: 4),
            StarConnection(from: 2, to: 5), StarConnection(from: 4, to: 6),
        ], difficulty: 2))

        result.append(Constellation(name: "Perseus", latinName: "Perseus", stars: [
            Star(position: CGPoint(x: 0.50, y: 0.20), magnitude: 1.8),
            Star(position: CGPoint(x: 0.48, y: 0.35), magnitude: 2.1),
            Star(position: CGPoint(x: 0.55, y: 0.45), magnitude: 2.9),
            Star(position: CGPoint(x: 0.45, y: 0.52), magnitude: 2.9),
            Star(position: CGPoint(x: 0.40, y: 0.65), magnitude: 3.4),
            Star(position: CGPoint(x: 0.60, y: 0.60), magnitude: 3.0),
        ], connections: [
            StarConnection(from: 0, to: 1), StarConnection(from: 1, to: 2),
            StarConnection(from: 1, to: 3), StarConnection(from: 3, to: 4),
            StarConnection(from: 2, to: 5),
        ], difficulty: 2))

        result.append(Constellation(name: "Andromeda", latinName: "Andromeda", stars: [
            Star(position: CGPoint(x: 0.25, y: 0.45), magnitude: 2.1),
            Star(position: CGPoint(x: 0.40, y: 0.40), magnitude: 2.1),
            Star(position: CGPoint(x: 0.55, y: 0.38), magnitude: 2.2),
            Star(position: CGPoint(x: 0.70, y: 0.42), magnitude: 3.3),
            Star(position: CGPoint(x: 0.42, y: 0.30), magnitude: 3.6),
            Star(position: CGPoint(x: 0.58, y: 0.50), magnitude: 3.6),
        ], connections: [
            StarConnection(from: 0, to: 1), StarConnection(from: 1, to: 2),
            StarConnection(from: 2, to: 3), StarConnection(from: 1, to: 4),
            StarConnection(from: 2, to: 5),
        ], difficulty: 3))

        result.append(Constellation(name: "Hercules", latinName: "Hercules", stars: [
            Star(position: CGPoint(x: 0.45, y: 0.22), magnitude: 2.8),
            Star(position: CGPoint(x: 0.40, y: 0.38), magnitude: 3.1),
            Star(position: CGPoint(x: 0.55, y: 0.35), magnitude: 2.8),
            Star(position: CGPoint(x: 0.50, y: 0.50), magnitude: 3.5),
            Star(position: CGPoint(x: 0.38, y: 0.58), magnitude: 2.8),
            Star(position: CGPoint(x: 0.58, y: 0.55), magnitude: 3.5),
            Star(position: CGPoint(x: 0.45, y: 0.70), magnitude: 3.9),
        ], connections: [
            StarConnection(from: 0, to: 1), StarConnection(from: 0, to: 2),
            StarConnection(from: 1, to: 3), StarConnection(from: 2, to: 3),
            StarConnection(from: 3, to: 4), StarConnection(from: 3, to: 5),
            StarConnection(from: 4, to: 6),
        ], difficulty: 3))

        result.append(Constellation(name: "Cassiopeia", latinName: "Cassiopeia", stars: [
            Star(position: CGPoint(x: 0.25, y: 0.42), magnitude: 2.2),
            Star(position: CGPoint(x: 0.38, y: 0.35), magnitude: 2.3),
            Star(position: CGPoint(x: 0.50, y: 0.45), magnitude: 2.5),
            Star(position: CGPoint(x: 0.62, y: 0.35), magnitude: 2.7),
            Star(position: CGPoint(x: 0.75, y: 0.40), magnitude: 3.4),
        ], connections: [
            StarConnection(from: 0, to: 1), StarConnection(from: 1, to: 2),
            StarConnection(from: 2, to: 3), StarConnection(from: 3, to: 4),
        ], difficulty: 1))

        result.append(Constellation(name: "Pegasus", latinName: "Pegasus", stars: [
            Star(position: CGPoint(x: 0.35, y: 0.30), magnitude: 2.5),
            Star(position: CGPoint(x: 0.60, y: 0.30), magnitude: 2.4),
            Star(position: CGPoint(x: 0.62, y: 0.55), magnitude: 2.4),
            Star(position: CGPoint(x: 0.35, y: 0.55), magnitude: 2.8),
            Star(position: CGPoint(x: 0.25, y: 0.42), magnitude: 2.9),
            Star(position: CGPoint(x: 0.72, y: 0.42), magnitude: 3.5),
        ], connections: [
            StarConnection(from: 0, to: 1), StarConnection(from: 1, to: 2),
            StarConnection(from: 2, to: 3), StarConnection(from: 3, to: 0),
            StarConnection(from: 3, to: 4), StarConnection(from: 1, to: 5),
        ], difficulty: 3))

        // Fill remaining mythical
        for i in 0..<10 {
            let srcIdx = 16 + (i % 6)
            let src = result[srcIdx]
            result.append(makeVariation("\(src.name) \(i+2)", src.latinName, src,
                                       offsetX: Double(i % 3) * 0.03 - 0.03,
                                       offsetY: Double(i % 4) * 0.02 - 0.03,
                                       difficulty: min(src.difficulty + 1, 5)))
        }

        // Realm 2: Animals (16 levels)
        result.append(Constellation(name: "Ursa Major", latinName: "Ursa Major", stars: [
            Star(position: CGPoint(x: 0.30, y: 0.35), magnitude: 1.8),
            Star(position: CGPoint(x: 0.38, y: 0.30), magnitude: 2.4),
            Star(position: CGPoint(x: 0.48, y: 0.28), magnitude: 2.4),
            Star(position: CGPoint(x: 0.55, y: 0.32), magnitude: 3.3),
            Star(position: CGPoint(x: 0.58, y: 0.42), magnitude: 2.1),
            Star(position: CGPoint(x: 0.50, y: 0.48), magnitude: 2.4),
            Star(position: CGPoint(x: 0.42, y: 0.45), magnitude: 2.4),
        ], connections: [
            StarConnection(from: 0, to: 1), StarConnection(from: 1, to: 2),
            StarConnection(from: 2, to: 3), StarConnection(from: 3, to: 4),
            StarConnection(from: 4, to: 5), StarConnection(from: 5, to: 6),
            StarConnection(from: 6, to: 0),
        ], difficulty: 2))

        result.append(Constellation(name: "Aquila", latinName: "Aquila", stars: [
            Star(position: CGPoint(x: 0.50, y: 0.30), magnitude: 0.8),
            Star(position: CGPoint(x: 0.40, y: 0.40), magnitude: 2.7),
            Star(position: CGPoint(x: 0.60, y: 0.40), magnitude: 3.7),
            Star(position: CGPoint(x: 0.45, y: 0.55), magnitude: 3.4),
            Star(position: CGPoint(x: 0.55, y: 0.55), magnitude: 3.0),
        ], connections: [
            StarConnection(from: 0, to: 1), StarConnection(from: 0, to: 2),
            StarConnection(from: 1, to: 3), StarConnection(from: 2, to: 4),
        ], difficulty: 2))

        result.append(Constellation(name: "Cygnus", latinName: "Cygnus", stars: [
            Star(position: CGPoint(x: 0.50, y: 0.20), magnitude: 1.2),
            Star(position: CGPoint(x: 0.50, y: 0.40), magnitude: 2.2),
            Star(position: CGPoint(x: 0.35, y: 0.48), magnitude: 2.5),
            Star(position: CGPoint(x: 0.65, y: 0.48), magnitude: 2.5),
            Star(position: CGPoint(x: 0.50, y: 0.65), magnitude: 3.0),
        ], connections: [
            StarConnection(from: 0, to: 1), StarConnection(from: 1, to: 2),
            StarConnection(from: 1, to: 3), StarConnection(from: 1, to: 4),
        ], difficulty: 2))

        result.append(Constellation(name: "Leo Minor", latinName: "Leo Minor", stars: [
            Star(position: CGPoint(x: 0.30, y: 0.45), magnitude: 3.8),
            Star(position: CGPoint(x: 0.50, y: 0.40), magnitude: 4.2),
            Star(position: CGPoint(x: 0.70, y: 0.45), magnitude: 3.8),
        ], connections: [
            StarConnection(from: 0, to: 1), StarConnection(from: 1, to: 2),
        ], difficulty: 1))

        result.append(Constellation(name: "Lupus", latinName: "Lupus", stars: [
            Star(position: CGPoint(x: 0.45, y: 0.25), magnitude: 2.3),
            Star(position: CGPoint(x: 0.55, y: 0.35), magnitude: 2.7),
            Star(position: CGPoint(x: 0.40, y: 0.45), magnitude: 2.8),
            Star(position: CGPoint(x: 0.60, y: 0.50), magnitude: 3.2),
            Star(position: CGPoint(x: 0.50, y: 0.60), magnitude: 3.4),
        ], connections: [
            StarConnection(from: 0, to: 1), StarConnection(from: 0, to: 2),
            StarConnection(from: 1, to: 3), StarConnection(from: 2, to: 4),
            StarConnection(from: 3, to: 4),
        ], difficulty: 3))

        result.append(Constellation(name: "Corvus", latinName: "Corvus", stars: [
            Star(position: CGPoint(x: 0.35, y: 0.35), magnitude: 2.6),
            Star(position: CGPoint(x: 0.60, y: 0.30), magnitude: 2.7),
            Star(position: CGPoint(x: 0.65, y: 0.55), magnitude: 2.6),
            Star(position: CGPoint(x: 0.38, y: 0.58), magnitude: 3.0),
        ], connections: [
            StarConnection(from: 0, to: 1), StarConnection(from: 1, to: 2),
            StarConnection(from: 2, to: 3), StarConnection(from: 3, to: 0),
        ], difficulty: 2))

        // Fill remaining animals
        for i in 0..<10 {
            let srcIdx = 32 + (i % 6)
            let src = result[srcIdx]
            result.append(makeVariation("\(src.name) \(i+2)", src.latinName, src,
                                       offsetX: Double(i % 3) * 0.04 - 0.04,
                                       offsetY: Double(i % 4) * 0.03 - 0.04,
                                       difficulty: min(src.difficulty + 1, 5)))
        }

        // Realm 3: Ancient (16 levels)
        result.append(Constellation(name: "Draco", latinName: "Draco", stars: [
            Star(position: CGPoint(x: 0.35, y: 0.25), magnitude: 2.2),
            Star(position: CGPoint(x: 0.45, y: 0.30), magnitude: 3.1),
            Star(position: CGPoint(x: 0.55, y: 0.35), magnitude: 2.7),
            Star(position: CGPoint(x: 0.60, y: 0.48), magnitude: 2.2),
            Star(position: CGPoint(x: 0.50, y: 0.55), magnitude: 3.1),
            Star(position: CGPoint(x: 0.40, y: 0.50), magnitude: 2.7),
            Star(position: CGPoint(x: 0.35, y: 0.65), magnitude: 3.3),
        ], connections: [
            StarConnection(from: 0, to: 1), StarConnection(from: 1, to: 2),
            StarConnection(from: 2, to: 3), StarConnection(from: 3, to: 4),
            StarConnection(from: 4, to: 5), StarConnection(from: 5, to: 6),
        ], difficulty: 3))

        result.append(Constellation(name: "Lyra", latinName: "Lyra", stars: [
            Star(position: CGPoint(x: 0.50, y: 0.25), magnitude: 0.0),
            Star(position: CGPoint(x: 0.42, y: 0.45), magnitude: 3.3),
            Star(position: CGPoint(x: 0.58, y: 0.45), magnitude: 3.3),
            Star(position: CGPoint(x: 0.40, y: 0.60), magnitude: 3.5),
            Star(position: CGPoint(x: 0.60, y: 0.60), magnitude: 3.2),
        ], connections: [
            StarConnection(from: 0, to: 1), StarConnection(from: 0, to: 2),
            StarConnection(from: 1, to: 3), StarConnection(from: 2, to: 4),
            StarConnection(from: 3, to: 4),
        ], difficulty: 2))

        result.append(Constellation(name: "Bootes", latinName: "Boötes", stars: [
            Star(position: CGPoint(x: 0.50, y: 0.20), magnitude: 2.7),
            Star(position: CGPoint(x: 0.42, y: 0.35), magnitude: 3.0),
            Star(position: CGPoint(x: 0.58, y: 0.35), magnitude: 3.5),
            Star(position: CGPoint(x: 0.50, y: 0.50), magnitude: 0.0),
            Star(position: CGPoint(x: 0.40, y: 0.65), magnitude: 3.5),
            Star(position: CGPoint(x: 0.60, y: 0.65), magnitude: 3.5),
        ], connections: [
            StarConnection(from: 0, to: 1), StarConnection(from: 0, to: 2),
            StarConnection(from: 1, to: 3), StarConnection(from: 2, to: 3),
            StarConnection(from: 3, to: 4), StarConnection(from: 3, to: 5),
        ], difficulty: 3))

        // Fill remaining ancient
        for i in 0..<13 {
            let srcIdx = 48 + (i % 3)
            let src = result[srcIdx]
            result.append(makeVariation("Ancient \(i+4)", src.latinName, src,
                                       offsetX: Double(i % 5) * 0.02 - 0.04,
                                       offsetY: Double(i % 4) * 0.03 - 0.04,
                                       difficulty: min(src.difficulty + i / 4, 5)))
        }

        // Realm 4: Modern (16 levels)
        result.append(Constellation(name: "Crux", latinName: "Crux", stars: [
            Star(position: CGPoint(x: 0.50, y: 0.25), magnitude: 0.8),
            Star(position: CGPoint(x: 0.50, y: 0.60), magnitude: 1.3),
            Star(position: CGPoint(x: 0.35, y: 0.42), magnitude: 1.6),
            Star(position: CGPoint(x: 0.65, y: 0.42), magnitude: 1.6),
        ], connections: [
            StarConnection(from: 0, to: 1), StarConnection(from: 2, to: 3),
        ], difficulty: 1))

        result.append(Constellation(name: "Telescopium", latinName: "Telescopium", stars: [
            Star(position: CGPoint(x: 0.45, y: 0.35), magnitude: 3.5),
            Star(position: CGPoint(x: 0.55, y: 0.45), magnitude: 4.1),
            Star(position: CGPoint(x: 0.50, y: 0.60), magnitude: 4.5),
        ], connections: [
            StarConnection(from: 0, to: 1), StarConnection(from: 1, to: 2),
        ], difficulty: 1))

        result.append(Constellation(name: "Microscopium", latinName: "Microscopium", stars: [
            Star(position: CGPoint(x: 0.40, y: 0.30), magnitude: 4.7),
            Star(position: CGPoint(x: 0.55, y: 0.40), magnitude: 4.7),
            Star(position: CGPoint(x: 0.45, y: 0.55), magnitude: 5.0),
            Star(position: CGPoint(x: 0.60, y: 0.60), magnitude: 4.9),
        ], connections: [
            StarConnection(from: 0, to: 1), StarConnection(from: 1, to: 2),
            StarConnection(from: 2, to: 3),
        ], difficulty: 2))

        // Fill remaining modern
        for i in 0..<13 {
            let srcIdx = 64 + (i % 3)
            let src = result[srcIdx]
            result.append(makeVariation("Modern \(i+4)", src.latinName, src,
                                       offsetX: Double(i % 5) * 0.03 - 0.05,
                                       offsetY: Double(i % 3) * 0.04 - 0.04,
                                       difficulty: min(src.difficulty + i / 3, 5)))
        }

        return result
    }()

    private static func makeVariation(_ name: String, _ latin: String, _ src: Constellation,
                                       offsetX: Double, offsetY: Double, difficulty: Int) -> Constellation {
        let newStars = src.stars.map { star in
            Star(
                position: CGPoint(
                    x: min(max(star.position.x + offsetX, 0.1), 0.9),
                    y: min(max(star.position.y + offsetY, 0.1), 0.9)
                ),
                magnitude: star.magnitude
            )
        }
        return Constellation(name: name, latinName: latin, stars: newStars,
                            connections: src.connections, difficulty: difficulty)
    }
}
