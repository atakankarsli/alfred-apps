import Foundation

struct MorphLevel {
    let index: Int
    let source: [CGPoint]
    let target: [CGPoint]
    let availableTools: [TransformTool]
    let optimalMoves: Int

    var realm: ShapeRealm {
        ShapeRealm(rawValue: index / 16) ?? .prisms
    }

    var levelInRealm: Int { index % 16 }
    var displayNumber: Int { index + 1 }
}

enum LevelData {
    private static let shapes: [[CGPoint]] = [
        // 0: Triangle
        [CGPoint(x: 0.5, y: 0.2), CGPoint(x: 0.8, y: 0.8), CGPoint(x: 0.2, y: 0.8)],
        // 1: Square
        [CGPoint(x: 0.3, y: 0.3), CGPoint(x: 0.7, y: 0.3), CGPoint(x: 0.7, y: 0.7), CGPoint(x: 0.3, y: 0.7)],
        // 2: Diamond
        [CGPoint(x: 0.5, y: 0.2), CGPoint(x: 0.8, y: 0.5), CGPoint(x: 0.5, y: 0.8), CGPoint(x: 0.2, y: 0.5)],
        // 3: Pentagon
        [CGPoint(x: 0.5, y: 0.2), CGPoint(x: 0.8, y: 0.4), CGPoint(x: 0.7, y: 0.8), CGPoint(x: 0.3, y: 0.8), CGPoint(x: 0.2, y: 0.4)],
        // 4: Hexagon
        [CGPoint(x: 0.5, y: 0.2), CGPoint(x: 0.78, y: 0.35), CGPoint(x: 0.78, y: 0.65), CGPoint(x: 0.5, y: 0.8), CGPoint(x: 0.22, y: 0.65), CGPoint(x: 0.22, y: 0.35)],
        // 5: Arrow right
        [CGPoint(x: 0.2, y: 0.35), CGPoint(x: 0.55, y: 0.35), CGPoint(x: 0.55, y: 0.2), CGPoint(x: 0.8, y: 0.5), CGPoint(x: 0.55, y: 0.8), CGPoint(x: 0.55, y: 0.65), CGPoint(x: 0.2, y: 0.65)],
        // 6: Star 4-point
        [CGPoint(x: 0.5, y: 0.15), CGPoint(x: 0.58, y: 0.42), CGPoint(x: 0.85, y: 0.5), CGPoint(x: 0.58, y: 0.58), CGPoint(x: 0.5, y: 0.85), CGPoint(x: 0.42, y: 0.58), CGPoint(x: 0.15, y: 0.5), CGPoint(x: 0.42, y: 0.42)],
        // 7: Wide rectangle
        [CGPoint(x: 0.15, y: 0.35), CGPoint(x: 0.85, y: 0.35), CGPoint(x: 0.85, y: 0.65), CGPoint(x: 0.15, y: 0.65)],
        // 8: Tall rectangle
        [CGPoint(x: 0.35, y: 0.15), CGPoint(x: 0.65, y: 0.15), CGPoint(x: 0.65, y: 0.85), CGPoint(x: 0.35, y: 0.85)],
        // 9: Parallelogram
        [CGPoint(x: 0.35, y: 0.3), CGPoint(x: 0.8, y: 0.3), CGPoint(x: 0.65, y: 0.7), CGPoint(x: 0.2, y: 0.7)],
    ]

