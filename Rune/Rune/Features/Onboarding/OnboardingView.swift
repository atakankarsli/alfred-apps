import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.theme) private var theme
    @Environment(\.modelContext) private var modelContext
    @Query private var settings: [SettingsRecord]
    @State private var page = 0

    private let pages: [(icon: String, title: String, subtitle: String)] = [
        ("character.book.closed.fill", "Welcome to Rune", "Decode ancient scripts from lost civilizations."),
        ("hand.tap.fill", "Match the Symbols", "Tap glyphs and guess their Latin equivalents."),
        ("trophy.fill", "Master All Scripts", "Unlock achievements across five writing systems."),
    ]

    var body: some View {
        ZStack {
            theme.gradient.ignoresSafeArea()
            FloatingOrbsView()

            VStack(spacing: 40) {
                Spacer()

                let p = pages[page]
                VStack(spacing: 16) {
                    Image(systemName: p.icon)
                        .font(.system(size: 64))
                        .foregroundStyle(theme.colors.primary)
                        .shadow(color: theme.colors.primary.opacity(0.3), radius: 20)

                    Text(p.title)
                        .font(.title.weight(.bold))
                        .foregroundStyle(theme.colors.text)

                    Text(p.subtitle)
                        .font(.body)
                        .foregroundStyle(theme.colors.textSecondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 40)

                Spacer()

                GlassButton(page < pages.count - 1 ? "Next" : "Start Decoding", icon: "arrow.right") {
                    if page < pages.count - 1 {
                        withAnimation { page += 1 }
                    } else {
                        settings.first?.hasSeenOnboarding = true
                    }
                }
                .padding(.horizontal, 24)

                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { i in
                        Circle()
                            .fill(i == page ? theme.colors.primary : theme.colors.textMuted)
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.bottom, 20)
            }
        }
    }
}
