import SwiftUI
import SwiftData

struct SeasonMapView: View {
    @Environment(\.theme) private var theme
    @Environment(AppState.self) private var appState
    @Query private var settings: [SettingsRecord]
    @Query private var stats: [StatsRecord]

    private var bestMoves: [Int: Int] { stats.first?.bestMoves ?? [:] }
    private var highestUnlocked: Int { settings.first?.currentLevelIndex ?? 0 }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(Season.all) { season in
                    seasonCard(season)
                }
            }
            .padding(16)
        }
        .themedBackground()
        .navigationTitle("Seasons")
    }

    private func seasonCard(_ season: Season) -> some View {
        let completedCount = season.gardenRange.filter { bestMoves[$0] != nil }.count
        let starsEarned = season.gardenRange.reduce(0) { total, garden in
            guard bestMoves[garden] != nil else { return total }
            return total + 3
        }
        let maxStars = season.gardenCount * 3
        let isLocked = season.firstGarden > highestUnlocked
        let isComplete = completedCount == season.gardenCount
        let seasonColor = Color(hex: season.accentHex)

        return VStack(spacing: 0) {
            HStack {
                ZStack {
                    Circle()
                        .fill(
                            isLocked
                                ? theme.colors.textMuted.opacity(0.1)
                                : seasonColor.opacity(0.15)
                        )
                        .frame(width: 44, height: 44)

                    Image(systemName: season.icon)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(isLocked ? theme.colors.textMuted.opacity(0.3) : seasonColor)
                }

                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text(season.name)
                            .font(.system(size: 18, weight: .black, design: .rounded))
                            .primaryText()
                        if isComplete {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 14))
                                .foregroundStyle(.green)
                        }
                    }
                    Text(season.subtitle)
                        .font(.system(size: 13, weight: .medium))
                        .secondaryText()
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 3) {
                    Text("\(completedCount)/\(season.gardenCount)")
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .primaryText()
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 10))
                            .foregroundStyle(.yellow)
                        Text("\(starsEarned)/\(maxStars)")
                            .font(.system(size: 11, weight: .medium))
                            .secondaryText()
                    }
                }
            }
            .padding(14)

            if !isLocked {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .fill(theme.colors.cellBackground)
                            .frame(height: 4)
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [seasonColor, seasonColor.opacity(0.7)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geo.size.width * Double(completedCount) / Double(season.gardenCount), height: 4)
                    }
                }
                .frame(height: 4)
                .padding(.horizontal, 14)

                gardenGrid(season, seasonColor: seasonColor)
                    .padding(14)
                    .padding(.top, 4)
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 18)
                .fill(isLocked ? theme.colors.surface.opacity(0.2) : theme.colors.surface.opacity(0.45))
                .overlay {
                    RoundedRectangle(cornerRadius: 18)
                        .strokeBorder(
                            isLocked ? theme.colors.boardBorder.opacity(0.08) : seasonColor.opacity(0.12),
                            lineWidth: 1
                        )
                }
        }
        .opacity(isLocked ? 0.5 : 1)
    }

    private func gardenGrid(_ season: Season, seasonColor: Color) -> some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 5), spacing: 8) {
            ForEach(Array(season.gardenRange), id: \.self) { garden in
                let isCompleted = bestMoves[garden] != nil
                let isAvailable = garden <= highestUnlocked
                let localIndex = garden - season.firstGarden + 1

                Button {
                    if isAvailable {
                        appState.navigateInCurrentTab(to: .garden(mode: .garden(index: garden)))
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(
                                isCompleted
                                    ? seasonColor.opacity(0.15)
                                    : (isAvailable ? theme.colors.surface.opacity(0.5) : theme.colors.cellBackground.opacity(0.2))
                            )
                            .overlay {
                                if isCompleted {
                                    RoundedRectangle(cornerRadius: 10)
                                        .strokeBorder(seasonColor.opacity(0.2), lineWidth: 1)
                                }
                            }
                            .frame(height: 42)

                        VStack(spacing: 2) {
                            Text("\(localIndex)")
                                .font(.system(size: 14, weight: isCompleted ? .bold : .medium, design: .rounded))
                                .foregroundStyle(
                                    isCompleted ? seasonColor : (isAvailable ? theme.colors.text : theme.colors.textMuted.opacity(0.3))
                                )

                            if isCompleted {
                                HStack(spacing: 1) {
                                    ForEach(1...3, id: \.self) { star in
                                        Image(systemName: "star.fill")
                                            .font(.system(size: 6))
                                            .foregroundStyle(.yellow)
                                    }
                                }
                            }
                        }
                    }
                }
                .buttonStyle(BounceButtonStyle())
                .disabled(!isAvailable)
            }
        }
    }
}
