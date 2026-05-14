import SwiftUI
import SwiftData

struct WorldsView: View {
    @Environment(\.theme) private var theme
    @Environment(AppState.self) private var appState
    @Query private var completedLevels: [LevelRecord]

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(WaveWorld.allCases) { world in
                    worldCard(world)
                }
            }
            .padding(16)
        }
        .themedBackground()
        .navigationTitle("Wave Worlds")
    }

    private func worldCard(_ world: WaveWorld) -> some View {
        let completed = completedLevels.filter { world.levelRange.contains($0.levelIndex) }
        let progress = Double(completed.count) / Double(world.levelsPerWorld)
        let totalStars = completed.reduce(0) { $0 + $1.stars }
        let maxStars = world.levelsPerWorld * 3

        return VStack(spacing: 12) {
            HStack {
                ZStack {
                    Circle().fill(world.color.opacity(0.15)).frame(width: 50, height: 50)
                    Image(systemName: world.icon).font(.system(size: 22, weight: .bold)).foregroundStyle(world.color)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(world.displayName).font(.system(size: 18, weight: .black, design: .rounded)).primaryText()
                    Text(world.subtitle).font(.system(size: 12, weight: .medium)).secondaryText()
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(completed.count)/\(world.levelsPerWorld)")
                        .font(.system(size: 14, weight: .bold, design: .monospaced)).primaryText()
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill").font(.system(size: 10)).foregroundStyle(.yellow)
                        Text("\(totalStars)/\(maxStars)").font(.system(size: 10, weight: .medium)).secondaryText()
                    }
                }
            }

            ProgressView(value: progress).tint(world.color)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 6), count: 8), spacing: 6) {
                ForEach(world.levelRange, id: \.self) { idx in
                    let record = completedLevels.first { $0.levelIndex == idx }
                    Button {
                        appState.navigate(to: .play(levelIndex: idx))
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(record != nil ? world.color.opacity(0.2) : theme.colors.surface.opacity(0.3))
                                .frame(height: 32)
                            if let record {
                                VStack(spacing: 1) {
                                    Text("\(idx % 16 + 1)").font(.system(size: 10, weight: .bold)).primaryText()
                                    HStack(spacing: 0) {
                                        ForEach(0..<record.stars, id: \.self) { _ in
                                            Image(systemName: "star.fill").font(.system(size: 5)).foregroundStyle(.yellow)
                                        }
                                    }
                                }
                            } else {
                                Text("\(idx % 16 + 1)").font(.system(size: 10, weight: .medium)).mutedText()
                            }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 20)
                .fill(world.color.opacity(0.04))
                .overlay { RoundedRectangle(cornerRadius: 20).strokeBorder(world.color.opacity(0.12), lineWidth: 1) }
        }
    }
}
