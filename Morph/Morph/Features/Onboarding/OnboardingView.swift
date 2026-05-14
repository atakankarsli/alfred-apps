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
                    mechanicsPage.tag(1)
                    readyPage.tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .themedBackground()
        .onAppear {
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) { iconPulse = true }
        }
    }

    private var welcomePage: some View {
        VStack(spacing: 28) {
            Spacer()
            ZStack {
                Circle().fill(theme.colors.accent.opacity(0.1)).frame(width: 140, height: 140)
                    .scaleEffect(iconPulse ? 1.1 : 1.0).blur(radius: 10)
                Circle().fill(RadialGradient(colors: [theme.colors.accent.opacity(0.2), theme.colors.accent.opacity(0.05)],
                    center: .center, startRadius: 0, endRadius: 60)).frame(width: 120, height: 120)
                Image(systemName: "triangle.fill").font(.system(size: 64))
                    .foregroundStyle(theme.colors.accent).shadow(color: theme.colors.accent.opacity(0.4), radius: 10)
            }
            Text("Welcome to Morph").font(.system(size: 30, weight: .black, design: .rounded)).primaryText().multilineTextAlignment(.center)
            Text("Transform shapes with\ngeometric operations.").font(.system(size: 18, weight: .medium)).secondaryText().multilineTextAlignment(.center)
            Spacer()
            nextButton
        }
        .padding(32)
    }

    private var mechanicsPage: some View {
        VStack(spacing: 28) {
            Spacer()
            ZStack {
                Circle().fill(theme.colors.accent.opacity(0.08)).frame(width: 100, height: 100)
                Image(systemName: "arrow.triangle.2.circlepath").font(.system(size: 52)).foregroundStyle(theme.colors.accent)
            }
            Text("How It Works").font(.system(size: 26, weight: .black, design: .rounded)).primaryText()
            VStack(alignment: .leading, spacing: 18) {
                mechInfo(icon: "eye.fill", text: "See the target shape", color: .cyan)
                mechInfo(icon: "arrow.clockwise", text: "Apply transforms", color: .green)
                mechInfo(icon: "checkmark.circle.fill", text: "Match to complete", color: .orange)
                mechInfo(icon: "star.fill", text: "Fewer moves = more stars", color: .yellow)
            }
            .padding(.horizontal, 8)
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
                Image(systemName: "sparkles").font(.system(size: 52)).foregroundStyle(theme.colors.secondary)
            }
            Text("Ready?").font(.system(size: 26, weight: .black, design: .rounded)).primaryText()
            Text("5 shape realms, 80 levels.\nMaster geometry.").font(.system(size: 16, weight: .medium)).secondaryText().multilineTextAlignment(.center)
            HStack(spacing: 16) {
                featurePill(icon: "triangle.fill", text: "5 Realms")
                featurePill(icon: "star.fill", text: "Stars")
                featurePill(icon: "trophy.fill", text: "Badges")
            }
            Spacer()
            GlassButton("Let's Go", icon: "play.fill") {
                HapticsService.medium()
                settings.first?.hasSeenOnboarding = true
            }
        }
        .padding(32)
    }

    private var nextButton: some View {
        GlassButton("Next", icon: "arrow.right") {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) { currentPage += 1 }
        }
    }

    private func mechInfo(icon: String, text: String, color: Color) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon).foregroundStyle(color).font(.system(size: 22, weight: .bold))
            Text(text).font(.system(size: 16, weight: .medium)).primaryText()
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
