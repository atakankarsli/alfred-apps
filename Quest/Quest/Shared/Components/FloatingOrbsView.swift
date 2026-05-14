import SwiftUI

struct FloatingOrbsView: View {
    @Environment(\.theme) private var theme
    @State private var animate = false
    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(0..<6, id: \.self) { i in
                    Circle().fill(orbColor(i).opacity(0.06)).frame(width: orbSize(i), height: orbSize(i))
                        .blur(radius: orbSize(i) * 0.3)
                        .offset(x: animate ? endX(i, geo.size) : startX(i, geo.size), y: animate ? endY(i, geo.size) : startY(i, geo.size))
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear { withAnimation(.easeInOut(duration: 8).repeatForever(autoreverses: true)) { animate = true } }
        .allowsHitTesting(false)
    }
    private func orbColor(_ i: Int) -> Color { [theme.colors.accent, theme.colors.secondary, theme.colors.primary, .orange, .purple, theme.colors.accent][i % 6] }
    private func orbSize(_ i: Int) -> CGFloat { [80, 120, 60, 100, 70, 90][i % 6] }
    private func startX(_ i: Int, _ s: CGSize) -> CGFloat { [-0.3, 0.35, -0.2, 0.4, -0.4, 0.25][i % 6] * s.width * 0.8 }
    private func endX(_ i: Int, _ s: CGSize) -> CGFloat { [-0.3, 0.35, -0.2, 0.4, -0.4, 0.25][i % 6] * s.width }
    private func startY(_ i: Int, _ s: CGSize) -> CGFloat { [-0.3, 0.15, 0.35, -0.2, 0.0, -0.35][i % 6] * s.height * 0.7 }
    private func endY(_ i: Int, _ s: CGSize) -> CGFloat { [-0.3, 0.15, 0.35, -0.2, 0.0, -0.35][i % 6] * s.height }
}
