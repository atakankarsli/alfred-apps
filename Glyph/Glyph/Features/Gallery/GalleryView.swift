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

                ForEach(SymbolCategory.allCases) { category in
                    categorySection(category)
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
                Image(systemName: "square.grid.3x3.fill")
                    .font(.system(size: 28)).foregroundStyle(theme.colors.accent)
            }
            Text("\(completed) Symbols Drawn")
                .font(.system(size: 24, weight: .black, design: .rounded)).primaryText()
            ProgressView(value: Double(completed), total: Double(GlyphConfig.totalChallenges))
                .tint(theme.colors.accent)
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(theme.colors.surface.opacity(0.4))
                .overlay { RoundedRectangle(cornerRadius: 16).strokeBorder(theme.colors.cardBorder.opacity(0.12), lineWidth: 1) }
        }
    }

    private func categorySection(_ category: SymbolCategory) -> some View {
        let completedInCat = category.challengeRange.filter { bestStars[$0] != nil }

        return VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: category.icon).foregroundStyle(category.color)
                Text(category.displayName)
                    .font(.system(size: 16, weight: .bold, design: .rounded)).primaryText()
                Spacer()
                Text("\(completedInCat.count)/\(category.challengeCount)")
                    .font(.system(size: 13, weight: .medium)).secondaryText()
            }

            if completedInCat.isEmpty {
                Text("No symbols drawn yet")
                    .font(.system(size: 13)).mutedText()
                    .frame(maxWidth: .infinity).padding(.vertical, 20)
            } else {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(completedInCat, id: \.self) { index in
                        galleryTile(index: index, category: category)
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

    private func galleryTile(index: Int, category: SymbolCategory) -> some View {
        let stars = bestStars[index] ?? 0
        let symbol = SymbolData.symbol(for: index)

        return VStack(spacing: 4) {
            miniSymbol(symbol: symbol)
                .frame(width: 64, height: 64)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay { RoundedRectangle(cornerRadius: 8).strokeBorder(category.color.opacity(0.3), lineWidth: 1) }

            HStack(spacing: 1) {
                ForEach(1...3, id: \.self) { s in
                    Image(systemName: s <= stars ? "star.fill" : "star")
                        .font(.system(size: 7))
                        .foregroundStyle(s <= stars ? .yellow : theme.colors.textMuted.opacity(0.2))
                }
            }
        }
    }

    private func miniSymbol(symbol: SymbolDefinition) -> some View {
        Canvas { context, size in
            for stroke in symbol.strokes {
                var path = Path()
                for (i, point) in stroke.enumerated() {
                    let x = point.x * size.width
                    let y = point.y * size.height
                    if i == 0 { path.move(to: CGPoint(x: x, y: y)) }
                    else { path.addLine(to: CGPoint(x: x, y: y)) }
                }
                context.stroke(path, with: .color(theme.colors.accent), lineWidth: 1.5)
            }
        }
    }
}
