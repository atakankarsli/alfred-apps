import SwiftUI
import SwiftData

@MainActor
@Observable
final class PlayViewModel {
    let engine = WaveEngine()
    var level: TidalLevel?
    var selectedSourceIndex: Int?
    var score: Double = 0
    var stars: Int = 0
    var isComplete = false
    var timeRemaining: Int?
    var isSandbox: Bool = false
    var isDailyWave: Bool = false

    private var timer: Timer?
    private var animationTimer: Timer?

    func startLevel(_ index: Int) {
        isComplete = false
        score = 0
        stars = 0
        engine.reset()

        if index == -1 {
            isSandbox = true
            isDailyWave = false
            level = nil
            timeRemaining = nil
        } else if index == -2 {
            isDailyWave = true
            isSandbox = false
            var rng = SeededRNG(seed: SeededRNG.dailySeed())
            let dailyIndex = Int.random(in: 0..<80, using: &rng)
            level = LevelData.level(dailyIndex)
            timeRemaining = 60
        } else {
            isSandbox = false
            isDailyWave = false
            level = LevelData.level(index)
            timeRemaining = level?.timeLimit
        }

        if let level {
            for fixed in level.fixedSources {
                engine.sources.append(fixed)
            }
        }

        startAnimation()
        if timeRemaining != nil { startCountdown() }
    }

    func addSource(at normalizedPosition: CGPoint) {
        let maxSources = level?.maxSources ?? 10
        let playerSources = engine.sources.count - (level?.fixedSources.count ?? 0)
        guard playerSources < maxSources else { return }

        let source = WaveSource(
            position: normalizedPosition,
            frequency: 1.5,
            amplitude: 1.0
        )
        engine.sources.append(source)
        selectedSourceIndex = engine.sources.count - 1
        HapticsService.light()
        SoundService.shared.playWaveDrop()
    }

    func removeSelectedSource() {
        guard let idx = selectedSourceIndex, idx < engine.sources.count else { return }
        if let level, idx < level.fixedSources.count { return }
        engine.sources.remove(at: idx)
        selectedSourceIndex = nil
        HapticsService.light()
    }

    func updateFrequency(_ freq: Double) {
        guard let idx = selectedSourceIndex, idx < engine.sources.count else { return }
        guard level?.frequencyLocked != true else { return }
        engine.sources[idx].frequency = freq
    }

    func updateAmplitude(_ amp: Double) {
        guard let idx = selectedSourceIndex, idx < engine.sources.count else { return }
        guard level?.amplitudeLocked != true else { return }
        engine.sources[idx].amplitude = amp
    }

    func checkSolution() {
        guard let level else { return }
        score = engine.scoreAgainstTargets(level.targets)
        stars = TidalConfig.starsForAccuracy(score)
        if stars > 0 {
            isComplete = true
            stopTimers()
            HapticsService.success()
            SoundService.shared.playSuccess()
        } else {
            HapticsService.error()
            SoundService.shared.playFail()
        }
    }

    func saveResult(modelContext: ModelContext) {
        guard let level, isComplete else { return }

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

        let xp = TidalConfig.xpForLevel(stars: stars, worldIndex: level.world.rawValue)
        if let stats = try? modelContext.fetch(FetchDescriptor<StatsRecord>()).first {
            stats.levelsCompleted += 1
            stats.totalXP += xp
            if stars == 3 { stats.threeStarCount += 1 }
            stats.updateStreak()
            stats.incrementWorld(level.world)
            if isDailyWave { stats.dailyWavesCompleted += 1 }
        }
    }

    private func startAnimation() {
        animationTimer = Timer.scheduledTimer(withTimeInterval: 1.0 / 30.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.engine.tick(dt: 1.0 / 30.0)
            }
        }
    }

    private func startCountdown() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self, var remaining = self.timeRemaining else { return }
                remaining -= 1
                self.timeRemaining = remaining
                if remaining <= 0 {
                    self.stopTimers()
                    if !self.isComplete {
                        HapticsService.error()
                        SoundService.shared.playFail()
                    }
                }
            }
        }
    }

    func stopTimers() {
        timer?.invalidate()
        timer = nil
        animationTimer?.invalidate()
        animationTimer = nil
    }
}
