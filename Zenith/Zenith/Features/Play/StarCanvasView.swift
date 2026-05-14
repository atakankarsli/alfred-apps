import SwiftUI

struct StarCanvasView: View {
    @Environment(\.theme) private var theme
    let constellation: Constellation
    let engine: ZenithEngine
    let onStarTap: (Int) -> Void

    var body: some View {
        GeometryReader { geo in
            let size = geo.size
            ZStack {
                Canvas { context, canvasSize in
                    drawGrid(context: context, size: canvasSize)
                    drawConnections(context: context, size: canvasSize)
                    drawStars(context: context, size: canvasSize)
                }

                ForEach(constellation.stars.indices, id: \.self) { i in
                    let star = constellation.stars[i]
                    let pos = CGPoint(x: star.position.x * size.width, y: star.position.y * size.height)
                    let hitSize: CGFloat = 44

                    Circle()
                        .fill(Color.clear)
                        .frame(width: hitSize, height: hitSize)
                        .contentShape(Circle())
                        .position(pos)
                        .onTapGesture { onStarTap(i) }
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }

    private func drawGrid(context: GraphicsContext, size: CGSize) {
        let gridColor = theme.colors.cardBorder.opacity(0.15)
        for i in 1..<10 {
            let frac = CGFloat(i) / 10
            var hPath = Path()
            hPath.move(to: CGPoint(x: 0, y: frac * size.height))
            hPath.addLine(to: CGPoint(x: size.width, y: frac * size.height))
            context.stroke(hPath, with: .color(gridColor), lineWidth: 0.5)

            var vPath = Path()
            vPath.move(to: CGPoint(x: frac * size.width, y: 0))
            vPath.addLine(to: CGPoint(x: frac * size.width, y: size.height))
            context.stroke(vPath, with: .color(gridColor), lineWidth: 0.5)
        }
    }

    private func drawConnections(context: GraphicsContext, size: CGSize) {
        for conn in constellation.connections {
            let from = constellation.stars[conn.from].position
            let to = constellation.stars[conn.to].position

            let fromPt = CGPoint(x: from.x * size.width, y: from.y * size.height)
            let toPt = CGPoint(x: to.x * size.width, y: to.y * size.height)

            var path = Path()
            path.move(to: fromPt)
            path.addLine(to: toPt)

            if engine.isConnected(conn.from, conn.to) {
                context.stroke(path, with: .color(theme.colors.primary), lineWidth: 2.5)
                let glow = path
                context.stroke(glow, with: .color(theme.colors.primary.opacity(0.3)), lineWidth: 6)
            } else if engine.showHint {
                context.stroke(path, with: .color(theme.colors.textMuted.opacity(0.2)),
                              style: StrokeStyle(lineWidth: 1, dash: [4, 4]))
            }
        }
    }

    private func drawStars(context: GraphicsContext, size: CGSize) {
        for i in constellation.stars.indices {
            let star = constellation.stars[i]
            let pos = CGPoint(x: star.position.x * size.width, y: star.position.y * size.height)
            let baseSize = max(3.0, 8.0 - star.magnitude * 1.2)

            let isSelected = engine.selectedStarIndex == i
            let isConnected = engine.isStarConnected(i)

            let glowRadius = baseSize * (isSelected ? 4 : (isConnected ? 2.5 : 1.5))
            let glowColor = isSelected ? theme.colors.accent : (isConnected ? theme.colors.primary : theme.colors.text)
            let glowRect = CGRect(x: pos.x - glowRadius, y: pos.y - glowRadius,
                                  width: glowRadius * 2, height: glowRadius * 2)
            context.fill(Path(ellipseIn: glowRect), with: .color(glowColor.opacity(0.15)))

            let starRadius = isSelected ? baseSize * 1.8 : (isConnected ? baseSize * 1.3 : baseSize)
            let starRect = CGRect(x: pos.x - starRadius, y: pos.y - starRadius,
                                  width: starRadius * 2, height: starRadius * 2)
            let starColor = isSelected ? theme.colors.accent : (isConnected ? theme.colors.primary : theme.colors.text)
            context.fill(Path(ellipseIn: starRect), with: .color(starColor))
        }
    }
}
