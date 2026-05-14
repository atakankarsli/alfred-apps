import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.theme) private var theme
    @Environment(\.modelContext) private var modelContext
    @Query private var settings: [SettingsRecord]

    @State private var page = 0
    private let pages: [(icon: String, title: String, subtitle: String)] = [
        ("map.fill", "Explore Your World", "Complete daily missions in your neighborhood and beyond"),
        ("binoculars.fill", "Discover & Observe", "Photo challenges, checkpoints, and hidden discoveries await"),
        ("cloud.fog.fill", "Clear the Fog", "Reveal the map as you complete objectives"),
        ("trophy.fill", "Earn & Grow", "Gain XP, unlock regions, and collect achievements"),
    ]

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            TabView(selection: $page) {
                ForEach(0..<pages.count, id: \.self) { i in
                    VStack(spacing: 16) {
                        Image(systemName: pages[i].icon)
                            .font(.system(size: 60))
                            .foregroundStyle(theme.colors.accent)
                        Text(pages[i].title)
                            .font(.system(size: 24, weight: .black, design: .rounded))
                            .primaryText()
                        Text(pages[i].subtitle)
                            .font(.system(size: 15))
                            .secondaryText()
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                    .tag(i)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))

            if page == pages.count - 1 {
                GlassButton("Start Exploring", icon: "arrow.right") {
                    HapticsService.medium()
                    settings.first?.hasSeenOnboarding = true
                }
                .padding(.horizontal, 32)
            }

            Spacer()
        }
        .themedBackground()
        .overlay { FloatingOrbsView() }
    }
}
