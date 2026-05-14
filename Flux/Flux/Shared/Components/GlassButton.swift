import SwiftUI

struct GlassButton: View {
    @Environment(\.theme) private var theme
    let title: String; let icon: String?; let style: Style; let action: () -> Void
    enum Style { case primary, secondary, subtle }
    init(_ title: String, icon: String? = nil, style: Style = .primary, action: @escaping () -> Void) {
        self.title = title; self.icon = icon; self.style = style; self.action = action
    }
    var body: some View {
        if #available(iOS 26, *) {
            Button(action: action) { buttonLabel }.buttonStyle(.glassProminent)
        } else {
            Button(action: action) { buttonLabel.foregroundStyle(fgColor).background { bg }.clipShape(.capsule) }
                .buttonStyle(ScaleButtonStyle())
        }
    }
    private var buttonLabel: some View {
        HStack(spacing: 8) {
            if let icon { Image(systemName: icon).font(.body.weight(.medium)) }
            Text(title).fontWeight(.semibold)
        }
        .frame(maxWidth: style == .subtle ? nil : .infinity)
        .padding(.horizontal, style == .subtle ? 16 : 24)
        .padding(.vertical, style == .subtle ? 10 : 14)
    }
    private var fgColor: Color {
        switch style { case .primary: theme.colors.textOnPrimary; case .secondary: theme.colors.primary; case .subtle: theme.colors.textSecondary }
    }
    @ViewBuilder private var bg: some View {
        switch style {
        case .primary: Capsule().fill(theme.colors.primary).overlay { Capsule().fill(LinearGradient(colors: [.white.opacity(0.2), .clear], startPoint: .top, endPoint: .bottom)) }
        case .secondary: Capsule().fill(.ultraThinMaterial).overlay { Capsule().strokeBorder(theme.colors.primary.opacity(0.3), lineWidth: 1) }
        case .subtle: Capsule().fill(theme.colors.surface.opacity(0.5))
        }
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.scaleEffect(configuration.isPressed ? 0.96 : 1).opacity(configuration.isPressed ? 0.9 : 1)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}
struct BounceButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.6), value: configuration.isPressed)
    }
}
