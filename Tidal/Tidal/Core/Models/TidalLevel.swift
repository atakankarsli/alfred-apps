import Foundation

struct TidalLevel {
    let index: Int
    let maxSources: Int
    let targets: [TargetZone]
    let obstacles: [Obstacle]
    let fixedSources: [WaveSource]
    let timeLimit: Int?
    let frequencyLocked: Bool
    let amplitudeLocked: Bool

    var world: WaveWorld {
        WaveWorld(rawValue: index / 16) ?? .ripples
    }

    var levelInWorld: Int {
        index % 16
    }

    var displayNumber: Int {
        index + 1
    }
}
