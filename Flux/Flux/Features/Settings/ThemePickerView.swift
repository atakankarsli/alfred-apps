import SwiftUI
import SwiftData

struct ThemePickerView: View {
    @Environment(\.theme) private var theme
    @Environment(\.modelContext) private var context
    @Environment(AppState.self) private var appState
    @Query private var settingsRecords: [SettingsRecord]
    private var settings: SettingsRecord? { settingsRecords.first }

    var body: some View {
        ZStack {
            FloatingOrbsView()
            ScrollView {
                VStack(spacing: 20) {
                    section("Dark Themes", Themes.all.filter(\.isDark))
                    section("Light Themes", Themes.all.filter { !$0.isDark })
                }
                .padding()
            }
        }
        .themedBackground()
        .navigationTitle("Themes")
    }

    private func section(_ title: String, _ themes: [Theme]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title).font(.headline).primaryText()
            LazyVGrid(columns: [.init(.flexible()), .init(.flexible())], spacing: 12) {
                ForEach(themes) { t in
                    Button {
                        settings?.themeId = t.id; try? context.save()
                        appState.currentTheme = t; HapticsService.selection()
                    } label: {
                        VStack(spacing: 8) {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(LinearGradient(colors: t.gradientColors, startPoint: .top, endPoint: .bottom))
                                .frame(height: 80)
                                .overlay { Image(systemName: t.iconName).font(.title2).foregroundStyle(t.colors.primary) }
                                .overlay(alignment: .topTrailing) {
                                    if t.id == appState.currentTheme.id {
                                        Image(systemName: "checkmark.circle.fill").foregroundStyle(t.colors.primary).padding(6)
                                    }
                                }
                            Text(t.name).font(.caption.bold()).foregroundStyle(theme.colors.text)
                        }
                        .padding(8)
                        .background(RoundedRectangle(cornerRadius: 16).fill(theme.colors.surface.opacity(0.3)))
                        .overlay { if t.id == appState.currentTheme.id { RoundedRectangle(cornerRadius: 16).strokeBorder(theme.colors.primary, lineWidth: 2) } }
                    }
                    .buttonStyle(ScaleButtonStyle())
                }
            }
        }
    }
}
