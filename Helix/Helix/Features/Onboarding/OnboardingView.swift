import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.theme) var theme
    @Environment(\.modelContext) var modelContext
    @Query var settings: [SettingsRecord]
    @State private var currentPage = 0

    private let pages: [(icon: String, title: String, desc: String)] = [
        ("line.3.crossed.swirl.circle.fill", "Welcome to Helix", "Decode DNA sequences and master the language of life."),
        ("a.circle.fill", "Match Base Pairs", "Align nucleotides A, T, C, G to solve genetic puzzles."),
        ("star.fill", "Master the Realms", "Journey from Nucleus to Evolution across 80 levels."),
    ]

    var body: some View {
        ZStack {
            FloatingOrbsView()
            VStack(spacing: 32) {
                Spacer()
                Image(systemName: pages[currentPage].icon)
                    .font(.system(size: 80))
                    .foregroundStyle(theme.colors.primary)
                    .contentTransition(.symbolEffect(.replace))

                Text(pages[currentPage].title)
                    .font(.title.bold())
                    .foregroundStyle(theme.colors.text)

                Text(pages[currentPage].desc)
                    .font(.body)
                    .foregroundStyle(theme.colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                Spacer()

                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { i in
                        Circle()
                            .fill(i == currentPage ? theme.colors.primary : theme.colors.textMuted)
                            .frame(width: 8, height: 8)
                    }
                }

                GlassButton(currentPage < pages.count - 1 ? "Next" : "Begin", icon: "arrow.right") {
                    if currentPage < pages.count - 1 {
                        withAnimation { currentPage += 1 }
                    } else {
                        completeOnboarding()
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
        }
    }

    private func completeOnboarding() {
        if settings.isEmpty {
            modelContext.insert(SettingsRecord())
        }
        modelContext.insert(StatsRecord())
        settings.first?.hasSeenOnboarding = true
        try? modelContext.save()
    }
}
