import SwiftUI
import SwiftData

struct WorldMapView: View {
    @Environment(\.theme) private var theme
    @Environment(AppState.self) private var appState
    @Query private var settings: [SettingsRecord]
    @Query private var stats: [StatsRecord]

    private var bestMoves: [Int: Int] { stats.first?.bestMoves ?? [:] }
    private var highestUnlocked: Int { settings.first?.highestUnlockedLevel ?? 0 }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(World.all) { world in
                    worldCard(world)
                }
            }
            .padding(16)
        }
        .themedBackground()
        .navigationTitle("Worlds")
    }

    private func worldCard(_ world: World) -> some View {
        let completedCount = world.levelRange.filter { bestMoves[$0] != nil }.count
        let starsEarned = world.levelRange.reduce(0) { total, level in
            guard let moves = bestMoves[level] else { return total }
            let puzzle = NovaPuzzle.generate(level: level)
            return total + GameConfig.starsForTaps(moves, par: puzzle.parTaps)
        }
        let maxStars = world.levelCount * 3
        let isLocked = world.firstLevel > highestUnlocked
        let isComplete = completedCount == world.levelCount
        let worldColor = Color(hex: world.accentHex)

        return VStack(spacing: 0) {
            HStack {
                ZStack {
                    Circle()
                        .fill(
                            isLocked
                                ? theme.colors.textMuted.opacity(0.1)
                                : worldColor.opacity(0.15)
                        )
                        .frame(width: 44, height: 44)

                    Image(systemName: world.icon)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(isLocked ? theme.colors.textMuted.opacity(0.3) : worldColor)
                }

                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text(world.name)
                            .font(.system(size: 18, weight: .black, design: .rounded))
                            .primaryText()
                        if isComplete {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 14))
                                .foregroundStyle(.green)
                        }
                    }
                    Text(world.subtitle)
                        .font(.system(size: 13, weight: .medium))
                        .secondaryText()
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 3) {
                    Text("\(completedCount)/\(world.levelCount)")
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
                                    colors: [worldColor, worldColor.opacity(0.7)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geo.size.width * Double(completedCount) / Double(world.levelCount), height: 4)
                    }
                }
                .frame(height: 4)
                .padding(.horizontal, 14)

                levelGrid(world, worldColor: worldColor)
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
                            isLocked ? theme.colors.boardBorder.opacity(0.08) : worldColor.opacity(0.12),
                            lineWidth: 1
                        )
                }
        }
        .opacity(isLocked ? 0.5 : 1)
    }

    private func levelGrid(_ world: World, worldColor: Color) -> some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 5), spacing: 8) {
            ForEach(Array(world.levelRange), id: \.self) { level in
                let isCompleted = bestMoves[level] != nil
                let isAvailable = level <= highestUnlocked
                let localIndex = level - world.firstLevel + 1

                Button {
                    if isAvailable {
                        appState.navigateInCurrentTab(to: .game(mode: .level(index: level)))
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(
                                isCompleted
                                    ? worldColor.opacity(0.15)
                                    : (isAvailable ? theme.colors.surface.opacity(0.5) : theme.colors.cellBackground.opacity(0.2))
                            )
                            .overlay {
                                if isCompleted {
                                    RoundedRectangle(cornerRadius: 10)
                                        .strokeBorder(worldColor.opacity(0.2), lineWidth: 1)
                                }
                            }
                            .frame(height: 42)

                        VStack(spacing: 2) {
                            Text("\(localIndex)")
                                .font(.system(size: 14, weight: isCompleted ? .bold : .medium, design: .rounded))
                                .foregroundStyle(
                                    isCompleted ? worldColor : (isAvailable ? theme.colors.text : theme.colors.textMuted.opacity(0.3))
                                )

                            if isCompleted, let moves = bestMoves[level] {
                                let puzzle = NovaPuzzle.generate(level: level)
                                let s = GameConfig.starsForTaps(moves, par: puzzle.parTaps)
                                HStack(spacing: 1) {
                                    ForEach(1...3, id: \.self) { star in
                                        Image(systemName: star <= s ? "star.fill" : "star")
                                            .font(.system(size: 6))
                                            .foregroundStyle(star <= s ? .yellow : theme.colors.textMuted.opacity(0.2))
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
