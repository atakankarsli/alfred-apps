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
                MainTabView()
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
        let statsCount = (try? modelContext.fetchCount(statsDescriptor)) ?? 0
        if statsCount == 0 {
            modelContext.insert(StatsRecord())
        }
    }
}

struct MainTabView: View {
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
        case .home:
            HomeView()
        case .cipher(let mode):
            CipherView(mode: mode)
        case .settings:
            SettingsView()
        case .themePicker:
            ThemePickerView()
        case .achievements:
            AchievementsView()
        case .stats:
            StatsDetailView()
        case .vaultMap:
            VaultMapView()
        }
    }
}
