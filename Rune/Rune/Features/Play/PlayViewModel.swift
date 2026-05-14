import SwiftUI
import SwiftData

@MainActor
@Observable
final class PlayViewModel {
    let levelIndex: Int
    let puzzle: DecodePuzzle
    let engine: RuneEngine

    var startTime: Date = .now
    var elapsed: TimeInterval = 0
    var timerTask: Task<Void, Never>?
    var showConfetti = false
    var endlessRound = 0

    var isComplete: Bool { engine.isComplete }

    var stars: Int {
        RuneConfig.starsForErrors(engine.wrongAttempts, hintCount: engine.hintsUsed)
    }

    var xpEarned: Int {
        var xp = RuneConfig.xpPerLevel + RuneConfig.xpPerStar * stars
        if engine.hintsUsed == 0 { xp += RuneConfig.xpBonusNoHint }
        if engine.wrongAttempts == 0 { xp += RuneConfig.xpBonusPerfect }
        return xp
    }

    init(levelIndex: Int) {
        self.levelIndex = levelIndex
        let idx = levelIndex >= 0 ? levelIndex : Int.random(in: 0..<80)
        self.puzzle = GlyphData.puzzle(forLevel: idx)
        self.engine = RuneEngine(puzzle: puzzle)
    }

    func startTimer() {
        startTime = .now
        timerTask?.cancel()
        timerTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .milliseconds(100))
                guard !Task.isCancelled else { return }
                self.elapsed = Date.now.timeIntervalSince(self.startTime)
                if self.engine.isComplete && !self.showConfetti {
                    self.showConfetti = true
                    self.timerTask?.cancel()
                }
            }
        }
    }

    func stopTimer() {
        timerTask?.cancel()
        timerTask = nil
    }

    func saveResults(context: ModelContext) {
        guard isComplete else { return }

        if levelIndex >= 0 {
            let idx = levelIndex
            let descriptor = FetchDescriptor<LevelRecord>(predicate: #Predicate { $0.levelIndex == idx })
            if let existing = try? context.fetch(descriptor).first {
                if stars > existing.stars { existing.stars = stars }
                if elapsed < existing.bestTime { existing.bestTime = elapsed }
            } else {
                context.insert(LevelRecord(levelIndex: levelIndex, stars: stars, bestTime: elapsed, hintsUsed: engine.hintsUsed))
            }
        }

        let statsDescriptor = FetchDescriptor<StatsRecord>()
        if let stats = try? context.fetch(statsDescriptor).first {
            stats.totalXP += xpEarned
            stats.totalTimePlayed += Int(elapsed)
            stats.updateStreak()

            if levelIndex >= 0 {
                stats.levelsCompleted += 1
                if stars == 3 { stats.threeStarCount += 1 }
                if engine.hintsUsed == 0 { stats.noHintCount += 1 }
                let realm = ScriptRealm(rawValue: levelIndex / 16) ?? .futhark
                stats.incrementRealm(realm)
            } else if levelIndex == -1 {
                endlessRound += 1
                stats.endlessBest = max(stats.endlessBest, endlessRound)
            } else if levelIndex == -2 {
                stats.dailyScrollsCompleted += 1
            }
        }
    }

    var formattedTime: String {
        let secs = Int(elapsed)
        return String(format: "%d:%02d", secs / 60, secs % 60)
    }
}
