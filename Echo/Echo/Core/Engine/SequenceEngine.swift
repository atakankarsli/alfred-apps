import Foundation

@MainActor
@Observable
final class SequenceEngine {
    var sequence: [Int] = []
    var playerInput: [Int] = []
    var isPlaying = false
    var currentPlayIndex = -1
    var isPlayerTurn = false
    var lives = 3
    var replaysRemaining = 0

    private var playTask: Task<Void, Never>?

    func generateSequence(length: Int, buttonCount: Int) {
        sequence = (0..<length).map { _ in Int.random(in: 0..<buttonCount) }
        playerInput = []
        isPlayerTurn = false
        currentPlayIndex = -1
    }

    func generateDailySequence(length: Int, buttonCount: Int, seed: UInt64) {
        var rng = SeededRNG(seed: seed)
        sequence = (0..<length).map { _ in Int.random(in: 0..<buttonCount, using: &rng) }
        playerInput = []
        isPlayerTurn = false
        currentPlayIndex = -1
    }

    func playSequence(realm: SonicRealm, tempo: Double) {
        isPlaying = true
        isPlayerTurn = false
        currentPlayIndex = -1

        let intervalMs = Int(60.0 / tempo * 1000)
        let seq = sequence

        playTask = Task {
            for step in seq.indices {
                guard !Task.isCancelled else { return }
                self.currentPlayIndex = seq[step]
                ToneGenerator.shared.playTone(seq[step], realm: realm)
                try? await Task.sleep(for: .milliseconds(intervalMs / 2))
                guard !Task.isCancelled else { return }
                self.currentPlayIndex = -1
                try? await Task.sleep(for: .milliseconds(intervalMs / 2))
            }
            guard !Task.isCancelled else { return }
            self.isPlaying = false
            self.isPlayerTurn = true
            self.currentPlayIndex = -1
        }
    }

    func replay(realm: SonicRealm, tempo: Double) {
        guard replaysRemaining > 0, !isPlaying else { return }
        replaysRemaining -= 1
        playerInput = []
        playSequence(realm: realm, tempo: tempo)
    }

    enum InputResult {
        case correct
        case sequenceComplete
        case wrong
        case gameOver
    }

    func handleInput(_ buttonIndex: Int) -> InputResult {
        guard isPlayerTurn else { return .correct }

        playerInput.append(buttonIndex)
        let pos = playerInput.count - 1

        if buttonIndex != sequence[pos] {
            lives -= 1
            playerInput.removeLast()
            if lives <= 0 {
                return .gameOver
            }
            return .wrong
        }

        if playerInput.count == sequence.count {
            isPlayerTurn = false
            return .sequenceComplete
        }

        return .correct
    }

    func accuracy() -> Double {
        guard !sequence.isEmpty else { return 0 }
        return Double(playerInput.count) / Double(sequence.count)
    }

    func reset() {
        playTask?.cancel()
        playTask = nil
        sequence = []
        playerInput = []
        isPlaying = false
        currentPlayIndex = -1
        isPlayerTurn = false
        lives = 3
        replaysRemaining = 0
    }
}
