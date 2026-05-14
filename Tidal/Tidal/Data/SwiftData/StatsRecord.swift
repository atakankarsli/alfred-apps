import Foundation
import SwiftData

@Model
final class StatsRecord {
    var levelsCompleted: Int
    var threeStarCount: Int
    var currentStreak: Int
    var longestStreak: Int
    var lastPlayedDate: String?
    var totalXP: Int
    var totalTimePlayed: Int

    var ripplesCompleted: Int
    var echoesCompleted: Int
    var resonanceCompleted: Int
    var harmonicsCompleted: Int
    var chaosCompleted: Int

    var sandboxPlays: Int
    var dailyWavesCompleted: Int

    init(
        levelsCompleted: Int = 0, threeStarCount: Int = 0,
        currentStreak: Int = 0, longestStreak: Int = 0, lastPlayedDate: String? = nil,
        totalXP: Int = 0, totalTimePlayed: Int = 0,
        ripplesCompleted: Int = 0, echoesCompleted: Int = 0,
        resonanceCompleted: Int = 0, harmonicsCompleted: Int = 0,
        chaosCompleted: Int = 0,
        sandboxPlays: Int = 0, dailyWavesCompleted: Int = 0
    ) {
        self.levelsCompleted = levelsCompleted
        self.threeStarCount = threeStarCount
        self.currentStreak = currentStreak
        self.longestStreak = longestStreak
        self.lastPlayedDate = lastPlayedDate
        self.totalXP = totalXP
        self.totalTimePlayed = totalTimePlayed
        self.ripplesCompleted = ripplesCompleted
        self.echoesCompleted = echoesCompleted
        self.resonanceCompleted = resonanceCompleted
        self.harmonicsCompleted = harmonicsCompleted
        self.chaosCompleted = chaosCompleted
        self.sandboxPlays = sandboxPlays
        self.dailyWavesCompleted = dailyWavesCompleted
    }

    func updateStreak() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = formatter.string(from: .now)
        guard lastPlayedDate != today else { return }

        if let last = lastPlayedDate,
           let lastDate = formatter.date(from: last),
           Calendar.current.isDateInYesterday(lastDate) {
            currentStreak += 1
        } else {
            currentStreak = 1
        }
        longestStreak = max(longestStreak, currentStreak)
        lastPlayedDate = today
    }

    func incrementWorld(_ world: WaveWorld) {
        switch world {
        case .ripples: ripplesCompleted += 1
        case .echoes: echoesCompleted += 1
        case .resonance: resonanceCompleted += 1
        case .harmonics: harmonicsCompleted += 1
        case .chaos: chaosCompleted += 1
        }
    }

    var hasPlayedAllWorlds: Bool {
        ripplesCompleted > 0 && echoesCompleted > 0 && resonanceCompleted > 0 && harmonicsCompleted > 0 && chaosCompleted > 0
    }
}
