import SwiftUI
import SwiftData

struct ChapterMapView: View {
    @Environment(\.theme) private var theme
    @Environment(AppState.self) private var appState
    @Query private var settings: [SettingsRecord]
    @Query private var stats: [StatsRecord]

    private var bestStars: [Int: Int] { stats.first?.bestStars ?? [:] }
    private var highestUnlocked: Int { settings.first?.highestUnlockedLevel ?? 0 }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(Chapter.all) { chapter in chapterCard(chapter) }
            }
            .padding(16)
        }
        .themedBackground()
        .navigationTitle("Chapters")
    }

    private func chapterCard(_ chapter: Chapter) -> some View {
        let completedCount = chapter.levelRange.filter { bestStars[$0] != nil }.count
        let starsEarned = chapter.levelRange.reduce(0) { $0 + (bestStars[$1] ?? 0) }
        let maxStars = chapter.levelCount * 3
        let isLocked = chapter.firstLevel > highestUnlocked
        let isComplete = completedCount == chapter.levelCount
        let color = Color(hex: chapter.accentHex)

        return VStack(spacing: 0) {
            chapterHeader(chapter, completedCount: completedCount, starsEarned: starsEarned, maxStars: maxStars, isLocked: isLocked, isComplete: isComplete, color: color)

            if !isLocked {
                progressBar(completedCount: completedCount, total: chapter.levelCount, color: color)
                levelGrid(chapter, color: color).padding(14).padding(.top, 4)
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 18)
                .fill(isLocked ? theme.colors.surface.opacity(0.2) : theme.colors.surface.opacity(0.45))
                .overlay { RoundedRectangle(cornerRadius: 18).strokeBorder(isLocked ? theme.colors.boardBorder.opacity(0.08) : color.opacity(0.12), lineWidth: 1) }
        }
        .opacity(isLocked ? 0.5 : 1)
    }

    private func chapterHeader(_ chapter: Chapter, completedCount: Int, starsEarned: Int, maxStars: Int, isLocked: Bool, isComplete: Bool, color: Color) -> some View {
        HStack {
            ZStack {
                Circle().fill(isLocked ? theme.colors.textMuted.opacity(0.1) : color.opacity(0.15)).frame(width: 44, height: 44)
                Image(systemName: chapter.icon).font(.system(size: 20, weight: .bold)).foregroundStyle(isLocked ? theme.colors.textMuted.opacity(0.3) : color)
            }
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(chapter.name).font(.system(size: 18, weight: .black, design: .rounded)).primaryText()
                    if isComplete { Image(systemName: "checkmark.seal.fill").font(.system(size: 14)).foregroundStyle(.green) }
                }
                Text("\(chapter.subtitle) • \(chapter.form.displayName)").font(.system(size: 13, weight: .medium)).secondaryText()
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 3) {
                Text("\(completedCount)/\(chapter.levelCount)").font(.system(size: 15, weight: .bold, design: .rounded)).primaryText()
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
                    .frame(width: geo.size.width * Double(completedCount) / Double(max(total, 1)), height: 4)
            }
        }
        .frame(height: 4).padding(.horizontal, 14)
    }

    private func levelGrid(_ chapter: Chapter, color: Color) -> some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 5), spacing: 8) {
            ForEach(Array(chapter.levelRange), id: \.self) { level in
                levelButton(level: level, chapter: chapter, color: color)
            }
        }
    }

    private func levelButton(level: Int, chapter: Chapter, color: Color) -> some View {
        let isCompleted = bestStars[level] != nil
        let isAvailable = level <= highestUnlocked
        let localIndex = level - chapter.firstLevel + 1

        return Button {
            if isAvailable { appState.navigateInCurrentTab(to: .verse(mode: .level(index: level))) }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(isCompleted ? color.opacity(0.15) : (isAvailable ? theme.colors.surface.opacity(0.5) : theme.colors.cellBackground.opacity(0.2)))
                    .overlay { if isCompleted { RoundedRectangle(cornerRadius: 10).strokeBorder(color.opacity(0.2), lineWidth: 1) } }
                    .frame(height: 42)

                VStack(spacing: 2) {
                    Text("\(localIndex)")
                        .font(.system(size: 14, weight: isCompleted ? .bold : .medium, design: .rounded))
                        .foregroundStyle(isCompleted ? color : (isAvailable ? theme.colors.text : theme.colors.textMuted.opacity(0.3)))
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
            }
        }
        .buttonStyle(BounceButtonStyle())
        .disabled(!isAvailable)
    }
}
