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
            FloatingOrbsView()
                .ignoresSafeArea()

            VStack {
                TabView(selection: $currentPage) {
                    welcomePage.tag(0)
                    howToPlayPage.tag(1)
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
                    .fill(Color(hex: "6BCB77").opacity(0.1))
                    .frame(width: 140, height: 140)
                    .scaleEffect(iconPulse ? 1.1 : 1.0)
                    .blur(radius: 10)

                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color(hex: "6BCB77").opacity(0.2), Color(hex: "6BCB77").opacity(0.05)],
                            center: .center,
                            startRadius: 0,
                            endRadius: 60
                        )
                    )
                    .frame(width: 120, height: 120)

                Image(systemName: "leaf.circle.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(Color(hex: "6BCB77"))
                    .shadow(color: Color(hex: "6BCB77").opacity(0.4), radius: 10)
            }

            Text("Welcome to Bloom")
                .font(.system(size: 30, weight: .black, design: .rounded))
                .primaryText()
                .multilineTextAlignment(.center)

            Text("Plant your emotions.\nGrow your garden.")
                .font(.system(size: 18, weight: .medium))
                .secondaryText()
                .multilineTextAlignment(.center)

            Spacer()
            nextButton
        }
        .padding(32)
    }

    private var howToPlayPage: some View {
        VStack(spacing: 28) {
            Spacer()

            ZStack {
                Circle()
                    .fill(Color(hex: "FFD93D").opacity(0.08))
                    .frame(width: 100, height: 100)

                Image(systemName: "hand.tap.fill")
                    .font(.system(size: 52))
                    .foregroundStyle(Color(hex: "FFD93D"))
            }

            Text("How It Works")
                .font(.system(size: 26, weight: .black, design: .rounded))
                .primaryText()

            VStack(alignment: .leading, spacing: 18) {
                instruction(
                    icon: "1.circle.fill",
                    text: "Tap an empty cell in your garden"
                )
                instruction(
                    icon: "2.circle.fill",
                    text: "Choose how you feel — each emotion grows a unique plant"
                )
                instruction(
                    icon: "3.circle.fill",
                    text: "Water your plants to help them bloom"
                )
            }
            .padding(.horizontal, 8)

            HStack(spacing: 12) {
                emotionDemo(emotions: ["joy", "calm", "love"])
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
                Circle()
                    .fill(Color(hex: "9B5DE5").opacity(0.08))
                    .frame(width: 100, height: 100)

                Image(systemName: "sparkles")
                    .font(.system(size: 52))
                    .foregroundStyle(Color(hex: "9B5DE5"))
            }

            Text("Ready to Grow?")
                .font(.system(size: 26, weight: .black, design: .rounded))
                .primaryText()

            Text("80 gardens across 4 seasons.\nYour emotions, your landscape.")
                .font(.system(size: 16, weight: .medium))
                .secondaryText()
                .multilineTextAlignment(.center)

            HStack(spacing: 16) {
                featurePill(icon: "map.fill", text: "4 Seasons")
                featurePill(icon: "star.fill", text: "Stars")
                featurePill(icon: "trophy.fill", text: "Badges")
            }

            Spacer()

            GlassButton("Start Growing", icon: "leaf.fill") {
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
            Image(systemName: icon)
                .foregroundStyle(Color(hex: "6BCB77"))
                .font(.system(size: 22, weight: .bold))
            Text(text)
                .font(.system(size: 16, weight: .medium))
                .primaryText()
        }
    }

    private func emotionDemo(emotions: [String]) -> some View {
        HStack(spacing: 8) {
            ForEach(emotions, id: \.self) { emotionId in
                if let emotion = Emotion.find(emotionId) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(hex: emotion.colorHex).opacity(0.3))
                            .frame(width: 48, height: 48)
                            .overlay {
                                RoundedRectangle(cornerRadius: 10)
                                    .strokeBorder(Color(hex: emotion.colorHex).opacity(0.5), lineWidth: 1)
                            }
                        Image(systemName: emotion.icon)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundStyle(Color(hex: emotion.colorHex))
                    }
                }
            }
        }
    }

    private func featurePill(icon: String, text: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .bold))
            Text(text)
                .font(.system(size: 12, weight: .bold, design: .rounded))
        }
        .foregroundStyle(Color(hex: "6BCB77"))
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background {
            Capsule()
                .fill(Color(hex: "6BCB77").opacity(0.1))
        }
    }
}