    static func level(_ index: Int) -> MorphLevel {
        let realm = index / 16
        let lvl = index % 16

        var rng = SeededRNG(seed: UInt64(index * 7919 + 42))

        let shapePool: [Int]
        let tools: [TransformTool]
        let optimal: Int

        switch realm {
        case 0:
            shapePool = [0, 1, 2, 7, 8]
            tools = prismTools(lvl)
            optimal = 1 + lvl / 4
        case 1:
            shapePool = [1, 2, 3, 4, 9]
            tools = polygonTools(lvl)
            optimal = 2 + lvl / 4
        case 2:
            shapePool = [0, 1, 3, 4, 6]
            tools = fractalTools(lvl)
            optimal = 2 + lvl / 3
        case 3:
            shapePool = [0, 1, 2, 5, 6]
            tools = symmetryTools(lvl)
            optimal = 2 + lvl / 3
        default:
            shapePool = Array(0..<10)
            tools = chaosTools(lvl)
            optimal = 3 + lvl / 3
        }

        let targetIdx = shapePool[Int.random(in: 0..<shapePool.count, using: &rng)]
        let target = shapes[targetIdx]

        let invertibleTools = tools.filter { hasProperInverse($0) }
        let genTools = invertibleTools.isEmpty ? [TransformTool.rotateCW] : invertibleTools
        let moveCount = min(optimal, genTools.count)
        var source = target
        for _ in 0..<moveCount {
            let toolIdx = Int.random(in: 0..<genTools.count, using: &rng)
            let inverseTool = inverseof(genTools[toolIdx])
            source = inverseTool.apply(to: source)
        }

        return MorphLevel(index: index, source: source, target: target, availableTools: tools, optimalMoves: optimal)
    }

    private static func prismTools(_ lvl: Int) -> [TransformTool] {
        if lvl < 4 { return [.rotateCW, .flipH] }
        if lvl < 8 { return [.rotateCW, .rotateCCW, .flipH] }
        if lvl < 12 { return [.rotateCW, .flipH, .flipV, .scaleUp] }
        return [.rotateCW, .rotateCCW, .flipH, .flipV, .scaleUp, .scaleDown]
    }

    private static func polygonTools(_ lvl: Int) -> [TransformTool] {
        if lvl < 4 { return [.rotateCW, .rotateCCW, .flipH] }
        if lvl < 8 { return [.rotateCW, .flipH, .flipV, .stretchX] }
        if lvl < 12 { return [.rotateCW, .flipH, .stretchX, .stretchY, .scaleUp] }
        return [.rotateCW, .rotateCCW, .flipH, .flipV, .stretchX, .stretchY]
    }

    private static func fractalTools(_ lvl: Int) -> [TransformTool] {
        if lvl < 4 { return [.rotateCW, .scaleUp, .scaleDown] }
        if lvl < 8 { return [.rotateCW, .flipH, .scaleUp, .scaleDown] }
        return [.rotateCW, .rotateCCW, .flipH, .flipV, .scaleUp, .scaleDown]
    }

    private static func symmetryTools(_ lvl: Int) -> [TransformTool] {
        if lvl < 4 { return [.flipH, .flipV, .rotateCW] }
        if lvl < 8 { return [.flipH, .flipV, .rotateCW, .rotateCCW] }
        return [.flipH, .flipV, .rotateCW, .rotateCCW, .shiftLeft, .shiftRight]
    }

    private static func chaosTools(_ lvl: Int) -> [TransformTool] {
        if lvl < 4 { return [.rotateCW, .flipH, .scaleUp, .stretchX, .shiftLeft] }
        if lvl < 8 { return [.rotateCW, .rotateCCW, .flipH, .flipV, .scaleUp, .scaleDown] }
        return Array(TransformTool.allCases)
    }

    private static func hasProperInverse(_ tool: TransformTool) -> Bool {
        switch tool {
        case .stretchX, .stretchY, .shiftLeft, .shiftRight: false
        default: true
        }
    }

    private static func inverseof(_ tool: TransformTool) -> TransformTool {
        switch tool {
        case .rotateCW: .rotateCCW
        case .rotateCCW: .rotateCW
        case .flipH: .flipH
        case .flipV: .flipV
        case .scaleUp: .scaleDown
        case .scaleDown: .scaleUp
        case .stretchX: .stretchX
        case .stretchY: .stretchY
        case .shiftLeft: .shiftRight
        case .shiftRight: .shiftLeft
        }
    }
}
