import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var appState = AppState()
    @Query var settings: [SettingsRecord]

    var body: some View {
        Group {
            if settings.first?.hasSeenOnboarding == true {
                NavigationStack(path: $appState.path) {
                    HomeView()
                        .navigationDestination(for: Route.self) { route in
                            switch route {
                            case .home:
                                HomeView()
                            case .play(let levelIndex):
                                PlayView(levelIndex: levelIndex)
                            case .daily:
                                PlayView(levelIndex: -2)
                            case .worlds:
                                WorldsView()
                            case .settings:
                                SettingsView()
                            case .themePicker:
                                ThemePickerView()
                            case .achievements:
                                AchievementsView()
                            case .stats:
                                StatsDetailView()
                            }
                        }
                }
                .environment(appState)
            } else {
                OnboardingView()
            }
        }
        .theme(appState.currentTheme)
        .onAppear {
            if let themeId = settings.first?.selectedThemeId {
                appState.selectedThemeId = themeId
            }
        }
    }
}
