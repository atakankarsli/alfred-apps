import SwiftUI
import SwiftData

struct ThemePickerView: View {
    @Environment(\.theme) var theme
    @Environment(AppState.self) var appState
    @Query var settings: [SettingsRecord]

    var body: some View {
        ZStack {
            FloatingOrbsView()
            ScrollView {
                VStack(spacing: 16) {
                    Text("Themes")
                        .font(.title.bold())
                        .foregroundStyle(theme.colors.text)
                        .padding(.top)

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(Themes.all, id: \.id) { t in
                            let isSelected = appState.selectedThemeId == t.id
                            Button {
                                appState.selectedThemeId = t.id
                                settings.first?.selectedThemeId = t.id
                            } label: {
                                VStack(spacing: 8) {
                                    Circle()
                                        .fill(t.colors.primary)
                                        .frame(width: 40, height: 40)
                                        .overlay {
                                            Image(systemName: t.iconName)
                                                .font(.body)
                                                .foregroundStyle(t.colors.textOnPrimary)
                                        }
                                    Text(t.name)
                                        .font(.caption.bold())
                                        .foregroundStyle(isSelected ? theme.colors.primary : theme.colors.text)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(isSelected ? theme.colors.cardSelected : theme.colors.cardBackground)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .strokeBorder(isSelected ? theme.colors.primary : theme.colors.cardHighlight, lineWidth: isSelected ? 2 : 1)
                                        )
                                )
                            }
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
}
