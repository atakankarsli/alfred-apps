import SwiftUI
import SwiftData

@main
struct HelixApp: App {
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
