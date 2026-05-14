import SwiftUI
import SwiftData

struct AchievementsView: View {
    @Environment(\.theme) var theme
    @Environment(AppState.self) var appState
    @Query var unlocked: [AchievementRecord]

    private var unlockedIds: Set<String> {
        Set(unlocked.map { $0.achievementId })
    }

    var body: some View {
        ZStack {
            FloatingOrbsView()
            ScrollView {
                VStack(spacing: 16) {
                    Text("Achievements")
                        .font(.title.bold())
                        .foregroundStyle(theme.colors.text)
                        .padding(.top)

                    Text("\(unlocked.count)/\(Achievement.all.count) Unlocked")
                        .font(.subheadline)
                        .foregroundStyle(theme.colors.textSecondary)

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(Achievement.all) { achievement in
                            achievementCard(achievement, isUnlocked: unlockedIds.contains(achievement.id))
                        }
                    }
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button { appState.path.removeLast() } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(theme.colors.text)
                }
            }
        }
    }

    private func achievementCard(_ a: Achievement, isUnlocked: Bool) -> some View {
        GlassCard {
            VStack(spacing: 8) {
                Image(systemName: a.icon)
                    .font(.title2)
                    .foregroundStyle(isUnlocked ? theme.colors.primary : theme.colors.textMuted)
                Text(a.name)
                    .font(.caption.bold())
                    .foregroundStyle(isUnlocked ? theme.colors.text : theme.colors.textMuted)
                Text(a.desc)
                    .font(.caption2)
                    .foregroundStyle(theme.colors.textSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .opacity(isUnlocked ? 1.0 : 0.5)
        }
    }
}
