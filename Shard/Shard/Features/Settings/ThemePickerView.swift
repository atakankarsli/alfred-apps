import SwiftUI
import SwiftData

struct ThemePickerView: View {
    @Environment(\.theme) private var theme
    @Environment(AppState.self) private var appState
    @Query private var settings: [SettingsRecord]

    private var currentSettings: SettingsRecord? { settings.first }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(Themes.all) { t in
                    themeCard(t)
                }
            }
            .padding(16)
        }
        .themedBackground()
        .navigationTitle("Themes")
    }

    private func themeCard(_ t: Theme) -> some View {
        let selected = (currentSettings?.currentTheme ?? "amethyst") == t.id
        return Button {
            currentSettings?.currentTheme = t.id
            appState.currentThemeId = t.id
            HapticsService.selection()
        } label: {
            VStack(spacing: 8) {
                HStack(spacing: 4) {
                    Circle().fill(t.colors.accent).frame(width: 16, height: 16)
                    Circle().fill(t.colors.secondary).frame(width: 16, height: 16)
                    Circle().fill(t.colors.primary).frame(width: 16, height: 16)
                }
                Text(t.name)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundStyle(selected ? t.colors.accent : theme.colors.text)
            }
            .frame(maxWidth: .infinity)
            .padding(16)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(selected ? t.colors.accent.opacity(0.1) : theme.colors.surface.opacity(0.3))
                    .overlay {
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(selected ? t.colors.accent.opacity(0.4) : theme.colors.cardBorder.opacity(0.1), lineWidth: selected ? 2 : 1)
                    }
            }
        }
        .buttonStyle(.plain)
    }
}
