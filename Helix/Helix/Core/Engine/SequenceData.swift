import Foundation

enum SequenceData {
    static func generateTarget(forLevel index: Int) -> [Nucleotide] {
        let length = HelixConfig.sequenceLength(forLevel: index)
        var rng = SeededRNG(seed: UInt64(index * 7 + 42))
        return (0..<length).map { _ in
            Nucleotide.allCases[Int(rng.next() % 4)]
        }
    }

    static func generateScrambled(from target: [Nucleotide], level: Int) -> [Nucleotide] {
        var scrambled = target
        var rng = SeededRNG(seed: UInt64(level * 13 + 99))
        let swapCount = max(2, target.count / 2 + level / 10)
        for _ in 0..<swapCount {
            let i = Int(rng.next() % UInt64(scrambled.count))
            let j = Int(rng.next() % UInt64(scrambled.count))
            if i != j {
                scrambled.swapAt(i, j)
            }
        }
        if scrambled == target {
            scrambled.swapAt(0, scrambled.count - 1)
        }
        return scrambled
    }

    static func levelPuzzle(forLevel index: Int) -> HelixPuzzle {
        let realm = BioRealm(rawValue: index / 16) ?? .nucleus
        let lvl = index % 16
        let target = generateTarget(forLevel: index)
        let scrambled = generateScrambled(from: target, level: index)
        let hints = lvl < 4 ? 2 : (lvl < 10 ? 1 : 0)
        let mode: PuzzleMode = switch realm {
        case .nucleus: .pairMatch
        case .ribosome: .sequence
        case .membrane: .pairMatch
        case .helicase: .timed
        case .evolution: .mutation
        }

        return HelixPuzzle(
            levelIndex: index,
            target: target,
            scrambled: scrambled,
            realm: realm,
            mode: mode,
            hintCount: hints,
            timeLimit: realm == .helicase ? max(20, 60 - lvl * 2) : 0
        )
    }

    static func dailyPuzzle() -> HelixPuzzle {
        let day = Calendar.current.ordinality(of: .day, in: .era, for: Date()) ?? 0
        let length = 8
        var rng = SeededRNG(seed: UInt64(day))
        let target = (0..<length).map { _ in Nucleotide.allCases[Int(rng.next() % 4)] }
        let scrambled = generateScrambled(from: target, level: day)
        return HelixPuzzle(
            levelIndex: -2,
            target: target,
            scrambled: scrambled,
            realm: .nucleus,
            mode: .sequence,
            hintCount: 1,
            timeLimit: 0
        )
    }
}

enum PuzzleMode: Sendable {
    case sequence
    case pairMatch
    case mutation
    case timed
}

struct HelixPuzzle: Sendable {
    let levelIndex: Int
    let target: [Nucleotide]
    let scrambled: [Nucleotide]
    let realm: BioRealm
    let mode: PuzzleMode
    let hintCount: Int
    let timeLimit: Int
}

struct SeededRNG {
    private var state: UInt64

    init(seed: UInt64) {
        state = seed
    }

    mutating func next() -> UInt64 {
        state = state &* 6364136223846793005 &+ 1442695040888963407
        return state >> 33
    }
}
