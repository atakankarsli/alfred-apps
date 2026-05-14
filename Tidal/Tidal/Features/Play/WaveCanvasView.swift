import SwiftUI

struct WaveCanvasView: View {
    @Environment(\.theme) private var theme
    let engine: WaveEngine
    let targets: [TargetZone]
    let obstacles: [Obstacle]

    private let resolution = 60

    var body: some View {
        Canvas { context, size in
            drawWaves(context: context, size: size)
            drawObstacles(context: context, size: size)
            drawTargets(context: context, size: size)
            drawSources(context: context, size: size)
        }
    }

    private func drawWaves(context: GraphicsContext, size: CGSize) {
        let cellW = size.width / Double(resolution)
        let cellH = size.height / Double(resolution)

        for iy in 0..<resolution {
            let ny = Double(iy) / Double(resolution)
            for ix in 0..<resolution {
                let nx = Double(ix) / Double(resolution)
                let amp = engine.amplitude(at: nx, y: ny)
                let clamped = max(-1, min(1, amp))

                let color: Color
                if clamped > 0 {
                    color = theme.colors.primary.opacity(Double(clamped) * 0.7)
                } else if clamped < 0 {
                    color = theme.colors.secondary.opacity(Double(-clamped) * 0.5)
                } else {
                    continue
                }

                let rect = CGRect(
                    x: Double(ix) * cellW,
                    y: Double(iy) * cellH,
                    width: cellW + 1,
                    height: cellH + 1
                )
                context.fill(Path(rect), with: .color(color))
            }
        }
    }

    private func drawTargets(context: GraphicsContext, size: CGSize) {
        for target in targets {
            let x = target.position.x * size.width
            let y = target.position.y * size.height
            let r = target.radius * min(size.width, size.height)

            let isConstructive = target.targetAmplitude != .destructive
            let targetColor: Color = isConstructive ? .cyan : .orange

            let circle = Path(ellipseIn: CGRect(x: x - r, y: y - r, width: r * 2, height: r * 2))
            context.stroke(circle, with: .color(targetColor), style: StrokeStyle(lineWidth: 2, dash: [4, 4]))

            let innerCircle = Path(ellipseIn: CGRect(x: x - 4, y: y - 4, width: 8, height: 8))
            context.fill(innerCircle, with: .color(targetColor.opacity(0.8)))

            context.draw(
                Text(target.targetAmplitude.label)
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(targetColor),
                at: CGPoint(x: x, y: y + r + 10)
            )
        }
    }

    private func drawObstacles(context: GraphicsContext, size: CGSize) {
        for obstacle in obstacles {
            let x = obstacle.position.x * size.width
            let y = obstacle.position.y * size.height
            let w = obstacle.size.width * size.width
            let h = obstacle.size.height * size.height

            let rect = CGRect(x: x - w / 2, y: y - h / 2, width: w, height: h)
            context.fill(Path(rect), with: .color(theme.colors.textMuted.opacity(0.6)))
            context.stroke(Path(rect), with: .color(theme.colors.text.opacity(0.3)), lineWidth: 1)
        }
    }

    private func drawSources(context: GraphicsContext, size: CGSize) {
        for source in engine.sources where source.isActive {
            let x = source.position.x * size.width
            let y = source.position.y * size.height

            let outerCircle = Path(ellipseIn: CGRect(x: x - 14, y: y - 14, width: 28, height: 28))
            context.fill(outerCircle, with: .color(theme.colors.accent.opacity(0.3)))

            let innerCircle = Path(ellipseIn: CGRect(x: x - 8, y: y - 8, width: 16, height: 16))
            context.fill(innerCircle, with: .color(theme.colors.accent))

            let dot = Path(ellipseIn: CGRect(x: x - 3, y: y - 3, width: 6, height: 6))
            context.fill(dot, with: .color(.white))
        }
    }
}
