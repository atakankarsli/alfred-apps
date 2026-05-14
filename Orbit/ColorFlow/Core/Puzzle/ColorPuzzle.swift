import Foundation

struct GravitySource: Hashable {
    let x: Double
    let y: Double
    let mass: Double
    let kind: MassKind
}

enum MassKind: Int, Hashable, CaseIterable {
    case asteroid = 1
    case planet = 2
    case star = 3
    case blackHole = 4

    var label: String {
        switch self {
        case .asteroid: "Asteroid"
        case .planet: "Planet"
        case .star: "Star"
        case .blackHole: "Black Hole"
        }
    }

    var icon: String {
        switch self {
        case .asteroid: "circle.fill"
        case .planet: "globe.americas.fill"
        case .star: "sun.max.fill"
        case .blackHole: "eye.circle.fill"
        }
    }

    var massValue: Double {
        switch self {
        case .asteroid: 0.3
        case .planet: 1.0
        case .star: 3.0
        case .blackHole: 6.0
        }
    }

    var colorHex: String {
        switch self {
        case .asteroid: "9CA3AF"
        case .planet: "3B82F6"
        case .star: "F59E0B"
        case .blackHole: "7C3AED"
        }
    }
}

struct OrbitCheckpoint: Hashable {
    let x: Double
    let y: Double
    let radius: Double
}

struct OrbitPuzzle {
    let level: Int
    let satelliteStart: (x: Double, y: Double)
    let satelliteVelocity: (vx: Double, vy: Double)
    let checkpoints: [OrbitCheckpoint]
    let fixedSources: [GravitySource]
    let availableMasses: [MassKind]
    let placementSlots: [(x: Double, y: Double)]
    let parPlacements: Int

    static func generate(level: Int) -> OrbitPuzzle {
        var rng = SeededRNG(seed: UInt64(level * 7919 + 104729))

        let sectorIndex = level / 16
        let localIndex = level % 16

        let numCheckpoints = min(3 + localIndex / 4, 6)
        let numSlots = slotCount(sector: sectorIndex, local: localIndex)
        let par = parCount(sector: sectorIndex, local: localIndex)

        let checkpoints = generateCheckpoints(count: numCheckpoints, rng: &rng)
        let slots = generateSlots(count: numSlots, rng: &rng)
        let fixed = generateFixedSources(sector: sectorIndex, local: localIndex, rng: &rng)
        let available = availableMasses(sector: sectorIndex, local: localIndex)

        let startPos = generateStart(rng: &rng)
        let startVel = generateVelocity(sector: sectorIndex, rng: &rng)

        return OrbitPuzzle(
            level: level,
            satelliteStart: startPos,
            satelliteVelocity: startVel,
            checkpoints: checkpoints,
            fixedSources: fixed,
            availableMasses: available,
            placementSlots: slots,
            parPlacements: par
        )
    }

    static func simulate(sources: [GravitySource], startX: Double, startY: Double, vx: Double, vy: Double, steps: Int) -> [(x: Double, y: Double)] {
        var x = startX
        var y = startY
        var velX = vx
        var velY = vy
        var path: [(x: Double, y: Double)] = [(x, y)]
        let dt = 0.02
        let g = 10.0

        for _ in 0..<steps {
            var ax = 0.0
            var ay = 0.0

            for source in sources {
                let dx = source.x - x
                let dy = source.y - y
                let distSq = max(dx * dx + dy * dy, 0.01)
                let dist = distSq.squareRoot()
                let force = g * source.mass / distSq
                ax += force * dx / dist
                ay += force * dy / dist
            }

            velX += ax * dt
            velY += ay * dt
            x += velX * dt
            y += velY * dt

            if x < -0.3 || x > 1.3 || y < -0.3 || y > 1.3 { break }

            path.append((x, y))
        }

        return path
    }

    static func checkpointsHit(path: [(x: Double, y: Double)], checkpoints: [OrbitCheckpoint]) -> Int {
        var hit = Set<Int>()
        for point in path {
            for (i, cp) in checkpoints.enumerated() {
                let dx = point.x - cp.x
                let dy = point.y - cp.y
                if dx * dx + dy * dy <= cp.radius * cp.radius {
                    hit.insert(i)
                }
            }
        }
        return hit.count
    }

