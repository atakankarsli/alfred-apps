import SwiftUI
import SwiftData

struct WorldsView: View {
    @Environment(\.theme) var theme
    @Environment(AppState.self) var appState
    @Query var levels: [LevelRecord]

    var body: some View {
        ZStack {
            FloatingOrbsView()
            ScrollView {
                VStack(spacing: 20) {
                    Text("Realms")
                        .font(.title.bold())
                        .foregroundStyle(theme.colors.text)
                        .padding(.top)

                    ForEach(BioRealm.allCases, id: \.rawValue) { realm in
                        realmCard(realm)
                    }
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button { appState.path.removeLast() } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(theme.colors.text)
                }
            }
        }
    }

    private func realmCard(_ realm: BioRealm) -> some View {
        let range = realm.levelRange
        let completed = levels.filter { range.contains($0.levelIndex) }.count
        let total = range.count

        return GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: realm.icon)
                        .font(.title2)
                        .foregroundStyle(theme.colors.primary)
                    VStack(alignment: .leading) {
                        Text(realm.name)
                            .font(.headline)
                            .foregroundStyle(theme.colors.text)
                        Text(realm.subtitle)
                            .font(.caption)
                            .foregroundStyle(theme.colors.textSecondary)
                    }
                    Spacer()
                    Text("\(completed)/\(total)")
                        .font(.caption.bold())
                        .foregroundStyle(theme.colors.accent)
                }

                ProgressView(value: Double(completed) / Double(total))
                    .tint(theme.colors.primary)

                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 8), spacing: 8) {
                    ForEach(Array(range), id: \.self) { idx in
                        let record = levels.first { $0.levelIndex == idx }
                        Button {
                            appState.navigate(to: .play(levelIndex: idx))
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(record != nil ? theme.colors.primary.opacity(0.3) : theme.colors.cardBackground)
                                    .frame(width: 32, height: 32)
                                Text(record.map { "\($0.stars)" } ?? "\(idx % 16 + 1)")
                                    .font(.caption2.bold())
                                    .foregroundStyle(record != nil ? theme.colors.accent : theme.colors.textMuted)
                            }
                        }
                    }
                }
            }
        }
    }
}
