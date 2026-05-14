import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.theme) private var theme
    @Environment(\.modelContext) private var modelContext
    @Query private var settings: [SettingsRecord]
    @Query private var stats: [StatsRecord]
    @Query private var achievements: [AchievementRecord]
    private var cs: SettingsRecord? { settings.first }
    private var st: StatsRecord? { stats.first }
    private var nextLevel: Int { cs?.currentLevelIndex ?? 0 }
    private var currentPhase: RitualPhase { RitualPhase.phaseForRitual(nextLevel) }
    @State private var pulse = false

    var body: some View {
        ZStack {
            FloatingOrbsView().ignoresSafeArea()
            ScrollView {
                VStack(spacing: 20) { xpBadge.padding(.top, 8); playHero; streakBanner; modeButtons; quickNav; statsSection }
                .padding(.horizontal, 16).padding(.bottom, 32)
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity).themedBackground().navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .principal) { Text("Ritual").font(.system(size: 28, weight: .black, design: .rounded)).primaryText() }
            ToolbarItem(placement: .topBarTrailing) { NavigationLink(value: Route.settings) { Image(systemName: "gearshape.fill").font(.system(size: 18)).foregroundStyle(theme.colors.textSecondary).frame(width: 36, height: 36) } }
        }
        .onAppear { withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) { pulse = true } }
    }

    private var xpBadge: some View {
        let xp = st?.totalXP ?? 0; let level = RitualConfig.levelForXP(xp); let progress = RitualConfig.xpProgressInLevel(xp); let title = RitualConfig.xpLevelTitle(level)
        return HStack(spacing: 14) {
            ZStack { Circle().fill(RadialGradient(colors: [theme.colors.accent, theme.colors.accent.opacity(0.3)], center: .center, startRadius: 0, endRadius: 28)).frame(width: 56, height: 56).shadow(color: theme.colors.accent.opacity(0.4), radius: 8)
                Text("\(level)").font(.system(size: 24, weight: .black, design: .rounded)).foregroundStyle(.white) }
            VStack(alignment: .leading, spacing: 4) {
                HStack { Text(title).font(.system(size: 17, weight: .bold, design: .rounded)).primaryText(); Spacer(); Text("\(xp) XP").font(.system(size: 13, weight: .bold, design: .monospaced)).foregroundStyle(theme.colors.accent) }
                GeometryReader { geo in ZStack(alignment: .leading) { Capsule().fill(theme.colors.cellBackground).frame(height: 10)
                    Capsule().fill(LinearGradient(colors: [theme.colors.accent, theme.colors.accent.opacity(0.7)], startPoint: .leading, endPoint: .trailing)).frame(width: max(10, geo.size.width * progress), height: 10) } }.frame(height: 10)
            }
        }.padding(16).background { RoundedRectangle(cornerRadius: 18).fill(theme.colors.surface.opacity(0.5)).overlay { RoundedRectangle(cornerRadius: 18).strokeBorder(theme.colors.accent.opacity(0.2), lineWidth: 1) } }
    }

    private var playHero: some View {
        NavigationLink(value: Route.ritual(mode: .ritual(index: nextLevel))) {
            VStack(spacing: 14) {
                ZStack { Circle().fill(theme.colors.accent.opacity(0.15)).frame(width: 100, height: 100).scaleEffect(pulse ? 1.15 : 1.0).blur(radius: 8)
                    Circle().fill(RadialGradient(colors: [theme.colors.accent, theme.colors.accent.opacity(0.85)], center: .center, startRadius: 0, endRadius: 38)).frame(width: 76, height: 76).shadow(color: theme.colors.accent.opacity(0.5), radius: 12, y: 4)
                        .overlay { Image(systemName: "leaf.fill").font(.system(size: 32, weight: .bold)).foregroundStyle(.white) } }
                VStack(spacing: 4) {
                    if nextLevel > 0 { Text("\(currentPhase.name) — Ritual \(RitualPhase.localIndex(forRitual: nextLevel) + 1)").font(.system(size: 16, weight: .bold, design: .rounded)).primaryText() }
                    else { Text("Begin Ritual").font(.system(size: 16, weight: .bold, design: .rounded)).primaryText() }
                    Text("Ritual \(nextLevel + 1) of \(RitualConfig.totalRituals)").font(.system(size: 12, weight: .medium)).secondaryText()
                }
            }.frame(maxWidth: .infinity).padding(.vertical, 24).background { RoundedRectangle(cornerRadius: 22).fill(LinearGradient(colors: [theme.colors.accent.opacity(0.08), theme.colors.accent.opacity(0.02)], startPoint: .top, endPoint: .bottom)).overlay { RoundedRectangle(cornerRadius: 22).strokeBorder(theme.colors.accent.opacity(0.15), lineWidth: 1) } }
        }.buttonStyle(BounceButtonStyle())
    }

    private var streakBanner: some View {
        let streak = st?.currentStreak ?? 0
        return HStack(spacing: 10) {
            ZStack { if streak > 0 { Circle().fill(Color.orange.opacity(0.15)).frame(width: 42, height: 42) }
                Image(systemName: streak > 0 ? "flame.fill" : "flame").font(.system(size: 22)).foregroundStyle(streak > 0 ? .orange : theme.colors.textMuted) }
            VStack(alignment: .leading, spacing: 2) {
                Text(streak > 0 ? "\(streak)-day streak!" : "Start your streak!").font(.system(size: 15, weight: .bold, design: .rounded)).primaryText()
                Text(streak > 0 ? "Practice today to keep going" : "Practice daily to build a streak").font(.system(size: 12)).secondaryText()
            }; Spacer()
            if streak >= 7 { Image(systemName: "shield.checkered").font(.system(size: 18)).foregroundStyle(.orange) }
        }.padding(14).background { RoundedRectangle(cornerRadius: 16).fill(streak > 0 ? Color.orange.opacity(0.06) : theme.colors.surface.opacity(0.3)).overlay { RoundedRectangle(cornerRadius: 16).strokeBorder(streak > 0 ? Color.orange.opacity(0.2) : theme.colors.boardBorder.opacity(0.08), lineWidth: 1) } }
    }

    private var modeButtons: some View {
        HStack(spacing: 12) {
            NavigationLink(value: Route.ritual(mode: .daily)) { modeCard(icon: "calendar", title: "Daily", color: .orange) }.buttonStyle(BounceButtonStyle())
            NavigationLink(value: Route.ritual(mode: .quickRitual)) { modeCard(icon: "shuffle", title: "Quick Ritual", color: theme.colors.secondary) }.buttonStyle(BounceButtonStyle())
        }
    }

    private func modeCard(icon: String, title: String, color: Color) -> some View {
        VStack(spacing: 8) { ZStack { Circle().fill(color.opacity(0.12)).frame(width: 44, height: 44); Image(systemName: icon).font(.system(size: 20, weight: .semibold)).foregroundStyle(color) }
            Text(title).font(.system(size: 13, weight: .bold, design: .rounded)).primaryText()
        }.frame(maxWidth: .infinity).padding(.vertical, 16).background { RoundedRectangle(cornerRadius: 18).fill(theme.colors.surface.opacity(0.5)).overlay { RoundedRectangle(cornerRadius: 18).strokeBorder(theme.colors.boardBorder.opacity(0.12), lineWidth: 1) } }
    }

    private var quickNav: some View {
        HStack(spacing: 10) {
            NavigationLink(value: Route.phaseMap) { navBtn(icon: "leaf.fill", label: "Phases", color: Color(hex: "FFD93D")) }.buttonStyle(BounceButtonStyle())
            NavigationLink(value: Route.achievements) { navBtn(icon: "trophy.fill", label: "\(achievements.count) Badges", color: Color(hex: "FFD166")) }.buttonStyle(BounceButtonStyle())
            NavigationLink(value: Route.stats) { navBtn(icon: "chart.bar.fill", label: "Stats", color: Color(hex: "2EC4B6")) }.buttonStyle(BounceButtonStyle())
        }
    }

    private func navBtn(icon: String, label: String, color: Color) -> some View {
        VStack(spacing: 6) { ZStack { Circle().fill(color.opacity(0.12)).frame(width: 40, height: 40); Image(systemName: icon).font(.system(size: 17)).foregroundStyle(color) }
            Text(label).font(.system(size: 10, weight: .bold, design: .rounded)).secondaryText().lineLimit(1)
        }.frame(maxWidth: .infinity).padding(.vertical, 12).background { RoundedRectangle(cornerRadius: 16).fill(theme.colors.surface.opacity(0.35)).overlay { RoundedRectangle(cornerRadius: 16).strokeBorder(theme.colors.boardBorder.opacity(0.08), lineWidth: 1) } }
    }

    private var statsSection: some View {
        HStack(spacing: 0) { gameStat("\(st?.puzzlesCompleted ?? 0)", "Rituals", "leaf.fill", theme.colors.accent); sd; gameStat("\(st?.threeStarCount ?? 0)", "Perfect", "star.fill", .yellow); sd; gameStat("\(st?.currentStreak ?? 0)", "Streak", "flame.fill", .orange) }
        .padding(.vertical, 14).background { RoundedRectangle(cornerRadius: 18).fill(theme.colors.surface.opacity(0.35)).overlay { RoundedRectangle(cornerRadius: 18).strokeBorder(theme.colors.boardBorder.opacity(0.08), lineWidth: 1) } }
    }

    private var sd: some View { Rectangle().fill(theme.colors.boardBorder.opacity(0.1)).frame(width: 1, height: 36) }

    private func gameStat(_ v: String, _ l: String, _ i: String, _ c: Color) -> some View {
        VStack(spacing: 4) { Image(systemName: i).font(.system(size: 12)).foregroundStyle(c); Text(v).font(.system(size: 22, weight: .black, design: .rounded)).primaryText(); Text(l).font(.system(size: 10, weight: .medium)).secondaryText() }.frame(maxWidth: .infinity)
    }
}

