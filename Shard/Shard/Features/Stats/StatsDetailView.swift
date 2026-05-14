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
                crystalStats
                familyStats
                performanceStats
            }
            .padding(16)
        }
        .themedBackground()
        .navigationTitle("Statistics")
    }

    private var xpSection: some View {
        let xp = s?.totalXP ?? 0
        let level = ShardConfig.levelForXP(xp)
        let progress = ShardConfig.xpProgressInLevel(xp)

        return VStack(spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Level \(level)").font(.system(size: 24, weight: .black, design: .rounded)).primaryText()
                    Text(ShardConfig.xpLevelTitle(level)).font(.system(size: 14, weight: .medium)).foregroundStyle(theme.colors.accent)
                }
                Spacer()
                Text("\(xp) XP").font(.system(size: 18, weight: .bold, design: .monospaced)).secondaryText()
            }
            ProgressView(value: progress).tint(theme.colors.accent)
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(theme.colors.accent.opacity(0.06))
                .overlay { RoundedRectangle(cornerRadius: 16).strokeBorder(theme.colors.accent.opacity(0.15), lineWidth: 1) }
        }
    }

    private var crystalStats: some View {
        statsCard(title: "Crystals", rows: [
            ("Crystals Grown", "\(s?.crystalsGrown ?? 0)"),
            ("3-Star Crystals", "\(s?.threeStarCount ?? 0)"),
            ("Best Quality", s?.bestQuality ?? 0 > 0 ? "\(Int((s?.bestQuality ?? 0) * 100))%" : "—"),
            ("Types Discovered", "\(s?.typesGrown.count ?? 0)/\(CrystalType.allCases.count)"),
        ])
    }

    private var familyStats: some View {
        statsCard(title: "Families", rows: [
            ("Quartz", "\(s?.quartzGrown ?? 0)"),
            ("Beryl", "\(s?.berylGrown ?? 0)"),
            ("Corundum", "\(s?.corundumGrown ?? 0)"),
            ("Fluorite", "\(s?.fluoriteGrown ?? 0)"),
            ("Carbon", "\(s?.carbonGrown ?? 0)"),
        ])
    }

    private var performanceStats: some View {
        statsCard(title: "Performance", rows: [
            ("Current Streak", "\(s?.currentStreak ?? 0) days"),
            ("Longest Streak", "\(s?.longestStreak ?? 0) days"),
            ("Families Explored", "\(s?.familiesPlayed.count ?? 0)/5"),
            ("Achievements", "\(achievements.count)/\(Achievement.all.count)"),
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
            RoundedRectangle(cornerRadius: 16)
                .fill(theme.colors.surface.opacity(0.4))
                .overlay { RoundedRectangle(cornerRadius: 16).strokeBorder(theme.colors.cardBorder.opacity(0.12), lineWidth: 1) }
        }
    }
}
