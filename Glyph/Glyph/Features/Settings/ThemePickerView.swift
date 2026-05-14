import SwiftUI
import SwiftData

struct ThemePickerView: View {
    @Environment(\.theme) private var theme
    @Environment(AppState.self) private var appState
    @Query private var settings: [SettingsRecord]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                themeSection(title: "Light Themes", themes: Themes.lightThemes)
                themeSection(title: "Dark Themes", themes: Themes.darkThemes)
            }
            .padding(16)
        }
        .themedBackground()
        .navigationTitle("Themes")
    }

    private func themeSection(title: String, themes: [Theme]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .primaryText()

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 90), spacing: 12)], spacing: 12) {
                ForEach(themes) { t in
                    themeCard(t)
                }
            }
        }
    }

    private func themeCard(_ t: Theme) -> some View {
        let isSelected = appState.currentThemeId == t.id

        return Button {
            HapticsService.selection()
            appState.currentThemeId = t.id
            settings.first?.currentTheme = t.id
        } label: {
            VStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(LinearGradient(colors: t.gradientColors, startPoint: .top, endPoint: .bottom))
                        .frame(height: 56)
                        .overlay {
                            Image(systemName: t.iconName)
                                .font(.system(size: 22))
                                .foregroundStyle(t.colors.accent)
                        }
                    if isSelected {
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(t.colors.accent, lineWidth: 2.5)
                            .frame(height: 56)
                    }
                }
                Text(t.name)
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
                    .foregroundStyle(isSelected ? theme.colors.accent : theme.colors.textSecondary)
            }
        }
        .buttonStyle(BounceButtonStyle())
    }
}
