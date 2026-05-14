import CoreGraphics

enum StrokeRecognizer {
    static func score(userStrokes: [[CGPoint]], referenceStrokes: [[CGPoint]], canvasSize: CGSize) -> Double {
        guard !referenceStrokes.isEmpty else { return 0 }
        let normalizedUser = userStrokes.map { normalize($0, size: canvasSize) }
        let normalizedRef = referenceStrokes.map { resampleStroke($0, count: 32) }
        guard !normalizedUser.isEmpty else { return 0 }

        var totalScore: Double = 0
        var matchedRef = Set<Int>()

        for userStroke in normalizedUser {
            let resampled = resampleStroke(userStroke, count: 32)
            var bestScore: Double = 0
            var bestIdx = -1
            for (ri, refStroke) in normalizedRef.enumerated() {
                guard !matchedRef.contains(ri) else { continue }
                let d = strokeSimilarity(resampled, refStroke)
                if d > bestScore {
                    bestScore = d
                    bestIdx = ri
                }
            }
            if bestIdx >= 0 {
                matchedRef.insert(bestIdx)
                totalScore += bestScore
            }
        }

        let coverageBonus = Double(matchedRef.count) / Double(normalizedRef.count)
        let rawScore = normalizedRef.isEmpty ? 0 : totalScore / Double(normalizedRef.count)
        return min(1.0, rawScore * 0.7 + coverageBonus * 0.3)
    }

    private static func normalize(_ points: [CGPoint], size: CGSize) -> [CGPoint] {
        points.map { CGPoint(x: $0.x / size.width, y: $0.y / size.height) }
    }

    private static func resampleStroke(_ points: [CGPoint], count: Int) -> [CGPoint] {
        guard points.count >= 2 else { return points }
        let totalLength = pathLength(points)
        guard totalLength > 0 else { return points }
        let interval = totalLength / Double(count - 1)

        var resampled = [points[0]]
        var accum: Double = 0

        for i in 1..<points.count {
            let d = distance(points[i - 1], points[i])
            if accum + d >= interval {
                var remaining = interval - accum
                var prev = points[i - 1]
                while remaining <= d && resampled.count < count {
                    let ratio = remaining / d
                    let nx = prev.x + (points[i].x - prev.x) * ratio
                    let ny = prev.y + (points[i].y - prev.y) * ratio
                    let np = CGPoint(x: nx, y: ny)
                    resampled.append(np)
                    prev = np
                    remaining += interval
                }
                accum = d - (remaining - interval)
            } else {
                accum += d
            }
        }

        while resampled.count < count { resampled.append(points.last!) }
        return Array(resampled.prefix(count))
    }

    private static func strokeSimilarity(_ a: [CGPoint], _ b: [CGPoint]) -> Double {
        guard a.count == b.count, !a.isEmpty else { return 0 }
        let forwardDist = averageDistance(a, b)
        let reversedB = Array(b.reversed())
        let reverseDist = averageDistance(a, reversedB)
        let bestDist = min(forwardDist, reverseDist)
        let maxDist = 1.414
        return max(0, 1 - bestDist / (maxDist * 0.3))
    }

    private static func averageDistance(_ a: [CGPoint], _ b: [CGPoint]) -> Double {
        var total: Double = 0
        for i in a.indices { total += distance(a[i], b[i]) }
        return total / Double(a.count)
    }

    private static func pathLength(_ points: [CGPoint]) -> Double {
        var length: Double = 0
        for i in 1..<points.count { length += distance(points[i - 1], points[i]) }
        return length
    }

    private static func distance(_ a: CGPoint, _ b: CGPoint) -> Double {
        let dx = a.x - b.x
        let dy = a.y - b.y
        return (dx * dx + dy * dy).squareRoot()
    }
}
