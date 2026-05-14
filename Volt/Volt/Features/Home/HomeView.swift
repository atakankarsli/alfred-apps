import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.theme) private var theme
    @Environment(AppState.self) private var appState
    @Query private var stats: [StatsRecord]

    private var s: StatsRecord? { stats.first }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                heroSection
                playButton
                seasonsGrid
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
                Image(systemName: "bolt.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(theme.colors.accent)
                    .symbolEffect(.pulse)
            }
            Text("VOLT")
                .font(.system(size: 32, weight: .black, design: .rounded))
                .foregroundStyle(theme.colors.accent)
            Text("Circuit Builder Puzzle")
                .font(.system(size: 14, weight: .medium))
                .secondaryText()
        }
        .padding(.vertical, 8)
    }

    private var playButton: some View {
        GlassButton("Solve Next Puzzle", icon: "bolt.fill") {
            let next = s?.puzzlesCompleted ?? 0
            appState.navigate(to: .puzzle(index: min(next, VoltConfig.totalPuzzles - 1)))
        }
        .padding(.horizontal, 16)
    }

    private var seasonsGrid: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Seasons")
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .primaryText()

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(Season.all) { season in
                    seasonCard(season)
                }
            }
        }
    }

    private func seasonCard(_ season: Season) -> some View {
        let completed = s?.puzzlesCompleted ?? 0
        let seasonColor = Color(hex: season.accentHex)
        let unlocked = completed >= season.puzzleRange.lowerBound
        let inSeason = min(completed, season.puzzleRange.upperBound) - season.puzzleRange.lowerBound
        let progress = max(0, inSeason)

        return Button {
            if unlocked {
                let next = max(season.puzzleRange.lowerBound, min(completed, season.puzzleRange.upperBound - 1))
                appState.navigate(to: .puzzle(index: next))
            }
        } label: {
            VStack(spacing: 6) {
                Image(systemName: season.icon)
                    .font(.system(size: 24))
                    .foregroundStyle(unlocked ? seasonColor : theme.colors.textMuted)
                Text(season.name)
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundStyle(unlocked ? theme.colors.text : theme.colors.textMuted)
                Text("\(max(0, progress))/\(season.puzzleCount)")
                    .font(.system(size: 11))
                    .foregroundStyle(unlocked ? theme.colors.textSecondary : theme.colors.textMuted)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background {
                RoundedRectangle(cornerRadius: 14)
                    .fill(seasonColor.opacity(unlocked ? 0.06 : 0.02))
                    .overlay {
                        RoundedRectangle(cornerRadius: 14)
                            .strokeBorder(seasonColor.opacity(unlocked ? 0.15 : 0.06), lineWidth: 1)
                    }
            }
        }
        .buttonStyle(ScaleButtonStyle())
        .opacity(unlocked ? 1 : 0.5)
    }

    private var progressSection: some View {
        let xp = s?.totalXP ?? 0
        let level = VoltConfig.levelForXP(xp)
        let progress = VoltConfig.xpProgressInLevel(xp)

        return HStack(spacing: 14) {
            ZStack {
                Circle().stroke(theme.colors.cardBorder.opacity(0.15), lineWidth: 4).frame(width: 50, height: 50)
                Circle().trim(from: 0, to: progress).stroke(theme.colors.accent, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .frame(width: 50, height: 50).rotationEffect(.degrees(-90))
                Text("\(level)").font(.system(size: 16, weight: .black, design: .rounded)).primaryText()
            }
            VStack(alignment: .leading, spacing: 3) {
                Text(VoltConfig.xpLevelTitle(level)).font(.system(size: 15, weight: .bold, design: .rounded)).primaryText()
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
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                navButton("Sandbox", icon: "hammer.fill") { appState.navigate(to: .sandbox) }
                navButton("Stats", icon: "chart.bar.fill") { appState.navigate(to: .stats) }
            }
            HStack(spacing: 10) {
                navButton("Achievements", icon: "trophy.fill") { appState.navigate(to: .achievements) }
                navButton("Settings", icon: "gearshape.fill") { appState.navigate(to: .settings) }
            }
        }
    }

    private func navButton(_ title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: icon).font(.system(size: 18)).foregroundStyle(theme.colors.accent)
                Text(title).font(.system(size: 10, weight: .semibold)).primaryText()
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
