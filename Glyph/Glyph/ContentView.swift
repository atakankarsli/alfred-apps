import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.modelContext) private var modelContext
    @Query private var settings: [SettingsRecord]

    private var currentTheme: Theme {
        Themes.theme(for: appState.currentThemeId)
    }

    var body: some View {
        Group {
            if !hasSeenOnboarding {
                OnboardingView()
            } else {
                MainNavView()
            }
        }
        .theme(currentTheme)
        .task {
            ensureRecordsExist()
            if let themeId = settings.first?.currentTheme {
                appState.currentThemeId = themeId
            }
        }
    }

    private var hasSeenOnboarding: Bool {
        settings.first?.hasSeenOnboarding ?? false
    }

    private func ensureRecordsExist() {
        if settings.isEmpty {
            modelContext.insert(SettingsRecord())
        }
        let statsDescriptor = FetchDescriptor<StatsRecord>()
        if (try? modelContext.fetchCount(statsDescriptor)) == 0 {
            modelContext.insert(StatsRecord())
        }
    }
}

struct MainNavView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        @Bindable var appState = appState

        NavigationStack(path: $appState.navigationPath) {
            HomeView()
                .navigationDestination(for: Route.self) { route in
                    destinationView(for: route)
                }
        }
    }

    @ViewBuilder
    private func destinationView(for route: Route) -> some View {
        switch route {
        case .draw(let index):
            DrawView(challengeIndex: index)
        case .daily:
            DrawView(challengeIndex: dailyIndex(), isDaily: true)
        case .settings:
            SettingsView()
        case .themePicker:
            ThemePickerView()
        case .achievements:
            AchievementsView()
        case .stats:
            StatsDetailView()
        case .worlds:
            WorldsView()
        case .gallery:
            GalleryView()
        }
    }

    private func dailyIndex() -> Int {
        let day = Calendar.current.ordinality(of: .day, in: .era, for: .now) ?? 0
        return day % GlyphConfig.totalChallenges
    }
}
