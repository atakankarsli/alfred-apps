import SwiftUI
import SwiftData

@main
struct FluxApp: App {
    var body: some Scene {
        WindowGroup { ContentView() }
            .modelContainer(for: [SettingsRecord.self, StatsRecord.self, AchievementRecord.self])
    }
}
