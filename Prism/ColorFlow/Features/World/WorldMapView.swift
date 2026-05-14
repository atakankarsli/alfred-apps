import SwiftUI
import SwiftData

struct SpectrumMapView: View {
    @Environment(\.theme) private var theme
    @Environment(AppState.self) private var appState
    @Query private var settings: [SettingsRecord]
    @Query private var stats: [StatsRecord]

    private var bestMoves: [Int: Int] { stats.first?.bestMoves ?? [:] }
    private var highestUnlocked: Int { settings.first?.highestUnlockedLevel ?? 0 }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(Spectrum.all) { spectrum in
                    spectrumCard(spectrum)
                }
            }
            .padding(16)
        }
        .themedBackground()
        .navigationTitle("Spectrums")
    }

    private func spectrumCard(_ spectrum: Spectrum) -> some View {
        let completedCount = spectrum.levelRange.filter { bestMoves[$0] != nil }.count
        let starsEarned = starsForSpectrum(spectrum)
        let maxStars = spectrum.levelCount * 3
        let isLocked = spectrum.firstLevel > highestUnlocked
        let isComplete = completedCount == spectrum.levelCount
        let color = Color(hex: spectrum.accentHex)

        return VStack(spacing: 0) {
            spectrumHeader(spectrum, completedCount: completedCount, starsEarned: starsEarned, maxStars: maxStars, isLocked: isLocked, isComplete: isComplete, color: color)

            if !isLocked {
                progressBar(completedCount: completedCount, total: spectrum.levelCount, color: color)
                levelGrid(spectrum, color: color).padding(14).padding(.top, 4)
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 18)
                .fill(isLocked ? theme.colors.surface.opacity(0.2) : theme.colors.surface.opacity(0.45))
                .overlay {
                    RoundedRectangle(cornerRadius: 18)
                        .strokeBorder(isLocked ? theme.colors.boardBorder.opacity(0.08) : color.opacity(0.12), lineWidth: 1)
                }
        }
        .opacity(isLocked ? 0.5 : 1)
    }

    private func spectrumHeader(_ spectrum: Spectrum, completedCount: Int, starsEarned: Int, maxStars: Int, isLocked: Bool, isComplete: Bool, color: Color) -> some View {
        HStack {
            ZStack {
                Circle().fill(isLocked ? theme.colors.textMuted.opacity(0.1) : color.opacity(0.15)).frame(width: 44, height: 44)
                Image(systemName: spectrum.icon).font(.system(size: 20, weight: .bold))
                    .foregroundStyle(isLocked ? theme.colors.textMuted.opacity(0.3) : color)
            }
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(spectrum.name).font(.system(size: 18, weight: .black, design: .rounded)).primaryText()
                    if isComplete { Image(systemName: "checkmark.seal.fill").font(.system(size: 14)).foregroundStyle(.green) }
                }
                Text(spectrum.subtitle).font(.system(size: 13, weight: .medium)).secondaryText()
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 3) {
                Text("\(completedCount)/\(spectrum.levelCount)").font(.system(size: 15, weight: .bold, design: .rounded)).primaryText()
                HStack(spacing: 2) {
                    Image(systemName: "star.fill").font(.system(size: 10)).foregroundStyle(.yellow)
                    Text("\(starsEarned)/\(maxStars)").font(.system(size: 11, weight: .medium)).secondaryText()
                }
            }
        }
        .padding(14)
    }

    private func progressBar(completedCount: Int, total: Int, color: Color) -> some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Rectangle().fill(theme.colors.cellBackground).frame(height: 4)
                Rectangle()
                    .fill(LinearGradient(colors: [color, color.opacity(0.7)], startPoint: .leading, endPoint: .trailing))
                    .frame(width: geo.size.width * Double(completedCount) / Double(total), height: 4)
            }
        }
        .frame(height: 4)
        .padding(.horizontal, 14)
    }

    private func levelGrid(_ spectrum: Spectrum, color: Color) -> some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 5), spacing: 8) {
            ForEach(Array(spectrum.levelRange), id: \.self) { level in
                levelButton(level: level, spectrum: spectrum, color: color)
            }
        }
    }

    private func levelButton(level: Int, spectrum: Spectrum, color: Color) -> some View {
        let isCompleted = bestMoves[level] != nil
        let isAvailable = level <= highestUnlocked
        let localIndex = level - spectrum.firstLevel + 1

        return Button {
            if isAvailable {
                appState.navigateInCurrentTab(to: .prism(mode: .level(index: level)))
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(isCompleted ? color.opacity(0.15) : (isAvailable ? theme.colors.surface.opacity(0.5) : theme.colors.cellBackground.opacity(0.2)))
                    .overlay {
                        if isCompleted { RoundedRectangle(cornerRadius: 10).strokeBorder(color.opacity(0.2), lineWidth: 1) }
                    }
                    .frame(height: 42)

                VStack(spacing: 2) {
                    Text("\(localIndex)")
                        .font(.system(size: 14, weight: isCompleted ? .bold : .medium, design: .rounded))
                        .foregroundStyle(isCompleted ? color : (isAvailable ? theme.colors.text : theme.colors.textMuted.opacity(0.3)))
                    if isCompleted, let moves = bestMoves[level] {
                        levelStars(level: level, moves: moves)
                    }
                }
            }
        }
        .buttonStyle(BounceButtonStyle())
        .disabled(!isAvailable)
    }

    private func levelStars(level: Int, moves: Int) -> some View {
        let puzzle = PrismPuzzle.generate(level: level)
        let s = PrismConfig.starsForMoves(moves, par: puzzle.parMoves)
        return HStack(spacing: 1) {
            ForEach(1...3, id: \.self) { star in
                Image(systemName: star <= s ? "star.fill" : "star")
                    .font(.system(size: 6))
                    .foregroundStyle(star <= s ? .yellow : theme.colors.textMuted.opacity(0.2))
            }
        }
    }

    private func starsForSpectrum(_ spectrum: Spectrum) -> Int {
        spectrum.levelRange.reduce(0) { total, level in
            guard let moves = bestMoves[level] else { return total }
            let puzzle = PrismPuzzle.generate(level: level)
            return total + PrismConfig.starsForMoves(moves, par: puzzle.parMoves)
        }
    }
}
