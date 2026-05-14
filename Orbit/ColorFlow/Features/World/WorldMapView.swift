import SwiftUI
import SwiftData

struct SectorMapView: View {
    @Environment(\.theme) private var theme
    @Environment(AppState.self) private var appState
    @Query private var settings: [SettingsRecord]
    @Query private var stats: [StatsRecord]

    private var bestMoves: [Int: Int] { stats.first?.bestMoves ?? [:] }
    private var highestUnlocked: Int { settings.first?.highestUnlockedLevel ?? 0 }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) { ForEach(Sector.all) { sector in sectorCard(sector) } }.padding(16)
        }.themedBackground().navigationTitle("Sectors")
    }

    private func sectorCard(_ sector: Sector) -> some View {
        let completed = sector.levelRange.filter { bestMoves[$0] != nil }.count
        let starsEarned = sectorStars(sector)
        let maxStars = sector.levelCount * 3
        let isLocked = sector.firstLevel > highestUnlocked
        let isDone = completed == sector.levelCount
        let color = Color(hex: sector.accentHex)

        return VStack(spacing: 0) {
            HStack {
                ZStack { Circle().fill(isLocked ? theme.colors.textMuted.opacity(0.1) : color.opacity(0.15)).frame(width: 44, height: 44); Image(systemName: sector.icon).font(.system(size: 20, weight: .bold)).foregroundStyle(isLocked ? theme.colors.textMuted.opacity(0.3) : color) }
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) { Text(sector.name).font(.system(size: 18, weight: .black, design: .rounded)).primaryText(); if isDone { Image(systemName: "checkmark.seal.fill").font(.system(size: 14)).foregroundStyle(.green) } }
                    Text(sector.subtitle).font(.system(size: 13, weight: .medium)).secondaryText()
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 3) {
                    Text("\(completed)/\(sector.levelCount)").font(.system(size: 15, weight: .bold, design: .rounded)).primaryText()
                    HStack(spacing: 2) { Image(systemName: "star.fill").font(.system(size: 10)).foregroundStyle(.yellow); Text("\(starsEarned)/\(maxStars)").font(.system(size: 11, weight: .medium)).secondaryText() }
                }
            }.padding(14)

            if !isLocked {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Rectangle().fill(theme.colors.cellBackground).frame(height: 4)
                        Rectangle().fill(LinearGradient(colors: [color, color.opacity(0.7)], startPoint: .leading, endPoint: .trailing))
                            .frame(width: geo.size.width * Double(completed) / Double(sector.levelCount), height: 4)
                    }
                }.frame(height: 4).padding(.horizontal, 14)

                levelGrid(sector, color: color).padding(14).padding(.top, 4)
            }
        }
        .background { RoundedRectangle(cornerRadius: 18).fill(isLocked ? theme.colors.surface.opacity(0.2) : theme.colors.surface.opacity(0.45)).overlay { RoundedRectangle(cornerRadius: 18).strokeBorder(isLocked ? theme.colors.boardBorder.opacity(0.08) : color.opacity(0.12), lineWidth: 1) } }
        .opacity(isLocked ? 0.5 : 1)
    }

    private func sectorStars(_ sector: Sector) -> Int {
        sector.levelRange.reduce(0) { total, level in
            guard let score = bestMoves[level] else { return total }
            return total + OrbitConfig.starsForAccuracy(Double(score) / 100.0)
        }
    }

    private func levelGrid(_ sector: Sector, color: Color) -> some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 4), spacing: 8) {
            ForEach(Array(sector.levelRange), id: \.self) { level in
                let done = bestMoves[level] != nil
                let avail = level <= highestUnlocked
                let local = level - sector.firstLevel + 1
                Button { if avail { appState.navigateInCurrentTab(to: .orbit(mode: .mission(index: level))) } } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(done ? color.opacity(0.15) : (avail ? theme.colors.surface.opacity(0.5) : theme.colors.cellBackground.opacity(0.2)))
                            .overlay { if done { RoundedRectangle(cornerRadius: 10).strokeBorder(color.opacity(0.2), lineWidth: 1) } }
                            .frame(height: 42)
                        VStack(spacing: 2) {
                            Text("\(local)").font(.system(size: 14, weight: done ? .bold : .medium, design: .rounded)).foregroundStyle(done ? color : (avail ? theme.colors.text : theme.colors.textMuted.opacity(0.3)))
                            if done, let score = bestMoves[level] {
                                let s = OrbitConfig.starsForAccuracy(Double(score) / 100.0)
                                HStack(spacing: 1) { ForEach(1...3, id: \.self) { star in Image(systemName: star <= s ? "star.fill" : "star").font(.system(size: 6)).foregroundStyle(star <= s ? .yellow : theme.colors.textMuted.opacity(0.2)) } }
                            }
                        }
                    }
                }.buttonStyle(BounceButtonStyle()).disabled(!avail)
            }
        }
    }
}
