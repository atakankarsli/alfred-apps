import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.theme) private var theme
    @Query private var profiles: [UserProfileModel]

    private var profile: UserProfileModel? { profiles.first }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                themeSection
                preferencesSection
            }
            .padding()
        }
        .themedBackground()
        .navigationTitle("Settings")
    }

    private var themeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Theme").font(.title3.bold())
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: 12)], spacing: 12) {
                ForEach(Themes.all) { t in
                    themeCard(t)
                }
            }
        }
    }

    private func themeCard(_ t: Theme) -> some View {
        Button { appState.updateTheme(t) } label: {
            VStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(LinearGradient(colors: t.gradientColors, startPoint: .top, endPoint: .bottom))
                    .frame(height: 60)
                    .overlay {
                        Image(systemName: t.iconName)
                            .foregroundStyle(t.colors.primary)
                    }
                    .overlay {
                        if t.id == theme.id {
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(theme.colors.primary, lineWidth: 2)
                        }
                    }
                Text(t.name)
                    .font(.caption)
                    .foregroundStyle(t.id == theme.id ? theme.colors.primary : theme.colors.textSecondary)
            }
        }
        .buttonStyle(ScaleButtonStyle())
    }

    private var preferencesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Preferences").font(.title3.bold())
            GlassCard {
                VStack(spacing: 0) {
                    toggleRow("Sound Effects", systemImage: "speaker.wave.2.fill", isOn: profile?.soundEnabled ?? true) { val in
                        appState.ensureProfile().soundEnabled = val
                    }
                    Divider().padding(.vertical, 4)
                    toggleRow("Haptics", systemImage: "hand.tap.fill", isOn: profile?.hapticsEnabled ?? true) { val in
                        appState.ensureProfile().hapticsEnabled = val
                    }
                }
            }
        }
    }

    @MainActor private func toggleRow(_ label: String, systemImage: String, isOn: Bool, action: @escaping @MainActor (Bool) -> Void) -> some View {
        HStack {
            Image(systemName: systemImage).foregroundStyle(theme.colors.primary)
            Text(label).font(.subheadline)
            Spacer()
            Toggle("", isOn: Binding(get: { isOn }, set: { val in MainActor.assumeIsolated { action(val) } }))
                .labelsHidden()
                .tint(theme.colors.primary)
        }
    }
}
