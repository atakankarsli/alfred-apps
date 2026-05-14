import Foundation

enum CipherConfig {
    static let totalLevels = 80
    static let xpPerLevel: [Int] = [100, 250, 500, 1000, 2000, 3500, 5500, 8000, 12000, 18000]

    static func starsForTime(_ seconds: Int, par: Int) -> Int {
        if seconds <= par { return 3 }
        if seconds <= par * 2 { return 2 }
        return 1
    }

    static func xpForPuzzle(stars: Int, vault: Int) -> Int {
        let base = stars * 10
        let vaultBonus = vault * 5
        return base + vaultBonus
    }

    static func levelForXP(_ xp: Int) -> Int {
        for (i, threshold) in xpPerLevel.enumerated() {
            if xp < threshold { return i }
        }
        return xpPerLevel.count
    }

    static func xpProgressInLevel(_ xp: Int) -> Double {
        let level = levelForXP(xp)
        if level >= xpPerLevel.count { return 1.0 }
        let prev = level > 0 ? xpPerLevel[level - 1] : 0
        let next = xpPerLevel[level]
        return Double(xp - prev) / Double(next - prev)
    }

    static func xpLevelTitle(_ level: Int) -> String {
        ["Novice", "Apprentice", "Decoder", "Analyst", "Cryptographer",
         "Cipher Master", "Code Breaker", "Enigma Solver", "Shadow Agent", "Grand Decryptor",
         "Legendary"][min(level, 10)]
    }
}
