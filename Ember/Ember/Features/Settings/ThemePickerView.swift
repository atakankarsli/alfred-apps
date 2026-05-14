import SwiftUI
import SwiftData

struct ThemePickerView: View {
    @Environment(\.theme) private var theme
    @Environment(AppState.self) private var appState
    @Query private var settings: [SettingsRecord]

    var body: some View {
        ZStack {
            theme.gradient.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 16) {
                    Text("Themes")
                        .font(.title.weight(.bold))
                        .foregroundStyle(theme.colors.text)
                        .padding(.top)

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(Themes.all) { t in
                            themeCard(t)
                        }
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

    private func themeCard(_ t: Theme) -> some View {
        let isSelected = appState.currentThemeId == t.id
        return Button {
            appState.currentThemeId = t.id
            settings.first?.currentTheme = t.id
        } label: {
            VStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(LinearGradient(colors: t.gradientColors, startPoint: .top, endPoint: .bottom))
                    .frame(height: 80)
                    .overlay {
                        Image(systemName: t.iconName)
                            .font(.title2)
                            .foregroundStyle(t.colors.primary)
                    }
                    .overlay {
                        if isSelected {
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(theme.colors.primary, lineWidth: 2)
                        }
                    }

                Text(t.name)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(isSelected ? theme.colors.primary : theme.colors.textSecondary)
            }
        }
        .buttonStyle(ScaleButtonStyle())
    }
}
