import SwiftUI
import SwiftData

@MainActor
@Observable
final class PlayViewModel {
    var track: BeatTrack?
    var isPlaying = false
    var isComplete = false
    var elapsedTime: Double = 0
    var score: Double = 0
    var stars: Int = 0
    var combo: Int = 0
    var maxCombo: Int = 0
    var comboMultiplier: Int = 1
    var lastJudgment: HitJudgment?
    var lastJudgmentTime: Date?

    var perfectCount = 0
    var greatCount = 0
    var goodCount = 0
    var missCount = 0

    private(set) var trackIndex: Int = 0
    private var isDaily = false
    private var isFreestyle = false
    private var hitNotes: Set<UUID> = []
    private var noteScores: [UUID: Double] = [:]
    private var timer: Timer?

    var totalHits: Int { perfectCount + greatCount + goodCount }
    var totalNotes: Int { track?.notes.count ?? 1 }

    var accuracy: Double {
        guard totalNotes > 0 else { return 0 }
        let maxScore = Double(totalNotes)
        let earned = noteScores.values.reduce(0, +)
        return earned / maxScore
    }

    var bpmDisplay: String {
        "\(track?.bpm ?? 0) BPM"
    }

    var visibleNotes: [BeatNote] {
        guard let track else { return [] }
        let windowStart = elapsedTime - 0.2
        let windowEnd = elapsedTime + 3.0
        return track.notes.filter { note in
            note.beatTime >= windowStart && note.beatTime <= windowEnd && !hitNotes.contains(note.id)
        }
    }

    func noteYPosition(note: BeatNote, height: CGFloat) -> CGFloat {
        let hitLineY = height * 0.85
        let timeUntilHit = note.beatTime - elapsedTime
        let pixelsPerSecond = hitLineY / 2.5
        return hitLineY - (timeUntilHit * pixelsPerSecond)
    }

    func startTrack(index: Int, isDaily: Bool, isFreestyle: Bool) {
        self.trackIndex = index
        self.isDaily = isDaily
        self.isFreestyle = isFreestyle

        let t = BeatTrack.generate(index: index)
        track = t
        elapsedTime = 0
        score = 0
        isComplete = false
        isPlaying = false
        combo = 0
        maxCombo = 0
        comboMultiplier = 1
        perfectCount = 0
        greatCount = 0
        goodCount = 0
        missCount = 0
        hitNotes = []
        noteScores = [:]
        lastJudgment = nil

        startCountdown()
    }

