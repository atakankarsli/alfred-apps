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
                growButton
                familiesGrid
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
                Image(systemName: "diamond.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(theme.colors.accent)
                    .symbolEffect(.pulse)
            }
            Text("SHARD")
                .font(.system(size: 32, weight: .black, design: .rounded))
                .foregroundStyle(theme.colors.accent)
            Text("Crystal Growing Simulator")
                .font(.system(size: 14, weight: .medium))
                .secondaryText()
        }
        .padding(.vertical, 8)
    }

    private var growButton: some View {
        GlassButton("Grow a Crystal", icon: "sparkle") {
            appState.navigate(to: .growth(crystalIndex: (s?.crystalsGrown ?? 0)))
        }
        .padding(.horizontal, 16)
    }

    private var familiesGrid: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Mineral Families")
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .primaryText()

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(MineralFamily.all, id: \.id) { family in
                    familyCard(family)
                }
            }
        }
    }

    private func familyCard(_ family: MineralFamily) -> some View {
        let familyColor = Color(hex: family.accentHex)
        let grown = familyGrown(family)

        return VStack(spacing: 6) {
            Image(systemName: family.icon)
                .font(.system(size: 24))
                .foregroundStyle(familyColor)
            Text(family.name)
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .primaryText()
            Text("\(grown) grown")
                .font(.system(size: 11))
                .mutedText()
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background {
            RoundedRectangle(cornerRadius: 14)
                .fill(familyColor.opacity(0.06))
                .overlay {
                    RoundedRectangle(cornerRadius: 14)
                        .strokeBorder(familyColor.opacity(0.15), lineWidth: 1)
                }
        }
    }

    private func familyGrown(_ family: MineralFamily) -> Int {
        switch family.id {
        case 0: s?.quartzGrown ?? 0
        case 1: s?.berylGrown ?? 0
        case 2: s?.corundumGrown ?? 0
        case 3: s?.fluoriteGrown ?? 0
        case 4: s?.carbonGrown ?? 0
        default: 0
        }
    }

    private var progressSection: some View {
        let xp = s?.totalXP ?? 0
        let level = ShardConfig.levelForXP(xp)
        let progress = ShardConfig.xpProgressInLevel(xp)

        return HStack(spacing: 14) {
            ZStack {
                Circle().stroke(theme.colors.cardBorder.opacity(0.15), lineWidth: 4).frame(width: 50, height: 50)
                Circle().trim(from: 0, to: progress).stroke(theme.colors.accent, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                    .frame(width: 50, height: 50).rotationEffect(.degrees(-90))
                Text("\(level)").font(.system(size: 16, weight: .black, design: .rounded)).primaryText()
            }
            VStack(alignment: .leading, spacing: 3) {
                Text(ShardConfig.xpLevelTitle(level)).font(.system(size: 15, weight: .bold, design: .rounded)).primaryText()
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
                navButton("Collection", icon: "tray.full.fill") { appState.navigate(to: .collection) }
                navButton("Lab", icon: "flask.fill") { appState.navigate(to: .lab) }
            }
            HStack(spacing: 10) {
                navButton("Stats", icon: "chart.bar.fill") { appState.navigate(to: .stats) }
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
