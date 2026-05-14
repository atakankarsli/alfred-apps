import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.theme) private var theme; @Environment(\.modelContext) private var modelContext; @Query private var settings: [SettingsRecord]
    @State private var currentPage = 0; @State private var iconPulse = false

    var body: some View {
        ZStack { FloatingOrbsView().ignoresSafeArea()
            VStack { TabView(selection: $currentPage) { welcomePage.tag(0); howPage.tag(1); readyPage.tag(2) }.tabViewStyle(.page(indexDisplayMode: .always)) }
        }.frame(maxWidth: .infinity, maxHeight: .infinity).themedBackground()
        .onAppear { withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) { iconPulse = true } }
    }

    private var welcomePage: some View {
        VStack(spacing: 28) { Spacer()
            ZStack { Circle().fill(theme.colors.accent.opacity(0.1)).frame(width: 140, height: 140).scaleEffect(iconPulse ? 1.1 : 1.0).blur(radius: 10)
                Circle().fill(RadialGradient(colors: [theme.colors.accent.opacity(0.2), theme.colors.accent.opacity(0.05)], center: .center, startRadius: 0, endRadius: 60)).frame(width: 120, height: 120)
                Image(systemName: "leaf.fill").font(.system(size: 64)).foregroundStyle(theme.colors.accent).shadow(color: theme.colors.accent.opacity(0.4), radius: 10) }
            Text("Welcome to Ritual").font(.system(size: 30, weight: .black, design: .rounded)).primaryText().multilineTextAlignment(.center)
            Text("Build daily habits.\nMorning. Wellness. Focus. Evening.").font(.system(size: 18, weight: .medium)).secondaryText().multilineTextAlignment(.center)
            Spacer(); nextButton
        }.padding(32)
    }

    private var howPage: some View {
        VStack(spacing: 28) { Spacer()
            ZStack { Circle().fill(theme.colors.accent.opacity(0.08)).frame(width: 100, height: 100)
                Image(systemName: "checklist").font(.system(size: 52)).foregroundStyle(theme.colors.accent) }
            Text("How It Works").font(.system(size: 26, weight: .black, design: .rounded)).primaryText()
            VStack(alignment: .leading, spacing: 18) {
                inst("1.circle.fill", "Get a grid of micro habits")
                inst("2.circle.fill", "Complete each habit and tap to check off")
                inst("3.circle.fill", "Build streaks and earn stars")
            }.padding(.horizontal, 8)
            HStack(spacing: 16) { demo("sunrise.fill", Color(hex: "FFD93D")); demo("heart.fill", Color(hex: "FF6B6B")); demo("brain.head.profile", Color(hex: "5BC0EB")); demo("moon.stars.fill", Color(hex: "9B5DE5")) }.padding(.top, 4)
            Spacer(); nextButton
        }.padding(32)
    }

    private var readyPage: some View {
        VStack(spacing: 28) { Spacer()
            ZStack { Circle().fill(theme.colors.secondary.opacity(0.08)).frame(width: 100, height: 100)
                Image(systemName: "sparkles").font(.system(size: 52)).foregroundStyle(theme.colors.secondary) }
            Text("Ready?").font(.system(size: 26, weight: .black, design: .rounded)).primaryText()
            Text("80 rituals across 4 phases.\nDawn. Vitality. Flow. Dusk.").font(.system(size: 16, weight: .medium)).secondaryText().multilineTextAlignment(.center)
            HStack(spacing: 16) { pill("leaf.fill", "4 Phases"); pill("star.fill", "Stars"); pill("trophy.fill", "Badges") }
            Spacer()
            GlassButton("Begin Practice", icon: "play.fill") { HapticsService.medium(); settings.first?.hasSeenOnboarding = true }
        }.padding(32)
    }

    private var nextButton: some View { GlassButton("Next", icon: "arrow.right") { withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) { currentPage += 1 } } }
    private func inst(_ i: String, _ t: String) -> some View { HStack(spacing: 12) { Image(systemName: i).foregroundStyle(theme.colors.accent).font(.system(size: 22, weight: .bold)); Text(t).font(.system(size: 16, weight: .medium)).primaryText() } }
    private func demo(_ i: String, _ c: Color) -> some View { ZStack { RoundedRectangle(cornerRadius: 12).fill(c.opacity(0.15)).frame(width: 52, height: 52).overlay { RoundedRectangle(cornerRadius: 12).strokeBorder(c.opacity(0.3), lineWidth: 1) }; Image(systemName: i).font(.system(size: 22, weight: .bold)).foregroundStyle(c) } }
    private func pill(_ i: String, _ t: String) -> some View { HStack(spacing: 4) { Image(systemName: i).font(.system(size: 12, weight: .bold)); Text(t).font(.system(size: 12, weight: .bold, design: .rounded)) }.foregroundStyle(theme.colors.accent).padding(.horizontal, 12).padding(.vertical, 6).background { Capsule().fill(theme.colors.accent.opacity(0.1)) } }
}
