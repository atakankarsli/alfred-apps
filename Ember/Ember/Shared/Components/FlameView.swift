import SwiftUI

struct FlameView: View {
    var intensity: Double = 0.5

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let time = timeline.date.timeIntervalSinceReferenceDate
                let cx = size.width / 2
                let cy = size.height * 0.7
                let baseRadius = min(size.width, size.height) * 0.15
                let flameHeight = baseRadius * (2.0 + intensity * 2.0)

                for i in 0..<25 {
                    let fi = Double(i)
                    let seed = fi * 1.3
                    let wobble = sin(time * 3.0 + seed) * baseRadius * 0.3
                    let yOffset = fi / 25.0 * flameHeight
                    let radiusFactor = 1.0 - (fi / 25.0)
                    let r = baseRadius * radiusFactor * (0.6 + intensity * 0.4) + wobble * 0.3

                    let alpha = radiusFactor * (0.3 + intensity * 0.4)
                    let hue: Double
                    if fi < 8 {
                        hue = 0.08 + fi * 0.005
                    } else if fi < 16 {
                        hue = 0.04 + (fi - 8) * 0.003
                    } else {
                        hue = 0.0
                    }

                    let color = Color(hue: hue, saturation: 0.9, brightness: 0.6 + intensity * 0.4)
                    let x = cx + wobble * 0.5
                    let y = cy - yOffset

                    let rect = CGRect(x: x - r, y: y - r * 1.5, width: r * 2, height: r * 3)
                    context.fill(
                        Ellipse().path(in: rect),
                        with: .color(color.opacity(alpha))
                    )
                }

                let glowRadius = baseRadius * (1.5 + intensity)
                let glowRect = CGRect(x: cx - glowRadius, y: cy - glowRadius, width: glowRadius * 2, height: glowRadius * 2)
                context.fill(
                    Circle().path(in: glowRect),
                    with: .color(Color.orange.opacity(0.08 + intensity * 0.07))
                )
            }
        }
    }
}
