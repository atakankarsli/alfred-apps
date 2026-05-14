import SwiftUI
import SwiftData

struct AchievementsView: View {
    @Environment(\.theme) private var theme
    @Query private var unlocked: [AchievementRecord]

    private var unlockedIDs: Set<String> { Set(unlocked.map(\.achievementId)) }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(Achievement.all) { achievement in
                    achievementCard(achievement, isUnlocked: unlockedIDs.contains(achievement.id))
                }
            }
            .padding(16)
        }
        .themedBackground()
        .navigationTitle("Achievements")
    }

    private func achievementCard(_ a: Achievement, isUnlocked: Bool) -> some View {
        VStack(spacing: 8) {
            Image(systemName: a.icon)
                .font(.system(size: 32))
                .opacity(isUnlocked ? 1 : 0.3)

            Text(a.title)
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .foregroundStyle(isUnlocked ? theme.colors.text : theme.colors.textSecondary.opacity(0.5))
                .multilineTextAlignment(.center)
                .lineLimit(2)

            Text(a.description)
                .font(.system(size: 11))
                .foregroundStyle(isUnlocked ? theme.colors.textSecondary : theme.colors.textSecondary.opacity(0.3))
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity)
        .padding(12)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(isUnlocked ? theme.colors.accent.opacity(0.06) : theme.colors.surface.opacity(0.2))
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(isUnlocked ? theme.colors.accent.opacity(0.15) : theme.colors.cardBorder.opacity(0.08), lineWidth: 1)
                }
        }
    }
}
