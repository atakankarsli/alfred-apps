import SwiftUI
import SwiftData

struct PlayView: View {
    @Environment(\.theme) var theme
    @Environment(\.modelContext) var modelContext
    @Environment(AppState.self) var appState
    @State private var engine = AetherEngine()
    @State private var selected: Element?
    @State private var lastResult: Element?
    @State private var showResult = false

    let levelIndex: Int

    var body: some View {
        ZStack {
            FloatingOrbsView()
            VStack(spacing: 0) {
                topBar
                if let target = engine.targetElement, !engine.isComplete {
                    targetView(target)
                }
                workspaceGrid
                Spacer()
                if engine.isComplete {
                    completionView
                }
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            if levelIndex >= 0 {
                engine.startLevel(levelIndex)
            } else {
                engine.startSandbox()
            }
        }
    }

    private var topBar: some View {
        HStack {
            Button { appState.path.removeLast() } label: {
                Image(systemName: "chevron.left")
                    .foregroundStyle(theme.colors.text)
            }
            Text(levelIndex >= 0 ? "Level \(levelIndex + 1)" : "Sandbox")
                .font(.headline)
                .foregroundStyle(theme.colors.text)
            Spacer()
            if levelIndex >= 0 {
                Label("\(engine.moveCount) moves", systemImage: "arrow.triangle.swap")
                    .font(.caption)
                    .foregroundStyle(theme.colors.textSecondary)
            }
            if engine.hintsRemaining > 0 {
                Button {
                    if let hint = engine.useHint() {
                        let a = ElementData.elementMap[hint.0]
                        let b = ElementData.elementMap[hint.1]
                        if let a, let b {
                            lastResult = ElementData.combine(a.id, b.id)
                            showResult = true
                        }
                    }
                } label: {
                    Label("\(engine.hintsRemaining)", systemImage: "lightbulb.fill")
                        .font(.caption)
                        .foregroundStyle(theme.colors.accent)
                }
            }
        }
        .padding()
    }

    private func targetView(_ target: Element) -> some View {
        GlassCard {
            HStack {
                Text("Create:")
                    .foregroundStyle(theme.colors.textSecondary)
                Image(systemName: target.icon)
                    .foregroundStyle(theme.colors.primary)
                Text(target.name)
                    .bold()
                    .foregroundStyle(theme.colors.text)
            }
            .font(.subheadline)
        }
        .padding(.horizontal)
    }

    private var workspaceGrid: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 90))], spacing: 12) {
                ForEach(engine.workspace) { element in
                    elementCard(element)
                }
            }
            .padding()
        }
    }

    private func elementCard(_ element: Element) -> some View {
        let isSelected = selected?.id == element.id
        return Button {
            handleTap(element)
        } label: {
            VStack(spacing: 4) {
                Image(systemName: element.icon)
                    .font(.title2)
                Text(element.name)
                    .font(.caption2)
                    .lineLimit(1)
            }
            .frame(width: 80, height: 70)
            .foregroundStyle(isSelected ? theme.colors.primary : theme.colors.text)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? theme.colors.cardSelected : theme.colors.cardBackground)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(isSelected ? theme.colors.cardBorder : theme.colors.cardHighlight, lineWidth: 1)
                    )
            )
        }
        .sensoryFeedback(.selection, trigger: isSelected)
    }

    private func handleTap(_ element: Element) {
        if let first = selected {
            if first.id == element.id {
                if let result = engine.combine(first, element) {
                    lastResult = result
                    withAnimation(.spring(duration: 0.4)) { showResult = true }
                    HapticsService.medium()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { showResult = false }
                    selected = nil
                    return
                }
                selected = nil
                return
            }
            if let result = engine.combine(first, element) {
                lastResult = result
                withAnimation(.spring(duration: 0.4)) {
                    showResult = true
                }
                HapticsService.medium()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    showResult = false
                }
            } else {
                HapticsService.error()
            }
            selected = nil
        } else {
            selected = element
        }
    }

    private var completionView: some View {
        VStack(spacing: 16) {
            Text("Element Created!")
                .font(.title2.bold())
                .foregroundStyle(theme.colors.primary)
            HStack(spacing: 4) {
                ForEach(0..<3, id: \.self) { i in
                    Image(systemName: i < engine.stars ? "star.fill" : "star")
                        .foregroundStyle(theme.colors.accent)
                }
            }
            .font(.title)
            Text("+\(engine.xpEarned) XP")
                .font(.headline)
                .foregroundStyle(theme.colors.accent)

            HStack(spacing: 16) {
                GlassButton("Home", icon: "house.fill") {
                    saveResults()
                    appState.popToRoot()
                }
                if levelIndex >= 0 && levelIndex < AetherConfig.totalLevels - 1 {
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
        stat.totalCombinations += engine.moveCount
        stat.totalTimePlayed += Int(engine.elapsed)
        stat.elementsDiscovered = max(stat.elementsDiscovered, engine.discovered.count)
        stat.updateStreak()

        if idx >= 0 {
            stat.levelsCompleted += 1
            if engine.stars == 3 { stat.threeStarCount += 1 }
            if engine.hintsUsed == 0 { stat.noHintCount += 1 }
            let realm = AlchemyRealm(rawValue: idx / 16) ?? .primordial
            stat.incrementRealm(realm)

            let levelDescriptor = FetchDescriptor<LevelRecord>(predicate: #Predicate { $0.levelIndex == fetchIdx })
            if let existing = try? modelContext.fetch(levelDescriptor).first {
                if engine.stars > existing.stars { existing.stars = engine.stars }
                if engine.moveCount < existing.bestMoves { existing.bestMoves = engine.moveCount }
            } else {
                modelContext.insert(LevelRecord(
                    levelIndex: idx, stars: engine.stars, moves: engine.moveCount,
                    elementsFound: engine.discovered.count - 4, hintsUsed: engine.hintsUsed
                ))
            }
        } else {
            stat.sandboxCombinations += engine.moveCount
        }

        try? modelContext.save()
    }
}
