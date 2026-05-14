import SwiftUI
import SwiftData

struct RegionMapView: View {
    @Environment(\.theme) private var theme
    @Query private var stats: [StatsRecord]

    private var s: StatsRecord? { stats.first }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(Region.all) { region in
                    regionCard(region)
                }
            }
            .padding(16)
        }
        .themedBackground()
        .navigationTitle("Regions")
    }

    private func regionCard(_ region: Region) -> some View {
        let unlocked = s?.regionsPlayed.contains(region.name) ?? false

        return VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: region.icon)
                    .font(.title2)
                    .foregroundStyle(unlocked ? region.color(theme) : theme.colors.textSecondary.opacity(0.4))
                VStack(alignment: .leading, spacing: 2) {
                    Text(region.name)
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundStyle(unlocked ? theme.colors.text : theme.colors.textSecondary.opacity(0.5))
                    Text("Missions \(region.levelRange.lowerBound + 1)–\(region.levelRange.upperBound)")
                        .font(.system(size: 12, weight: .medium))
                        .mutedText()
                }
                Spacer()
                if unlocked {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundStyle(theme.colors.accent)
                } else {
                    Image(systemName: "lock.fill")
                        .foregroundStyle(theme.colors.textSecondary.opacity(0.3))
                }
            }

            Text(region.description)
                .font(.system(size: 13))
                .secondaryText()

            let missionCount = region.levelRange.upperBound - region.levelRange.lowerBound
            HStack(spacing: 4) {
                ForEach(0..<min(missionCount, 16), id: \.self) { i in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(unlocked ? theme.colors.accent.opacity(0.5) : theme.colors.surface.opacity(0.3))
                        .frame(height: 4)
                }
            }
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(unlocked ? region.color(theme).opacity(0.06) : theme.colors.surface.opacity(0.3))
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(unlocked ? region.color(theme).opacity(0.15) : theme.colors.cardBorder.opacity(0.1), lineWidth: 1)
                }
        }
    }
}
