import Foundation
import Observation

@Observable
final class HelixEngine: @unchecked Sendable {
    var currentSequence: [Nucleotide] = []
    var targetSequence: [Nucleotide] = []
    var selectedIndex: Int?
    var moveCount = 0
    var hintsUsed = 0
    var hintsRemaining = 0
    var combo = 0
    var bestCombo = 0
    var isComplete = false
    var startTime: Date?
    var mode: PuzzleMode = .sequence
    var timeLimit: Int = 0

    private var puzzle: HelixPuzzle?

    func startLevel(_ index: Int) {
        let p = SequenceData.levelPuzzle(forLevel: index)
        puzzle = p
        currentSequence = p.scrambled
        targetSequence = p.target
        mode = p.mode
        timeLimit = p.timeLimit
        selectedIndex = nil
        moveCount = 0
        hintsUsed = 0
        hintsRemaining = p.hintCount
        combo = 0
        bestCombo = 0
        isComplete = false
        startTime = Date()
    }

    func startDaily() {
        let p = SequenceData.dailyPuzzle()
        puzzle = p
        currentSequence = p.scrambled
        targetSequence = p.target
        mode = p.mode
        timeLimit = 0
        selectedIndex = nil
        moveCount = 0
        hintsUsed = 0
        hintsRemaining = p.hintCount
        combo = 0
        bestCombo = 0
        isComplete = false
        startTime = Date()
    }

    func swap(_ i: Int, _ j: Int) {
        guard i != j, i >= 0, j >= 0,
              i < currentSequence.count, j < currentSequence.count else { return }
        moveCount += 1
        currentSequence.swapAt(i, j)

        if currentSequence[i] == targetSequence[i] || currentSequence[j] == targetSequence[j] {
            combo += 1
            bestCombo = max(bestCombo, combo)
        } else {
            combo = 0
        }

        checkCompletion()
    }

    func placePair(at index: Int, base: Nucleotide) {
        guard index >= 0, index < targetSequence.count else { return }
        moveCount += 1
        if index < currentSequence.count {
            currentSequence[index] = base
        }

        if base == targetSequence[index].complement {
            combo += 1
            bestCombo = max(bestCombo, combo)
        } else {
            combo = 0
        }

        checkCompletion()
    }

    func useHint() -> Int? {
        guard hintsRemaining > 0 else { return nil }
        hintsUsed += 1
        hintsRemaining -= 1

        for i in 0..<currentSequence.count {
            let isCorrect = mode == .pairMatch
                ? currentSequence[i] == targetSequence[i].complement
                : currentSequence[i] == targetSequence[i]
            if !isCorrect { return i }
        }
        return nil
    }

    private func checkCompletion() {
        if mode == .pairMatch {
            let matched = zip(currentSequence, targetSequence).allSatisfy { placed, target in
                placed == target.complement
            }
            isComplete = matched
        } else {
            isComplete = currentSequence == targetSequence
        }
    }

    private var correctCount: Int {
        if mode == .pairMatch {
            return zip(currentSequence, targetSequence).filter { $0 == $1.complement }.count
        }
        return zip(currentSequence, targetSequence).filter { $0 == $1 }.count
    }

    var accuracy: Double {
        guard !targetSequence.isEmpty else { return 0 }
        return Double(correctCount) / Double(targetSequence.count)
    }

    var elapsed: TimeInterval {
        guard let start = startTime else { return 0 }
        return Date().timeIntervalSince(start)
    }

    var stars: Int {
        HelixConfig.starsForAccuracy(accuracy)
    }

    var xpEarned: Int {
        guard isComplete else { return 0 }
        var xp = HelixConfig.xpPerLevel
        xp += HelixConfig.xpPerCorrectBase * correctCount
        if stars == 3 { xp += HelixConfig.xpBonusPerfect }
        if hintsUsed == 0 { xp += HelixConfig.xpBonusNoHint }
        if elapsed < 30 { xp += HelixConfig.xpBonusSpeed }
        return xp
    }
}
