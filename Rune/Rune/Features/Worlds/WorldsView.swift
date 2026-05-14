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
                VStack(spacing: 20) {
                    Text("Script Realms")
                        .font(.title.weight(.bold))
                        .foregroundStyle(theme.colors.text)
                        .padding(.top)

                    ForEach(ScriptRealm.allCases, id: \.rawValue) { realm in
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
                    Image(systemName: "chevron.left").foregroundStyle(theme.colors.text)
                }
            }
        }
    }

    private func realmCard(_ realm: ScriptRealm) -> some View {
        let completed = levels.filter { realm.levelRange.contains($0.levelIndex) }.count

        return GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: realm.icon).font(.title2).foregroundStyle(theme.colors.primary)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(realm.name).font(.headline).foregroundStyle(theme.colors.text)
                        Text(realm.subtitle).font(.caption).foregroundStyle(theme.colors.textSecondary)
                    }
                    Spacer()
                    Text("\(completed)/16").font(.subheadline.weight(.semibold).monospacedDigit()).foregroundStyle(theme.colors.primary)
                }

                ProgressView(value: Double(completed), total: 16).tint(theme.colors.primary)

                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 8), spacing: 8) {
                    ForEach(Array(realm.levelRange), id: \.self) { idx in
                        let isCompleted = levels.contains { $0.levelIndex == idx }
                        Button { appState.navigate(to: .play(levelIndex: idx)) } label: {
                            ZStack {
                                Circle()
                                    .fill(isCompleted ? theme.colors.primary.opacity(0.3) : theme.colors.surface.opacity(0.5))
                                    .frame(width: 36, height: 36)
                                if isCompleted {
                                    Image(systemName: "star.fill").font(.caption2).foregroundStyle(theme.colors.primary)
                                } else {
                                    Text("\(idx % 16 + 1)").font(.caption2.weight(.medium)).foregroundStyle(theme.colors.textSecondary)
                                }
                            }
                        }
                        .buttonStyle(ScaleButtonStyle())
                    }
                }
            }
        }
    }
}
