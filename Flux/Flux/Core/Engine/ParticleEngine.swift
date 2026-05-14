import SwiftUI

struct Particle: Identifiable {
    let id: Int
    var x: Double; var y: Double
    var vx: Double; var vy: Double
    var color: Color; var size: CGFloat
    var life: Double; var maxLife: Double
    var trail: [(Double, Double)]
}

struct FlowChallenge: Sendable {
    let title: String
    let element: FluidElement
    let targetPattern: TargetPattern
    let level: Int
    let particleCount: Int

    enum TargetPattern: Sendable {
        case fillArea(x: Double, y: Double, radius: Double)
        case connectPoints(points: [(Double, Double)])
        case spiral(centerX: Double, centerY: Double)
        case wave(amplitude: Double, frequency: Double)
        case freeform
    }
}

struct SeededRNG: RandomNumberGenerator {
    private var state: UInt64
    init(seed: UInt64) { state = seed }
    mutating func next() -> UInt64 {
        state &+= 0x9e3779b97f4a7c15
        var z = state
        z = (z ^ (z >> 30)) &* 0xbf58476d1ce4e5b9
        z = (z ^ (z >> 27)) &* 0x94d049bb133111eb
        return z ^ (z >> 31)
    }
}

enum ParticleEngine {
    static func generateChallenge(element: FluidElement, dayOffset: Int, level: Int) -> FlowChallenge {
        let seed = UInt64(dayOffset * 1000 + level * 10 + element.hashValue)
        var rng = SeededRNG(seed: seed)

        let titles = flowTitles[element] ?? ["Flow"]
        let title = titles[Int(rng.next() % UInt64(titles.count))]

        let patterns: [FlowChallenge.TargetPattern] = [
            .fillArea(x: Double(rng.next() % 60 + 20) / 100, y: Double(rng.next() % 60 + 20) / 100, radius: 0.15 + Double(rng.next() % 10) / 100),
            .connectPoints(points: (0..<(3 + level / 20)).map { _ in
                (Double(rng.next() % 80 + 10) / 100, Double(rng.next() % 80 + 10) / 100)
            }),
            .spiral(centerX: 0.5, centerY: 0.5),
            .wave(amplitude: 0.1 + Double(rng.next() % 15) / 100, frequency: 2 + Double(rng.next() % 3)),
            .freeform,
        ]
        let pattern = patterns[Int(rng.next() % UInt64(patterns.count))]
        let count = 80 + level * 2

        return FlowChallenge(title: title, element: element, targetPattern: pattern, level: level, particleCount: count)
    }

    static func createParticle(id: Int, at point: CGPoint, element: FluidElement, in size: CGSize, rng: inout SeededRNG) -> Particle {
        let angle = Double(rng.next() % 360) * .pi / 180
        let speed = 0.5 + Double(rng.next() % 100) / 100 * (1.0 - element.viscosity)
        let hueShift = Double(rng.next() % 30).advanced(by: -15) / 360
        let adjustedColor = element.baseColor.opacity(0.7 + Double(rng.next() % 30) / 100)
        _ = hueShift

        return Particle(
            id: id,
            x: Double(point.x) / Double(size.width),
            y: Double(point.y) / Double(size.height),
            vx: cos(angle) * speed * 0.01,
            vy: sin(angle) * speed * 0.01,
            color: adjustedColor,
            size: element.particleSize * CGFloat(0.8 + Double(rng.next() % 40) / 100),
            life: 1.0,
            maxLife: 3.0 + Double(rng.next() % 200) / 100,
            trail: []
        )
    }

    static func updateParticle(_ p: inout Particle, element: FluidElement, dt: Double) {
        p.trail.append((p.x, p.y))
        if p.trail.count > element.trailLength { p.trail.removeFirst() }

        p.vy += 0.0001 * (1.0 - element.viscosity)
        p.vx *= (1.0 - element.viscosity * 0.02)
        p.vy *= (1.0 - element.viscosity * 0.02)
        p.x += p.vx * dt * 60
        p.y += p.vy * dt * 60

        if p.x < 0 { p.x = 0; p.vx *= -0.5 }
        if p.x > 1 { p.x = 1; p.vx *= -0.5 }
        if p.y < 0 { p.y = 0; p.vy *= -0.5 }
        if p.y > 1 { p.y = 1; p.vy *= -0.5 }

        p.life -= dt / p.maxLife
    }

    private static let flowTitles: [FluidElement: [String]] = [
        .water: ["Gentle Stream", "Ocean Drift", "Rain Dance", "Tidal Wave", "Crystal Falls", "Deep Blue", "Aqua Pulse", "River Song", "Dew Drop", "Cascade", "Monsoon", "Ripple", "Surge", "Fountain", "Hydro", "Blue Lagoon", "Pearl Dive", "Coral Flow", "Ice Melt", "Spring"],
        .lava: ["Molten Core", "Eruption", "Magma Flow", "Fire River", "Ember Trail", "Inferno", "Volcanic", "Heat Wave", "Blaze", "Furnace", "Cinder", "Scorched", "Phoenix", "Solar Flare", "Ignite", "Smolder", "Forge", "Caldera", "Pyroclast", "Hellfire"],
        .plasma: ["Ion Storm", "Electric Arc", "Neon Pulse", "Lightning", "Spark Chain", "Charged", "Radiant", "Photon Burst", "Nova", "Galactic", "Quasar", "Nebula", "Cosmic Ray", "Aurora", "Solar Wind", "Particle Wave", "Flux Field", "Tesla", "Electron", "Voltage"],
        .mercury: ["Quicksilver", "Mirror Pool", "Chrome Wave", "Liquid Metal", "Silver Stream", "Platinum", "Steel Flow", "Alloy", "Titanium", "Pewter", "Zinc Rush", "Iron Tide", "Ore Melt", "Anvil Drop", "Bullet Rain", "Chrome", "Metal Rain", "Silverback", "Cold Steel", "Osmium"],
        .ether: ["Spirit Flow", "Phantom Mist", "Ghost Light", "Ethereal", "Wisp Trail", "Dream Wave", "Soul Drift", "Celestial", "Astral", "Mystic", "Enchanted", "Luminous", "Spectral", "Fairy Dust", "Starlight", "Moon Beam", "Shadow Play", "Twilight", "Echo", "Void"],
    ]
}
