import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(AppState.self) private var appState
    @Query private var settings: [SettingsRecord]

    var body: some View {
        @Bindable var state = appState
        let hasSeenOnboarding = settings.first?.hasSeenOnboarding ?? false

        NavigationStack(path: $state.path) {
            Group {
                if hasSeenOnboarding {
                    HomeView()
                } else {
                    OnboardingView()
                }
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .home: HomeView()
                case .play(let idx): PlayView(levelIndex: idx)
                case .endless: PlayView(levelIndex: -1)
                case .dailyEmber: PlayView(levelIndex: -2)
                case .quiz: QuizView()
                case .worlds: WorldsView()
                case .settings: SettingsView()
                case .themePicker: ThemePickerView()
                case .achievements: AchievementsView()
                case .stats: StatsDetailView()
                }
            }
        }
        .theme(Themes.theme(for: appState.currentThemeId))
        .onAppear {
            if let saved = settings.first?.currentTheme {
                appState.currentThemeId = saved
            }
        }
    }
}
