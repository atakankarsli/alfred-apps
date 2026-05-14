import SwiftUI

struct QuizResultView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss

    let quizType: QuizType
    let continent: Continent
    let correctCount: Int
    let totalCount: Int

    @State private var stars = 0
    @State private var xpEarned = 0
    @State private var newAchievements: [AchievementDef] = []
    @State private var showConfetti = false
    @State private var recorded = false

    private var score: Double { Double(correctCount) / Double(totalCount) }
    private var emoji: String { stars >= 3 ? "🏆" : stars >= 2 ? "⭐" : stars >= 1 ? "👍" : "💪" }
    private var message: String {
        switch stars {
        case 3: "Perfect!"
        case 2: "Great job!"
        case 1: "Not bad!"
        default: "Keep trying!"
        }
    }

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Text(emoji).font(.system(size: 72))

            Text(message).font(.largeTitle.bold())

            Text("\(correctCount)/\(totalCount) correct")
                .font(.title2).secondaryText()

            HStack(spacing: 8) {
                ForEach(0..<3, id: \.self) { i in
                    Image(systemName: i < stars ? "star.fill" : "star")
                        .font(.title)
                        .foregroundStyle(i < stars ? .yellow : theme.colors.textMuted)
                }
            }

            GlassCard {
                HStack {
                    Label("+\(xpEarned) XP", systemImage: "bolt.fill")
                        .font(.headline)
                        .foregroundStyle(theme.colors.primary)
                    Spacer()
                    Text(continent.displayName)
                        .font(.subheadline).secondaryText()
                }
            }

            if !newAchievements.isEmpty {
                VStack(spacing: 8) {
                    Text("New Achievements!").font(.headline)
                    ForEach(newAchievements) { ach in
                        HStack {
                            Image(systemName: ach.icon).foregroundStyle(theme.colors.accent)
                            Text(ach.name).font(.subheadline.bold())
                        }
                    }
                }
                .padding()
            }

            Spacer()

            GlassButton("Done", icon: "checkmark") { dismiss() }
                .padding(.horizontal)
        }
        .padding()
        .themedBackground()
        .overlay { if showConfetti { ConfettiView() } }
        .onAppear(perform: record)
    }

    private func record() {
        guard !recorded else { return }
        recorded = true
        let result = appState.recordQuiz(
            type: quizType, continentId: continent.rawValue,
            level: appState.fetchProfile()?.level ?? 0,
            score: score, correct: correctCount, total: totalCount
        )
        xpEarned = result.xp
        stars = result.stars
        newAchievements = result.newAchievements
        if stars >= 3 {
            showConfetti = true
            SoundService.playCelebration()
        } else if stars >= 2 {
            SoundService.playStreak()
        }
        HapticsService.medium()
    }
}
