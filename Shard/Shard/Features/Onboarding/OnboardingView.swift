import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.theme) private var theme
    @Environment(\.modelContext) private var modelContext
    @Query private var settings: [SettingsRecord]
    @State private var page = 0

    private let pages: [(icon: String, title: String, subtitle: String)] = [
        ("diamond.fill", "SHARD", "Crystal Growing Simulator"),
        ("thermometer.medium", "Tune Parameters", "Adjust temperature & pressure\nto grow perfect crystals"),
        ("sparkle", "Grow & Discover", "13 crystal types across\n5 mineral families"),
        ("tray.full.fill", "Build Your Collection", "Earn XP, unlock achievements\nand master crystal science"),
    ]

    var body: some View {
        ZStack {
            FloatingOrbsView().ignoresSafeArea()
            VStack(spacing: 32) {
                Spacer()
                ZStack {
                    Circle().fill(theme.colors.accent.opacity(0.1)).frame(width: 130, height: 130)
                    Image(systemName: pages[page].icon).font(.system(size: 56)).foregroundStyle(theme.colors.accent)
                }
                VStack(spacing: 10) {
                    Text(pages[page].title).font(.system(size: 30, weight: .black, design: .rounded)).primaryText()
                    Text(pages[page].subtitle).font(.system(size: 16, weight: .medium)).secondaryText().multilineTextAlignment(.center)
                }
                Spacer()
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { i in
                        Circle().fill(i == page ? theme.colors.accent : theme.colors.textMuted.opacity(0.3)).frame(width: 8, height: 8)
                    }
                }
                GlassButton(page < pages.count - 1 ? "Next" : "Start Growing!", icon: page < pages.count - 1 ? "arrow.right" : "diamond.fill") {
                    if page < pages.count - 1 {
                        withAnimation { page += 1 }
                    } else {
                        settings.first?.hasSeenOnboarding = true
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 20)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .themedBackground()
    }
}
