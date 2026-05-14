import SwiftUI
import SwiftData

@MainActor
@Observable
final class PlayViewModel {
    let levelIndex: Int
    let constellation: Constellation
    let engine: ZenithEngine

    var startTime: Date = .now
    var elapsed: TimeInterval = 0
    var timerTask: Task<Void, Never>?

    var isComplete: Bool { engine.isComplete }
    var showConfetti = false
    var endlessRound = 0

    var stars: Int {
        let optimal = ZenithConfig.optimalTime(forLevel: max(levelIndex, 0))
        return ZenithConfig.starsForTime(elapsed: elapsed, optimal: optimal)
    }

    var xpEarned: Int {
        var xp = ZenithConfig.xpPerLevel + ZenithConfig.xpPerStar * stars
        if engine.hintsUsed == 0 { xp += ZenithConfig.xpBonusNoHint }
        return xp
    }

    init(levelIndex: Int) {
        self.levelIndex = levelIndex
        let idx = levelIndex >= 0 ? levelIndex : Int.random(in: 0..<80)
        self.constellation = ConstellationData.constellation(for: idx)
        self.engine = ZenithEngine(constellation: constellation)
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

    func selectStar(_ index: Int) {
        engine.selectStar(index)
    }

    func useHint() {
        engine.useHint()
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
            stats.levelsCompleted += 1
            stats.totalXP += xpEarned
            stats.totalTimePlayed += Int(elapsed)
            if stars == 3 { stats.threeStarCount += 1 }
            if engine.hintsUsed == 0 { stats.noHintCount += 1 }

            if levelIndex >= 0 {
                let realm = SkyRealm(rawValue: levelIndex / 16) ?? .zodiac
                stats.incrementRealm(realm)
            }
            stats.updateStreak()

            if levelIndex == -1 {
                endlessRound += 1
                stats.endlessBest = max(stats.endlessBest, endlessRound)
            }
            if levelIndex == -2 {
                stats.dailyChallengesCompleted += 1
            }
        }
    }

    var formattedTime: String {
        let secs = Int(elapsed)
        let mins = secs / 60
        let remainSecs = secs % 60
        return String(format: "%d:%02d", mins, remainSecs)
    }
}
