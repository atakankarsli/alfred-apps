import SwiftUI
import SwiftData

struct GalleryView: View {
    @Environment(\.theme) private var theme
    @Query private var stats: [StatsRecord]

    private var bestStars: [Int: Int] { stats.first?.bestStars ?? [:] }
    private let columns = [GridItem(.adaptive(minimum: 80), spacing: 10)]

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                galleryHeader

                ForEach(Season.all) { season in
                    seasonGallerySection(season)
                }
            }
            .padding(16)
        }
        .themedBackground()
        .navigationTitle("Gallery")
    }

    private var galleryHeader: some View {
        let completed = bestStars.count

        return VStack(spacing: 8) {
            ZStack {
                Circle().fill(theme.colors.accent.opacity(0.1)).frame(width: 60, height: 60)
                Image(systemName: "photo.on.rectangle.angled")
                    .font(.system(size: 28)).foregroundStyle(theme.colors.accent)
            }
            Text("\(completed) Creations")
                .font(.system(size: 24, weight: .black, design: .rounded)).primaryText()
            ProgressView(value: Double(completed), total: Double(MuseConfig.totalChallenges))
                .tint(theme.colors.accent)
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(theme.colors.surface.opacity(0.4))
                .overlay { RoundedRectangle(cornerRadius: 16).strokeBorder(theme.colors.cardBorder.opacity(0.12), lineWidth: 1) }
        }
    }

    private func seasonGallerySection(_ season: Season) -> some View {
        let completedInSeason = season.challengeRange.filter { bestStars[$0] != nil }

        return VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: season.icon)
                    .foregroundStyle(Color(hex: season.accentHex))
                Text(season.name)
                    .font(.system(size: 16, weight: .bold, design: .rounded)).primaryText()
                Spacer()
                Text("\(completedInSeason.count)/\(season.challengeCount)")
                    .font(.system(size: 13, weight: .medium)).secondaryText()
            }

            if completedInSeason.isEmpty {
                Text("No creations yet")
                    .font(.system(size: 13)).mutedText()
                    .frame(maxWidth: .infinity).padding(.vertical, 20)
            } else {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(completedInSeason, id: \.self) { index in
                        galleryTile(index: index, season: season)
                    }
                }
            }
        }
        .padding(14)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(theme.colors.surface.opacity(0.35))
                .overlay { RoundedRectangle(cornerRadius: 16).strokeBorder(theme.colors.cardBorder.opacity(0.08), lineWidth: 1) }
        }
    }

    private func galleryTile(index: Int, season: Season) -> some View {
        let stars = bestStars[index] ?? 0
        let prompt = CreativePrompt.generate(index: index)
        let seasonColor = Color(hex: season.accentHex)

        return VStack(spacing: 4) {
            miniGrid(prompt: prompt)
                .frame(width: 64, height: 64)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay {
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(seasonColor.opacity(0.3), lineWidth: 1)
                }

            HStack(spacing: 1) {
                ForEach(1...3, id: \.self) { s in
                    Image(systemName: s <= stars ? "star.fill" : "star")
                        .font(.system(size: 7))
                        .foregroundStyle(s <= stars ? .yellow : theme.colors.textMuted.opacity(0.2))
                }
            }
        }
    }

    private func miniGrid(prompt: CreativePrompt) -> some View {
        let size = prompt.gridSize
        return GeometryReader { geo in
            let cellSize = geo.size.width / CGFloat(size)
            Canvas { context, _ in
                for row in 0..<size {
                    for col in 0..<size {
                        let idx = row * size + col
                        let colorIdx = prompt.targetPattern[idx]
                        let hex = colorIdx < prompt.palette.count ? prompt.palette[colorIdx] : "CCCCCC"
                        let rect = CGRect(x: CGFloat(col) * cellSize, y: CGFloat(row) * cellSize, width: cellSize, height: cellSize)
                        context.fill(Path(rect), with: .color(Color(hex: hex)))
                    }
                }
            }
        }
    }
}
