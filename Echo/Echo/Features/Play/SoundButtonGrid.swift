import SwiftUI

struct SoundButtonGrid: View {
    @Environment(\.theme) private var theme
    let buttonCount: Int
    let activeButton: Int
    let realm: SonicRealm
    let isEnabled: Bool
    let onTap: (Int) -> Void

    private let buttonColors: [Color] = [
        Color(hex: "FF4444"), Color(hex: "44FF44"), Color(hex: "4444FF"), Color(hex: "FFFF44"),
        Color(hex: "FF44FF"), Color(hex: "44FFFF"), Color(hex: "FF8844"), Color(hex: "88FF44")
    ]

    var body: some View {
        let columns = buttonCount <= 4
            ? [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]
            : Array(repeating: GridItem(.flexible(), spacing: 10), count: min(4, buttonCount))

        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(0..<buttonCount, id: \.self) { index in
                soundButton(index)
            }
        }
    }

    private func soundButton(_ index: Int) -> some View {
        let isActive = activeButton == index
        let color = buttonColors[index % buttonColors.count]

        return Button {
            guard isEnabled else { return }
            onTap(index)
        } label: {
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    RadialGradient(
                        colors: [
                            color.opacity(isActive ? 1.0 : 0.4),
                            color.opacity(isActive ? 0.6 : 0.15)
                        ],
                        center: .center, startRadius: 0, endRadius: 60
                    )
                )
                .frame(height: buttonCount <= 4 ? 90 : 70)
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(color.opacity(isActive ? 0.8 : 0.3), lineWidth: isActive ? 3 : 1)
                }
                .shadow(color: isActive ? color.opacity(0.6) : .clear, radius: 12)
                .scaleEffect(isActive ? 1.05 : 1.0)
                .animation(.easeOut(duration: 0.15), value: isActive)
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
    }
}
