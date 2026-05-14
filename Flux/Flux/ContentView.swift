import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var settingsRecords: [SettingsRecord]
    @State private var appState = AppState()
    private var settings: SettingsRecord? { settingsRecords.first }

    var body: some View {
        Group {
            if settings?.onboardingDone == true { MainNavView() }
            else { OnboardingView() }
        }
        .environment(appState)
        .theme(appState.currentTheme)
        .onChange(of: settings?.themeId) { _, _ in appState.loadTheme(from: settings) }
        .onAppear { appState.loadTheme(from: settings) }
    }
}

struct MainNavView: View {
    @Environment(AppState.self) private var appState
    var body: some View {
        @Bindable var state = appState
        NavigationStack(path: $state.path) {
            HomeView()
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .flow(let el, let lvl): FlowView(element: el, level: lvl)
                    case .dailyFlow: FlowView(element: dailyElement(), level: dailyLevel())
                    case .freePlay(let el): FlowView(element: el, level: 0)
                    case .settings: SettingsView()
                    case .themePicker: ThemePickerView()
                    case .achievements: AchievementsView()
                    case .stats: StatsDetailView()
                    case .elementMap: ElementMapView()
                    case .gallery: GalleryView()
                    }
                }
        }
    }
    private func dailyElement() -> FluidElement {
        let day = Calendar.current.ordinality(of: .day, in: .year, for: .now) ?? 1
        return FluidElement.allCases[day % FluidElement.allCases.count]
    }
    private func dailyLevel() -> Int {
        (Calendar.current.ordinality(of: .day, in: .year, for: .now) ?? 1) % 80
    }
}
