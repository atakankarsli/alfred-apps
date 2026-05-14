import SwiftUI

extension View {
    func themedBackground() -> some View { modifier(ThemedBG()) }
    func primaryText() -> some View { modifier(PrimaryTxt()) }
    func secondaryText() -> some View { modifier(SecondaryTxt()) }
    func mutedText() -> some View { modifier(MutedTxt()) }
}
private struct ThemedBG: ViewModifier {
    @Environment(\.theme) var theme
    func body(content: Content) -> some View {
        content.foregroundStyle(theme.colors.text).frame(maxWidth: .infinity, maxHeight: .infinity).background(theme.gradient.ignoresSafeArea())
    }
}
private struct PrimaryTxt: ViewModifier { @Environment(\.theme) var theme; func body(content: Content) -> some View { content.foregroundStyle(theme.colors.text) } }
private struct SecondaryTxt: ViewModifier { @Environment(\.theme) var theme; func body(content: Content) -> some View { content.foregroundStyle(theme.colors.textSecondary) } }
private struct MutedTxt: ViewModifier { @Environment(\.theme) var theme; func body(content: Content) -> some View { content.foregroundStyle(theme.colors.textMuted) } }
