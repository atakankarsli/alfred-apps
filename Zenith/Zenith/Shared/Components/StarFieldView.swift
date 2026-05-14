import SwiftUI

struct StarFieldView: View {
    @Environment(\.theme) private var theme
    @State private var twinklePhase = false

    var body: some View {
        Canvas { context, size in
            for i in 0..<80 {
                let seed = Double(i * 1327 + 42)
                let x = (seed.truncatingRemainder(dividingBy: size.width * 100)) / 100
                let y = (seed * 1.618).truncatingRemainder(dividingBy: Double(size.height) * 100) / 100
                let brightness = (sin(seed * 2.71) + 1) / 2 * 0.6 + 0.2
                let radius = brightness * 1.8 + 0.3

                context.opacity = brightness * (twinklePhase ? 0.8 : 1.0)
                context.fill(
                    Path(ellipseIn: CGRect(x: x - radius, y: y - radius, width: radius * 2, height: radius * 2)),
                    with: .color(.white)
                )
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                twinklePhase = true
            }
        }
        .allowsHitTesting(false)
    }
}
