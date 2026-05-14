import SwiftUI
import SwiftData

@MainActor
@Observable
final class PlayViewModel {
    let engine = SequenceEngine()
    var level: EchoLevel?
    var isComplete = false
    var score: Double = 0
    var stars: Int = 0
    var isEndless = false
    var isDailyEcho = false
    var endlessRound = 0
    var activeButton = -1
    var flashColor: Color? = nil

    func startLevel(_ index: Int) {
        isComplete = false
        score = 0
        stars = 0
        engine.reset()
        activeButton = -1
        flashColor = nil

        if index == -1 {
            isEndless = true
            isDailyEcho = false
            endlessRound = 1
            level = EchoLevel(index: 0, sequenceLength: 3, buttonCount: 4, tempo: 100, replaysAllowed: 0, timeLimit: nil, lives: 3)
            engine.lives = 3
            engine.replaysRemaining = 0
            engine.generateSequence(length: 3, buttonCount: 4)
        } else if index == -2 {
            isDailyEcho = true
            isEndless = false
            level = LevelData.level(0)
            engine.lives = level!.lives
            engine.replaysRemaining = level!.replaysAllowed
            engine.generateDailySequence(length: 6, buttonCount: 6, seed: SeededRNG.dailySeed())
        } else {
            isEndless = false
            isDailyEcho = false
            level = LevelData.level(index)
            engine.lives = level!.lives
            engine.replaysRemaining = level!.replaysAllowed
            engine.generateSequence(length: level!.sequenceLength, buttonCount: level!.buttonCount)
        }

        Task {
            try? await Task.sleep(for: .milliseconds(500))
            let realm = level?.realm ?? .tones
            let tempo = level?.tempo ?? 100
            engine.playSequence(realm: realm, tempo: tempo)
        }
    }

    func handleButtonTap(_ index: Int) {
        guard engine.isPlayerTurn else { return }

        let realm = level?.realm ?? .tones
        ToneGenerator.shared.playTone(index, realm: realm)
        activeButton = index

        Task {
            try? await Task.sleep(for: .milliseconds(200))
            activeButton = -1
        }

        let result = engine.handleInput(index)
        switch result {
        case .correct:
            HapticsService.light()
            flashColor = .green
        case .sequenceComplete:
            HapticsService.success()
            flashColor = .green
            handleSequenceComplete()
        case .wrong:
            HapticsService.error()
            ToneGenerator.shared.playFail()
            flashColor = .red
        case .gameOver:
            HapticsService.heavy()
            ToneGenerator.shared.playFail()
            flashColor = .red
            handleGameOver()
        }

        Task {
            try? await Task.sleep(for: .milliseconds(300))
            flashColor = nil
        }
    }

    private func handleSequenceComplete() {
        if isEndless {
            endlessRound += 1
            ToneGenerator.shared.playSuccess()
            Task {
                try? await Task.sleep(for: .milliseconds(800))
                let newLength = 3 + endlessRound
                let newButtons = min(4 + endlessRound / 3, 6)
                engine.generateSequence(length: newLength, buttonCount: newButtons)
                engine.playerInput = []
                engine.playSequence(realm: .tones, tempo: 100 + Double(endlessRound) * 8)
            }
        } else {
            score = 1.0
            stars = computeStars()
            isComplete = true
            ToneGenerator.shared.playCelebration()
        }
    }

    private func handleGameOver() {
        if isEndless {
            score = Double(endlessRound) / 10.0
            stars = min(3, endlessRound / 3)
            isComplete = true
        } else {
            score = engine.accuracy()
            stars = 0
            isComplete = true
        }
    }

    private func computeStars() -> Int {
        let livesLeft = engine.lives
        let usedReplay = (level?.replaysAllowed ?? 0) - engine.replaysRemaining > 0
        if livesLeft == 3 && !usedReplay { return 3 }
        if livesLeft >= 2 { return 2 }
        return 1
    }

    func replay() {
        guard let level else { return }
        engine.replay(realm: level.realm, tempo: level.tempo)
    }

    func saveResult(modelContext: ModelContext) {
        guard let level, isComplete, stars > 0 else { return }

        if !isEndless && !isDailyEcho {
            let levelIdx = level.index
            let descriptor = FetchDescriptor<LevelRecord>(predicate: #Predicate { $0.levelIndex == levelIdx })
            let existing = try? modelContext.fetch(descriptor)
            if let record = existing?.first {
                if stars > record.stars {
                    record.stars = stars
                    record.bestScore = score
                    record.completedAt = .now
                }
            } else {
                modelContext.insert(LevelRecord(levelIndex: level.index, stars: stars, bestScore: score))
            }
        }

        let xp = EchoConfig.xpForLevel(stars: stars, realmIndex: level.realm.rawValue)
        if let stats = try? modelContext.fetch(FetchDescriptor<StatsRecord>()).first {
            stats.levelsCompleted += 1
            stats.totalXP += xp
            if stars == 3 { stats.threeStarCount += 1 }
            stats.updateStreak()
            stats.incrementRealm(level.realm)
            if isDailyEcho { stats.dailyEchoesCompleted += 1 }
            if isEndless { stats.endlessBest = max(stats.endlessBest, endlessRound) }
            if engine.replaysRemaining == (level.replaysAllowed) { stats.noReplayCount += 1 }
        }
    }
}