    private func startCountdown() {
        isPlaying = true
        let startTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0 / 60.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            Task { @MainActor in
                guard self.isPlaying else { return }
                self.elapsedTime = Date().timeIntervalSince(startTime)
                self.checkMissedNotes()
                if let track = self.track, self.elapsedTime >= track.duration {
                    self.completeTrack()
                }
            }
        }
    }

    func tapLane(_ lane: Int) {
        guard isPlaying, !isComplete, let track else { return }

        let hitWindow = 0.1
        let closestNote = track.notes
            .filter { $0.lane == lane && !hitNotes.contains($0.id) }
            .min(by: { abs($0.beatTime - elapsedTime) < abs($1.beatTime - elapsedTime) })

        guard let note = closestNote else { return }

        let deltaMs = (note.beatTime - elapsedTime) * 1000
        let judgment = HitJudgment.judge(deltaMs: deltaMs)

        if abs(note.beatTime - elapsedTime) > hitWindow * 1.5 { return }

        hitNotes.insert(note.id)
        noteScores[note.id] = judgment.scoreMultiplier
        lastJudgment = judgment
        lastJudgmentTime = Date()

        switch judgment {
        case .perfect:
            perfectCount += 1
            combo += 1
            HapticsService.beatHit()
            SoundService.shared.playPerfect()
        case .great:
            greatCount += 1
            combo += 1
            HapticsService.light()
            SoundService.shared.playGreat()
        case .good:
            goodCount += 1
            combo += 1
            HapticsService.light()
            SoundService.shared.playTick()
        case .miss:
            missCount += 1
            combo = 0
            HapticsService.medium()
            SoundService.shared.playMiss()
        }

        maxCombo = max(maxCombo, combo)
        updateComboMultiplier()
    }

    private func updateComboMultiplier() {
        if combo >= 40 { comboMultiplier = 8 }
        else if combo >= 20 { comboMultiplier = 4 }
        else if combo >= 10 { comboMultiplier = 2 }
        else { comboMultiplier = 1 }
    }

    private func checkMissedNotes() {
        guard let track else { return }
        for note in track.notes {
            if !hitNotes.contains(note.id) && elapsedTime - note.beatTime > 0.15 {
                hitNotes.insert(note.id)
                noteScores[note.id] = 0
                missCount += 1
                if combo > 0 {
                    combo = 0
                    comboMultiplier = 1
                    SoundService.shared.playComboBreak()
                }
            }
        }
    }

    private func completeTrack() {
        guard !isComplete else { return }
        isComplete = true
        isPlaying = false
        timer?.invalidate()
        timer = nil

        score = accuracy
        stars = PulseConfig.starsForAccuracy(accuracy)

        if stars >= 2 {
            HapticsService.success()
            SoundService.shared.playCelebration()
        } else {
            HapticsService.medium()
        }
    }

    func updateStats(modelContext: ModelContext) {
        guard let track else { return }
        let season = Season.seasonForTrack(trackIndex)
        let xp = PulseConfig.xpForTrack(stars: stars, seasonId: season.id, maxCombo: maxCombo)

        let statsDescriptor = FetchDescriptor<StatsRecord>()
        guard let stats = try? modelContext.fetch(statsDescriptor).first else { return }

        stats.tracksCompleted += 1
        stats.totalXP += xp
        stats.totalHits += totalHits
        stats.perfectHits += perfectCount
        stats.greatHits += greatCount
        stats.goodHits += goodCount
        stats.missedHits += missCount
        stats.totalTimePlayed += Int(track.duration)
        stats.maxCombo = max(stats.maxCombo, maxCombo)
        stats.totalCombo += maxCombo

        if stars == 3 { stats.threeStarCount += 1 }

        var best = stats.bestStars
        if best[trackIndex] == nil || stars > (best[trackIndex] ?? 0) {
            best[trackIndex] = stars
        }
        stats.bestStars = best

        var seasons = stats.seasonsPlayed
        seasons.insert(season.id)
        stats.seasonsPlayed = seasons

        stats.updateStreak()

        if isDaily { stats.dailyTracksCompleted += 1 }

        let settingsDescriptor = FetchDescriptor<SettingsRecord>()
        if let settings = try? modelContext.fetch(settingsDescriptor).first {
            if !isDaily && !isFreestyle && trackIndex >= settings.highestUnlockedLevel {
                settings.highestUnlockedLevel = trackIndex + 1
            }
            settings.currentLevelIndex = max(settings.currentLevelIndex, trackIndex + 1)
        }
    }

    func checkAchievements(modelContext: ModelContext) {
        let descriptor = FetchDescriptor<AchievementRecord>()
        let existing = Set((try? modelContext.fetch(descriptor))?.map(\.achievementId) ?? [])
        let statsDescriptor = FetchDescriptor<StatsRecord>()
        guard let stats = try? modelContext.fetch(statsDescriptor).first else { return }

        var toUnlock: [String] = []

        if stats.tracksCompleted >= 1 && !existing.contains("first_beat") { toUnlock.append("first_beat") }
        if maxCombo >= 25 && !existing.contains("combo_25") { toUnlock.append("combo_25") }
        if maxCombo >= 50 && !existing.contains("combo_50") { toUnlock.append("combo_50") }
        if maxCombo >= 100 && !existing.contains("combo_100") { toUnlock.append("combo_100") }
        if stars == 3 && !existing.contains("triple_star") { toUnlock.append("triple_star") }
        if stats.threeStarCount >= 10 && !existing.contains("star_10") { toUnlock.append("star_10") }
        if stats.threeStarCount >= 50 && !existing.contains("star_50") { toUnlock.append("star_50") }
        if stats.currentStreak >= 3 && !existing.contains("streak_3") { toUnlock.append("streak_3") }
        if stats.currentStreak >= 7 && !existing.contains("streak_7") { toUnlock.append("streak_7") }
        if stats.currentStreak >= 30 && !existing.contains("streak_30") { toUnlock.append("streak_30") }
        if stats.currentStreak >= 100 && !existing.contains("streak_100") { toUnlock.append("streak_100") }
        if stats.totalXP >= 100 && !existing.contains("xp_100") { toUnlock.append("xp_100") }
        if stats.totalXP >= 500 && !existing.contains("xp_500") { toUnlock.append("xp_500") }
        if stats.totalXP >= 2000 && !existing.contains("xp_2000") { toUnlock.append("xp_2000") }
        if stats.totalXP >= 10000 && !existing.contains("xp_10000") { toUnlock.append("xp_10000") }
        if stats.seasonsPlayed.count >= Season.all.count && !existing.contains("all_seasons") { toUnlock.append("all_seasons") }
        if isDaily && !existing.contains("daily_first") { toUnlock.append("daily_first") }
        if stats.dailyTracksCompleted >= 30 && !existing.contains("daily_30") { toUnlock.append("daily_30") }
        if missCount == 0 && totalHits > 0 && !existing.contains("full_combo") { toUnlock.append("full_combo") }

        for id in toUnlock {
            modelContext.insert(AchievementRecord(achievementId: id))
        }
    }

    func cleanup() {
        timer?.invalidate()
    }
}
