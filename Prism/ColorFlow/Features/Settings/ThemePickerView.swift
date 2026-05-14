import SwiftUI
import SwiftData

struct ThemePickerView: View {
    @Environment(\.theme) private var theme
    @Environment(AppState.self) private var appState
    @Query private var settings: [SettingsRecord]

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Section {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(Themes.lightThemes) { t in
                            themeCard(t)
                        }
                    }
                } header: {
                    Text("Light")
                        .font(.headline)
                        .primaryText()
                }

                Section {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(Themes.darkThemes) { t in
                            themeCard(t)
                        }
                    }
                } header: {
                    Text("Dark")
                        .font(.headline)
                        .primaryText()
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .themedBackground()
        .navigationTitle("Themes")
    }

    private func themeCard(_ t: Theme) -> some View {
        let isSelected = settings.first?.currentTheme == t.id

        return Button {
            HapticsService.selection()
            settings.first?.currentTheme = t.id
            appState.currentThemeId = t.id
        } label: {
            VStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(t.gradient)
                    .frame(height: 80)
                    .overlay {
                        HStack(spacing: 4) {
                            Circle().fill(t.colors.primary).frame(width: 16, height: 16)
                            Circle().fill(t.colors.secondary).frame(width: 16, height: 16)
                            Circle().fill(t.colors.accent).frame(width: 16, height: 16)
                        }
                    }
                    .overlay {
                        if isSelected {
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(t.colors.primary, lineWidth: 3)
                        }
                    }
                    .clipShape(.rect(cornerRadius: 12))

                Text(t.name)
                    .font(.caption.bold())
                    .primaryText()
            }
        }
        .buttonStyle(.plain)
    }
}
