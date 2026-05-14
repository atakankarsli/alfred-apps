import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.theme) var theme
    @Environment(AppState.self) var appState
    @Query var settings: [SettingsRecord]

    var body: some View {
        let setting = settings.first
        ZStack {
            FloatingOrbsView()
            ScrollView {
                VStack(spacing: 16) {
                    Text("Settings")
                        .font(.title.bold())
                        .foregroundStyle(theme.colors.text)
                        .padding(.top)

                    GlassCard {
                        VStack(spacing: 16) {
                            settingsRow(icon: "paintpalette.fill", title: "Theme") {
                                appState.navigate(to: .themePicker)
                            }
                            Divider().overlay(theme.colors.textMuted)
                            toggleRow(icon: "hand.tap.fill", title: "Haptics", isOn: setting?.hapticsEnabled ?? true) {
                                setting?.hapticsEnabled = $0
                            }
                            Divider().overlay(theme.colors.textMuted)
                            toggleRow(icon: "speaker.wave.2.fill", title: "Sound", isOn: setting?.soundEnabled ?? true) {
                                setting?.soundEnabled = $0
                            }
                        }
                    }

                    GlassCard {
                        VStack(spacing: 12) {
                            HStack {
                                Image(systemName: "info.circle.fill")
                                    .foregroundStyle(theme.colors.primary)
                                Text("Aether v1.0")
                                    .foregroundStyle(theme.colors.text)
                                Spacer()
                            }
                            .font(.subheadline)
                        }
                    }
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button { appState.path.removeLast() } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(theme.colors.text)
                }
            }
        }
    }

    private func settingsRow(icon: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(theme.colors.primary)
                Text(title)
                    .foregroundStyle(theme.colors.text)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(theme.colors.textMuted)
            }
            .font(.subheadline)
        }
    }

    private func toggleRow(icon: String, title: String, isOn: Bool, onToggle: @escaping (Bool) -> Void) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(theme.colors.primary)
            Text(title)
                .foregroundStyle(theme.colors.text)
            Spacer()
            Toggle("", isOn: Binding(get: { isOn }, set: onToggle))
                .tint(theme.colors.primary)
        }
        .font(.subheadline)
    }
}
