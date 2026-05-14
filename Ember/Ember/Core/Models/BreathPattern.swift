import Foundation

struct BreathPattern: Sendable {
    let name: String
    let inhale: Double
    let hold1: Double
    let exhale: Double
    let hold2: Double
    let cycles: Int

    var totalCycleTime: Double {
        inhale + hold1 + exhale + hold2
    }

    var totalDuration: Double {
        totalCycleTime * Double(cycles)
    }

    static let box = BreathPattern(name: "Box", inhale: 4, hold1: 4, exhale: 4, hold2: 4, cycles: 4)
    static let relax478 = BreathPattern(name: "4-7-8", inhale: 4, hold1: 7, exhale: 8, hold2: 0, cycles: 4)
    static let triangle = BreathPattern(name: "Triangle", inhale: 4, hold1: 4, exhale: 4, hold2: 0, cycles: 5)
    static let calm = BreathPattern(name: "Calm", inhale: 5, hold1: 0, exhale: 5, hold2: 0, cycles: 6)
    static let energize = BreathPattern(name: "Energize", inhale: 2, hold1: 0, exhale: 2, hold2: 0, cycles: 10)
    static let deep = BreathPattern(name: "Deep", inhale: 6, hold1: 2, exhale: 8, hold2: 2, cycles: 3)

    static let all: [BreathPattern] = [box, relax478, triangle, calm, energize, deep]
}

struct FocusSession: Sendable {
    let pattern: BreathPattern
    let realm: FireRealm
    let targetCycles: Int
    let difficulty: Int
}
