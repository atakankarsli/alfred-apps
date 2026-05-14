import Foundation

enum TransformTool: String, CaseIterable, Identifiable, Sendable {
    case rotateCW = "rotate_cw"
    case rotateCCW = "rotate_ccw"
    case flipH = "flip_h"
    case flipV = "flip_v"
    case scaleUp = "scale_up"
    case scaleDown = "scale_down"
    case stretchX = "stretch_x"
    case stretchY = "stretch_y"
    case shiftLeft = "shift_left"
    case shiftRight = "shift_right"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .rotateCW: "arrow.clockwise"
        case .rotateCCW: "arrow.counterclockwise"
        case .flipH: "arrow.left.and.right.righttriangle.left.righttriangle.right"
        case .flipV: "arrow.up.and.down.righttriangle.up.righttriangle.down"
        case .scaleUp: "arrow.up.left.and.arrow.down.right"
        case .scaleDown: "arrow.down.right.and.arrow.up.left"
        case .stretchX: "arrow.left.and.right"
        case .stretchY: "arrow.up.and.down"
        case .shiftLeft: "arrow.left"
        case .shiftRight: "arrow.right"
        }
    }

    var label: String {
        switch self {
        case .rotateCW: "Rotate →"
        case .rotateCCW: "Rotate ←"
        case .flipH: "Flip H"
        case .flipV: "Flip V"
        case .scaleUp: "Grow"
        case .scaleDown: "Shrink"
        case .stretchX: "Wide"
        case .stretchY: "Tall"
        case .shiftLeft: "Left"
        case .shiftRight: "Right"
        }
    }

    func apply(to points: [CGPoint]) -> [CGPoint] {
        let center = centroid(of: points)
        switch self {
        case .rotateCW: return rotate(points, center: center, angle: .pi / 2)
        case .rotateCCW: return rotate(points, center: center, angle: -.pi / 2)
        case .flipH: return points.map { CGPoint(x: 2 * center.x - $0.x, y: $0.y) }
        case .flipV: return points.map { CGPoint(x: $0.x, y: 2 * center.y - $0.y) }
        case .scaleUp: return scale(points, center: center, factor: 1.2)
        case .scaleDown: return scale(points, center: center, factor: 0.8)
        case .stretchX: return points.map { CGPoint(x: center.x + ($0.x - center.x) * 1.3, y: $0.y) }
        case .stretchY: return points.map { CGPoint(x: $0.x, y: center.y + ($0.y - center.y) * 1.3) }
        case .shiftLeft: return points.map { CGPoint(x: $0.x - 0.05, y: $0.y) }
        case .shiftRight: return points.map { CGPoint(x: $0.x + 0.05, y: $0.y) }
        }
    }

    private func rotate(_ pts: [CGPoint], center: CGPoint, angle: CGFloat) -> [CGPoint] {
        let cos = cos(angle)
        let sin = sin(angle)
        return pts.map { p in
            let dx = p.x - center.x
            let dy = p.y - center.y
            return CGPoint(x: center.x + dx * cos - dy * sin, y: center.y + dx * sin + dy * cos)
        }
    }

    private func scale(_ pts: [CGPoint], center: CGPoint, factor: CGFloat) -> [CGPoint] {
        pts.map { p in
            CGPoint(x: center.x + (p.x - center.x) * factor, y: center.y + (p.y - center.y) * factor)
        }
    }

    private func centroid(of pts: [CGPoint]) -> CGPoint {
        let sum = pts.reduce(CGPoint.zero) { CGPoint(x: $0.x + $1.x, y: $0.y + $1.y) }
        return CGPoint(x: sum.x / CGFloat(pts.count), y: sum.y / CGFloat(pts.count))
    }
}

@MainActor
@Observable
final class MorphEngine {
    var currentShape: [CGPoint] = []
    var targetShape: [CGPoint] = []
    var moveCount = 0
    var moveHistory: [[CGPoint]] = []

    func setup(source: [CGPoint], target: [CGPoint]) {
        currentShape = source
        targetShape = target
        moveCount = 0
        moveHistory = [source]
    }

    func applyTool(_ tool: TransformTool) {
        moveHistory.append(currentShape)
        currentShape = tool.apply(to: currentShape)
        moveCount += 1
    }

    func undo() {
        guard let prev = moveHistory.popLast() else { return }
        currentShape = prev
        if moveCount > 0 { moveCount -= 1 }
    }

    func matchScore() -> Double {
        guard currentShape.count == targetShape.count else {
            return vertexCountMismatchScore()
        }

        var bestScore = 0.0
        for rotation in 0..<currentShape.count {
            var rotated = Array(currentShape[rotation...]) + Array(currentShape[..<rotation])
            let score = pairwiseScore(rotated, targetShape)
            bestScore = max(bestScore, score)

            rotated.reverse()
            let revScore = pairwiseScore(rotated, targetShape)
            bestScore = max(bestScore, revScore)
        }
        return bestScore
    }

    func isComplete(threshold: Double = 0.92) -> Bool {
        matchScore() >= threshold
    }

    func reset() {
        if let first = moveHistory.first {
            currentShape = first
        }
        moveCount = 0
        moveHistory = [currentShape]
    }

    private func pairwiseScore(_ a: [CGPoint], _ b: [CGPoint]) -> Double {
        guard a.count == b.count, !a.isEmpty else { return 0 }

        let centerA = centroid(of: a)
        let centerB = centroid(of: b)

        let normA = a.map { CGPoint(x: $0.x - centerA.x, y: $0.y - centerA.y) }
        let normB = b.map { CGPoint(x: $0.x - centerB.x, y: $0.y - centerB.y) }

        var totalDist = 0.0
        for i in normA.indices {
            let dx = normA[i].x - normB[i].x
            let dy = normA[i].y - normB[i].y
            totalDist += sqrt(dx * dx + dy * dy)
        }
        let avgDist = totalDist / Double(normA.count)
        return max(0, 1.0 - avgDist * 5.0)
    }

    private func vertexCountMismatchScore() -> Double {
        let diff = abs(currentShape.count - targetShape.count)
        return max(0, 1.0 - Double(diff) * 0.3)
    }

    private func centroid(of pts: [CGPoint]) -> CGPoint {
        let sum = pts.reduce(CGPoint.zero) { CGPoint(x: $0.x + $1.x, y: $0.y + $1.y) }
        return CGPoint(x: sum.x / CGFloat(pts.count), y: sum.y / CGFloat(pts.count))
    }
}
