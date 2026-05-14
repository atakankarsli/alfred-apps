import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.theme) private var theme
    @Environment(\.modelContext) private var modelContext
    @Query private var settings: [SettingsRecord]

    @State private var currentPage = 0
    @State private var iconPulse = false

    var body: some View {
        ZStack {
            FloatingOrbsView().ignoresSafeArea()

            VStack {
                TabView(selection: $currentPage) {
                    welcomePage.tag(0)
                    howItWorksPage.tag(1)
                    readyPage.tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .themedBackground()
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                iconPulse = true
            }
        }
    }

    private var welcomePage: some View {
        VStack(spacing: 28) {
            Spacer()
            ZStack {
                Circle()
                    .fill(theme.colors.accent.opacity(0.1))
                    .frame(width: 140, height: 140)
                    .scaleEffect(iconPulse ? 1.1 : 1.0)
                    .blur(radius: 10)
                Circle()
                    .fill(RadialGradient(colors: [theme.colors.accent.opacity(0.2), theme.colors.accent.opacity(0.05)], center: .center, startRadius: 0, endRadius: 60))
                    .frame(width: 120, height: 120)
                Image(systemName: "pencil.tip")
                    .font(.system(size: 64))
                    .foregroundStyle(theme.colors.accent)
                    .shadow(color: theme.colors.accent.opacity(0.4), radius: 10)
            }
            Text("Welcome to Glyph")
                .font(.system(size: 30, weight: .black, design: .rounded))
                .primaryText().multilineTextAlignment(.center)
            Text("Draw ancient symbols.\nMaster forgotten scripts.")
                .font(.system(size: 18, weight: .medium))
                .secondaryText().multilineTextAlignment(.center)
            Spacer()
            nextButton
        }
        .padding(32)
    }

    private var howItWorksPage: some View {
        VStack(spacing: 28) {
            Spacer()
            ZStack {
                Circle().fill(theme.colors.accent.opacity(0.08)).frame(width: 100, height: 100)
                Image(systemName: "hand.draw.fill")
                    .font(.system(size: 52)).foregroundStyle(theme.colors.accent)
            }
            Text("How It Works")
                .font(.system(size: 26, weight: .black, design: .rounded)).primaryText()

            VStack(alignment: .leading, spacing: 18) {
                instruction(icon: "1.circle.fill", text: "Study the symbol guide")
                instruction(icon: "2.circle.fill", text: "Draw it with your finger")
                instruction(icon: "3.circle.fill", text: "Earn stars for accuracy")
            }
            .padding(.horizontal, 8)

            HStack(spacing: 16) {
                ForEach(SymbolCategory.allCases) { cat in
                    catDemo(icon: cat.icon, color: cat.color)
                }
            }
            .padding(.top, 4)

            Spacer()
            nextButton
        }
        .padding(32)
    }

    private var readyPage: some View {
        VStack(spacing: 28) {
            Spacer()
            ZStack {
                Circle().fill(theme.colors.secondary.opacity(0.08)).frame(width: 100, height: 100)
                Image(systemName: "sparkles")
                    .font(.system(size: 52)).foregroundStyle(theme.colors.secondary)
            }
            Text("Ready?")
                .font(.system(size: 26, weight: .black, design: .rounded)).primaryText()
            Text("80 symbols across 5 ancient worlds.\nRunes. Hieroglyphs. Kanji. Geometry. Alchemy.")
                .font(.system(size: 16, weight: .medium))
                .secondaryText().multilineTextAlignment(.center)

            HStack(spacing: 16) {
                featurePill(icon: "map.fill", text: "5 Worlds")
                featurePill(icon: "star.fill", text: "Stars")
                featurePill(icon: "trophy.fill", text: "Badges")
            }

            Spacer()
            GlassButton("Start Drawing", icon: "play.fill") {
                HapticsService.medium()
                settings.first?.hasSeenOnboarding = true
            }
        }
        .padding(32)
    }

    private var nextButton: some View {
        GlassButton("Next", icon: "arrow.right") {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                currentPage += 1
            }
        }
    }

    private func instruction(icon: String, text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon).foregroundStyle(theme.colors.accent).font(.system(size: 22, weight: .bold))
            Text(text).font(.system(size: 16, weight: .medium)).primaryText()
        }
    }

    private func catDemo(icon: String, color: Color) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.15))
                .frame(width: 48, height: 48)
                .overlay { RoundedRectangle(cornerRadius: 12).strokeBorder(color.opacity(0.3), lineWidth: 1) }
            Image(systemName: icon).font(.system(size: 20, weight: .bold)).foregroundStyle(color)
        }
    }

    private func featurePill(icon: String, text: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon).font(.system(size: 12, weight: .bold))
            Text(text).font(.system(size: 12, weight: .bold, design: .rounded))
        }
        .foregroundStyle(theme.colors.accent)
        .padding(.horizontal, 12).padding(.vertical, 6)
        .background { Capsule().fill(theme.colors.accent.opacity(0.1)) }
    }
}
