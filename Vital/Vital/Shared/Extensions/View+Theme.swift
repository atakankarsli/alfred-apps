import SwiftUI

extension View {
    func themedBackground() -> some View { modifier(ThemedBG()) }
    func primaryText() -> some View { modifier(PrimaryTxt()) }
    func secondaryText() -> some View { modifier(SecondaryTxt()) }
    func mutedText() -> some View { modifier(MutedTxt()) }
}

private struct ThemedBG: ViewModifier { @Environment(\.theme) var t; func body(content: Content) -> some View { content.background(t.gradient) } }
private struct PrimaryTxt: ViewModifier { @Environment(\.theme) var t; func body(content: Content) -> some View { content.foregroundStyle(t.colors.text) } }
private struct SecondaryTxt: ViewModifier { @Environment(\.theme) var t; func body(content: Content) -> some View { content.foregroundStyle(t.colors.textSecondary) } }
private struct MutedTxt: ViewModifier { @Environment(\.theme) var t; func body(content: Content) -> some View { content.foregroundStyle(t.colors.textMuted) } }
