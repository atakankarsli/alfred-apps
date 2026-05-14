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
        if settings.isEmpty { modelContext.insert(SettingsRecord()) }
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
                    switch route {
                    case .home: HomeView()
                    case .play(let index): PlayView(levelIndex: index)
                    case .endless: PlayView(levelIndex: -1)
                    case .dailySky: PlayView(levelIndex: -2)
                    case .quiz: QuizView()
                    case .worlds: WorldsView()
                    case .settings: SettingsView()
                    case .themePicker: ThemePickerView()
                    case .achievements: AchievementsView()
                    case .stats: StatsDetailView()
                    }
                }
        }
    }
}
