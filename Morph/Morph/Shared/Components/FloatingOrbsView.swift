import SwiftUI

struct FloatingOrbsView: View {
    @Environment(\.theme) private var theme
    @State private var animate = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(0..<6, id: \.self) { i in
                    Circle()
                        .fill(orbColor(i).opacity(0.06))
                        .frame(width: orbSize(i), height: orbSize(i))
                        .blur(radius: orbSize(i) * 0.3)
                        .offset(
                            x: animate ? orbEndX(i, in: geo.size) : orbStartX(i, in: geo.size),
                            y: animate ? orbEndY(i, in: geo.size) : orbStartY(i, in: geo.size)
                        )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 8).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
        .allowsHitTesting(false)
    }

    private func orbColor(_ i: Int) -> Color {
        [theme.colors.accent, theme.colors.secondary, theme.colors.primary,
         .cyan, .blue, theme.colors.accent][i % 6]
    }

    private func orbSize(_ i: Int) -> CGFloat {
        [80, 120, 60, 100, 70, 90][i % 6]
    }

    private func orbStartX(_ i: Int, in s: CGSize) -> CGFloat {
        [-0.3, 0.35, -0.2, 0.4, -0.4, 0.25][i % 6] * s.width * 0.8
    }

    private func orbEndX(_ i: Int, in s: CGSize) -> CGFloat {
        [-0.3, 0.35, -0.2, 0.4, -0.4, 0.25][i % 6] * s.width
    }

    private func orbStartY(_ i: Int, in s: CGSize) -> CGFloat {
        [-0.3, 0.15, 0.35, -0.2, 0.0, -0.35][i % 6] * s.height * 0.7
    }

    private func orbEndY(_ i: Int, in s: CGSize) -> CGFloat {
        [-0.3, 0.15, 0.35, -0.2, 0.0, -0.35][i % 6] * s.height
    }
}
