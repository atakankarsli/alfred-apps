import SwiftUI
import SwiftData

struct AchievementsView: View {
    @Environment(\.theme) private var theme
    @Query private var achievements: [AchievementRecord]

    private var unlockedIds: Set<String> { Set(achievements.map(\.achievementId)) }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(Achievement.all, id: \.id) { a in
                    achievementCard(a)
                }
            }
            .padding(16)
        }
        .themedBackground()
        .navigationTitle("Achievements")
    }

    private func achievementCard(_ a: Achievement) -> some View {
        let unlocked = unlockedIds.contains(a.id)
        return VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(unlocked ? theme.colors.accent.opacity(0.12) : theme.colors.surface.opacity(0.3))
                    .frame(width: 48, height: 48)
                Image(systemName: a.icon)
                    .font(.system(size: 22))
                    .foregroundStyle(unlocked ? theme.colors.accent : theme.colors.textMuted)
            }
            Text(a.title)
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .foregroundStyle(unlocked ? theme.colors.text : theme.colors.textMuted)
                .lineLimit(1)
            Text(a.description)
                .font(.system(size: 11))
                .foregroundStyle(unlocked ? theme.colors.textSecondary : theme.colors.textMuted.opacity(0.6))
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .padding(12)
        .background {
            RoundedRectangle(cornerRadius: 14)
                .fill(unlocked ? theme.colors.accent.opacity(0.05) : theme.colors.surface.opacity(0.2))
                .overlay {
                    RoundedRectangle(cornerRadius: 14)
                        .strokeBorder(unlocked ? theme.colors.accent.opacity(0.2) : theme.colors.cardBorder.opacity(0.08), lineWidth: 1)
                }
        }
        .opacity(unlocked ? 1 : 0.6)
    }
}