struct BounceButtonStyle: ButtonStyle { func makeBody(configuration: Configuration) -> some View { configuration.label.scaleEffect(configuration.isPressed ? 0.95 : 1.0).animation(.spring(response: 0.25, dampingFraction: 0.6), value: configuration.isPressed) } }

struct FloatingOrbsView: View {
    @Environment(\.theme) private var theme; @State private var animate = false
    var body: some View {
        GeometryReader { geo in ZStack { ForEach(0..<6, id: \.self) { i in Circle().fill(oc(i).opacity(0.06)).frame(width: os(i), height: os(i)).blur(radius: os(i) * 0.3)
            .offset(x: animate ? ex(i, geo.size) : sx(i, geo.size), y: animate ? ey(i, geo.size) : sy(i, geo.size)) } }.frame(maxWidth: .infinity, maxHeight: .infinity) }
        .onAppear { withAnimation(.easeInOut(duration: 8).repeatForever(autoreverses: true)) { animate = true } }.allowsHitTesting(false)
    }
    private func oc(_ i: Int) -> Color { [theme.colors.accent, theme.colors.secondary, theme.colors.primary, .orange, .purple, theme.colors.accent][i % 6] }
    private func os(_ i: Int) -> CGFloat { [80, 120, 60, 100, 70, 90][i % 6] }
    private func sx(_ i: Int, _ s: CGSize) -> CGFloat { [-0.3, 0.35, -0.2, 0.4, -0.4, 0.25][i % 6] * s.width * 0.8 }
    private func ex(_ i: Int, _ s: CGSize) -> CGFloat { [-0.3, 0.35, -0.2, 0.4, -0.4, 0.25][i % 6] * s.width }
    private func sy(_ i: Int, _ s: CGSize) -> CGFloat { [-0.3, 0.15, 0.35, -0.2, 0.0, -0.35][i % 6] * s.height * 0.7 }
    private func ey(_ i: Int, _ s: CGSize) -> CGFloat { [-0.3, 0.15, 0.35, -0.2, 0.0, -0.35][i % 6] * s.height }
}
