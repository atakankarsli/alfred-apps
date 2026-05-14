import SwiftUI

struct GlassButton: View {
    @Environment(\.theme) private var theme

    let title: String
    let icon: String?
    let style: Style
    let action: () -> Void

    enum Style {
        case primary
        case secondary
        case subtle
    }

    init(
        _ title: String,
        icon: String? = nil,
        style: Style = .primary,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.style = style
        self.action = action
    }

    var body: some View {
        if #available(iOS 26, *) {
            glassButton
        } else {
            Button(action: action) {
                HStack(spacing: 8) {
                    if let icon {
                        Image(systemName: icon)
                            .font(.body.weight(.medium))
                    }
                    Text(title)
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: style == .subtle ? nil : .infinity)
                .padding(.horizontal, style == .subtle ? 16 : 24)
                .padding(.vertical, style == .subtle ? 10 : 14)
                .foregroundStyle(foregroundColor)
                .background {
                    backgroundView
                }
                .clipShape(.capsule)
            }
            .buttonStyle(ScaleButtonStyle())
        }
    }

    @available(iOS 26, *)
    private var glassButton: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon {
                    Image(systemName: icon)
                        .font(.body.weight(.medium))
                }
                Text(title)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: style == .subtle ? nil : .infinity)
            .padding(.horizontal, style == .subtle ? 16 : 24)
            .padding(.vertical, style == .subtle ? 10 : 14)
        }
        .buttonStyle(.glassProminent)
    }

    private var foregroundColor: Color {
        switch style {
        case .primary:
            theme.colors.textOnPrimary
        case .secondary:
            theme.colors.primary
        case .subtle:
            theme.colors.textSecondary
        }
    }

    @ViewBuilder
    private var backgroundView: some View {
        switch style {
        case .primary:
            Capsule()
                .fill(theme.colors.primary)
                .overlay {
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.2),
                                    Color.clear
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                }
                .shadow(color: .black.opacity(theme.isDark ? 0.2 : 0.06), radius: 4, y: 2)
        case .secondary:
            Capsule()
                .fill(.ultraThinMaterial)
                .overlay {
                    Capsule()
                        .strokeBorder(theme.colors.primary.opacity(0.3), lineWidth: 1)
                }
        case .subtle:
            Capsule()
                .fill(theme.colors.surface.opacity(0.5))
        }
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .opacity(configuration.isPressed ? 0.9 : 1)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

#Preview {
    VStack(spacing: 20) {
        GlassButton("Start Game", icon: "play.fill", style: .primary) {}
        GlassButton("Continue", icon: "arrow.right", style: .secondary) {}
        GlassButton("Settings", icon: "gearshape", style: .subtle) {}
    }
    .padding(40)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Themes.dawn.gradient)
    .environment(\.theme, Themes.dawn)
}
