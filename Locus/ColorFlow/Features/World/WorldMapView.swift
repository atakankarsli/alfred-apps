import SwiftUI
import SwiftData

struct WorldMapView: View {
    @Environment(\.theme) private var theme
    @Query private var stats: [StatsRecord]
    private var st: StatsRecord? { stats.first }

    var body: some View {
        ZStack {
            FloatingOrbsView().ignoresSafeArea()
            ScrollView {
                VStack(spacing: 16) {
                    Text("Memory Palace").font(.system(size: 28, weight: .black, design: .rounded)).primaryText().frame(maxWidth: .infinity, alignment: .leading)
                    Text("4 rooms · 80 challenges").font(.system(size: 14, weight: .medium)).secondaryText().frame(maxWidth: .infinity, alignment: .leading)
                    ForEach(Palace.all) { palace in palaceCard(palace) }
                }.padding(16).padding(.bottom, 32)
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity).themedBackground()
    }

    private func palaceCard(_ palace: Palace) -> some View {
        let best = st?.bestMoves ?? [:]
        let done = palace.puzzleRange.filter { best[$0] != nil }.count
        let total = palace.puzzleRange.count
        let ratio = total > 0 ? Double(done) / Double(total) : 0
        let color = Color(hex: palace.accentHex)
        return VStack(spacing: 12) {
            palaceHeader(palace: palace, done: done, total: total, ratio: ratio, color: color)
            progressBar(ratio: ratio, color: color)
            puzzleGrid(palace: palace, best: best, color: color)
        }.padding(16).background { RoundedRectangle(cornerRadius: 18).fill(theme.colors.surface.opacity(0.4)).overlay { RoundedRectangle(cornerRadius: 18).strokeBorder(color.opacity(0.15), lineWidth: 1) } }
    }

    private func palaceHeader(palace: Palace, done: Int, total: Int, ratio: Double, color: Color) -> some View {
        HStack {
            ZStack { Circle().fill(color.opacity(0.15)).frame(width: 48, height: 48); Image(systemName: palace.icon).font(.system(size: 22, weight: .bold)).foregroundStyle(color) }
            VStack(alignment: .leading, spacing: 2) {
                Text(palace.name).font(.system(size: 18, weight: .bold, design: .rounded)).primaryText()
                Text("\(done)/\(total) rooms").font(.system(size: 13, weight: .medium)).secondaryText()
            }; Spacer()
            Text("\(Int(ratio * 100))%").font(.system(size: 15, weight: .black, design: .monospaced)).foregroundStyle(color)
        }
    }

    private func progressBar(ratio: Double, color: Color) -> some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule().fill(theme.colors.cellBackground).frame(height: 8)
                Capsule().fill(LinearGradient(colors: [color, color.opacity(0.6)], startPoint: .leading, endPoint: .trailing)).frame(width: max(8, geo.size.width * ratio), height: 8)
            }
        }.frame(height: 8)
    }

    private func puzzleGrid(palace: Palace, best: [Int: Int], color: Color) -> some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 6), count: 10), spacing: 6) {
            ForEach(Array(palace.puzzleRange), id: \.self) { i in
                puzzleCell(index: i, completed: best[i] != nil, color: color)
            }
        }
    }

    private func puzzleCell(index: Int, completed: Bool, color: Color) -> some View {
        NavigationLink(value: Route.locus(mode: .room(index: index))) {
            ZStack {
                RoundedRectangle(cornerRadius: 6).fill(completed ? color.opacity(0.15) : theme.colors.surface.opacity(0.3)).frame(height: 28)
                    .overlay { RoundedRectangle(cornerRadius: 6).strokeBorder(completed ? color.opacity(0.3) : theme.colors.boardBorder.opacity(0.08), lineWidth: 1) }
                if completed { Image(systemName: "checkmark").font(.system(size: 8, weight: .bold)).foregroundStyle(color) }
                else { Text("\(Palace.localIndex(forPuzzle: index) + 1)").font(.system(size: 8, weight: .bold, design: .monospaced)).secondaryText() }
            }
        }.buttonStyle(BounceButtonStyle())
    }
}
