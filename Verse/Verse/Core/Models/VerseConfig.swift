import Foundation

enum VerseConfig {
    static let totalLevels = 80
    static let xpPerLevel: [Int] = [100, 250, 500, 1000, 2000, 3500, 5500, 8000, 12000, 18000]

    static func starsForCompletion(perfectForm: Bool, allWordsUsed: Bool, bonusUsed: Bool) -> Int {
        if perfectForm && allWordsUsed { return 3 }
        if perfectForm { return 2 }
        return 1
    }

    static func xpForPuzzle(stars: Int, chapter: Int) -> Int {
        let base = stars * 10
        let chapterBonus = chapter * 5
        return base + chapterBonus
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
        ["Scribbler", "Wordsmith", "Poet", "Bard", "Lyricist",
         "Balladeer", "Troubadour", "Laureate", "Sage", "Muse",
         "Eternal Verse"][min(level, 10)]
    }
}
