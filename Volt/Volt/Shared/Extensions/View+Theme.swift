import SwiftUI

extension View {
    func themedBackground() -> some View { modifier(ThemedBackgroundModifier()) }
    func primaryText() -> some View { modifier(PrimaryTextModifier()) }
    func secondaryText() -> some View { modifier(SecondaryTextModifier()) }
    func mutedText() -> some View { modifier(MutedTextModifier()) }
}

private struct ThemedBackgroundModifier: ViewModifier {
    @Environment(\.theme) private var theme
    func body(content: Content) -> some View { content.background(theme.gradient) }
}
private struct PrimaryTextModifier: ViewModifier {
    @Environment(\.theme) private var theme
    func body(content: Content) -> some View { content.foregroundStyle(theme.colors.text) }
}
private struct SecondaryTextModifier: ViewModifier {
    @Environment(\.theme) private var theme
    func body(content: Content) -> some View { content.foregroundStyle(theme.colors.textSecondary) }
}
private struct MutedTextModifier: ViewModifier {
    @Environment(\.theme) private var theme
    func body(content: Content) -> some View { content.foregroundStyle(theme.colors.textMuted) }
}
