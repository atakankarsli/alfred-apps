import Foundation

struct GameSession {
    let gameType: GameType
    let level: Int
    let targets: [Target]
    let duration: Double

    struct Target: Identifiable {
        let id: Int
        let x: Double
        let y: Double
        let appearTime: Double
        let duration: Double
        let size: Double
    }

    static func generate(type: GameType, level: Int) -> GameSession {
        var rng = SeededRNG(seed: UInt64(level * 31337 + type.hashValue + 2027))
        let targets = generateTargets(type: type, level: level, rng: &rng)
        return GameSession(gameType: type, level: level, targets: targets, duration: Double(type.durationSeconds))
    }

    private static func generateTargets(type: GameType, level: Int, rng: inout SeededRNG) -> [Target] {
        switch type {
        case .eyeFocus:
            return eyeFocusTargets(level: level, rng: &rng)
        case .breathSync:
            return breathTargets(level: level, rng: &rng)
        case .reflexRush:
            return reflexTargets(level: level, rng: &rng)
        case .postureCheck:
            return postureTargets(level: level, rng: &rng)
        }
    }

    private static func eyeFocusTargets(level: Int, rng: inout SeededRNG) -> [Target] {
        let count = 8 + min(level / 5, 12)
        let interval = 120.0 / Double(count)
        return (0..<count).map { i in
            Target(
                id: i,
                x: Double.random(in: 0.15...0.85, using: &rng),
                y: Double.random(in: 0.2...0.8, using: &rng),
                appearTime: Double(i) * interval + 1.0,
                duration: max(2.0 - Double(level) * 0.03, 0.8),
                size: max(60 - Double(level) * 0.5, 30)
            )
        }
    }

    private static func breathTargets(level: Int, rng: inout SeededRNG) -> [Target] {
        let cycles = 6 + min(level / 8, 6)
        let cycleTime = 120.0 / Double(cycles)
        return (0..<cycles).map { i in
            let inhaleRatio = 0.4 + Double.random(in: -0.05...0.05, using: &rng)
            return Target(
                id: i,
                x: inhaleRatio,
                y: 1.0 - inhaleRatio,
                appearTime: Double(i) * cycleTime + 0.5,
                duration: cycleTime,
                size: Double(60 + level)
            )
        }
    }

    private static func reflexTargets(level: Int, rng: inout SeededRNG) -> [Target] {
        let count = 15 + min(level / 3, 25)
        return (0..<count).map { i in
            Target(
                id: i,
                x: Double.random(in: 0.1...0.9, using: &rng),
                y: Double.random(in: 0.15...0.85, using: &rng),
                appearTime: Double.random(in: 1.0...58.0, using: &rng),
                duration: max(1.5 - Double(level) * 0.015, 0.4),
                size: max(70 - Double(level) * 0.5, 35)
            )
        }.sorted { $0.appearTime < $1.appearTime }
    }

    private static func postureTargets(level: Int, rng: inout SeededRNG) -> [Target] {
        let count = 6 + min(level / 6, 8)
        let interval = 90.0 / Double(count)
        return (0..<count).map { i in
            Target(
                id: i,
                x: 0.5 + Double.random(in: -0.2...0.2, using: &rng),
                y: 0.5 + Double.random(in: -0.2...0.2, using: &rng),
                appearTime: Double(i) * interval + 1.0,
                duration: max(4.0 - Double(level) * 0.04, 1.5),
                size: max(80 - Double(level) * 0.6, 40)
            )
        }
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
