import SwiftUI
import SwiftData

struct StatsDetailView: View {
    @Environment(\.theme) private var theme
    @Query private var stats: [StatsRecord]
    @Query private var achievements: [AchievementRecord]
    private var st: StatsRecord? { stats.first }

    var body: some View {
        ZStack {
            FloatingOrbsView().ignoresSafeArea()
            ScrollView {
                VStack(spacing: 16) {
                    levelCard; overviewCard; streakCard; phaseProgress
                }.padding(16).padding(.bottom, 32)
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity).themedBackground()
        .navigationTitle("Stats")
    }

    private var levelCard: some View {
        let xp = st?.totalXP ?? 0; let level = RitualConfig.levelForXP(xp); let progress = RitualConfig.xpProgressInLevel(xp); let title = RitualConfig.xpLevelTitle(level)
        return VStack(spacing: 12) {
            HStack {
                ZStack { Circle().fill(RadialGradient(colors: [theme.colors.accent, theme.colors.accent.opacity(0.3)], center: .center, startRadius: 0, endRadius: 24)).frame(width: 48, height: 48)
                    Text("\(level)").font(.system(size: 20, weight: .black, design: .rounded)).foregroundStyle(.white) }
                VStack(alignment: .leading, spacing: 2) { Text(title).font(.system(size: 17, weight: .bold, design: .rounded)).primaryText()
                    Text("\(xp) XP total").font(.system(size: 13, weight: .medium)).secondaryText() }; Spacer()
            }
            GeometryReader { geo in ZStack(alignment: .leading) { Capsule().fill(theme.colors.cellBackground).frame(height: 10)
                Capsule().fill(LinearGradient(colors: [theme.colors.accent, theme.colors.accent.opacity(0.7)], startPoint: .leading, endPoint: .trailing)).frame(width: max(10, geo.size.width * progress), height: 10) } }.frame(height: 10)
        }.padding(16).background { RoundedRectangle(cornerRadius: 18).fill(theme.colors.surface.opacity(0.5)).overlay { RoundedRectangle(cornerRadius: 18).strokeBorder(theme.colors.accent.opacity(0.2), lineWidth: 1) } }
    }

    private var overviewCard: some View {
        let cols = [GridItem(.flexible()), GridItem(.flexible())]
        return LazyVGrid(columns: cols, spacing: 12) {
            statBox("Rituals Done", "\(st?.puzzlesCompleted ?? 0)", "leaf.fill", theme.colors.accent)
            statBox("Perfect", "\(st?.threeStarCount ?? 0)", "star.fill", .yellow)
            statBox("Habits Done", "\(st?.totalMoves ?? 0)", "checkmark.circle.fill", .green)
            statBox("Badges", "\(achievements.count)", "trophy.fill", .orange)
        }
    }

    private func statBox(_ label: String, _ value: String, _ icon: String, _ color: Color) -> some View {
        VStack(spacing: 8) { ZStack { Circle().fill(color.opacity(0.12)).frame(width: 36, height: 36); Image(systemName: icon).font(.system(size: 16)).foregroundStyle(color) }
            Text(value).font(.system(size: 24, weight: .black, design: .rounded)).primaryText()
            Text(label).font(.system(size: 11, weight: .medium)).secondaryText()
        }.frame(maxWidth: .infinity).padding(.vertical, 14).background { RoundedRectangle(cornerRadius: 16).fill(theme.colors.surface.opacity(0.4)).overlay { RoundedRectangle(cornerRadius: 16).strokeBorder(theme.colors.boardBorder.opacity(0.1), lineWidth: 1) } }
    }

    private var streakCard: some View {
        let streak = st?.currentStreak ?? 0; let best = st?.longestStreak ?? 0
        return HStack(spacing: 16) {
            VStack(spacing: 4) { Image(systemName: "flame.fill").font(.system(size: 22)).foregroundStyle(.orange); Text("\(streak)").font(.system(size: 28, weight: .black, design: .rounded)).primaryText(); Text("Current").font(.system(size: 11, weight: .medium)).secondaryText() }.frame(maxWidth: .infinity)
            Rectangle().fill(theme.colors.boardBorder.opacity(0.1)).frame(width: 1, height: 50)
            VStack(spacing: 4) { Image(systemName: "trophy.fill").font(.system(size: 22)).foregroundStyle(.yellow); Text("\(best)").font(.system(size: 28, weight: .black, design: .rounded)).primaryText(); Text("Best").font(.system(size: 11, weight: .medium)).secondaryText() }.frame(maxWidth: .infinity)
        }.padding(16).background { RoundedRectangle(cornerRadius: 18).fill(theme.colors.surface.opacity(0.4)).overlay { RoundedRectangle(cornerRadius: 18).strokeBorder(theme.colors.boardBorder.opacity(0.1), lineWidth: 1) } }
    }

    private var phaseProgress: some View {
        VStack(spacing: 12) {
            Text("Phase Progress").font(.system(size: 17, weight: .bold, design: .rounded)).primaryText().frame(maxWidth: .infinity, alignment: .leading)
            ForEach(RitualPhase.all) { phase in phaseRow(phase) }
        }.padding(16).background { RoundedRectangle(cornerRadius: 18).fill(theme.colors.surface.opacity(0.4)).overlay { RoundedRectangle(cornerRadius: 18).strokeBorder(theme.colors.boardBorder.opacity(0.1), lineWidth: 1) } }
    }

    private func phaseRow(_ phase: RitualPhase) -> some View {
        let best = st?.bestMoves ?? [:]
        let done = phase.ritualRange.filter { best[$0] != nil }.count
        let total = phase.ritualRange.count
        let ratio = total > 0 ? Double(done) / Double(total) : 0
        let color = Color(hex: phase.accentHex)
        return HStack(spacing: 10) {
            Image(systemName: phase.icon).font(.system(size: 16)).foregroundStyle(color).frame(width: 24)
            Text(phase.name).font(.system(size: 14, weight: .bold, design: .rounded)).primaryText()
            GeometryReader { geo in ZStack(alignment: .leading) { Capsule().fill(theme.colors.cellBackground).frame(height: 6)
                Capsule().fill(color).frame(width: max(6, geo.size.width * ratio), height: 6) } }.frame(height: 6)
            Text("\(done)/\(total)").font(.system(size: 11, weight: .bold, design: .monospaced)).secondaryText()
        }
    }
}
