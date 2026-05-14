import Foundation

@MainActor
@Observable
final class WaveEngine {
    var sources: [WaveSource] = []
    var time: Double = 0
    private let gridSize = 80

    func amplitude(at x: Double, y: Double) -> Double {
        var total = 0.0
        for source in sources where source.isActive {
            let dx = x - source.position.x
            let dy = y - source.position.y
            let r = sqrt(dx * dx + dy * dy)
            guard r > 0.01 else {
                total += source.amplitude
                continue
            }
            let k = 2.0 * .pi * source.frequency
            let omega = 2.0 * .pi * source.frequency * 0.5
            let decay = 1.0 / sqrt(max(r, 0.5))
            total += source.amplitude * sin(k * r - omega * time + source.phase) * decay
        }
        return total
    }

    func computeGrid(width: Int, height: Int) -> [Double] {
        let w = width
        let h = height
        var grid = [Double](repeating: 0, count: w * h)
        let scaleX = 1.0 / Double(w)
        let scaleY = 1.0 / Double(h)

        for iy in 0..<h {
            let y = Double(iy) * scaleY
            for ix in 0..<w {
                let x = Double(ix) * scaleX
                grid[iy * w + ix] = amplitude(at: x, y: y)
            }
        }
        return grid
    }

    func scoreAgainstTargets(_ targets: [TargetZone]) -> Double {
        guard !targets.isEmpty else { return 0 }

        var totalScore = 0.0
        for target in targets {
            let amp = amplitude(at: target.position.x, y: target.position.y)

            let score: Double
            switch target.targetAmplitude {
            case .constructive:
                score = min(1, max(0, abs(amp) / 1.5))
            case .destructive:
                score = max(0, 1 - abs(amp) * 2)
            case .specific(let target):
                let diff = abs(abs(amp) - abs(target))
                score = max(0, 1 - diff)
            }
            totalScore += score
        }
        return totalScore / Double(targets.count)
    }

    func tick(dt: Double = 1.0 / 60.0) {
        time += dt
    }

    func reset() {
        sources.removeAll()
        time = 0
    }
}
