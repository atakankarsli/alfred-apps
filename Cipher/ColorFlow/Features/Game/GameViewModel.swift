import SwiftUI
import SwiftData

@MainActor
@Observable
final class CipherViewModel {
    var puzzle: CipherPuzzle?
    var level: Int = 0
    var isComplete = false
    var stars: Int = 0
    var xpEarned: Int = 0
    var showConfetti = false
    var newAchievements: [Achievement] = []
    var timerSeconds: Int = 0

    var encryptedChars: [Character] = []
    var guessMap: [Character: Character] = [:]
    var selectedCipherChar: Character?
    var revealedLetters: Set<Character> = []
    var incorrectGuesses: Set<Character> = []
    var letterFrequency: [Character: Int] = [:]

    private var modelContext: ModelContext?
    private var timer: Timer?
    private var solution: [Character: Character] = [:]

    func startGame(level: Int, modelContext: ModelContext) {
        self.level = level
        self.modelContext = modelContext
        self.puzzle = CipherPuzzle.generate(level: level)

        guard let puzzle else { return }
        encryptedChars = Array(puzzle.encryptedText)
        guessMap = [:]
        selectedCipherChar = nil
        revealedLetters = []
        incorrectGuesses = []
        isComplete = false
        stars = 0
        xpEarned = 0
        showConfetti = false
        newAchievements = []
        timerSeconds = 0

        buildSolution()
        buildFrequency()
        startTimer()
    }

    private func buildSolution() {
        guard let puzzle else { return }
        let plain = Array(puzzle.plainText)
        let encrypted = Array(puzzle.encryptedText)
        solution = [:]
        for i in 0..<min(plain.count, encrypted.count) {
            if encrypted[i].isLetter && plain[i].isLetter {
                solution[encrypted[i]] = plain[i]
            }
        }
    }

    private func buildFrequency() {
        letterFrequency = [:]
        for ch in encryptedChars where ch.isLetter {
            letterFrequency[ch, default: 0] += 1
        }
    }

    func selectCipherChar(_ ch: Character) {
        guard ch.isLetter, !isComplete else { return }
        selectedCipherChar = ch
        HapticsService.selection()
    }

    func guessLetter(_ plain: Character) {
        guard let selected = selectedCipherChar, selected.isLetter, !isComplete else { return }
        let upperPlain = Character(plain.uppercased())

        if let existing = guessMap.first(where: { $0.value == upperPlain }) {
            guessMap.removeValue(forKey: existing.key)
        }

        guessMap[selected] = upperPlain
        selectedCipherChar = nil

        if let correctPlain = solution[selected], correctPlain == upperPlain {
            HapticsService.light()
            SoundService.shared.playNote(2)
        } else {
            incorrectGuesses.insert(selected)
            HapticsService.medium()
            SoundService.shared.playNote(-4)
        }

        checkCompletion()
    }

    func clearGuess() {
        guard let selected = selectedCipherChar else { return }
        guessMap.removeValue(forKey: selected)
        incorrectGuesses.remove(selected)
        selectedCipherChar = nil
        HapticsService.light()
    }

    func useHint() {
        let unguessed = solution.keys.filter {
            !revealedLetters.contains($0) && guessMap[$0] != solution[$0]
        }
        guard let ch = unguessed.randomElement(), let plain = solution[ch] else { return }

        guessMap[ch] = plain
        revealedLetters.insert(ch)
        HapticsService.success()
        SoundService.shared.playNote(5)

        if let ctx = modelContext {
            let descriptor = FetchDescriptor<StatsRecord>()
            if let stats = try? ctx.fetch(descriptor).first {
                stats.hintsUsed += 1
                try? ctx.save()
            }
        }
        checkCompletion()
    }

    func cleanup() {
        timer?.invalidate()
        timer = nil
    }

    private func checkCompletion() {
        for (encrypted, plain) in solution {
            guard let guess = guessMap[encrypted], guess == plain else { return }
        }

        isComplete = true
        timer?.invalidate()

        let par = CipherPuzzle.parTime(for: level)
        stars = CipherConfig.starsForTime(timerSeconds, par: par)
        let vaultIndex = Vault.vaultForLevel(level).id
        xpEarned = CipherConfig.xpForPuzzle(stars: stars, vault: vaultIndex)

        if stars >= 3 {
            showConfetti = true
            HapticsService.success()
        }
        SoundService.shared.playCelebration()

        updateStats()
        checkAchievements()
    }

