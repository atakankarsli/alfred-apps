import Foundation

enum MomentType: String, Codable, CaseIterable {
    case dawn, golden, twilight, midnight

    var displayName: String {
        switch self {
        case .dawn: return "Dawn"
        case .golden: return "Golden Hour"
        case .twilight: return "Twilight"
        case .midnight: return "Midnight"
        }
    }

    var icon: String {
        switch self {
        case .dawn: return "sunrise.fill"
        case .golden: return "sun.max.fill"
        case .twilight: return "sunset.fill"
        case .midnight: return "moon.stars.fill"
        }
    }
}

struct ImprintPuzzle {
    let gridSize: Int
    let momentType: MomentType
    let level: Int
    let colorIndices: [Int]
    let previewDuration: TimeInterval

    static let palette = ["FF6B6B", "FFA62B", "FFD93D", "4ECB71", "5BC0EB", "9B5DE5", "FF85A1", "00BBF9"]

    static func generate(level: Int) -> ImprintPuzzle {
        var rng = SeededRNG(seed: UInt64(level * 7919 + 1301))

        let gridSize: Int
        let colorCount: Int
        let preview: TimeInterval

        switch level {
        case 0..<20:
            gridSize = 3
            colorCount = 3 + level / 7
            preview = 4.0 - Double(level) * 0.08
        case 20..<40:
            gridSize = 4
            colorCount = 4 + (level - 20) / 7
            preview = 3.5 - Double(level - 20) * 0.06
        case 40..<60:
            gridSize = 4
            colorCount = 5 + (level - 40) / 10
            preview = 3.0 - Double(level - 40) * 0.04
        default:
            gridSize = 5
            colorCount = 6 + (level - 60) / 10
            preview = 2.5 - Double(level - 60) * 0.03
        }

        let clampedColors = min(colorCount, palette.count)
        let totalCells = gridSize * gridSize
        var indices = [Int]()
        for _ in 0..<totalCells {
            indices.append(Int(rng.next() % UInt64(clampedColors)))
        }

        let moment = Moment.momentForPuzzle(level)

        return ImprintPuzzle(
            gridSize: gridSize,
            momentType: moment,
            level: level,
            colorIndices: indices,
            previewDuration: max(preview, 1.5)
        )
    }

    func accuracy(answer: [Int]) -> Double {
        guard answer.count == colorIndices.count else { return 0 }
        let correct = zip(colorIndices, answer).filter { $0 == $1 }.count
        return Double(correct) / Double(colorIndices.count)
    }
}

struct SeededRNG: RandomNumberGenerator {
    private var state: UInt64

    init(seed: UInt64) {
        state = seed == 0 ? 1 : seed
    }

    mutating func next() -> UInt64 {
        state &+= 0x9E3779B97F4A7C15
        var z = state
        z = (z ^ (z >> 30)) &* 0xBF58476D1CE4E5B9
        z = (z ^ (z >> 27)) &* 0x94D049BB133111EB
        return z ^ (z >> 31)
    }
}
