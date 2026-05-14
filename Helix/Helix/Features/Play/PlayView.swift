import SwiftUI
import SwiftData

struct PlayView: View {
    @Environment(\.theme) var theme
    @Environment(\.modelContext) var modelContext
    @Environment(AppState.self) var appState
    @State private var engine = HelixEngine()

    let levelIndex: Int

    var body: some View {
        ZStack {
            FloatingOrbsView()
            VStack(spacing: 0) {
                topBar
                if !engine.isComplete {
                    targetStrand
                    currentStrand
                    if engine.mode == .pairMatch {
                        baseSelector
                    }
                } else {
                    completionView
                }
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            if levelIndex == -2 {
                engine.startDaily()
            } else {
                engine.startLevel(levelIndex)
            }
        }
    }

    private var topBar: some View {
        HStack {
            Button { appState.path.removeLast() } label: {
                Image(systemName: "chevron.left")
                    .foregroundStyle(theme.colors.text)
            }
            Text(levelIndex == -2 ? "Daily Strand" : "Level \(levelIndex + 1)")
                .font(.headline)
                .foregroundStyle(theme.colors.text)
            Spacer()
            Label("\(engine.moveCount)", systemImage: "arrow.triangle.swap")
                .font(.caption)
                .foregroundStyle(theme.colors.textSecondary)
            if engine.combo > 1 {
                Text("\(engine.combo)x")
                    .font(.caption.bold())
                    .foregroundStyle(theme.colors.accent)
            }
            if engine.hintsRemaining > 0 {
                Button { applyHint() } label: {
                    Label("\(engine.hintsRemaining)", systemImage: "lightbulb.fill")
                        .font(.caption)
                        .foregroundStyle(theme.colors.accent)
                }
            }
        }
        .padding()
    }

    private var targetStrand: some View {
        VStack(spacing: 8) {
            Text(engine.mode == .pairMatch ? "Build the complement:" : "Target sequence:")
                .font(.caption)
                .foregroundStyle(theme.colors.textSecondary)
            HStack(spacing: 4) {
                ForEach(Array(engine.targetSequence.enumerated()), id: \.offset) { _, base in
                    baseCell(base, size: 36)
                }
            }
        }
        .padding()
    }

    private var currentStrand: some View {
        VStack(spacing: 8) {
            Text("Your sequence:")
                .font(.caption)
                .foregroundStyle(theme.colors.textSecondary)
            HStack(spacing: 4) {
                ForEach(Array(engine.currentSequence.enumerated()), id: \.offset) { idx, base in
                    Button {
                        handleTap(at: idx)
                    } label: {
                        baseCell(base, size: 44, highlighted: engine.selectedIndex == idx,
                                correct: engine.mode == .pairMatch ? base == engine.targetSequence[idx].complement : base == engine.targetSequence[idx])
                    }
                }
            }
        }
        .padding()
    }

    private func baseCell(_ base: Nucleotide, size: CGFloat, highlighted: Bool = false, correct: Bool? = nil) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(highlighted ? theme.colors.primary.opacity(0.3) : base.color.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(highlighted ? theme.colors.primary : (correct == true ? theme.colors.success : base.color.opacity(0.5)), lineWidth: highlighted ? 2 : 1)
                )
            Text(base.rawValue)
                .font(.system(size: size * 0.45, weight: .bold, design: .monospaced))
                .foregroundStyle(base.color)
        }
        .frame(width: size, height: size)
    }

    private var baseSelector: some View {
        HStack(spacing: 16) {
            ForEach(Nucleotide.allCases) { base in
                Button {
                    if let idx = engine.selectedIndex {
                        engine.placePair(at: idx, base: base)
                        if engine.isComplete {
                            HapticsService.success()
                        } else {
                            HapticsService.light()
                        }
                        engine.selectedIndex = nil
                    }
                } label: {
                    baseCell(base, size: 56)
                }
            }
        }
        .padding()
    }

    private func handleTap(at index: Int) {
        if engine.mode == .pairMatch {
            engine.selectedIndex = index
            HapticsService.selection()
        } else {
            if let first = engine.selectedIndex {
                if first == index {
                    engine.selectedIndex = nil
                    return
                }
                engine.swap(first, index)
                engine.selectedIndex = nil
                if engine.isComplete {
                    HapticsService.success()
                } else {
                    HapticsService.medium()
                }
            } else {
                engine.selectedIndex = index
                HapticsService.selection()
            }
        }
    }

    private func applyHint() {
        if let idx = engine.useHint() {
            let target = engine.targetSequence[idx]
            if engine.mode == .pairMatch {
                engine.placePair(at: idx, base: target.complement)
            } else {
                let swapIdx = engine.currentSequence.enumerated().first { i, base in
                    base == target && i != idx && engine.currentSequence[i] != engine.targetSequence[i]
                }?.offset ?? engine.currentSequence.firstIndex(of: target)
                if let swapIdx {
                    engine.swap(idx, swapIdx)
                }
            }
        }
    }

    private var completionView: some View {
        VStack(spacing: 16) {
            Text("Strand Decoded!")
                .font(.title2.bold())
                .foregroundStyle(theme.colors.primary)
            HStack(spacing: 4) {
                ForEach(0..<3, id: \.self) { i in
                    Image(systemName: i < engine.stars ? "star.fill" : "star")
                        .foregroundStyle(theme.colors.accent)
                }
            }
            .font(.title)
            if engine.bestCombo > 1 {
                Text("Best combo: \(engine.bestCombo)x")
                    .font(.subheadline)
                    .foregroundStyle(theme.colors.textSecondary)
            }
            Text("+\(engine.xpEarned) XP")
                .font(.headline)
                .foregroundStyle(theme.colors.accent)

            HStack(spacing: 16) {
                GlassButton("Home", icon: "house.fill") {
                    saveResults()
                    appState.popToRoot()
                }
                if levelIndex >= 0 && levelIndex < HelixConfig.totalLevels - 1 {
                    GlassButton("Next", icon: "arrow.right") {
                        saveResults()
                        engine.startLevel(levelIndex + 1)
                    }
                }
            }
        }
        .padding()
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }

    private func saveResults() {
        let idx = levelIndex
        let fetchIdx = idx
        let descriptor = FetchDescriptor<StatsRecord>()
        guard let stat = try? modelContext.fetch(descriptor).first else { return }

        stat.totalXP += engine.xpEarned
        stat.totalTimePlayed += Int(engine.elapsed)
        stat.totalPairsMatched += engine.targetSequence.count
        stat.bestCombo = max(stat.bestCombo, engine.bestCombo)
        stat.updateStreak()

        if idx >= 0 {
            stat.levelsCompleted += 1
            if engine.stars == 3 { stat.threeStarCount += 1 }
            if engine.hintsUsed == 0 { stat.noHintCount += 1 }
            let realm = BioRealm(rawValue: idx / 16) ?? .nucleus
            stat.incrementRealm(realm)

            let levelDescriptor = FetchDescriptor<LevelRecord>(predicate: #Predicate { $0.levelIndex == fetchIdx })
            if let existing = try? modelContext.fetch(levelDescriptor).first {
                if engine.stars > existing.stars { existing.stars = engine.stars }
                if engine.moveCount < existing.bestMoves { existing.bestMoves = engine.moveCount }
            } else {
                modelContext.insert(LevelRecord(
                    levelIndex: idx, stars: engine.stars, moves: engine.moveCount, hintsUsed: engine.hintsUsed
                ))
            }
        } else if idx == -2 {
            stat.dailyCompleted += 1
        }

        try? modelContext.save()
    }
}
