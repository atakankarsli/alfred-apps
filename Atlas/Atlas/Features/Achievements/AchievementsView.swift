import SwiftUI
import SwiftData

struct AchievementsView: View {
    @Environment(\.theme) private var theme
    @Query private var unlocked: [AchievementRecordModel]

    private var unlockedIds: Set<String> { Set(unlocked.map(\.achievementId)) }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(Achievements.all) { achievement in
                    achievementRow(achievement, isUnlocked: unlockedIds.contains(achievement.id))
                }
            }
            .padding()
        }
        .themedBackground()
        .navigationTitle("Achievements")
    }

    private func achievementRow(_ ach: AchievementDef, isUnlocked: Bool) -> some View {
        GlassCard {
            HStack(spacing: 14) {
                Image(systemName: ach.icon)
                    .font(.title2)
                    .foregroundStyle(isUnlocked ? tierColor(ach.tier) : theme.colors.textMuted)
                    .frame(width: 40)
                VStack(alignment: .leading, spacing: 2) {
                    Text(ach.name).font(.headline)
                        .foregroundStyle(isUnlocked ? theme.colors.text : theme.colors.textMuted)
                    Text(ach.description).font(.caption)
                        .foregroundStyle(theme.colors.textSecondary)
                }
                Spacer()
                if isUnlocked {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundStyle(tierColor(ach.tier))
                }
            }
        }
        .opacity(isUnlocked ? 1 : 0.5)
    }

    private func tierColor(_ tier: AchievementDef.Tier) -> Color {
        switch tier {
        case .bronze: Color(hex: "CD7F32")
        case .silver: Color(hex: "C0C0C0")
        case .gold: Color(hex: "FFD700")
        case .diamond: Color(hex: "B9F2FF")
        }
    }
}
