import SwiftUI

struct FloatingOrbsView: View {
    @Environment(\.theme) private var theme
    @State private var animate = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(0..<5, id: \.self) { i in
                    let d = Double(i)
                    Circle()
                        .fill(theme.colors.accent.opacity(0.04 + d * 0.008))
                        .frame(width: 60 + d * 20, height: 60 + d * 20)
                        .offset(
                            x: animate ? CGFloat(sin(d * 1.3) * 40) : CGFloat(cos(d * 0.9) * 30),
                            y: animate ? CGFloat(cos(d * 1.1) * 50) : CGFloat(sin(d * 0.7) * 40)
                        )
                        .position(x: geo.size.width * (0.2 + d * 0.15), y: geo.size.height * (0.2 + d * 0.12))
                }
            }
        }
        .allowsHitTesting(false)
        .onAppear {
            withAnimation(.easeInOut(duration: 6).repeatForever(autoreverses: true)) { animate = true }
        }
    }
}
