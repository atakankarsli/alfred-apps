import SwiftUI
import SwiftData

struct StatsDetailView: View {
    @Environment(\.theme) private var theme
    @Environment(AppState.self) private var appState
    @Query private var stats: [StatsRecord]
    @Query private var levels: [LevelRecord]

    private var record: StatsRecord? { stats.first }

    var body: some View {
        ZStack {
            theme.gradient.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 16) {
                    Text("Statistics")
                        .font(.title.weight(.bold))
                        .foregroundStyle(theme.colors.text)
                        .padding(.top)

                    GlassCard {
                        VStack(spacing: 12) {
                            Text(ZenithConfig.levelTitle(forXP: record?.totalXP ?? 0))
                                .font(.title2.weight(.bold))
                                .foregroundStyle(theme.colors.primary)
                            Text("\(record?.totalXP ?? 0) XP")
                                .font(.subheadline.monospacedDigit())
                                .foregroundStyle(theme.colors.textSecondary)
                        }
                    }

                    GlassCard {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            statCell("Completed", value: "\(record?.levelsCompleted ?? 0)")
                            statCell("3 Stars", value: "\(record?.threeStarCount ?? 0)")
                            statCell("No Hints", value: "\(record?.noHintCount ?? 0)")
                            statCell("Streak", value: "\(record?.currentStreak ?? 0)")
                            statCell("Best Streak", value: "\(record?.longestStreak ?? 0)")
                            statCell("Endless Best", value: "\(record?.endlessBest ?? 0)")
                            statCell("Daily Done", value: "\(record?.dailyChallengesCompleted ?? 0)")
                            statCell("Time Played", value: formatTime(record?.totalTimePlayed ?? 0))
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Realm Progress")
                                .font(.headline)
                                .foregroundStyle(theme.colors.text)

                            ForEach(SkyRealm.allCases, id: \.rawValue) { realm in
                                realmRow(realm)
                            }
                        }
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

    private func statCell(_ label: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title3.weight(.bold).monospacedDigit())
                .foregroundStyle(theme.colors.text)
            Text(label)
                .font(.caption)
                .foregroundStyle(theme.colors.textMuted)
        }
    }

    private func realmRow(_ realm: SkyRealm) -> some View {
        let completed = levels.filter { realm.levelRange.contains($0.levelIndex) }.count
        return HStack {
            Image(systemName: realm.icon)
                .font(.body)
                .foregroundStyle(theme.colors.primary)
                .frame(width: 24)
            Text(realm.name)
                .font(.subheadline)
                .foregroundStyle(theme.colors.text)
            Spacer()
            Text("\(completed)/16")
                .font(.subheadline.monospacedDigit())
                .foregroundStyle(theme.colors.textSecondary)
            ProgressView(value: Double(completed), total: 16)
                .tint(theme.colors.primary)
                .frame(width: 60)
        }
    }

    private func formatTime(_ seconds: Int) -> String {
        let hrs = seconds / 3600
        let mins = (seconds % 3600) / 60
        if hrs > 0 { return "\(hrs)h \(mins)m" }
        return "\(mins)m"
    }
}
