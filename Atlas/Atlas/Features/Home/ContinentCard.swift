import SwiftUI

struct ContinentCard: View {
    @Environment(\.theme) private var theme
    let continent: Continent

    var body: some View {
        GlassCard {
            HStack(spacing: 16) {
                Image(systemName: continent.icon)
                    .font(.title)
                    .foregroundStyle(continent.color)
                    .frame(width: 44)
                VStack(alignment: .leading, spacing: 4) {
                    Text(continent.displayName).font(.headline).primaryText()
                    Text(continent.subtitle).font(.subheadline).secondaryText()
                }
                Spacer()
                Text("\(Countries.forContinent(continent.rawValue).count)")
                    .font(.caption.bold())
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(continent.color.opacity(0.15))
                    .clipShape(Capsule())
                    .foregroundStyle(continent.color)
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(theme.colors.textMuted)
            }
        }
    }
}
