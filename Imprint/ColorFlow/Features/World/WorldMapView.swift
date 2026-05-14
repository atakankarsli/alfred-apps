import SwiftUI
import SwiftData

struct WorldMapView: View {
    @Environment(\.theme) private var theme
    @Environment(AppState.self) private var appState
    @Query private var stats: [StatsRecord]
    @Query private var settings: [SettingsRecord]

    private var bestMoves: [Int: Int] {
        stats.first?.bestMoves ?? [:]
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(Moment.all) { moment in
                    momentCard(moment)
                }
            }
            .padding(16)
        }
        .themedBackground()
        .navigationTitle("Moments")
    }

    private func momentCard(_ moment: Moment) -> some View {
        VStack(spacing: 12) {
            momentHeader(moment)
            momentProgress(moment)
            momentGrid(moment)
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: moment.accentHex).opacity(0.06))
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(Color(hex: moment.accentHex).opacity(0.15), lineWidth: 1)
                }
        }
    }

    private func momentHeader(_ moment: Moment) -> some View {
        HStack {
            Image(systemName: moment.icon)
                .font(.system(size: 22, weight: .bold))
                .foregroundStyle(Color(hex: moment.accentHex))
            Text(moment.name)
                .font(.system(size: 18, weight: .black, design: .rounded))
                .primaryText()
            Spacer()
            let completed = moment.puzzleRange.filter { bestMoves[$0] != nil }.count
            Text("\(completed)/\(moment.puzzleRange.count)")
                .font(.system(size: 14, weight: .bold, design: .monospaced))
                .secondaryText()
        }
    }

    private func momentProgress(_ moment: Moment) -> some View {
        let completed = moment.puzzleRange.filter { bestMoves[$0] != nil }.count
        let total = moment.puzzleRange.count
        let progress = total > 0 ? Double(completed) / Double(total) : 0

        return ProgressView(value: progress)
            .tint(Color(hex: moment.accentHex))
    }

    private func momentGrid(_ moment: Moment) -> some View {
        let puzzles = Array(moment.puzzleRange)
        let columns = Array(repeating: GridItem(.flexible(), spacing: 6), count: 5)

        return LazyVGrid(columns: columns, spacing: 6) {
            ForEach(puzzles, id: \.self) { idx in
                puzzleCell(idx, moment: moment)
            }
        }
    }

    private func puzzleCell(_ idx: Int, moment: Moment) -> some View {
        let unlocked = idx <= (settings.first?.highestUnlockedLevel ?? 0)
        let completed = bestMoves[idx] != nil
        let stars = completed ? ImprintConfig.starsForAccuracy(Double(bestMoves[idx] ?? 0) / 100.0) : 0
        let accent = Color(hex: moment.accentHex)

        return Button {
            if unlocked {
                HapticsService.light()
                appState.navigate(to: .imprint(mode: .mosaic(index: idx)))
            }
        } label: {
            VStack(spacing: 2) {
                Text("\(Moment.localIndex(for: idx) + 1)")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
                    .foregroundStyle(unlocked ? accent : theme.colors.textSecondary.opacity(0.4))
                if completed {
                    starsRow(count: stars, color: accent)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(completed ? accent.opacity(0.12) : theme.colors.surface.opacity(unlocked ? 0.3 : 0.1))
            }
        }
        .buttonStyle(.plain)
        .disabled(!unlocked)
    }

    private func starsRow(count: Int, color: Color) -> some View {
        HStack(spacing: 1) {
            ForEach(0..<3, id: \.self) { i in
                Image(systemName: i < count ? "star.fill" : "star")
                    .font(.system(size: 7))
                    .foregroundStyle(i < count ? color : color.opacity(0.3))
            }
        }
    }
}
