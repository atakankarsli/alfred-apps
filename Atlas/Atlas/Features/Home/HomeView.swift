import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.theme) private var theme
    @Query private var profiles: [UserProfileModel]

    private var profile: UserProfileModel? { profiles.first }

    var body: some View {
        ZStack {
            FloatingOrbsView().ignoresSafeArea()
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    streakCard
                    continentsSection
                }
                .padding()
            }
        }
        .themedBackground()
        .navigationTitle("Atlas")
    }

    private var headerSection: some View {
        GlassCard {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(profile?.title ?? "Tourist").font(.title3.bold())
                    Text("Level \(profile?.level ?? 0)").secondaryText()
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 4) {
                    Text("\(profile?.totalXP ?? 0) XP").font(.headline).foregroundStyle(theme.colors.primary)
                    ProgressView(value: profile?.xpProgress ?? 0)
                        .tint(theme.colors.primary)
                        .frame(width: 80)
                }
            }
        }
    }

    private var streakCard: some View {
        GlassCard {
            HStack {
                Image(systemName: "flame.fill")
                    .font(.title2)
                    .foregroundStyle(.orange)
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(profile?.currentStreak ?? 0) day streak")
                        .font(.headline)
                    Text("Best: \(profile?.bestStreak ?? 0) days")
                        .font(.caption).secondaryText()
                }
                Spacer()
                Text("\(profile?.totalQuizzes ?? 0)")
                    .font(.title2.bold())
                    .foregroundStyle(theme.colors.primary)
                Text("quizzes").font(.caption).secondaryText()
            }
        }
    }

    private var continentsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Continents").font(.title2.bold())
            ForEach(Continent.allCases) { continent in
                NavigationLink(value: continent) {
                    ContinentCard(continent: continent)
                }
                .buttonStyle(ScaleButtonStyle())
            }
        }
        .navigationDestination(for: Continent.self) { continent in
            ContinentDetailView(continent: continent)
        }
    }
}
