import SwiftUI

struct GlassCard<Content: View>: View {
    @Environment(\.theme) private var theme

    let content: () -> Content
    var padding: CGFloat = 16
    var cornerRadius: CGFloat = 16

    init(padding: CGFloat = 16, cornerRadius: CGFloat = 16, @ViewBuilder content: @escaping () -> Content) {
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.content = content
    }

    var body: some View {
        if #available(iOS 26, *) {
            content()
                .padding(padding)
                .glassEffect(.regular, in: .rect(cornerRadius: cornerRadius))
        } else {
            content()
                .padding(padding)
                .background {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(.ultraThinMaterial)
                        .overlay {
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .fill(theme.colors.surface.opacity(0.3))
                        }
                }
                .overlay {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(theme.isDark ? 0.15 : 0.4),
                                    Color.white.opacity(theme.isDark ? 0.05 : 0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                }
                .clipShape(.rect(cornerRadius: cornerRadius))
                .shadow(color: .black.opacity(theme.isDark ? 0.3 : 0.08), radius: 8, x: 0, y: 4)
        }
    }
}
