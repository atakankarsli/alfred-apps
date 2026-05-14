import SwiftUI

struct FloatingOrbsView: View {
    @Environment(\.theme) private var theme
    @State private var phase: CGFloat = 0
    var body: some View {
        Canvas { context, size in
            for i in 0..<5 {
                let fi = CGFloat(i)
                let x = size.width * (0.2 + 0.6 * (0.5 + 0.5 * sin(phase + fi * 1.3)))
                let y = size.height * (0.2 + 0.6 * (0.5 + 0.5 * cos(phase * 0.7 + fi * 1.1)))
                let r: CGFloat = 60 + 30 * sin(phase * 0.5 + fi)
                context.drawLayer { ctx in
                    ctx.opacity = 0.12
                    ctx.fill(Path(ellipseIn: CGRect(x: x - r, y: y - r, width: r * 2, height: r * 2)),
                             with: .color(i % 2 == 0 ? theme.colors.primary : theme.colors.secondary))
                }
            }
        }.ignoresSafeArea()
        .onAppear { withAnimation(.linear(duration: 20).repeatForever(autoreverses: false)) { phase = .pi * 2 } }
        .allowsHitTesting(false)
    }
}
