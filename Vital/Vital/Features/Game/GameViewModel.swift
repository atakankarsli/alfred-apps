import SwiftUI
import SwiftData

@MainActor
@Observable
final class GameViewModel {
    let session: GameSession
    var currentTargetIndex = 0
    var score: Double = 0
    var hits = 0
    var misses = 0
    var elapsedTime: Double = 0
    var isComplete = false
    var isPlaying = false
    var stars = 0

    var breathPhase: BreathPhase = .idle
    var breathProgress: Double = 0
    var reflexReactionTimes: [Double] = []
    var postureHoldProgress: Double = 0

    private var timer: Timer?
    private var startTime: Date?
    private var targetAppearTime: Date?

    enum BreathPhase { case idle, inhale, hold, exhale }

    init(gameType: GameType, level: Int) {
        self.session = GameSession.generate(type: gameType, level: level)
    }

    var totalTargets: Int { session.targets.count }
    var accuracy: Double { totalTargets > 0 ? Double(hits) / Double(totalTargets) : 0 }
    var currentTarget: GameSession.Target? {
        currentTargetIndex < session.targets.count ? session.targets[currentTargetIndex] : nil
    }
    var timeRemaining: Double { max(0, session.duration - elapsedTime) }
    var progress: Double { session.duration > 0 ? min(elapsedTime / session.duration, 1.0) : 0 }

