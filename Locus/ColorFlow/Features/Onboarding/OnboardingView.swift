import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.theme) private var theme
    @Query private var settings: [SettingsRecord]
    @State private var currentPage = 0; @State private var iconPulse = false

    var body: some View {
        ZStack {
            FloatingOrbsView().ignoresSafeArea()
            VStack(spacing: 0) {
                TabView(selection: $currentPage) { page0.tag(0); page1.tag(1); page2.tag(2) }
                    .tabViewStyle(.page(indexDisplayMode: .always))
                bottomButton
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity).themedBackground()
    }

    private var page0: some View {
        VStack(spacing: 20) {
            Spacer()
            ZStack { Circle().fill(theme.colors.accent.opacity(0.08)).frame(width: 120, height: 120)
                Image(systemName: "building.columns.fill").font(.system(size: 48)).foregroundStyle(theme.colors.accent.opacity(0.6))
                    .scaleEffect(iconPulse ? 1.1 : 1.0).animation(.easeInOut(duration: 1.5).repeatForever(), value: iconPulse)
            }.onAppear { iconPulse = true }
            Text("Welcome to Locus").font(.system(size: 28, weight: .black, design: .rounded)).primaryText()
            Text("Build your memory palace.\nPlace items. Remember positions.").font(.system(size: 16, weight: .medium)).secondaryText().multilineTextAlignment(.center)
            Spacer()
        }.padding(32)
    }

    private var page1: some View {
        VStack(spacing: 20) {
            Spacer()
            HStack(spacing: 16) {
                demoIcon("book.fill", "Study"); demoIcon("fork.knife", "Kitchen")
                demoIcon("leaf.fill", "Garden"); demoIcon("lock.shield.fill", "Vault")
            }
            Text("4 Palace Rooms").font(.system(size: 22, weight: .black, design: .rounded)).primaryText()
            Text("Each room has unique items.\n80 challenges to master.").font(.system(size: 15, weight: .medium)).secondaryText().multilineTextAlignment(.center)
            Spacer()
        }.padding(32)
    }

    private func demoIcon(_ icon: String, _ label: String) -> some View {
        VStack(spacing: 6) {
            ZStack { Circle().fill(theme.colors.accent.opacity(0.1)).frame(width: 48, height: 48)
                Image(systemName: icon).font(.system(size: 20)).foregroundStyle(theme.colors.accent) }
            Text(label).font(.system(size: 10, weight: .bold)).secondaryText()
        }
    }

    private var page2: some View {
        VStack(spacing: 20) {
            Spacer()
            ZStack { Circle().fill(theme.colors.accent.opacity(0.08)).frame(width: 100, height: 100)
                Image(systemName: "sparkles").font(.system(size: 40)).foregroundStyle(theme.colors.accent) }
            Text("How It Works").font(.system(size: 22, weight: .black, design: .rounded)).primaryText()
            VStack(alignment: .leading, spacing: 12) {
                stepRow("1", "Items appear in the room briefly")
                stepRow("2", "Tap where each item was placed")
                stepRow("3", "Earn stars, XP & badges")
            }
            Spacer()
        }.padding(32)
    }

    private func stepRow(_ num: String, _ text: String) -> some View {
        HStack(spacing: 12) {
            ZStack { Circle().fill(theme.colors.accent.opacity(0.15)).frame(width: 32, height: 32)
                Text(num).font(.system(size: 14, weight: .black, design: .rounded)).foregroundStyle(theme.colors.accent) }
            Text(text).font(.system(size: 15, weight: .medium)).primaryText()
        }
    }

    private var bottomButton: some View {
        VStack(spacing: 12) {
            if currentPage < 2 {
                GlassButton("Next", icon: "arrow.right") { withAnimation { currentPage += 1 } }
            } else {
                GlassButton("Enter Palace", icon: "play.fill") { HapticsService.medium(); settings.first?.hasSeenOnboarding = true }
            }
        }.padding(32)
    }
}
