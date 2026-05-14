import SwiftUI
import SwiftData

struct StatsDetailView: View {
    @Environment(\.theme) private var theme
    @Query private var stats: [StatsRecord]
    @Query private var achievements: [AchievementRecord]
    @Query private var levels: [LevelRecord]

    private var s: StatsRecord? { stats.first }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                xpSection
                puzzleStats
                streakStats
                worldStats
            }
            .padding(16)
        }
        .themedBackground()
        .navigationTitle("Statistics")
    }

    private var xpSection: some View {
        let xp = s?.totalXP ?? 0
        let level = TidalConfig.levelForXP(xp)
        let progress = TidalConfig.xpProgressInLevel(xp)
        let title = TidalConfig.levelTitle(level)

        return VStack(spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Level \(level)").font(.system(size: 24, weight: .black, design: .rounded)).primaryText()
                    Text(title).font(.system(size: 14, weight: .medium)).foregroundStyle(theme.colors.accent)
                }
                Spacer()
                Text("\(xp) XP").font(.system(size: 18, weight: .bold, design: .monospaced)).secondaryText()
            }
            ProgressView(value: progress).tint(theme.colors.accent)
            if level < TidalConfig.xpPerLevel.count {
                Text("\(TidalConfig.xpPerLevel[level] - xp) XP to next level").font(.caption).mutedText()
            }
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 16).fill(theme.colors.accent.opacity(0.06))
                .overlay { RoundedRectangle(cornerRadius: 16).strokeBorder(theme.colors.accent.opacity(0.15), lineWidth: 1) }
        }
    }

    private var puzzleStats: some View {
        statsCard(title: "Puzzles", rows: [
            ("Completed", "\(s?.levelsCompleted ?? 0)"),
            ("3-Star", "\(s?.threeStarCount ?? 0)"),
            ("Time Played", formatTime(s?.totalTimePlayed ?? 0)),
            ("Achievements", "\(achievements.count)/\(Achievement.all.count)"),
        ])
    }

    private var streakStats: some View {
        statsCard(title: "Streaks", rows: [
            ("Current", "\(s?.currentStreak ?? 0) days"),
            ("Longest", "\(s?.longestStreak ?? 0) days"),
            ("Daily Waves", "\(s?.dailyWavesCompleted ?? 0)"),
            ("Sandbox Plays", "\(s?.sandboxPlays ?? 0)"),
        ])
    }

    private var worldStats: some View {
        statsCard(title: "Worlds", rows: [
            ("Ripples", "\(s?.ripplesCompleted ?? 0) levels"),
            ("Echoes", "\(s?.echoesCompleted ?? 0) levels"),
            ("Resonance", "\(s?.resonanceCompleted ?? 0) levels"),
            ("Harmonics", "\(s?.harmonicsCompleted ?? 0) levels"),
            ("Chaos", "\(s?.chaosCompleted ?? 0) levels"),
        ])
    }

    private func statsCard(title: String, rows: [(String, String)]) -> some View {
        VStack(spacing: 0) {
            HStack { Text(title).font(.system(size: 15, weight: .bold, design: .rounded)).primaryText(); Spacer() }.padding(.bottom, 10)
            ForEach(Array(rows.enumerated()), id: \.offset) { _, row in
                HStack {
                    Text(row.0).font(.system(size: 14)).secondaryText()
                    Spacer()
                    Text(row.1).font(.system(size: 14, weight: .semibold, design: .rounded)).primaryText()
                }
                .padding(.vertical, 6)
            }
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 16).fill(theme.colors.surface.opacity(0.4))
                .overlay { RoundedRectangle(cornerRadius: 16).strokeBorder(theme.colors.cardBorder.opacity(0.12), lineWidth: 1) }
        }
    }

    private func formatTime(_ seconds: Int) -> String {
        let h = seconds / 3600
        let m = (seconds % 3600) / 60
        if h > 0 { return "\(h)h \(m)m" }
        return "\(m)m"
    }
}
