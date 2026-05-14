import SwiftUI
import SwiftData

enum ImprintPhase {
    case preview
    case playing
    case completed
}

@MainActor
@Observable
final class ImprintViewModel {
    let mode: ImprintMode
    var puzzle: ImprintPuzzle
    var phase: ImprintPhase = .preview
    var answer: [Int]
    var selectedColorIndex: Int = 0
    var elapsedTime: Int = 0
    var showTimer: Bool = true
    var isPaused: Bool = false

    private var timer: Timer?

    var gridSize: Int { puzzle.gridSize }
    var totalCells: Int { puzzle.gridSize * puzzle.gridSize }
    var availableColors: Int {
        let unique = Set(puzzle.colorIndices)
        return unique.count
    }

    var accuracy: Double {
        puzzle.accuracy(answer: answer)
    }

    var stars: Int {
        ImprintConfig.starsForAccuracy(accuracy)
    }

    init(mode: ImprintMode) {
        self.mode = mode
        let level: Int
        switch mode {
        case .mosaic(let index): level = index
        case .daily:
            let day = Calendar.current.ordinality(of: .day, in: .year, for: .now) ?? 1
            level = day % ImprintConfig.totalPuzzles
        case .quickSnap:
            level = Int.random(in: 0..<ImprintConfig.totalPuzzles)
        }
        let p = ImprintPuzzle.generate(level: level)
        self.puzzle = p
        self.answer = Array(repeating: 0, count: p.gridSize * p.gridSize)
    }

    func startPreview() {
        phase = .preview
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: puzzle.previewDuration, repeats: false) { [weak self] _ in
            Task { @MainActor in
                guard let self else { return }
                self.phase = .playing
                self.startPlayTimer()
            }
        }
    }

    private func startPlayTimer() {
        elapsedTime = 0
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self, !self.isPaused else { return }
                self.elapsedTime += 1
            }
        }
    }

    func tapCell(_ index: Int) {
        guard phase == .playing, index < answer.count else { return }
        answer[index] = selectedColorIndex
        HapticsService.light()
        SoundService.shared.playTap()
    }

    func submit(stats: StatsRecord?, settings: SettingsRecord?, modelContext: ModelContext) {
        timer?.invalidate()
        phase = .completed

        let acc = accuracy
        let earnedStars = ImprintConfig.starsForAccuracy(acc)
        let xp = ImprintConfig.xpForPuzzle(accuracy: acc, level: puzzle.level)

        if let stats {
            stats.puzzlesCompleted += 1
            stats.totalTimePlayed += elapsedTime
            if earnedStars == 3 { stats.threeStarCount += 1 }
            stats.totalXP += xp
            if acc >= 0.95 { stats.noHintCompletions += 1 }

            var best = stats.bestMoves
            if best[puzzle.level] == nil || acc > Double(best[puzzle.level] ?? 0) / 100.0 {
                best[puzzle.level] = Int(acc * 100)
            }
            stats.bestMoves = best
            stats.updateStreak()

            if case .daily = mode {
                stats.dailyPuzzlesCompleted += 1
            }
        }

        if let settings {
            let nextLevel = puzzle.level + 1
            if nextLevel > settings.highestUnlockedLevel {
                settings.highestUnlockedLevel = nextLevel
            }
        }

        checkAchievements(stats: stats, modelContext: modelContext)
        HapticsService.success()
        SoundService.shared.playCelebration()
    }

    private func checkAchievements(stats: StatsRecord?, modelContext: ModelContext) {
        let existing = (try? modelContext.fetch(FetchDescriptor<AchievementRecord>()))?.map(\.achievementId) ?? []
        var newIds = [String]()

        if !existing.contains("first_snap") { newIds.append("first_snap") }
        if accuracy >= 0.95 && !existing.contains("sharp_eye") { newIds.append("sharp_eye") }

        if let stats {
            if stats.currentStreak >= 3 && !existing.contains("streak_3") { newIds.append("streak_3") }
            if stats.currentStreak >= 7 && !existing.contains("streak_7") { newIds.append("streak_7") }
            if stats.currentStreak >= 30 && !existing.contains("streak_30") { newIds.append("streak_30") }
            if stats.threeStarCount >= 10 && !existing.contains("perfect_10") { newIds.append("perfect_10") }
            if stats.noHintCompletions >= 10 && !existing.contains("no_mistakes") { newIds.append("no_mistakes") }
            if stats.dailyPuzzlesCompleted >= 10 && !existing.contains("daily_10") { newIds.append("daily_10") }
            if stats.puzzlesCompleted >= 40 && !existing.contains("half_way") { newIds.append("half_way") }
            if stats.puzzlesCompleted >= 80 && !existing.contains("completionist") { newIds.append("completionist") }
            if elapsedTime < 10 && !existing.contains("speed_snap") { newIds.append("speed_snap") }

            let best = stats.bestMoves
            if Moment.all[0].levelRange.allSatisfy({ best[$0] != nil }) && !existing.contains("dawn_walker") { newIds.append("dawn_walker") }
            if Moment.all[1].levelRange.allSatisfy({ best[$0] != nil }) && !existing.contains("golden_light") { newIds.append("golden_light") }
            if Moment.all[2].levelRange.allSatisfy({ best[$0] != nil }) && !existing.contains("twilight_artist") { newIds.append("twilight_artist") }
            if Moment.all[3].levelRange.allSatisfy({ best[$0] != nil }) && !existing.contains("midnight_master") { newIds.append("midnight_master") }

            let level = ImprintConfig.levelForXP(stats.totalXP)
            if level >= ImprintConfig.xpLevelTitles.count - 1 && !existing.contains("xp_max") { newIds.append("xp_max") }
        }

        for id in newIds {
            modelContext.insert(AchievementRecord(achievementId: id))
        }
    }

    func cleanup() {
        timer?.invalidate()
        timer = nil
    }
}
