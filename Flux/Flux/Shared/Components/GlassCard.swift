import SwiftUI

struct GlassCard<Content: View>: View {
    @Environment(\.theme) private var theme
    let content: () -> Content
    init(@ViewBuilder content: @escaping () -> Content) { self.content = content }
    var body: some View {
        if #available(iOS 26, *) {
            content().padding(16).glassEffect()
        } else {
            content().padding(16)
                .background {
                    RoundedRectangle(cornerRadius: 16).fill(theme.colors.surface.opacity(0.4))
                        .overlay { RoundedRectangle(cornerRadius: 16).strokeBorder(theme.colors.boardBorder.opacity(0.12), lineWidth: 1) }
                }
        }
    }
}
