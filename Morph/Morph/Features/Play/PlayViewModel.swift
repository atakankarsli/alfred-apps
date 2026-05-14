import SwiftUI
import SwiftData

@MainActor
@Observable
final class PlayViewModel {
    let engine = MorphEngine()
    var level: MorphLevel?
    var isComplete = false
    var score: Double = 0
    var stars: Int = 0
    var isEndless = false
    var isDailyMorph = false
    var endlessRound = 0

    func startLevel(_ index: Int) {
        isComplete = false
        score = 0
        stars = 0

        if index == -1 {
            isEndless = true
            isDailyMorph = false
            endlessRound = 1
            let lvl = LevelData.level(0)
            level = lvl
            engine.setup(source: lvl.source, target: lvl.target)
        } else if index == -2 {
            isDailyMorph = true
            isEndless = false
            let seed = SeededRNG.dailySeed()
            let idx = Int(seed % 80)
            let lvl = LevelData.level(idx)
            level = lvl
            engine.setup(source: lvl.source, target: lvl.target)
        } else {
            isEndless = false
            isDailyMorph = false
            let lvl = LevelData.level(index)
            level = lvl
            engine.setup(source: lvl.source, target: lvl.target)
        }
    }

    func applyTool(_ tool: TransformTool) {
        guard !isComplete else { return }
        engine.applyTool(tool)
        HapticsService.light()
        checkCompletion()
    }

    func undo() {
        engine.undo()
        HapticsService.selection()
    }

    func resetShape() {
        engine.reset()
        HapticsService.medium()
    }

    private func checkCompletion() {
        let matchScore = engine.matchScore()
        if engine.isComplete() {
            score = matchScore
            stars = MorphConfig.starsForMoves(used: engine.moveCount, optimal: level?.optimalMoves ?? 1)
            isComplete = true
            HapticsService.success()

            if isEndless {
                endlessRound += 1
                Task {
                    try? await Task.sleep(for: .milliseconds(1200))
                    let nextIdx = endlessRound % 80
                    let lvl = LevelData.level(nextIdx)
                    level = lvl
                    engine.setup(source: lvl.source, target: lvl.target)
                    isComplete = false
                    score = 0
                    stars = 0
                }
            }
        }
    }

    func saveResult(modelContext: ModelContext) {
        guard let level, isComplete, stars > 0 else { return }

        if !isEndless && !isDailyMorph {
            let levelIdx = level.index
            let descriptor = FetchDescriptor<LevelRecord>(predicate: #Predicate { $0.levelIndex == levelIdx })
            let existing = try? modelContext.fetch(descriptor)
            if let record = existing?.first {
                if stars > record.stars {
                    record.stars = stars
                    record.bestScore = score
                    record.bestMoves = engine.moveCount
                    record.completedAt = .now
                }
            } else {
                modelContext.insert(LevelRecord(levelIndex: level.index, stars: stars, bestScore: score, bestMoves: engine.moveCount))
            }
        }

        let xp = MorphConfig.xpForLevel(stars: stars, realmIndex: level.realm.rawValue)
        if let stats = try? modelContext.fetch(FetchDescriptor<StatsRecord>()).first {
            stats.levelsCompleted += 1
            stats.totalXP += xp
            if stars == 3 { stats.threeStarCount += 1 }
            stats.updateStreak()
            stats.incrementRealm(level.realm)
            if isDailyMorph { stats.dailyMorphsCompleted += 1 }
            if isEndless { stats.endlessBest = max(stats.endlessBest, endlessRound) }
            if engine.moveCount <= level.optimalMoves { stats.minMovesCount += 1 }
        }
    }
}
