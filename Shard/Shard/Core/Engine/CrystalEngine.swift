import Foundation

struct Crystal: Identifiable, Hashable {
    let id: UUID
    let type: CrystalType
    let familyId: Int
    let temperature: Double
    let pressure: Double
    let quality: Double
    let stars: Int
    let size: Double
    let clarity: Double
    let facets: Int
    let seed: UInt64

    var xp: Int { ShardConfig.xpForCrystal(stars: stars, familyId: familyId) }
}

struct GrowthParameters {
    var temperature: Double = 0.5
    var pressure: Double = 0.5
    var selectedType: CrystalType = .amethyst
}

enum CrystalEngine {
    struct OptimalRange {
        let tempMin: Double, tempMax: Double
        let pressMin: Double, pressMax: Double
    }

    static func optimalRange(for type: CrystalType) -> OptimalRange {
        switch type {
        case .amethyst: OptimalRange(tempMin: 0.3, tempMax: 0.5, pressMin: 0.4, pressMax: 0.6)
        case .citrine: OptimalRange(tempMin: 0.5, tempMax: 0.7, pressMin: 0.3, pressMax: 0.5)
        case .roseQuartz: OptimalRange(tempMin: 0.2, tempMax: 0.4, pressMin: 0.5, pressMax: 0.7)
        case .smokyQuartz: OptimalRange(tempMin: 0.4, tempMax: 0.6, pressMin: 0.2, pressMax: 0.4)
        case .emerald: OptimalRange(tempMin: 0.6, tempMax: 0.8, pressMin: 0.6, pressMax: 0.8)
        case .aquamarine: OptimalRange(tempMin: 0.3, tempMax: 0.5, pressMin: 0.5, pressMax: 0.7)
        case .morganite: OptimalRange(tempMin: 0.4, tempMax: 0.6, pressMin: 0.6, pressMax: 0.8)
        case .ruby: OptimalRange(tempMin: 0.7, tempMax: 0.9, pressMin: 0.7, pressMax: 0.9)
        case .sapphire: OptimalRange(tempMin: 0.6, tempMax: 0.8, pressMin: 0.7, pressMax: 0.9)
        case .greenFluorite: OptimalRange(tempMin: 0.2, tempMax: 0.4, pressMin: 0.3, pressMax: 0.5)
        case .purpleFluorite: OptimalRange(tempMin: 0.3, tempMax: 0.5, pressMin: 0.2, pressMax: 0.4)
        case .blueFluorite: OptimalRange(tempMin: 0.1, tempMax: 0.3, pressMin: 0.4, pressMax: 0.6)
        case .diamond: OptimalRange(tempMin: 0.85, tempMax: 0.95, pressMin: 0.85, pressMax: 0.95)
        }
    }

    static func grow(params: GrowthParameters) -> Crystal {
        let range = optimalRange(for: params.selectedType)

        let tempScore = proximityScore(params.temperature, min: range.tempMin, max: range.tempMax)
        let pressScore = proximityScore(params.pressure, min: range.pressMin, max: range.pressMax)
        let quality = (tempScore * 0.5 + pressScore * 0.5).clamped(to: 0...1)

        let stars = ShardConfig.starsForQuality(quality)
        let family = MineralFamily.all.first { $0.crystalTypes.contains(params.selectedType) }?.id ?? 0

        var rng = SeededRNG(seed: UInt64(Date.now.timeIntervalSince1970 * 1000))
        let size = 0.4 + quality * 0.5 + rng.nextDouble() * 0.1
        let clarity = quality * 0.7 + rng.nextDouble() * 0.3
        let facets = params.selectedType.facetCount + (stars >= 3 ? 2 : 0)

        return Crystal(
            id: UUID(),
            type: params.selectedType,
            familyId: family,
            temperature: params.temperature,
            pressure: params.pressure,
            quality: quality,
            stars: stars,
            size: size,
            clarity: clarity,
            facets: facets,
            seed: rng.state
        )
    }

    private static func proximityScore(_ value: Double, min: Double, max: Double) -> Double {
        let mid = (min + max) / 2
        let halfRange = (max - min) / 2
        let distance = abs(value - mid)
        if distance <= halfRange { return 1.0 }
        return Swift.max(0, 1.0 - (distance - halfRange) / 0.3)
    }
}

struct SeededRNG: RandomNumberGenerator {
    var state: UInt64

    init(seed: UInt64) {
        state = seed == 0 ? 1 : seed
    }

    mutating func next() -> UInt64 {
        state &+= 0x9e3779b97f4a7c15
        var z = state
        z = (z ^ (z >> 30)) &* 0xbf58476d1ce4e5b9
        z = (z ^ (z >> 27)) &* 0x94d049bb133111eb
        return z ^ (z >> 31)
    }

    mutating func nextDouble() -> Double {
        Double(next() >> 11) / Double(1 << 53)
    }
}

private extension Double {
    func clamped(to range: ClosedRange<Double>) -> Double {
        Swift.min(Swift.max(self, range.lowerBound), range.upperBound)
    }
}
