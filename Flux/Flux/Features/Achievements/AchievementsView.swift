import SwiftUI
import SwiftData

struct AchievementsView: View {
    @Environment(\.theme) private var theme
    @Query private var records: [AchievementRecord]
    private var unlockedIds: Set<String> { Set(records.map(\.id)) }

    var body: some View {
        ZStack {
            FloatingOrbsView()
            ScrollView {
                VStack(spacing: 16) {
                    GlassCard {
                        VStack(spacing: 8) {
                            Text("\(unlockedIds.count)/\(Achievements.all.count)").font(.title.bold()).primaryText()
                            ProgressView(value: Double(unlockedIds.count), total: Double(Achievements.all.count))
                                .tint(theme.colors.primary).scaleEffect(y: 2)
                            Text("Achievements Unlocked").font(.subheadline).secondaryText()
                        }
                    }
                    LazyVStack(spacing: 12) {
                        ForEach(Achievements.all) { ach in card(ach) }
                    }
                }
                .padding()
            }
        }
        .themedBackground()
        .navigationTitle("Achievements")
    }

    private func card(_ ach: AchievementDef) -> some View {
        let unlocked = unlockedIds.contains(ach.id)
        return GlassCard {
            HStack(spacing: 12) {
                Image(systemName: ach.icon).font(.title2).foregroundStyle(unlocked ? tierColor(ach.tier) : theme.colors.textMuted)
                    .frame(width: 44, height: 44).background(Circle().fill((unlocked ? tierColor(ach.tier) : theme.colors.textMuted).opacity(0.15)))
                VStack(alignment: .leading, spacing: 2) {
                    Text(ach.name).font(.headline).foregroundStyle(unlocked ? theme.colors.text : theme.colors.textMuted)
                    Text(ach.description).font(.caption).foregroundStyle(unlocked ? theme.colors.textSecondary : theme.colors.textMuted)
                }
                Spacer()
                if unlocked { Image(systemName: "checkmark.circle.fill").foregroundStyle(tierColor(ach.tier)) }
            }
        }
        .opacity(unlocked ? 1 : 0.6)
    }

    private func tierColor(_ tier: AchievementDef.Tier) -> Color {
        switch tier {
        case .bronze: Color(hex: "CD7F32"); case .silver: Color(hex: "C0C0C0")
        case .gold: Color(hex: "FFD700"); case .diamond: Color(hex: "B9F2FF")
        }
    }
}
