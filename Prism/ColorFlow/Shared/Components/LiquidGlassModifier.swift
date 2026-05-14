import SwiftUI

struct LiquidGlassModifier: ViewModifier {
    @Environment(\.theme) private var theme

    let cornerRadius: CGFloat
    let intensity: Double

    init(cornerRadius: CGFloat = 20, intensity: Double = 1.0) {
        self.cornerRadius = cornerRadius
        self.intensity = intensity
    }

    func body(content: Content) -> some View {
        content
            .background {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.ultraThinMaterial)
                    .opacity(intensity)
            }
            .background {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(theme.colors.surface.opacity(0.2 * intensity))
            }
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                Color.white.opacity((theme.isDark ? 0.12 : 0.35) * intensity),
                                Color.white.opacity((theme.isDark ? 0.04 : 0.08) * intensity)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.5
                    )
            }
            .clipShape(.rect(cornerRadius: cornerRadius))
            .shadow(
                color: Color.black.opacity((theme.isDark ? 0.25 : 0.06) * intensity),
                radius: 6 * intensity,
                x: 0,
                y: 3 * intensity
            )
    }
}

extension View {
    func liquidGlass(cornerRadius: CGFloat = 20, intensity: Double = 1.0) -> some View {
        modifier(LiquidGlassModifier(cornerRadius: cornerRadius, intensity: intensity))
    }
}

#Preview {
    LiquidGlassPreview()
}

private struct LiquidGlassPreview: View {
    var body: some View {
        VStack(spacing: 30) {
            Text("Liquid Glass Effect")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(24)
                .liquidGlass(cornerRadius: 16)

            HStack(spacing: 16) {
                intensityDemo(0.33)
                intensityDemo(0.66)
                intensityDemo(1.0)
            }
        }
        .padding(40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Themes.ocean.gradient)
        .environment(\.theme, Themes.ocean)
    }

    private func intensityDemo(_ intensity: Double) -> some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.clear)
            .frame(width: 80, height: 80)
            .liquidGlass(cornerRadius: 12, intensity: intensity)
            .overlay {
                Text("\(Int(intensity * 100))%")
                    .font(.caption)
            }
    }
}
