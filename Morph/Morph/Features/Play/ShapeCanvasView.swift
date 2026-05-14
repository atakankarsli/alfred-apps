import SwiftUI

struct ShapeCanvasView: View {
    @Environment(\.theme) private var theme
    let currentShape: [CGPoint]
    let targetShape: [CGPoint]
    let matchScore: Double

    var body: some View {
        Canvas { context, size in
            drawGrid(context: context, size: size)
            drawShape(context: context, size: size, points: targetShape, style: .target)
            drawShape(context: context, size: size, points: currentShape, style: .current(matchScore))
        }
    }

    private func drawGrid(context: GraphicsContext, size: CGSize) {
        let gridCount = 10
        var gridPath = Path()
        for i in 0...gridCount {
            let x = size.width * CGFloat(i) / CGFloat(gridCount)
            let y = size.height * CGFloat(i) / CGFloat(gridCount)
            gridPath.move(to: CGPoint(x: x, y: 0))
            gridPath.addLine(to: CGPoint(x: x, y: size.height))
            gridPath.move(to: CGPoint(x: 0, y: y))
            gridPath.addLine(to: CGPoint(x: size.width, y: y))
        }
        context.stroke(gridPath, with: .color(.white.opacity(0.04)), lineWidth: 0.5)
    }

    private enum ShapeStyle {
        case target
        case current(Double)
    }

    private func drawShape(context: GraphicsContext, size: CGSize, points: [CGPoint], style: ShapeStyle) {
        guard points.count >= 3 else { return }

        let scaled = points.map { CGPoint(x: $0.x * size.width, y: $0.y * size.height) }

        var path = Path()
        path.move(to: scaled[0])
        for pt in scaled.dropFirst() { path.addLine(to: pt) }
        path.closeSubpath()

        switch style {
        case .target:
            context.fill(path, with: .color(.white.opacity(0.04)))
            context.stroke(path, with: .color(.white.opacity(0.25)), style: StrokeStyle(lineWidth: 2, dash: [8, 4]))
            for pt in scaled {
                let dot = Path(ellipseIn: CGRect(x: pt.x - 3, y: pt.y - 3, width: 6, height: 6))
                context.fill(dot, with: .color(.white.opacity(0.3)))
            }

        case .current(let score):
            let hue = score * 0.33
            let shapeColor = Color(hue: hue, saturation: 0.8, brightness: 0.9)
            context.fill(path, with: .color(shapeColor.opacity(0.15)))
            context.stroke(path, with: .color(shapeColor), lineWidth: 3)
            for pt in scaled {
                let dot = Path(ellipseIn: CGRect(x: pt.x - 5, y: pt.y - 5, width: 10, height: 10))
                context.fill(dot, with: .color(shapeColor))
            }
        }
    }
}
