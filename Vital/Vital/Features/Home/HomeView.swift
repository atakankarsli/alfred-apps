import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.theme) private var theme
    @Environment(AppState.self) private var appState
    @Query private var settings: [SettingsRecord]
    @Query private var stats: [StatsRecord]

    private var s: StatsRecord? { stats.first }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                heroSection
                dailyPlanCard
                gamesGrid
                progressSection
                navigationCards
            }
            .padding(16)
        }
        .themedBackground()
        .overlay { FloatingOrbsView() }
    }

    private var heroSection: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle().fill(theme.colors.accent.opacity(0.1)).frame(width: 90, height: 90)
                Image(systemName: "heart.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(theme.colors.accent)
                    .symbolEffect(.pulse)
            }
            Text("VITAL")
                .font(.system(size: 32, weight: .black, design: .rounded))
                .foregroundStyle(theme.colors.accent)
            Text("2-Minute Health Games")
                .font(.system(size: 14, weight: .medium))
                .secondaryText()
        }
        .padding(.vertical, 8)
    }

    private var dailyPlanCard: some View {
        Button { appState.navigate(to: .dailyPlan) } label: {
            HStack(spacing: 12) {
                Image(systemName: "calendar.badge.clock")
                    .font(.title2)
                    .foregroundStyle(theme.colors.accent)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Today's Plan")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .primaryText()
                    Text("4 games · ~8 minutes")
                        .font(.system(size: 13))
                        .secondaryText()
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(theme.colors.accent)
            }
            .padding(14)
            .background {
                RoundedRectangle(cornerRadius: 14)
                    .fill(theme.colors.accent.opacity(0.08))
                    .overlay {
                        RoundedRectangle(cornerRadius: 14)
                            .strokeBorder(theme.colors.accent.opacity(0.2), lineWidth: 1)
                    }
            }
        }
        .buttonStyle(.plain)
    }

    private var gamesGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            ForEach(GameType.allCases) { type in
                gameCard(type)
            }
        }
    }

    private func gameCard(_ type: GameType) -> some View {
        Button { appState.navigate(to: .game(type: type)) } label: {
            VStack(spacing: 8) {
                Image(systemName: type.icon)
                    .font(.system(size: 28))
                    .foregroundStyle(type.color)
                Text(type.displayName)
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .primaryText()
                Text(type.subtitle)
                    .font(.system(size: 11))
                    .mutedText()
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .padding(.horizontal, 8)
            .background {
                RoundedRectangle(cornerRadius: 14)
                    .fill(type.color.opacity(0.06))
                    .overlay {
                        RoundedRectangle(cornerRadius: 14)
                            .strokeBorder(type.color.opacity(0.15), lineWidth: 1)
                    }
            }
        }
        .buttonStyle(ScaleButtonStyle())
    }

    private var progressSection: some View {
        let xp = s?.totalXP ?? 0
        let level = VitalConfig.levelForXP(xp)
        let progress = VitalConfig.xpProgressInLevel(xp)

        return HStack(spacing: 14) {
            ZStack {
                Circle().stroke(theme.colors.cardBorder.opacity(0.15), lineWidth: 4).frame(width: 50, height: 50)
                Circle().trim(from: 0, to: progress).stroke(theme.colors.accent, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .frame(width: 50, height: 50).rotationEffect(.degrees(-90))
                Text("\(level)").font(.system(size: 16, weight: .black, design: .rounded)).primaryText()
            }
            VStack(alignment: .leading, spacing: 3) {
                Text(VitalConfig.xpLevelTitle(level)).font(.system(size: 15, weight: .bold, design: .rounded)).primaryText()
                Text("\(xp) XP").font(.system(size: 13, weight: .medium, design: .monospaced)).secondaryText()
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 3) {
                HStack(spacing: 3) {
                    Image(systemName: "flame.fill").font(.system(size: 12)).foregroundStyle(.orange)
                    Text("\(s?.currentStreak ?? 0)").font(.system(size: 14, weight: .bold, design: .rounded)).primaryText()
                }
                Text("streak").font(.system(size: 11)).mutedText()
            }
        }
        .padding(14)
        .background {
            RoundedRectangle(cornerRadius: 14)
                .fill(theme.colors.surface.opacity(0.4))
                .overlay { RoundedRectangle(cornerRadius: 14).strokeBorder(theme.colors.cardBorder.opacity(0.12), lineWidth: 1) }
        }
    }

    private var navigationCards: some View {
        HStack(spacing: 10) {
            navButton("Stats", icon: "chart.bar.fill") { appState.navigate(to: .stats) }
            navButton("Achievements", icon: "trophy.fill") { appState.navigate(to: .achievements) }
            navButton("Settings", icon: "gearshape.fill") { appState.navigate(to: .settings) }
        }
    }

    private func navButton(_ title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon).font(.system(size: 20)).foregroundStyle(theme.colors.accent)
                Text(title).font(.system(size: 11, weight: .semibold)).primaryText()
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(theme.colors.surface.opacity(0.35))
                    .overlay { RoundedRectangle(cornerRadius: 12).strokeBorder(theme.colors.cardBorder.opacity(0.1), lineWidth: 1) }
            }
        }
        .buttonStyle(ScaleButtonStyle())
    }
}
