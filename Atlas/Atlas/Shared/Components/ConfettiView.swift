import SwiftUI

struct ConfettiView: View {
    @Environment(\.theme) private var theme
    @State private var particles: [(id: Int, x: CGFloat, y: CGFloat, rot: Double, scale: CGFloat, color: Color)] = []
    @State private var animate = false
    var body: some View {
        GeometryReader { geo in
            ForEach(particles, id: \.id) { p in
                Circle().fill(p.color).frame(width: 8, height: 8).scaleEffect(animate ? 0 : p.scale)
                    .rotationEffect(.degrees(animate ? p.rot + 360 : p.rot))
                    .position(x: p.x, y: animate ? geo.size.height + 20 : p.y)
            }
        }
        .onAppear {
            let c = [theme.colors.primary, theme.colors.secondary, theme.colors.accent, .yellow, .green]
            particles = (0..<40).map { i in (id: i, x: CGFloat.random(in: 0...400), y: CGFloat.random(in: -50...0), rot: Double.random(in: 0...360), scale: CGFloat.random(in: 0.5...1.5), color: c[i % c.count]) }
            withAnimation(.easeOut(duration: 2.0)) { animate = true }
        }.allowsHitTesting(false)
    }
}
