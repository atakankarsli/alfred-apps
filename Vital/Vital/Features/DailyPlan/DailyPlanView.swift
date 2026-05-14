import SwiftUI
import SwiftData

struct DailyPlanView: View {
    @Environment(\.theme) private var theme
    @Environment(AppState.self) private var appState
    @State private var completedToday: Set<GameType> = []

    private var dailyGames: [GameType] { GameType.allCases }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                headerCard
                ForEach(dailyGames) { type in
                    gameRow(type)
                }
                if completedToday.count == dailyGames.count {
                    allDoneCard
                }
            }
            .padding(16)
        }
        .themedBackground()
        .navigationTitle("Today's Plan")
    }

    private var headerCard: some View {
        VStack(spacing: 8) {
            Text("\(completedToday.count)/\(dailyGames.count)")
                .font(.system(size: 36, weight: .black, design: .rounded))
                .foregroundStyle(theme.colors.accent)
            Text("Games Completed")
                .font(.system(size: 14, weight: .medium))
                .secondaryText()
            ProgressView(value: Double(completedToday.count), total: Double(dailyGames.count))
                .tint(theme.colors.accent)
                .padding(.horizontal, 32)
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(theme.colors.accent.opacity(0.06))
                .overlay { RoundedRectangle(cornerRadius: 16).strokeBorder(theme.colors.accent.opacity(0.15), lineWidth: 1) }
        }
    }

    private func gameRow(_ type: GameType) -> some View {
        let done = completedToday.contains(type)
        return Button {
            if !done {
                appState.navigate(to: .game(type: type))
                completedToday.insert(type)
            }
        } label: {
            HStack(spacing: 12) {
                Image(systemName: done ? "checkmark.circle.fill" : type.icon)
                    .font(.title2)
                    .foregroundStyle(done ? theme.colors.success : type.color)
                VStack(alignment: .leading, spacing: 2) {
                    Text(type.displayName)
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(done ? theme.colors.textMuted : theme.colors.text)
                        .strikethrough(done)
                    Text("\(type.durationSeconds / 60) min · \(type.subtitle)")
                        .font(.system(size: 12))
                        .foregroundStyle(theme.colors.textSecondary)
                }
                Spacer()
                if !done {
                    Image(systemName: "play.circle.fill")
                        .font(.title2)
                        .foregroundStyle(type.color)
                }
            }
            .padding(14)
            .background {
                RoundedRectangle(cornerRadius: 14)
                    .fill(done ? theme.colors.surface.opacity(0.2) : type.color.opacity(0.05))
                    .overlay { RoundedRectangle(cornerRadius: 14).strokeBorder(done ? theme.colors.cardBorder.opacity(0.08) : type.color.opacity(0.12), lineWidth: 1) }
            }
        }
        .buttonStyle(.plain)
        .disabled(done)
    }

    private var allDoneCard: some View {
        VStack(spacing: 10) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 40))
                .foregroundStyle(theme.colors.accent)
            Text("All Done!")
                .font(.system(size: 22, weight: .black, design: .rounded))
                .foregroundStyle(theme.colors.accent)
            Text("Great work today. See you tomorrow!")
                .font(.system(size: 14))
                .secondaryText()
        }
        .padding(20)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(theme.colors.accent.opacity(0.08))
                .overlay { RoundedRectangle(cornerRadius: 16).strokeBorder(theme.colors.accent.opacity(0.2), lineWidth: 1) }
        }
    }
}
