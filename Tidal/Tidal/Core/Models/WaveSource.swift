import Foundation

struct WaveSource: Identifiable, Equatable {
    let id: UUID
    var position: CGPoint
    var frequency: Double
    var amplitude: Double
    var phase: Double
    var isActive: Bool

    init(
        id: UUID = UUID(),
        position: CGPoint = .zero,
        frequency: Double = 1.0,
        amplitude: Double = 1.0,
        phase: Double = 0.0,
        isActive: Bool = true
    ) {
        self.id = id
        self.position = position
        self.frequency = frequency
        self.amplitude = amplitude
        self.phase = phase
        self.isActive = isActive
    }
}

struct TargetZone: Equatable {
    let position: CGPoint
    let radius: Double
    let targetAmplitude: TargetType

    enum TargetType: Equatable {
        case constructive
        case destructive
        case specific(Double)

        var label: String {
            switch self {
            case .constructive: "High"
            case .destructive: "Calm"
            case .specific: "Match"
            }
        }
    }
}

struct Obstacle: Equatable {
    let position: CGPoint
    let size: CGSize
    let type: ObstacleType

    enum ObstacleType: Equatable {
        case wall
        case reflector
        case slit(width: Double)
    }
}
