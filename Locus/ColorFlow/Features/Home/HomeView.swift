import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.theme) private var theme
    @Query private var stats: [StatsRecord]
    @Query private var settings: [SettingsRecord]
    @Query private var achievements: [AchievementRecord]
    private var st: StatsRecord? { stats.first }

    var body: some View {
        ZStack {
            FloatingOrbsView().ignoresSafeArea()
            ScrollView {
                VStack(spacing: 16) { topBar; levelCard; playCard; streakCard; modesRow; navRow; miniStats }.padding(16).padding(.bottom, 32)
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity).themedBackground()
    }

    private var topBar: some View {
        HStack {
            Text("Locus").font(.system(size: 28, weight: .black, design: .rounded)).primaryText()
            Spacer()
            NavigationLink(value: Route.settings) {
                Image(systemName: "gearshape.fill").font(.system(size: 18)).secondaryText()
                    .frame(width: 40, height: 40).background { Circle().fill(theme.colors.surface.opacity(0.4)) }
            }
        }
    }

    private var levelCard: some View {
        let xp = st?.totalXP ?? 0; let lvl = LocusConfig.levelForXP(xp); let prog = LocusConfig.xpProgressInLevel(xp); let title = LocusConfig.xpLevelTitle(lvl)
        return HStack(spacing: 12) {
            ZStack { Circle().fill(theme.colors.accent.opacity(0.15)).frame(width: 48, height: 48)
                Text("\(lvl)").font(.system(size: 20, weight: .black, design: .rounded)).foregroundStyle(theme.colors.accent) }
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.system(size: 17, weight: .bold, design: .rounded)).primaryText()
                GeometryReader { geo in ZStack(alignment: .leading) { Capsule().fill(theme.colors.cellBackground).frame(height: 6)
                    Capsule().fill(theme.colors.accent).frame(width: max(6, geo.size.width * prog), height: 6) } }.frame(height: 6)
            }
            Text("\(xp) XP").font(.system(size: 14, weight: .bold, design: .monospaced)).secondaryText()
        }.padding(16).background { RoundedRectangle(cornerRadius: 18).fill(theme.colors.surface.opacity(0.4)).overlay { RoundedRectangle(cornerRadius: 18).strokeBorder(theme.colors.boardBorder.opacity(0.1), lineWidth: 1) } }
    }

    private var playCard: some View {
        let next = nextPuzzle
        return NavigationLink(value: Route.locus(mode: .room(index: next))) {
            VStack(spacing: 12) {
                ZStack { Circle().fill(theme.colors.accent.opacity(0.15)).frame(width: 72, height: 72)
                    Image(systemName: "building.columns.fill").font(.system(size: 32, weight: .bold)).foregroundStyle(theme.colors.accent) }
                Text("Enter Palace").font(.system(size: 20, weight: .black, design: .rounded)).primaryText()
                Text("Room \(next + 1) of \(LocusConfig.totalPuzzles)").font(.system(size: 14, weight: .medium)).secondaryText()
            }.frame(maxWidth: .infinity).padding(.vertical, 28)
            .background { RoundedRectangle(cornerRadius: 22).fill(theme.colors.surface.opacity(0.4)).overlay { RoundedRectangle(cornerRadius: 22).strokeBorder(theme.colors.accent.opacity(0.15), lineWidth: 1) } }
        }.buttonStyle(BounceButtonStyle())
    }

    private var nextPuzzle: Int {
        let best = st?.bestMoves ?? [:]
        for i in 0..<LocusConfig.totalPuzzles { if best[i] == nil { return i } }
        return 0
    }

    private var streakCard: some View {
        let streak = st?.currentStreak ?? 0
        return HStack(spacing: 10) {
            Image(systemName: streak > 0 ? "flame.fill" : "flame").font(.system(size: 20)).foregroundStyle(streak > 0 ? .orange : theme.colors.textSecondary)
            VStack(alignment: .leading, spacing: 2) {
                Text(streak > 0 ? "\(streak)-day streak!" : "Start your streak!").font(.system(size: 15, weight: .bold, design: .rounded)).primaryText()
                Text("Visit your palace daily").font(.system(size: 12, weight: .medium)).secondaryText()
            }; Spacer()
        }.padding(14).background { RoundedRectangle(cornerRadius: 16).fill(theme.colors.surface.opacity(0.3)).overlay { RoundedRectangle(cornerRadius: 16).strokeBorder(theme.colors.boardBorder.opacity(0.08), lineWidth: 1) } }
    }

    private var modesRow: some View {
        HStack(spacing: 12) {
            modeBtn("Daily", "calendar", Route.locus(mode: .daily))
            modeBtn("Quick Place", "shuffle", Route.locus(mode: .quickPlace))
        }
    }

    private func modeBtn(_ label: String, _ icon: String, _ route: Route) -> some View {
        NavigationLink(value: route) {
            VStack(spacing: 8) { Image(systemName: icon).font(.system(size: 22)).foregroundStyle(theme.colors.accent)
                Text(label).font(.system(size: 13, weight: .bold, design: .rounded)).primaryText()
            }.frame(maxWidth: .infinity).padding(.vertical, 18)
            .background { RoundedRectangle(cornerRadius: 16).fill(theme.colors.surface.opacity(0.3)).overlay { RoundedRectangle(cornerRadius: 16).strokeBorder(theme.colors.boardBorder.opacity(0.08), lineWidth: 1) } }
        }.buttonStyle(BounceButtonStyle())
    }

    private var navRow: some View {
        HStack(spacing: 10) {
            navBtn("Palaces", "map.fill", .palaceMap)
            navBtn("\(achievements.count) Badges", "trophy.fill", .achievements)
            navBtn("Stats", "chart.bar.fill", .stats)
        }
    }

    private func navBtn(_ label: String, _ icon: String, _ route: Route) -> some View {
        NavigationLink(value: route) {
            VStack(spacing: 6) { Image(systemName: icon).font(.system(size: 18)).foregroundStyle(theme.colors.accent)
                Text(label).font(.system(size: 11, weight: .bold, design: .rounded)).primaryText() }
            .frame(maxWidth: .infinity).padding(.vertical, 14)
            .background { RoundedRectangle(cornerRadius: 14).fill(theme.colors.surface.opacity(0.3)).overlay { RoundedRectangle(cornerRadius: 14).strokeBorder(theme.colors.boardBorder.opacity(0.08), lineWidth: 1) } }
        }.buttonStyle(BounceButtonStyle())
    }

    private var miniStats: some View {
        HStack(spacing: 0) {
            miniStat("building.columns.fill", "\(st?.puzzlesCompleted ?? 0)", "Rooms")
            miniStat("star.fill", "\(st?.threeStarCount ?? 0)", "Perfect")
            miniStat("flame.fill", "\(st?.currentStreak ?? 0)", "Streak")
        }.padding(12).background { RoundedRectangle(cornerRadius: 16).fill(theme.colors.surface.opacity(0.3)).overlay { RoundedRectangle(cornerRadius: 16).strokeBorder(theme.colors.boardBorder.opacity(0.08), lineWidth: 1) } }
    }

    private func miniStat(_ icon: String, _ value: String, _ label: String) -> some View {
        VStack(spacing: 4) { Image(systemName: icon).font(.system(size: 14)).foregroundStyle(theme.colors.accent)
            Text(value).font(.system(size: 18, weight: .black, design: .rounded)).primaryText()
            Text(label).font(.system(size: 10, weight: .medium)).secondaryText() }.frame(maxWidth: .infinity)
    }
}