    private func updateStats() {
        guard let ctx = modelContext else { return }
        let descriptor = FetchDescriptor<StatsRecord>()
        guard let stats = try? ctx.fetch(descriptor).first else { return }

        stats.puzzlesCompleted += 1
        stats.totalMoves += guessMap.count
        if stars >= 3 { stats.threeStarCount += 1 }
        stats.totalXP += xpEarned
        stats.totalTimePlayed += timerSeconds
        stats.updateStreak()

        var best = stats.bestMoves
        if let existing = best[level] {
            if timerSeconds < existing { best[level] = timerSeconds }
        } else {
            best[level] = timerSeconds
        }
        stats.bestMoves = best

        try? ctx.save()
    }

    private func checkAchievements() {
        guard let ctx = modelContext else { return }
        let statsDesc = FetchDescriptor<StatsRecord>()
        let achDesc = FetchDescriptor<AchievementRecord>()

        guard let stats = try? ctx.fetch(statsDesc).first,
              let unlocked = try? ctx.fetch(achDesc) else { return }

        let unlockedIds = Set(unlocked.map(\.achievementId))

        for ach in Achievement.all where !unlockedIds.contains(ach.id) {
            if shouldUnlock(ach, stats: stats) {
                let record = AchievementRecord(achievementId: ach.id, unlockedAt: .now)
                ctx.insert(record)
                newAchievements.append(ach)
                xpEarned += ach.tier.xpReward
                stats.totalXP += ach.tier.xpReward
            }
        }

        try? ctx.save()
    }

    private func shouldUnlock(_ ach: Achievement, stats: StatsRecord) -> Bool {
        switch ach.id {
        case "first_decrypt": return stats.puzzlesCompleted >= 1
        case "scrolls_complete": return completedVaultCount(stats: stats) >= 1
        case "society_complete": return completedVaultCount(stats: stats) >= 2
        case "warroom_complete": return completedVaultCount(stats: stats) >= 3
        case "enigma_complete": return completedVaultCount(stats: stats) >= 4
        case "perfectionist": return stats.threeStarCount >= 10
        case "star_collector": return stats.threeStarCount >= 40
        case "speed_decoder": return timerSeconds <= 30 && isComplete
        case "no_hints": return stats.noHintCompletions >= 20
        case "streak_3": return stats.currentStreak >= 3
        case "streak_7": return stats.currentStreak >= 7
        case "streak_30": return stats.currentStreak >= 30
        case "streak_100": return stats.currentStreak >= 100
        case "xp_100": return stats.totalXP >= 100
        case "xp_500": return stats.totalXP >= 500
        case "xp_2000": return stats.totalXP >= 2000
        case "xp_10000": return stats.totalXP >= 10000
        case "daily_first": return stats.dailyPuzzlesCompleted >= 1
        case "daily_30": return stats.dailyPuzzlesCompleted >= 30
        case "caesar_master": return (0..<10).allSatisfy { stats.bestMoves[$0] != nil }
        case "vigenere_master": return (60..<70).allSatisfy { stats.bestMoves[$0] != nil }
        case "all_types": return allTypesSolved(stats: stats)
        default: return false
        }
    }

    private func completedVaultCount(stats: StatsRecord) -> Int {
        Vault.all.filter { v in v.levelRange.allSatisfy { stats.bestMoves[$0] != nil } }.count
    }

    private func allTypesSolved(stats: StatsRecord) -> Bool {
        let ranges = [0, 10, 20, 30, 40, 50, 60, 70]
        return ranges.allSatisfy { s in (s..<s+10).contains { stats.bestMoves[$0] != nil } }
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in self?.timerSeconds += 1 }
        }
    }

    var uniqueEncryptedLetters: [Character] {
        var seen = Set<Character>()
        return encryptedChars.filter { ch in
            guard ch.isLetter, !seen.contains(ch) else { return false }
            seen.insert(ch)
            return true
        }.sorted()
    }

    var alphabetLetters: [Character] { Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ") }

    var usedPlainLetters: Set<Character> { Set(guessMap.values) }

    func isCorrectGuess(for encChar: Character) -> Bool {
        guard let guess = guessMap[encChar], let correct = solution[encChar] else { return false }
        return guess == correct
    }
}
