import SwiftUI
import SwiftData

struct WorldsView: View {
    @Environment(\.theme) private var theme
    @Environment(AppState.self) private var appState
    @Query private var levels: [LevelRecord]

    var body: some View {
        ZStack {
            theme.gradient.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 16) {
                    Text("Realms")
                        .font(.title.weight(.bold))
                        .foregroundStyle(theme.colors.text)
                        .padding(.top)

                    ForEach(FireRealm.allCases, id: \.rawValue) { realm in
                        realmCard(realm)
                    }
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button { appState.pop() } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(theme.colors.text)
                }
            }
        }
    }

    private func realmCard(_ realm: FireRealm) -> some View {
        GlassCard {
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
                    let completed = levels.filter { realm.levelRange.contains($0.levelIndex) }.count
                    Text("\(completed)/16")
                        .font(.subheadline.weight(.medium).monospacedDigit())
                        .foregroundStyle(theme.colors.primary)
                }

                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 8), spacing: 8) {
                    ForEach(realm.levelRange, id: \.self) { idx in
                        let record = levels.first { $0.levelIndex == idx }
                        levelCell(idx, record: record)
                    }
                }
            }
        }
    }

    private func levelCell(_ index: Int, record: LevelRecord?) -> some View {
        Button {
            appState.navigate(to: .play(levelIndex: index))
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(record != nil ? theme.colors.primary.opacity(0.3) : theme.colors.surface.opacity(0.3))
                    .frame(height: 36)
                if let r = record, r.stars == 3 {
                    Image(systemName: "star.fill")
                        .font(.caption2)
                        .foregroundStyle(theme.colors.warning)
                } else {
                    Text("\(index % 16 + 1)")
                        .font(.caption2.weight(.medium).monospacedDigit())
                        .foregroundStyle(record != nil ? theme.colors.primary : theme.colors.textMuted)
                }
            }
        }
        .buttonStyle(ScaleButtonStyle())
    }
}