    static func accuracy(path: [(x: Double, y: Double)], checkpoints: [OrbitCheckpoint]) -> Double {
        guard !checkpoints.isEmpty else { return 0 }
        let hit = checkpointsHit(path: path, checkpoints: checkpoints)
        return Double(hit) / Double(checkpoints.count)
    }

    // MARK: - Generation Helpers

    private static func slotCount(sector: Int, local: Int) -> Int {
        switch sector {
        case 0: return 2 + local / 8
        case 1: return 3 + local / 8
        case 2: return 3 + local / 6
        case 3: return 4 + local / 8
        default: return 4 + local / 6
        }
    }

    private static func parCount(sector: Int, local: Int) -> Int {
        switch sector {
        case 0: return 1 + local / 8
        case 1: return 1 + local / 6
        case 2: return 2 + local / 8
        case 3: return 2 + local / 6
        default: return 2 + local / 5
        }
    }

    private static func generateCheckpoints(count: Int, rng: inout SeededRNG) -> [OrbitCheckpoint] {
        (0..<count).map { i in
            let angle = Double(i) / Double(count) * 2.0 * .pi
            let r = 0.2 + Double(rng.next() % 100) / 400.0
            let cx = 0.5 + r * cos(angle)
            let cy = 0.5 + r * sin(angle)
            return OrbitCheckpoint(x: cx, y: cy, radius: 0.06)
        }
    }

    private static func generateSlots(count: Int, rng: inout SeededRNG) -> [(x: Double, y: Double)] {
        (0..<count).map { _ in
            let x = 0.15 + Double(rng.next() % 70) / 100.0
            let y = 0.15 + Double(rng.next() % 70) / 100.0
            return (x, y)
        }
    }

    private static func generateFixedSources(sector: Int, local: Int, rng: inout SeededRNG) -> [GravitySource] {
        switch sector {
        case 0:
            return [GravitySource(x: 0.5, y: 0.5, mass: 2.0, kind: .star)]
        case 1:
            return [GravitySource(x: 0.5, y: 0.5, mass: 1.5, kind: .star)]
        case 2:
            return [
                GravitySource(x: 0.4, y: 0.5, mass: 2.0, kind: .star),
                GravitySource(x: 0.7, y: 0.4, mass: 1.5, kind: .planet),
            ]
        case 3:
            let offset = 0.08 + Double(local) * 0.005
            return [
                GravitySource(x: 0.5 - offset, y: 0.5, mass: 2.0, kind: .star),
                GravitySource(x: 0.5 + offset, y: 0.5, mass: 2.0, kind: .star),
            ]
        default:
            if local < 8 {
                return [GravitySource(x: 0.5, y: 0.5, mass: 3.0, kind: .blackHole)]
            }
            return [
                GravitySource(x: 0.35, y: 0.5, mass: 3.0, kind: .blackHole),
                GravitySource(x: 0.65, y: 0.5, mass: 2.0, kind: .star),
            ]
        }
    }

    private static func availableMasses(sector: Int, local: Int) -> [MassKind] {
        switch sector {
        case 0: return [.planet]
        case 1: return [.asteroid, .planet]
        case 2: return [.planet, .star]
        case 3: return [.asteroid, .planet, .star]
        default: return MassKind.allCases
        }
    }

    private static func generateStart(rng: inout SeededRNG) -> (x: Double, y: Double) {
        let edge = Int(rng.next() % 4)
        switch edge {
        case 0: return (0.05, 0.3 + Double(rng.next() % 40) / 100.0)
        case 1: return (0.95, 0.3 + Double(rng.next() % 40) / 100.0)
        case 2: return (0.3 + Double(rng.next() % 40) / 100.0, 0.05)
        default: return (0.3 + Double(rng.next() % 40) / 100.0, 0.95)
        }
    }

    private static func generateVelocity(sector: Int, rng: inout SeededRNG) -> (vx: Double, vy: Double) {
        let speed = 1.5 + Double(sector) * 0.3
        let angle = Double(rng.next() % 628) / 100.0
        return (speed * cos(angle), speed * sin(angle))
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
