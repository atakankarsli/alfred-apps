import SwiftUI

struct FloatingOrbsView: View {
    @Environment(\.theme) private var theme
    @State private var phase: CGFloat = 0
    var body: some View {
        Canvas { context, size in
            let t = phase
            for i in 0..<5 {
                let fi = CGFloat(i)
                let x = size.width * (0.2 + 0.6 * (0.5 + 0.5 * sin(t + fi * 1.3)))
                let y = size.height * (0.2 + 0.6 * (0.5 + 0.5 * cos(t * 0.7 + fi * 1.1)))
                let radius: CGFloat = 60 + 30 * sin(t * 0.5 + fi)
                let color = i % 2 == 0 ? theme.colors.primary : theme.colors.secondary
                context.drawLayer { ctx in
                    ctx.opacity = 0.12
                    ctx.fill(Path(ellipseIn: CGRect(x: x - radius, y: y - radius, width: radius * 2, height: radius * 2)), with: .color(color))
                }
            }
        }
        .ignoresSafeArea()
        .onAppear { withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) { phase = .pi * 2 } }
        .allowsHitTesting(false)
    }
}
