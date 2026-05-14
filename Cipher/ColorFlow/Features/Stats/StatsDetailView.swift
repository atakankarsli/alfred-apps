import SwiftUI
import SwiftData

struct StatsDetailView: View {
    @Environment(\.theme) private var theme
    @Query private var stats: [StatsRecord]
    @Query private var achievements: [AchievementRecord]

    private var s: StatsRecord? { stats.first }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                xpSection
                cipherStats
                streakStats
                performanceStats
            }
            .padding(16)
        }
        .themedBackground()
        .navigationTitle("Statistics")
    }

    private var xpSection: some View {
        let xp = s?.totalXP ?? 0
        let level = CipherConfig.levelForXP(xp)
        let progress = CipherConfig.xpProgressInLevel(xp)
        let rankTitle = CipherConfig.xpLevelTitle(level)

        return VStack(spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Level \(level)").font(.system(size: 24, weight: .black, design: .rounded)).primaryText()
                    Text(rankTitle).font(.system(size: 14, weight: .medium)).foregroundStyle(theme.colors.accent)
                }
                Spacer()
                Text("\(xp) XP").font(.system(size: 18, weight: .bold, design: .monospaced)).secondaryText()
            }
            ProgressView(value: progress).tint(theme.colors.accent)
            if level < CipherConfig.xpPerLevel.count {
                Text("\(CipherConfig.xpPerLevel[level] - xp) XP to next level").font(.caption).mutedText()
            }
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 16).fill(theme.colors.accent.opacity(0.06))
                .overlay { RoundedRectangle(cornerRadius: 16).strokeBorder(theme.colors.accent.opacity(0.15), lineWidth: 1) }
        }
    }

    private var cipherStats: some View {
        statsCard(title: "Ciphers", rows: [
            ("Decoded", "\(s?.puzzlesCompleted ?? 0)"),
            ("3-Star", "\(s?.threeStarCount ?? 0)"),
            ("Total Guesses", "\(s?.totalMoves ?? 0)"),
            ("Time Played", formatTime(s?.totalTimePlayed ?? 0)),
            ("Achievements", "\(achievements.count)/\(Achievement.all.count)"),
        ])
    }

    private var streakStats: some View {
        statsCard(title: "Streaks", rows: [
            ("Current Streak", "\(s?.currentStreak ?? 0) days"),
            ("Longest Streak", "\(s?.longestStreak ?? 0) days"),
            ("Daily Ciphers", "\(s?.dailyPuzzlesCompleted ?? 0)"),
        ])
    }

    private var performanceStats: some View {
        let noHint = s?.noHintCompletions ?? 0
        let total = max(s?.puzzlesCompleted ?? 1, 1)

        return statsCard(title: "Performance", rows: [
            ("No-Hint Solves", "\(noHint) (\(noHint * 100 / total)%)"),
            ("Hints Used", "\(s?.hintsUsed ?? 0)"),
            ("Vaults Cleared", "\(vaultsCleared())/4"),
        ])
    }

    private func statsCard(title: String, rows: [(String, String)]) -> some View {
        VStack(spacing: 0) {
            HStack {
                Text(title).font(.system(size: 15, weight: .bold, design: .rounded)).primaryText()
                Spacer()
            }.padding(.bottom, 10)
            ForEach(Array(rows.enumerated()), id: \.offset) { _, row in
                HStack {
                    Text(row.0).font(.system(size: 14)).secondaryText()
                    Spacer()
                    Text(row.1).font(.system(size: 14, weight: .semibold, design: .rounded)).primaryText()
                }.padding(.vertical, 6)
            }
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 16).fill(theme.colors.surface.opacity(0.4))
                .overlay { RoundedRectangle(cornerRadius: 16).strokeBorder(theme.colors.boardBorder.opacity(0.12), lineWidth: 1) }
        }
    }

    private func formatTime(_ seconds: Int) -> String {
        let h = seconds / 3600
        let m = (seconds % 3600) / 60
        if h > 0 { return "\(h)h \(m)m" }
        return "\(m)m"
    }

    private func vaultsCleared() -> Int {
        let best = s?.bestMoves ?? [:]
        return Vault.all.filter { v in v.levelRange.allSatisfy { best[$0] != nil } }.count
    }
}
