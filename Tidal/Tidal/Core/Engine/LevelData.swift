import Foundation

enum LevelData {
    static func level(_ index: Int) -> TidalLevel {
        let world = index / 16
        let lvl = index % 16

        switch world {
        case 0: return ripplesLevel(index: index, lvl: lvl)
        case 1: return echoesLevel(index: index, lvl: lvl)
        case 2: return resonanceLevel(index: index, lvl: lvl)
        case 3: return harmonicsLevel(index: index, lvl: lvl)
        case 4: return chaosLevel(index: index, lvl: lvl)
        default: return ripplesLevel(index: index, lvl: lvl)
        }
    }

    private static func ripplesLevel(index: Int, lvl: Int) -> TidalLevel {
        let targetCount = min(1 + lvl / 4, 3)
        var targets = [TargetZone]()
        for i in 0..<targetCount {
            let angle = Double(i) * (2.0 * .pi / Double(targetCount)) + Double(lvl) * 0.3
            let r = 0.2 + Double(lvl) * 0.01
            targets.append(TargetZone(
                position: CGPoint(x: 0.5 + cos(angle) * r, y: 0.5 + sin(angle) * r),
                radius: 0.05,
                targetAmplitude: .constructive
            ))
        }
        return TidalLevel(
            index: index, maxSources: 1 + lvl / 8,
            targets: targets, obstacles: [], fixedSources: [],
            timeLimit: lvl > 12 ? 60 : nil,
            frequencyLocked: lvl < 4, amplitudeLocked: lvl < 2
        )
    }

    private static func echoesLevel(index: Int, lvl: Int) -> TidalLevel {
        let targetCount = 1 + lvl / 4
        var targets = [TargetZone]()
        for i in 0..<targetCount {
            let x = 0.2 + Double(i) * 0.6 / Double(max(1, targetCount - 1))
            targets.append(TargetZone(
                position: CGPoint(x: x, y: 0.3 + Double(lvl % 3) * 0.15),
                radius: 0.04,
                targetAmplitude: i % 2 == 0 ? .constructive : .destructive
            ))
        }
        let wall = Obstacle(
            position: CGPoint(x: 0.5, y: 0.8),
            size: CGSize(width: 0.6 + Double(lvl) * 0.02, height: 0.02),
            type: .reflector
        )
        return TidalLevel(
            index: index, maxSources: 1 + lvl / 6,
            targets: targets, obstacles: [wall], fixedSources: [],
            timeLimit: lvl > 10 ? 60 : nil,
            frequencyLocked: false, amplitudeLocked: false
        )
    }

    private static func resonanceLevel(index: Int, lvl: Int) -> TidalLevel {
        let fixed = WaveSource(
            position: CGPoint(x: 0.3, y: 0.5),
            frequency: 1.0 + Double(lvl) * 0.2,
            amplitude: 0.8,
            phase: 0
        )
        let targetX = 0.5 + Double(lvl % 4) * 0.08
        let targetY = 0.5 + Double(lvl % 3) * 0.1 - 0.1
        return TidalLevel(
            index: index, maxSources: 1 + lvl / 8,
            targets: [TargetZone(
                position: CGPoint(x: targetX, y: targetY),
                radius: 0.04,
                targetAmplitude: .constructive
            )],
            obstacles: [],
            fixedSources: [fixed],
            timeLimit: lvl > 8 ? 45 : nil,
            frequencyLocked: false, amplitudeLocked: lvl < 4
        )
    }

    private static func harmonicsLevel(index: Int, lvl: Int) -> TidalLevel {
        let targetCount = 2 + lvl / 4
        var targets = [TargetZone]()
        for i in 0..<targetCount {
            let angle = Double(i) * (2.0 * .pi / Double(targetCount))
            let r = 0.15 + Double(lvl) * 0.01
            targets.append(TargetZone(
                position: CGPoint(x: 0.5 + cos(angle) * r, y: 0.5 + sin(angle) * r),
                radius: 0.035,
                targetAmplitude: i % 3 == 0 ? .destructive : .constructive
            ))
        }
        return TidalLevel(
            index: index, maxSources: 2 + lvl / 4,
            targets: targets, obstacles: [], fixedSources: [],
            timeLimit: 60,
            frequencyLocked: false, amplitudeLocked: false
        )
    }

    private static func chaosLevel(index: Int, lvl: Int) -> TidalLevel {
        let targetCount = 2 + lvl / 3
        var targets = [TargetZone]()
        for i in 0..<targetCount {
            let x = 0.15 + Double(i) * 0.7 / Double(max(1, targetCount - 1))
            let y = 0.2 + Double((i * 7 + lvl * 3) % 5) * 0.12
            targets.append(TargetZone(
                position: CGPoint(x: x, y: y),
                radius: 0.03,
                targetAmplitude: i % 2 == 0 ? .constructive : .destructive
            ))
        }
        var obstacles = [Obstacle]()
        let wallCount = 1 + lvl / 5
        for w in 0..<wallCount {
            obstacles.append(Obstacle(
                position: CGPoint(x: 0.3 + Double(w) * 0.2, y: 0.5),
                size: CGSize(width: 0.02, height: 0.2),
                type: lvl > 10 ? .slit(width: 0.05) : .wall
            ))
        }
        return TidalLevel(
            index: index, maxSources: 2 + lvl / 3,
            targets: targets, obstacles: obstacles, fixedSources: [],
            timeLimit: 45,
            frequencyLocked: false, amplitudeLocked: false
        )
    }
}
