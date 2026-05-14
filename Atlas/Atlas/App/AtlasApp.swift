import SwiftUI
import SwiftData

@main
struct AtlasApp: App {
    @State private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(appState)
                .theme(appState.selectedTheme)
        }
        .modelContainer(for: [UserProfileModel.self, QuizRecordModel.self, AchievementRecordModel.self])
    }
}
