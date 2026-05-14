import SwiftUI

struct ContentView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.modelContext) private var modelContext
    @Environment(\.theme) private var theme

    var body: some View {
        @Bindable var state = appState
        TabView(selection: $state.selectedTab) {
            Tab("Home", systemImage: "globe.americas.fill", value: .home) {
                NavigationStack { HomeView() }
            }
            Tab("Achievements", systemImage: "trophy.fill", value: .achievements) {
                NavigationStack { AchievementsView() }
            }
            Tab("Stats", systemImage: "chart.bar.fill", value: .stats) {
                NavigationStack { StatsView() }
            }
            Tab("Settings", systemImage: "gearshape.fill", value: .settings) {
                NavigationStack { SettingsView() }
            }
        }
        .tint(theme.colors.primary)
        .onAppear { appState.configure(with: modelContext) }
    }
}