    func start() {
        isPlaying = true
        startTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0 / 60.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            Task { @MainActor in self.tick() }
        }
    }

    private func tick() {
        guard isPlaying, let startTime else { return }
        elapsedTime = Date().timeIntervalSince(startTime)

        switch session.gameType {
        case .breathSync:
            updateBreathPhase()
        default:
            break
        }

        if elapsedTime >= session.duration {
            complete()
        }
    }

    private func updateBreathPhase() {
        guard let target = currentTarget else { return }
        let cycleTime = target.duration
        let cycleProgress = (elapsedTime - target.appearTime).truncatingRemainder(dividingBy: cycleTime) / cycleTime
        let inhaleRatio = target.x
        let holdRatio = 0.1

        if cycleProgress < inhaleRatio {
            breathPhase = .inhale
            breathProgress = cycleProgress / inhaleRatio
        } else if cycleProgress < inhaleRatio + holdRatio {
            breathPhase = .hold
            breathProgress = 1.0
        } else {
            breathPhase = .exhale
            breathProgress = 1.0 - (cycleProgress - inhaleRatio - holdRatio) / (1.0 - inhaleRatio - holdRatio)
        }

        if elapsedTime >= target.appearTime + target.duration, currentTargetIndex < totalTargets - 1 {
            currentTargetIndex += 1
            hits += 1
        }
    }

    func tapTarget() {
        guard isPlaying, !isComplete else { return }

        switch session.gameType {
        case .eyeFocus:
            handleEyeFocusTap()
        case .reflexRush:
            handleReflexTap()
        case .postureCheck:
            handlePostureTap()
        case .breathSync:
            handleBreathTap()
        }
    }

    private func handleEyeFocusTap() {
        hits += 1
        HapticsService.tap()
        SoundService.shared.playHit()
        if currentTargetIndex < totalTargets - 1 { currentTargetIndex += 1 }
    }

    private func handleReflexTap() {
        if let targetAppearTime {
            let reaction = Date().timeIntervalSince(targetAppearTime)
            reflexReactionTimes.append(reaction)
            hits += 1
            HapticsService.tap()
            SoundService.shared.playHit()
        }
        targetAppearTime = nil
        if currentTargetIndex < totalTargets - 1 { currentTargetIndex += 1 }
    }

    private func handlePostureTap() {
        hits += 1
        HapticsService.light()
        SoundService.shared.playHit()
        if currentTargetIndex < totalTargets - 1 { currentTargetIndex += 1 }
    }

    private func handleBreathTap() {
        HapticsService.light()
        if breathPhase == .inhale || breathPhase == .exhale {
            SoundService.shared.playInhale()
        }
    }

    func showReflexTarget() {
        targetAppearTime = Date()
    }

    private func complete() {
        guard !isComplete else { return }
        isComplete = true
        isPlaying = false
        timer?.invalidate()
        timer = nil

        let ratio: Double
        switch session.gameType {
        case .breathSync:
            hits = totalTargets
            ratio = 0.85
        default:
            ratio = accuracy
        }

        score = ratio
        stars = VitalConfig.starsForScore(ratio)

        if stars >= 2 {
            HapticsService.success()
            SoundService.shared.playCelebration()
        } else {
            HapticsService.medium()
            SoundService.shared.playComplete()
        }
    }

    func saveResults(modelContext: ModelContext) {
        let xp = VitalConfig.xpForGame(stars: stars, level: session.level)
        let statsDescriptor = FetchDescriptor<StatsRecord>()
        guard let stats = try? modelContext.fetch(statsDescriptor).first else { return }

        stats.gamesCompleted += 1
        stats.totalXP += xp
        stats.totalTimePlayed += Int(session.duration)
        if stars == 3 { stats.threeStarCount += 1 }
        stats.typesPlayed.insert(session.gameType.rawValue)
        stats.updateStreak()

        switch session.gameType {
        case .eyeFocus: stats.eyeFocusGames += 1
        case .breathSync: stats.breathSyncGames += 1; stats.totalBreathCycles += totalTargets
        case .reflexRush: stats.reflexRushGames += 1
            if let avg = averageReflexTime, (stats.bestReflexTime == 0 || avg < stats.bestReflexTime) {
                stats.bestReflexTime = avg
            }
        case .postureCheck: stats.postureCheckGames += 1
        }

        var best = stats.bestScores
        let key = session.level * 10 + session.gameType.hashValue
        if best[key] == nil || stars > (best[key] ?? 0) { best[key] = stars }
        stats.bestScores = best

        checkAchievements(stats: stats, modelContext: modelContext)
    }

    private func checkAchievements(stats: StatsRecord, modelContext: ModelContext) {
        let existing = Set((try? modelContext.fetch(FetchDescriptor<AchievementRecord>()))?.map(\.achievementId) ?? [])
        var toUnlock: [String] = []

        if stats.gamesCompleted >= 1 { toUnlock.append("first_game") }
        if stats.eyeFocusGames >= 10 { toUnlock.append("eye_10") }
        if stats.breathSyncGames >= 10 { toUnlock.append("breath_10") }
        if stats.reflexRushGames >= 10 { toUnlock.append("reflex_10") }
        if stats.postureCheckGames >= 10 { toUnlock.append("posture_10") }
        if stats.typesPlayed.count >= GameType.allCases.count { toUnlock.append("all_types") }
        if stars == 3 { toUnlock.append("triple_star") }
        if stats.threeStarCount >= 10 { toUnlock.append("star_10") }
        if stats.threeStarCount >= 50 { toUnlock.append("star_50") }
        if stats.currentStreak >= 3 { toUnlock.append("streak_3") }
        if stats.currentStreak >= 7 { toUnlock.append("streak_7") }
        if stats.currentStreak >= 30 { toUnlock.append("streak_30") }
        if stats.currentStreak >= 100 { toUnlock.append("streak_100") }
        if stats.totalXP >= 100 { toUnlock.append("xp_100") }
        if stats.totalXP >= 500 { toUnlock.append("xp_500") }
        if stats.totalXP >= 2000 { toUnlock.append("xp_2000") }
        if stats.totalXP >= 10000 { toUnlock.append("xp_10000") }
        if session.gameType == .reflexRush && score >= 0.95 { toUnlock.append("speed_demon") }

        for id in toUnlock where !existing.contains(id) {
            modelContext.insert(AchievementRecord(achievementId: id))
        }
    }

    var averageReflexTime: Double? {
        guard !reflexReactionTimes.isEmpty else { return nil }
        return reflexReactionTimes.reduce(0, +) / Double(reflexReactionTimes.count)
    }

    func cleanup() {
        timer?.invalidate()
        timer = nil
    }
}
