import SwiftUI
import SwiftData

@MainActor
@Observable
final class PlayViewModel {
    let levelIndex: Int
    let engine: EmberEngine

    var startTime: Date = .now
    var elapsed: TimeInterval = 0
    var timerTask: Task<Void, Never>?
    var showConfetti = false
    var endlessRound = 0

    var stars: Int {
        EmberConfig.starsForAccuracy(engine.accuracy)
    }

    var xpEarned: Int {
        var xp = EmberConfig.xpPerLevel + EmberConfig.xpPerStar * stars
        if engine.accuracy >= 1.0 { xp += EmberConfig.xpBonusPerfect }
        if engine.tapMisses == 0 { xp += EmberConfig.xpBonusNoMiss }
        return xp
    }

    init(levelIndex: Int) {
        self.levelIndex = levelIndex
        let idx = levelIndex >= 0 ? levelIndex : Int.random(in: 0..<80)
        let session = EmberConfig.session(forLevel: idx)
        self.engine = EmberEngine(session: session)
    }

    func startSession() {
        startTime = .now
        engine.start()
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

    func stopSession() {
        engine.stop()
        timerTask?.cancel()
        timerTask = nil
    }

    func saveResults(context: ModelContext) {
        guard engine.isComplete else { return }

        if levelIndex >= 0 {
            let idx = levelIndex
            let descriptor = FetchDescriptor<LevelRecord>(predicate: #Predicate { $0.levelIndex == idx })
            if let existing = try? context.fetch(descriptor).first {
                if stars > existing.stars { existing.stars = stars }
                if elapsed < existing.bestTime { existing.bestTime = elapsed }
                if engine.accuracy > existing.bestAccuracy { existing.bestAccuracy = engine.accuracy }
            } else {
                context.insert(LevelRecord(levelIndex: levelIndex, stars: stars, bestTime: elapsed, bestAccuracy: engine.accuracy))
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
                if engine.tapMisses == 0 { stats.noMissCount += 1 }
                let realm = FireRealm(rawValue: levelIndex / 16) ?? .hearth
                stats.incrementRealm(realm)
            } else if levelIndex == -1 {
                endlessRound += 1
                stats.endlessBest = max(stats.endlessBest, endlessRound)
            } else if levelIndex == -2 {
                stats.dailyEmbersCompleted += 1
            }
        }
    }

    var formattedTime: String {
        let secs = Int(elapsed)
        return String(format: "%d:%02d", secs / 60, secs % 60)
    }
}
