import SwiftUI
import SwiftData

struct AchievementsView: View {
    @Environment(\.theme) private var theme
    @Environment(AppState.self) private var appState
    @Query private var unlocked: [AchievementRecord]

    var body: some View {
        ZStack {
            theme.gradient.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 16) {
                    Text("Achievements")
                        .font(.title.weight(.bold))
                        .foregroundStyle(theme.colors.text)
                        .padding(.top)

                    Text("\(unlocked.count)/\(Achievement.all.count) unlocked")
                        .font(.subheadline)
                        .foregroundStyle(theme.colors.textSecondary)

                    ForEach(Achievement.all) { achievement in
                        let isUnlocked = unlocked.contains { $0.achievementId == achievement.id }
                        achievementRow(achievement, unlocked: isUnlocked)
                    }
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button { appState.pop() } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(theme.colors.text)
                }
            }
        }
    }

    private func achievementRow(_ achievement: Achievement, unlocked: Bool) -> some View {
        GlassCard(padding: 12) {
            HStack(spacing: 12) {
                Image(systemName: achievement.icon)
                    .font(.title2)
                    .foregroundStyle(unlocked ? theme.colors.primary : theme.colors.textMuted)
                    .frame(width: 40)

                VStack(alignment: .leading, spacing: 2) {
                    Text(achievement.name)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(unlocked ? theme.colors.text : theme.colors.textMuted)
                    Text(achievement.description)
                        .font(.caption)
                        .foregroundStyle(unlocked ? theme.colors.textSecondary : theme.colors.textMuted)
                }

                Spacer()

                if unlocked {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(theme.colors.success)
                }
            }
            .opacity(unlocked ? 1 : 0.5)
        }
    }
}
