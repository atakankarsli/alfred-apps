import SwiftUI
import SwiftData

struct StatsDetailView: View {
    @Environment(\.theme) var theme
    @Environment(AppState.self) var appState
    @Query var stats: [StatsRecord]

    var body: some View {
        let stat = stats.first
        ZStack {
            FloatingOrbsView()
            ScrollView {
                VStack(spacing: 16) {
                    Text("Statistics")
                        .font(.title.bold())
                        .foregroundStyle(theme.colors.text)
                        .padding(.top)

                    GlassCard {
                        VStack(spacing: 12) {
                            statRow("Total XP", value: "\(stat?.totalXP ?? 0)")
                            statRow("Levels Completed", value: "\(stat?.levelsCompleted ?? 0)/\(HelixConfig.totalLevels)")
                            statRow("Pairs Matched", value: "\(stat?.totalPairsMatched ?? 0)")
                            statRow("Best Combo", value: "\(stat?.bestCombo ?? 0)x")
                            statRow("Three Star Levels", value: "\(stat?.threeStarCount ?? 0)")
                            statRow("Daily Strands", value: "\(stat?.dailyCompleted ?? 0)")
                        }
                    }

                    GlassCard {
                        VStack(spacing: 12) {
                            statRow("Current Streak", value: "\(stat?.currentStreak ?? 0) days")
                            statRow("Best Streak", value: "\(stat?.bestStreak ?? 0) days")
                            statRow("Time Played", value: formatTime(stat?.totalTimePlayed ?? 0))
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

    private func statRow(_ title: String, value: String) -> some View {
        HStack {
            Text(title).foregroundStyle(theme.colors.textSecondary)
            Spacer()
            Text(value).bold().foregroundStyle(theme.colors.text)
        }
        .font(.subheadline)
    }

    private func formatTime(_ seconds: Int) -> String {
        let h = seconds / 3600
        let m = (seconds % 3600) / 60
        return h > 0 ? "\(h)h \(m)m" : "\(m)m"
    }
}
