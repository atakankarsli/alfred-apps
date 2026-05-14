import SwiftUI
import SwiftData

struct RitualView: View {
    @Environment(\.theme) private var theme
    @Environment(\.modelContext) private var modelContext
    @Environment(AppState.self) private var appState
    let mode: RitualMode
    @State private var vm = RitualViewModel()

    var body: some View {
        ZStack {
            FloatingOrbsView().ignoresSafeArea()
            if vm.isComplete { completionView } else { ritualContent }
        }.frame(maxWidth: .infinity, maxHeight: .infinity).themedBackground()
        .onAppear { vm.startRitual(mode: mode, modelContext: modelContext) }
    }

    private var ritualContent: some View {
        VStack(spacing: 12) {
            header.padding(.horizontal, 16)
            if let r = vm.ritualSet {
                Text("Tap habits as you complete them").font(.system(size: 13, weight: .medium)).secondaryText()
                habitGrid(r).padding(.horizontal, 16)
                progressBar(r).padding(.horizontal, 16)
                if vm.completedHabits.count > 0 {
                    GlassButton("Finish Ritual", icon: "checkmark.circle.fill") { vm.finishEarly() }.padding(.horizontal, 32)
                }
            }
            Spacer()
        }.padding(.top, 8)
    }

    private var header: some View {
        HStack {
            if let r = vm.ritualSet {
                HStack(spacing: 6) {
                    Image(systemName: r.category.icon).font(.system(size: 14, weight: .bold)).foregroundStyle(Color(hex: r.category.colorHex))
                    Text(r.category.displayName).font(.system(size: 14, weight: .bold, design: .rounded)).primaryText()
                }
            }
            Spacer()
            HStack(spacing: 4) {
                Image(systemName: "checkmark.circle.fill").font(.system(size: 12))
                Text("\(vm.completedHabits.count)/\(vm.ritualSet?.habits.count ?? 0)").font(.system(size: 18, weight: .black, design: .monospaced))
            }.foregroundStyle(theme.colors.accent)
        }.padding(12).background {
            RoundedRectangle(cornerRadius: 14).fill(theme.colors.surface.opacity(0.5))
                .overlay { RoundedRectangle(cornerRadius: 14).strokeBorder(theme.colors.boardBorder.opacity(0.12), lineWidth: 1) }
        }
    }

    private func habitGrid(_ r: RitualSet) -> some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: r.gridSize), spacing: 8) {
            ForEach(r.habits) { habit in
                RitualCellView(habit: habit, isCompleted: vm.completedHabits.contains(habit.id), catHex: r.category.colorHex, theme: theme) { vm.toggleHabit(habit.id) }
            }
        }
    }

    private func progressBar(_ r: RitualSet) -> some View {
        let ratio = r.completionRatio(completed: vm.completedHabits)
        return VStack(spacing: 4) {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(theme.colors.cellBackground).frame(height: 8)
                    Capsule().fill(LinearGradient(colors: [theme.colors.accent, theme.colors.accent.opacity(0.7)], startPoint: .leading, endPoint: .trailing))
                        .frame(width: max(8, geo.size.width * ratio), height: 8).animation(.spring(response: 0.4), value: ratio)
                }
            }.frame(height: 8)
            Text("\(Int(ratio * 100))% complete").font(.system(size: 11, weight: .medium)).secondaryText()
        }
    }

    private var completionView: some View {
        VStack(spacing: 24) {
            Spacer()
            ZStack {
                Circle().fill(theme.colors.accent.opacity(0.1)).frame(width: 120, height: 120)
                Image(systemName: vm.stars >= 2 ? "sparkles" : "checkmark.seal.fill").font(.system(size: 52)).foregroundStyle(theme.colors.accent)
            }
            Text(vm.stars >= 3 ? "Ritual Complete!" : vm.stars >= 2 ? "Well Done!" : vm.stars >= 1 ? "Good Start!" : "Keep Going!")
                .font(.system(size: 28, weight: .black, design: .rounded)).primaryText()
            Text("\(vm.completedHabits.count)/\(vm.ritualSet?.habits.count ?? 0) habits completed")
                .font(.system(size: 18, weight: .bold, design: .rounded)).secondaryText()
            HStack(spacing: 8) {
                ForEach(1...3, id: \.self) { s in
                    Image(systemName: s <= vm.stars ? "star.fill" : "star").font(.system(size: 32))
                        .foregroundStyle(s <= vm.stars ? .yellow : theme.colors.textMuted.opacity(0.3))
                }
            }
            Spacer()
            GlassButton("Continue", icon: "arrow.right") {
                vm.updateStats(modelContext: modelContext); vm.checkAchievements(modelContext: modelContext)
                appState.navigationPath.removeLast()
            }.padding(.horizontal, 32)
        }.padding(24)
    }
}

struct RitualCellView: View {
    let habit: RitualSet.Habit; let isCompleted: Bool; let catHex: String; let theme: Theme; let onTap: () -> Void
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Image(systemName: isCompleted ? "checkmark.circle.fill" : habit.icon).font(.system(size: 20, weight: .bold))
                    .foregroundStyle(isCompleted ? .green : Color(hex: catHex))
                Text(habit.title).font(.system(size: 8, weight: .bold, design: .rounded))
                    .foregroundStyle(isCompleted ? theme.colors.textMuted : theme.colors.text).lineLimit(2).multilineTextAlignment(.center)
                Text(habit.duration).font(.system(size: 7, weight: .medium)).foregroundStyle(theme.colors.textMuted)
            }.frame(maxWidth: .infinity).padding(.vertical, 8).padding(.horizontal, 4)
            .background {
                RoundedRectangle(cornerRadius: 10).fill(isCompleted ? Color.green.opacity(0.1) : theme.colors.surface.opacity(0.5))
                    .overlay { RoundedRectangle(cornerRadius: 10).strokeBorder(isCompleted ? Color.green.opacity(0.3) : theme.colors.boardBorder.opacity(0.12), lineWidth: 1) }
            }
        }.buttonStyle(BounceButtonStyle())
    }
}
