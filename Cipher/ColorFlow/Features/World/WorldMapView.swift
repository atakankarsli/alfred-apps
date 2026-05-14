import SwiftUI
import SwiftData

struct VaultMapView: View {
    @Environment(\.theme) private var theme
    @Environment(AppState.self) private var appState
    @Query private var settings: [SettingsRecord]
    @Query private var stats: [StatsRecord]

    private var bestTimes: [Int: Int] { stats.first?.bestMoves ?? [:] }
    private var highestUnlocked: Int { settings.first?.highestUnlockedLevel ?? 0 }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(Vault.all) { vault in
                    vaultCard(vault)
                }
            }
            .padding(16)
        }
        .themedBackground()
        .navigationTitle("Vaults")
    }

    private func vaultCard(_ vault: Vault) -> some View {
        let completedCount = vault.levelRange.filter { bestTimes[$0] != nil }.count
        let starsEarned = vaultStars(vault)
        let maxStars = vault.levelCount * 3
        let isLocked = vault.firstLevel > highestUnlocked
        let isComplete = completedCount == vault.levelCount
        let vaultColor = Color(hex: vault.accentHex)

        return VStack(spacing: 0) {
            vaultHeader(vault, completedCount: completedCount, starsEarned: starsEarned, maxStars: maxStars, isLocked: isLocked, isComplete: isComplete, vaultColor: vaultColor)
            if !isLocked {
                vaultProgressBar(completedCount: completedCount, total: vault.levelCount, color: vaultColor)
                levelGrid(vault, vaultColor: vaultColor).padding(14).padding(.top, 4)
            }
        }
        .background {
            RoundedRectangle(cornerRadius: 18)
                .fill(isLocked ? theme.colors.surface.opacity(0.2) : theme.colors.surface.opacity(0.45))
                .overlay { RoundedRectangle(cornerRadius: 18).strokeBorder(isLocked ? theme.colors.boardBorder.opacity(0.08) : vaultColor.opacity(0.12), lineWidth: 1) }
        }
        .opacity(isLocked ? 0.5 : 1)
    }

    private func vaultHeader(_ vault: Vault, completedCount: Int, starsEarned: Int, maxStars: Int, isLocked: Bool, isComplete: Bool, vaultColor: Color) -> some View {
        HStack {
            ZStack {
                Circle().fill(isLocked ? theme.colors.textMuted.opacity(0.1) : vaultColor.opacity(0.15)).frame(width: 44, height: 44)
                Image(systemName: vault.icon).font(.system(size: 20, weight: .bold)).foregroundStyle(isLocked ? theme.colors.textMuted.opacity(0.3) : vaultColor)
            }
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(vault.name).font(.system(size: 18, weight: .black, design: .rounded)).primaryText()
                    if isComplete { Image(systemName: "checkmark.seal.fill").font(.system(size: 14)).foregroundStyle(.green) }
                }
                Text(vault.subtitle).font(.system(size: 13, weight: .medium)).secondaryText()
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 3) {
                Text("\(completedCount)/\(vault.levelCount)").font(.system(size: 15, weight: .bold, design: .rounded)).primaryText()
                HStack(spacing: 2) {
                    Image(systemName: "star.fill").font(.system(size: 10)).foregroundStyle(.yellow)
                    Text("\(starsEarned)/\(maxStars)").font(.system(size: 11, weight: .medium)).secondaryText()
                }
            }
        }
        .padding(14)
    }

    private func vaultProgressBar(completedCount: Int, total: Int, color: Color) -> some View {
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

    private func vaultStars(_ vault: Vault) -> Int {
        vault.levelRange.reduce(0) { total, level in
            guard let time = bestTimes[level] else { return total }
            let par = CipherPuzzle.parTime(for: level)
            return total + CipherConfig.starsForTime(time, par: par)
        }
    }

    private func levelGrid(_ vault: Vault, vaultColor: Color) -> some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 5), spacing: 8) {
            ForEach(Array(vault.levelRange), id: \.self) { level in
                levelCell(level, vault: vault, vaultColor: vaultColor)
            }
        }
    }

    private func levelCell(_ level: Int, vault: Vault, vaultColor: Color) -> some View {
        let isCompleted = bestTimes[level] != nil
        let isAvailable = level <= highestUnlocked
        let localIndex = level - vault.firstLevel + 1

        return Button {
            if isAvailable {
                appState.navigateInCurrentTab(to: .cipher(mode: .decrypt(index: level)))
            }
        } label: {
            ZStack {
                cellBackground(isCompleted: isCompleted, isAvailable: isAvailable, vaultColor: vaultColor)
                VStack(spacing: 2) {
                    Text("\(localIndex)")
                        .font(.system(size: 14, weight: isCompleted ? .bold : .medium, design: .rounded))
                        .foregroundStyle(cellTextColor(isCompleted: isCompleted, isAvailable: isAvailable, vaultColor: vaultColor))
                    if isCompleted {
                        cellStars(level: level)
                    }
                }
            }
        }
        .buttonStyle(BounceButtonStyle())
        .disabled(!isAvailable)
    }

    private func cellBackground(isCompleted: Bool, isAvailable: Bool, vaultColor: Color) -> some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(isCompleted ? vaultColor.opacity(0.15) : (isAvailable ? theme.colors.surface.opacity(0.5) : theme.colors.cellBackground.opacity(0.2)))
            .overlay {
                if isCompleted { RoundedRectangle(cornerRadius: 10).strokeBorder(vaultColor.opacity(0.2), lineWidth: 1) }
            }
            .frame(height: 42)
    }

    private func cellTextColor(isCompleted: Bool, isAvailable: Bool, vaultColor: Color) -> Color {
        isCompleted ? vaultColor : (isAvailable ? theme.colors.text : theme.colors.textMuted.opacity(0.3))
    }

    private func cellStars(level: Int) -> some View {
        let time = bestTimes[level] ?? 0
        let par = CipherPuzzle.parTime(for: level)
        let s = CipherConfig.starsForTime(time, par: par)
        return HStack(spacing: 1) {
            ForEach(1...3, id: \.self) { star in
                Image(systemName: star <= s ? "star.fill" : "star")
                    .font(.system(size: 6))
                    .foregroundStyle(star <= s ? .yellow : theme.colors.textMuted.opacity(0.2))
            }
        }
    }
}
