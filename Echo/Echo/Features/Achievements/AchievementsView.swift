import SwiftUI
import SwiftData

struct AchievementsView: View {
    @Environment(\.theme) private var theme
    @Query private var unlocked: [AchievementRecord]

    private var unlockedIds: Set<String> { Set(unlocked.map(\.achievementId)) }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                progressHeader
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 12)], spacing: 12) {
                    ForEach(Achievement.all) { achievement in achievementCard(achievement) }
                }
            }
            .padding(16)
        }
        .themedBackground()
        .navigationTitle("Achievements")
    }

    private var progressHeader: some View {
        let total = Achievement.all.count
        let done = Achievement.all.filter { unlockedIds.contains($0.id) }.count
        return VStack(spacing: 8) {
            Text("\(done)/\(total)").font(.system(size: 32, weight: .black, design: .rounded)).primaryText()
            ProgressView(value: Double(done), total: Double(total)).tint(theme.colors.accent)
            Text("Achievements Unlocked").font(.caption).secondaryText()
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 16).fill(theme.colors.surface.opacity(0.4))
                .overlay { RoundedRectangle(cornerRadius: 16).strokeBorder(theme.colors.cardBorder.opacity(0.12), lineWidth: 1) }
        }
    }

    private func achievementCard(_ achievement: Achievement) -> some View {
        let isUnlocked = unlockedIds.contains(achievement.id)
        let showDetails = isUnlocked || !achievement.isHidden
        return VStack(spacing: 6) {
            ZStack {
                Circle().fill(isUnlocked ? tierColor(achievement.tier).opacity(0.15) : theme.colors.cardBackground.opacity(0.4)).frame(width: 48, height: 48)
                if showDetails {
                    Image(systemName: achievement.icon).font(.system(size: 20)).foregroundStyle(isUnlocked ? tierColor(achievement.tier) : theme.colors.textMuted.opacity(0.4))
                } else {
                    Image(systemName: "questionmark").font(.system(size: 20)).foregroundStyle(theme.colors.textMuted.opacity(0.3))
                }
            }
            Text(showDetails ? achievement.title : "???").font(.system(size: 11, weight: .semibold, design: .rounded))
                .foregroundStyle(isUnlocked ? theme.colors.text : theme.colors.textMuted).lineLimit(1)
            if showDetails {
                Text(achievement.description).font(.system(size: 9)).foregroundStyle(theme.colors.textMuted).lineLimit(2).multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity).padding(.vertical, 10).padding(.horizontal, 6)
        .background {
            RoundedRectangle(cornerRadius: 12).fill(isUnlocked ? tierColor(achievement.tier).opacity(0.05) : theme.colors.surface.opacity(0.2))
                .overlay { RoundedRectangle(cornerRadius: 12).strokeBorder(isUnlocked ? tierColor(achievement.tier).opacity(0.2) : theme.colors.cardBorder.opacity(0.08), lineWidth: 1) }
        }
    }

    private func tierColor(_ tier: Achievement.Tier) -> Color {
        switch tier {
        case .bronze: Color(red: 0.8, green: 0.5, blue: 0.2)
        case .silver: Color(red: 0.65, green: 0.65, blue: 0.7)
        case .gold: Color(red: 0.95, green: 0.75, blue: 0.1)
        case .diamond: Color(red: 0.4, green: 0.7, blue: 0.95)
        }
    }
}
