import SwiftUI
import SwiftData

struct WorldsView: View {
    @Environment(\.theme) private var theme
    @Environment(AppState.self) private var appState
    @Query private var settings: [SettingsRecord]
    @Query private var stats: [StatsRecord]

    private var bestStars: [Int: Int] { stats.first?.bestStars ?? [:] }
    private var highestUnlocked: Int { settings.first?.highestUnlockedLevel ?? 0 }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(SymbolCategory.allCases) { category in
                    categoryCard(category)
                }
            }
            .padding(16)
        }
        .themedBackground()
        .navigationTitle("Worlds")
    }

    private func categoryCard(_ category: SymbolCategory) -> some View {
        let completedCount = category.challengeRange.filter { bestStars[$0] != nil }.count
        let starsEarned = category.challengeRange.reduce(0) { $0 + (bestStars[$1] ?? 0) }
        let maxStars = category.challengeCount * 3
        let isLocked = category.firstChallenge > highestUnlocked
        let isComplete = completedCount == category.challengeCount

        return VStack(spacing: 0) {
            HStack {
                ZStack {
                    Circle()
                        .fill(isLocked ? theme.colors.textMuted.opacity(0.1) : category.color.opacity(0.15))
                        .frame(width: 44, height: 44)
                    Image(systemName: category.icon)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(isLocked ? theme.colors.textMuted.opacity(0.3) : category.color)
                }

                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text(category.displayName)
                            .font(.system(size: 18, weight: .black, design: .rounded)).primaryText()
                        if isComplete {
                            Image(systemName: "checkmark.seal.fill")
                                .font(.system(size: 14)).foregroundStyle(.green)
                        }
                    }
                    Text(category.subtitle)
                        .font(.system(size: 13, weight: .medium)).secondaryText()
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 3) {
                    Text("\(completedCount)/\(category.challengeCount)")
                        .font(.system(size: 15, weight: .bold, design: .rounded)).primaryText()
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill").font(.system(size: 10)).foregroundStyle(.yellow)
                        Text("\(starsEarned)/\(maxStars)")
                            .font(.system(size: 11, weight: .medium)).secondaryText()
                    }
                }
            }
            .padding(14)

            if !isLocked {
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Rectangle().fill(theme.colors.cardBackground).frame(height: 4)
                        Rectangle()
                            .fill(LinearGradient(colors: [category.color, category.color.opacity(0.7)], startPoint: .leading, endPoint: .trailing))
                            .frame(width: geo.size.width * Double(completedCount) / Double(max(category.challengeCount, 1)), height: 4)
                    }
                }
                .frame(height: 4)
                .padding(.horizontal, 14)

                symbolGrid(category)
                    .padding(14).padding(.top, 4)
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 18)
                .fill(isLocked ? theme.colors.surface.opacity(0.2) : theme.colors.surface.opacity(0.45))
                .overlay {
                    RoundedRectangle(cornerRadius: 18)
                        .strokeBorder(isLocked ? theme.colors.cardBorder.opacity(0.08) : category.color.opacity(0.12), lineWidth: 1)
                }
        }
        .opacity(isLocked ? 0.5 : 1)
    }

    private func symbolGrid(_ category: SymbolCategory) -> some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 4), spacing: 8) {
            ForEach(Array(category.challengeRange), id: \.self) { level in
                let isCompleted = bestStars[level] != nil
                let isAvailable = level <= highestUnlocked
                let symbol = SymbolData.symbol(for: level)

                Button {
                    if isAvailable { appState.navigate(to: .draw(index: level)) }
                } label: {
                    VStack(spacing: 2) {
                        Text(symbol.name)
                            .font(.system(size: 10, weight: isCompleted ? .bold : .medium, design: .rounded))
                            .foregroundStyle(
                                isCompleted ? category.color : (isAvailable ? theme.colors.text : theme.colors.textMuted.opacity(0.3))
                            )
                            .lineLimit(1)
                        if isCompleted, let s = bestStars[level] {
                            HStack(spacing: 1) {
                                ForEach(1...3, id: \.self) { star in
                                    Image(systemName: star <= s ? "star.fill" : "star")
                                        .font(.system(size: 6))
                                        .foregroundStyle(star <= s ? .yellow : theme.colors.textMuted.opacity(0.2))
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 42)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(
                                isCompleted ? category.color.opacity(0.15)
                                : (isAvailable ? theme.colors.surface.opacity(0.5) : theme.colors.cardBackground.opacity(0.2))
                            )
                            .overlay {
                                if isCompleted {
                                    RoundedRectangle(cornerRadius: 10).strokeBorder(category.color.opacity(0.2), lineWidth: 1)
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
