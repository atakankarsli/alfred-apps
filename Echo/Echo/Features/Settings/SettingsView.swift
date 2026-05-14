import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.theme) private var theme
    @Environment(AppState.self) private var appState
    @Environment(\.modelContext) private var modelContext
    @Query private var settings: [SettingsRecord]

    private var currentSettings: SettingsRecord? { settings.first }

    var body: some View {
        List {
            feedbackSection
            appearanceSection
            notificationSection
            dataSection
        }
        .scrollContentBackground(.hidden)
        .themedBackground()
        .navigationTitle("Settings")
    }

    private var feedbackSection: some View {
        Section("Feedback") {
            Toggle("Sound Effects", isOn: soundBinding).listRowBackground(theme.colors.surface.opacity(0.3))
            Toggle("Haptics", isOn: hapticsBinding).listRowBackground(theme.colors.surface.opacity(0.3))
        }
    }

    private var appearanceSection: some View {
        Section("Appearance") {
            NavigationLink(value: Route.themePicker) {
                HStack {
                    Text("Theme"); Spacer()
                    Text(Themes.theme(for: currentSettings?.currentTheme ?? "neongrid").name).foregroundStyle(theme.colors.textSecondary)
                }
            }
            .listRowBackground(theme.colors.surface.opacity(0.3))
        }
    }

    private var notificationSection: some View {
        Section("Notifications") {
            Toggle("Daily Reminder", isOn: dailyReminderBinding).listRowBackground(theme.colors.surface.opacity(0.3))
        }
    }

    private var dataSection: some View {
        Section("Data") {
            Button("Reset Progress", role: .destructive) {
                HapticsService.heavy()
                resetProgress()
            }
            .listRowBackground(theme.colors.surface.opacity(0.3))
        }
    }

    private var soundBinding: Binding<Bool> {
        Binding(
            get: { currentSettings?.soundEffects ?? true },
            set: { currentSettings?.soundEffects = $0; ToneGenerator.shared.configure(enabled: $0); HapticsService.selection() }
        )
    }

    private var hapticsBinding: Binding<Bool> {
        Binding(
            get: { currentSettings?.haptics ?? true },
            set: { currentSettings?.haptics = $0; HapticsService.configure(enabled: $0); HapticsService.selection() }
        )
    }

    private var dailyReminderBinding: Binding<Bool> {
        Binding(
            get: { currentSettings?.dailyReminderEnabled ?? false },
            set: { newValue in
                currentSettings?.dailyReminderEnabled = newValue
                HapticsService.selection()
                if newValue {
                    Task {
                        let granted = await NotificationService.requestPermission()
                        if granted {
                            NotificationService.scheduleDailyReminder(
                                hour: currentSettings?.dailyReminderHour ?? 9,
                                minute: currentSettings?.dailyReminderMinute ?? 0
                            )
                        }
                    }
                } else { NotificationService.cancelAll() }
            }
        )
    }

    private func resetProgress() {
        if let stat = (try? modelContext.fetch(FetchDescriptor<StatsRecord>()))?.first {
            modelContext.delete(stat)
            modelContext.insert(StatsRecord())
        }
    }
}
