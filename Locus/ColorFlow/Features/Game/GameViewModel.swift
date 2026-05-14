import SwiftUI
import SwiftData

@MainActor
@Observable
class LocusViewModel {
    var puzzle: LocusPuzzle
    var phase: GamePhase = .preview
    var selectedCells = Set<Int>()
    var timeElapsed: TimeInterval = 0
    var stars = 0
    var xpEarned = 0
    var isNewBest = false

    enum GamePhase { case preview, playing, completed }

    private var timer: Timer?
    private var modelContext: ModelContext?
    private let mode: LocusMode

    init(mode: LocusMode) {
        self.mode = mode
        switch mode {
        case .room(let i): puzzle = LocusPuzzle.generate(level: i)
        case .daily:
            let day = Calendar.current.ordinality(of: .day, in: .year, for: .now) ?? 1
            puzzle = LocusPuzzle.generate(level: day % LocusConfig.totalPuzzles)
        case .quickPlace:
            puzzle = LocusPuzzle.generate(level: Int.random(in: 0..<LocusConfig.totalPuzzles))
        }
    }

    func configure(context: ModelContext) { modelContext = context; startPreview() }

    var itemPositions: Set<Int> { Set(puzzle.items.map(\.position)) }

    func symbolAt(_ pos: Int) -> String? { puzzle.items.first(where: { $0.position == pos })?.symbol }

    func startPreview() {
        phase = .preview
        selectedCells.removeAll()
        timeElapsed = 0
        timer?.invalidate()
        let dur = puzzle.previewDuration
        DispatchQueue.main.asyncAfter(deadline: .now() + dur) { [weak self] in
            guard let self, self.phase == .preview else { return }
            self.phase = .playing
            self.startTimer()
            SoundService.shared.playTap()
        }
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self else { return }
            Task { @MainActor in
                guard self.phase == .playing else { return }
                self.timeElapsed += 0.1
            }
        }
    }

    func toggleCell(_ index: Int) {
        guard phase == .playing else { return }
        HapticsService.light(); SoundService.shared.playTap()
        if selectedCells.contains(index) { selectedCells.remove(index) }
        else { selectedCells.insert(index) }
    }

    func submit() {
        guard phase == .playing else { return }
        timer?.invalidate()
        let target = itemPositions
        let correct = selectedCells.intersection(target).count
        let wrong = selectedCells.subtracting(target).count
        let acc = target.isEmpty ? 0 : max(0, min(1, (Double(correct) - Double(wrong) * 0.5) / Double(target.count)))
        stars = LocusConfig.starsForScore(acc)
        let palace = Palace.palaceForPuzzle(puzzle.level)
        xpEarned = LocusConfig.xpForPuzzle(stars: stars, room: palace.id)
        phase = .completed
        if stars > 0 { SoundService.shared.playCelebration(); HapticsService.success() }
        else { HapticsService.heavy() }
        updateStats(); checkAchievements()
    }

    private func updateStats() {
        guard let ctx = modelContext else { return }
        let stats = (try? ctx.fetch(FetchDescriptor<StatsRecord>()))?.first ?? { let s = StatsRecord(); ctx.insert(s); return s }()
        stats.puzzlesCompleted += 1
        stats.totalMoves += selectedCells.count
        if stars >= 3 { stats.threeStarCount += 1 }
        stats.totalXP += xpEarned
        stats.totalTimePlayed += Int(timeElapsed)
        if case .daily = mode { stats.dailyPuzzlesCompleted += 1 }
        var best = stats.bestMoves
        if case .room(let i) = mode { let prev = best[i] ?? 0; if stars > prev { best[i] = stars; isNewBest = true } }
        stats.bestMoves = best
        stats.updateStreak()
        try? ctx.save()
    }

    private func checkAchievements() {
        guard let ctx = modelContext else { return }
        let stats = (try? ctx.fetch(FetchDescriptor<StatsRecord>()))?.first
        let existing = Set((try? ctx.fetch(FetchDescriptor<AchievementRecord>()))?.map(\.achievementId) ?? [])
        var newOnes: [String] = []
        func check(_ id: String, _ met: Bool) { if met && !existing.contains(id) { newOnes.append(id) } }
        let completed = stats?.puzzlesCompleted ?? 0
        let perfects = stats?.threeStarCount ?? 0
        let streak = stats?.currentStreak ?? 0
        let xp = stats?.totalXP ?? 0
        let best = stats?.bestMoves ?? [:]
        check("first_place", completed >= 1)
        check("ten_rooms", completed >= 10)
        check("twenty_five", completed >= 25)
        check("fifty", completed >= 50)
        check("all_rooms", completed >= 80)
        check("perfect_one", perfects >= 1)
        check("perfect_ten", perfects >= 10)
        check("perfect_twenty", perfects >= 20)
        check("streak_three", streak >= 3)
        check("streak_seven", streak >= 7)
        check("streak_thirty", streak >= 30)
        check("study_done", Palace.all[0].puzzleRange.allSatisfy { best[$0] != nil })
        check("kitchen_done", Palace.all[1].puzzleRange.allSatisfy { best[$0] != nil })
        check("garden_done", Palace.all[2].puzzleRange.allSatisfy { best[$0] != nil })
        check("vault_done", Palace.all[3].puzzleRange.allSatisfy { best[$0] != nil })
        check("speed_place", timeElapsed < 5 && stars > 0)
        check("daily_five", (stats?.dailyPuzzlesCompleted ?? 0) >= 5)
        check("level_five", LocusConfig.levelForXP(xp) >= 5)
        check("xp_thousand", xp >= 1000)
        for id in newOnes { ctx.insert(AchievementRecord(achievementId: id, unlockedAt: .now)) }
        try? ctx.save()
    }

    func cleanup() { timer?.invalidate(); timer = nil }
}
