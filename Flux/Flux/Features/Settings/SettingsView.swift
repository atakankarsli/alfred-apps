import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.theme) private var theme
    @Environment(\.modelContext) private var context
    @Environment(AppState.self) private var appState
    @Query private var settingsRecords: [SettingsRecord]
    private var settings: SettingsRecord? { settingsRecords.first }

    var body: some View {
        ZStack {
            FloatingOrbsView()
            ScrollView {
                VStack(spacing: 16) {
                    GlassCard {
                        VStack(spacing: 16) {
                            toggle("Sound", icon: "speaker.wave.2.fill", isOn: Binding(
                                get: { settings?.soundEnabled ?? true }, set: { settings?.soundEnabled = $0; try? context.save() }))
                            toggle("Haptics", icon: "hand.tap.fill", isOn: Binding(
                                get: { settings?.hapticsEnabled ?? true }, set: { settings?.hapticsEnabled = $0; try? context.save() }))
                            toggle("Notifications", icon: "bell.fill", isOn: Binding(
                                get: { settings?.notificationsEnabled ?? true },
                                set: { v in settings?.notificationsEnabled = v; try? context.save()
                                    if v { NotificationService.scheduleDailyReminder(hour: settings?.reminderHour ?? 8) }
                                }))
                        }
                    }
                    GlassButton("Change Theme", icon: "paintpalette.fill", style: .secondary) { appState.path.append(Route.themePicker) }
                    GlassButton("Reset Progress", icon: "arrow.counterclockwise", style: .subtle) {
                        try? context.delete(model: StatsRecord.self)
                        try? context.delete(model: AchievementRecord.self)
                        try? context.save()
                    }
                }
                .padding()
            }
        }
        .themedBackground()
        .navigationTitle("Settings")
    }

    private func toggle(_ title: String, icon: String, isOn: Binding<Bool>) -> some View {
        HStack {
            Image(systemName: icon).foregroundStyle(theme.colors.primary)
            Text(title).primaryText(); Spacer()
            Toggle("", isOn: isOn).labelsHidden().tint(theme.colors.primary)
        }
    }
}
