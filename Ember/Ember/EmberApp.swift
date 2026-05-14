import SwiftUI
import SwiftData

@main
struct EmberApp: App {
    @State private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appState)
        }
        .modelContainer(for: [
            SettingsRecord.self,
            StatsRecord.self,
            LevelRecord.self,
            AchievementRecord.self,
        ])
    }
}
