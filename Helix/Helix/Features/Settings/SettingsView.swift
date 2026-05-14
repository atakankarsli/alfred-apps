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
                            Button { appState.navigate(to: .themePicker) } label: {
                                HStack {
                                    Image(systemName: "paintpalette.fill")
                                        .foregroundStyle(theme.colors.primary)
                                    Text("Theme")
                                        .foregroundStyle(theme.colors.text)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(theme.colors.textMuted)
                                }
                                .font(.subheadline)
                            }
                            Divider().overlay(theme.colors.textMuted)
                            HStack {
                                Image(systemName: "hand.tap.fill")
                                    .foregroundStyle(theme.colors.primary)
                                Text("Haptics")
                                    .foregroundStyle(theme.colors.text)
                                Spacer()
                                Toggle("", isOn: Binding(get: { setting?.hapticsEnabled ?? true }, set: { setting?.hapticsEnabled = $0 }))
                                    .tint(theme.colors.primary)
                            }
                            .font(.subheadline)
                        }
                    }

                    GlassCard {
                        HStack {
                            Image(systemName: "info.circle.fill")
                                .foregroundStyle(theme.colors.primary)
                            Text("Helix v1.0")
                                .foregroundStyle(theme.colors.text)
                            Spacer()
                        }
                        .font(.subheadline)
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
}
