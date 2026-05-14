import SwiftUI
import SwiftData

@main
struct AetherApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [
            SettingsRecord.self,
            StatsRecord.self,
            LevelRecord.self,
            AchievementRecord.self,
        ])
    }
}