struct BounceButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

struct FloatingOrbsView: View {
    @Environment(\.theme) private var theme
    @State private var animate = false
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(0..<6, id: \.self) { i in
                    Circle().fill(orbColor(i).opacity(0.06)).frame(width: orbSize(i), height: orbSize(i))
                        .blur(radius: orbSize(i) * 0.3)
                        .offset(x: animate ? orbEndX(i, in: geo.size) : orbStartX(i, in: geo.size),
                                y: animate ? orbEndY(i, in: geo.size) : orbStartY(i, in: geo.size))
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear { withAnimation(.easeInOut(duration: 8).repeatForever(autoreverses: true)) { animate = true } }
        .allowsHitTesting(false)
    }
    private func orbColor(_ i: Int) -> Color { [theme.colors.accent, theme.colors.secondary, theme.colors.primary, .orange, .purple, theme.colors.accent][i % 6] }
    private func orbSize(_ i: Int) -> CGFloat { [80, 120, 60, 100, 70, 90][i % 6] }
    private func orbStartX(_ i: Int, in s: CGSize) -> CGFloat { [-0.3, 0.35, -0.2, 0.4, -0.4, 0.25][i % 6] * s.width * 0.8 }
    private func orbEndX(_ i: Int, in s: CGSize) -> CGFloat { [-0.3, 0.35, -0.2, 0.4, -0.4, 0.25][i % 6] * s.width }
    private func orbStartY(_ i: Int, in s: CGSize) -> CGFloat { [-0.3, 0.15, 0.35, -0.2, 0.0, -0.35][i % 6] * s.height * 0.7 }
    private func orbEndY(_ i: Int, in s: CGSize) -> CGFloat { [-0.3, 0.15, 0.35, -0.2, 0.0, -0.35][i % 6] * s.height }
}
