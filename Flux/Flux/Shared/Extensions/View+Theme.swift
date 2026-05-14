import SwiftUI

extension View {
    func themedBackground() -> some View { modifier(ThemedBackground()) }
    func primaryText() -> some View { modifier(PrimaryText()) }
    func secondaryText() -> some View { modifier(SecondaryText()) }
    func mutedText() -> some View { modifier(MutedText()) }
}

private struct ThemedBackground: ViewModifier {
    @Environment(\.theme) var theme
    func body(content: Content) -> some View {
        content.foregroundStyle(theme.colors.text)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(theme.gradient.ignoresSafeArea())
    }
}
private struct PrimaryText: ViewModifier {
    @Environment(\.theme) var theme
    func body(content: Content) -> some View { content.foregroundStyle(theme.colors.text) }
}
private struct SecondaryText: ViewModifier {
    @Environment(\.theme) var theme
    func body(content: Content) -> some View { content.foregroundStyle(theme.colors.textSecondary) }
}
private struct MutedText: ViewModifier {
    @Environment(\.theme) var theme
    func body(content: Content) -> some View { content.foregroundStyle(theme.colors.textMuted) }
}
