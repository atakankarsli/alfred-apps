import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(AppState.self) private var appState
    @Query private var settings: [SettingsRecord]

    var body: some View {
        @Bindable var state = appState
        Group {
            if settings.first?.hasSeenOnboarding == true {
                NavigationStack(path: $state.navigationPath) {
                    HomeView()
                        .navigationDestination(for: Route.self) { route in
                            switch route {
                            case .home: HomeView()
                            case .locus(let mode): LocusView(mode: mode)
                            case .settings: SettingsView()
                            case .themePicker: ThemePickerView()
                            case .achievements: AchievementsView()
                            case .stats: StatsDetailView()
                            case .palaceMap: WorldMapView()
                            }
                        }
                }
            } else {
                OnboardingView()
            }
        }
    }
}
