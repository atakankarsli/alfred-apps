import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.theme) private var theme
    @Environment(AppState.self) private var appState
    @Query private var settings: [SettingsRecord]

    private var record: SettingsRecord? { settings.first }

    var body: some View {
        ZStack {
            theme.gradient.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 16) {
                    Text("Settings")
                        .font(.title.weight(.bold))
                        .foregroundStyle(theme.colors.text)
                        .padding(.top)

                    GlassCard {
                        VStack(spacing: 16) {
                            settingsToggle("Sound Effects", icon: "speaker.wave.2.fill", isOn: Binding(
                                get: { record?.soundEffects ?? true },
                                set: { record?.soundEffects = $0 }
                            ))
                            Divider().foregroundStyle(theme.colors.cardBorder)
                            settingsToggle("Haptics", icon: "iphone.radiowaves.left.and.right", isOn: Binding(
                                get: { record?.haptics ?? true },
                                set: { record?.haptics = $0; HapticsService.configure(enabled: $0) }
                            ))
                        }
                    }

                    GlassCard {
                        Button {
                            appState.navigate(to: .themePicker)
                        } label: {
                            HStack {
                                Image(systemName: "paintpalette.fill")
                                    .foregroundStyle(theme.colors.primary)
                                Text("Theme")
                                    .foregroundStyle(theme.colors.text)
                                Spacer()
                                Text(Themes.theme(for: appState.currentThemeId).name)
                                    .foregroundStyle(theme.colors.textSecondary)
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundStyle(theme.colors.textMuted)
                            }
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Rune")
                                .font(.headline)
                                .foregroundStyle(theme.colors.text)
                            Text("Ancient Script Decoder")
                                .font(.subheadline)
                                .foregroundStyle(theme.colors.textSecondary)
                            Text("Version 1.0")
                                .font(.caption)
                                .foregroundStyle(theme.colors.textMuted)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button { appState.pop() } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(theme.colors.text)
                }
            }
        }
    }

    private func settingsToggle(_ title: String, icon: String, isOn: Binding<Bool>) -> some View {
        Toggle(isOn: isOn) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundStyle(theme.colors.primary)
                Text(title)
                    .foregroundStyle(theme.colors.text)
            }
        }
        .tint(theme.colors.primary)
    }
}
