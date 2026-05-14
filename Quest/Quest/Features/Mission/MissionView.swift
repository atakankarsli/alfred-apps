import SwiftUI
import SwiftData

struct MissionView: View {
    @Environment(\.theme) private var theme
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var vm: MissionViewModel

    let isDaily: Bool
    let isFreeRoam: Bool

    init(missionIndex: Int, isDaily: Bool = false, isFreeRoam: Bool = false) {
        _vm = State(initialValue: MissionViewModel(level: missionIndex))
        self.isDaily = isDaily
        self.isFreeRoam = isFreeRoam
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                missionHeader
                fogMapSection
                objectivesList
                if vm.isComplete { completionCard }
            }
            .padding(16)
        }
        .themedBackground()
        .navigationTitle(vm.mission.title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { vm.startTimer() }
        .onDisappear { vm.stopTimer() }
    }

    private var missionHeader: some View {
        HStack {
            Image(systemName: vm.mission.type.icon)
                .font(.title2)
                .foregroundStyle(vm.mission.type.color(theme))
            VStack(alignment: .leading, spacing: 2) {
                Text(vm.mission.region.name)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(vm.mission.region.color(theme))
                Text("\(vm.mission.xpReward) XP")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .secondaryText()
            }
            Spacer()
            Text(formatTime(vm.elapsedTime))
                .font(.system(size: 16, weight: .bold, design: .monospaced))
                .primaryText()
        }
        .padding(12)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(theme.colors.surface.opacity(0.4))
        }
    }

    private var fogMapSection: some View {
        let cols = vm.mission.gridSize

        return VStack(spacing: 8) {
            Text("Fog Map")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .primaryText()

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 2), count: cols), spacing: 2) {
                ForEach(0..<vm.fogRevealed.count, id: \.self) { i in
                    Rectangle()
                        .fill(vm.fogRevealed[i] ? theme.colors.accent.opacity(0.6) : theme.colors.surface.opacity(0.2))
                        .aspectRatio(1, contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 2))
                }
            }

            let revealed = vm.fogRevealed.filter { $0 }.count
            Text("\(revealed)/\(vm.fogRevealed.count) revealed")
                .font(.caption)
                .mutedText()
        }
        .padding(12)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(theme.colors.surface.opacity(0.3))
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(theme.colors.cardBorder.opacity(0.1), lineWidth: 1)
                }
        }
    }

    private var objectivesList: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Objectives")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .primaryText()

            ForEach(0..<vm.mission.objectives.count, id: \.self) { i in
                let obj = vm.mission.objectives[i]
                Button {
                    vm.completeObjective(i)
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: vm.objectivesDone[i] ? "checkmark.circle.fill" : "circle")
                            .foregroundStyle(vm.objectivesDone[i] ? theme.colors.accent : theme.colors.textSecondary)
                        Text(obj.description)
                            .font(.system(size: 14))
                            .strikethrough(vm.objectivesDone[i])
                            .primaryText()
                        Spacer()
                    }
                    .padding(10)
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(vm.objectivesDone[i] ? theme.colors.accent.opacity(0.08) : theme.colors.surface.opacity(0.2))
                    }
                }
                .buttonStyle(.plain)
                .disabled(vm.objectivesDone[i] || vm.isComplete)
            }

            ProgressView(value: vm.progress)
                .tint(theme.colors.accent)
                .padding(.top, 4)
        }
        .padding(12)
        .background {
            RoundedRectangle(cornerRadius: 12)
                .fill(theme.colors.surface.opacity(0.3))
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(theme.colors.cardBorder.opacity(0.1), lineWidth: 1)
                }
        }
    }

    private var completionCard: some View {
        VStack(spacing: 12) {
            Text("Mission Complete!")
                .font(.system(size: 22, weight: .black, design: .rounded))
                .foregroundStyle(theme.colors.accent)

            HStack(spacing: 4) {
                ForEach(0..<3, id: \.self) { i in
                    Image(systemName: i < vm.starRating ? "star.fill" : "star")
                        .font(.title)
                        .foregroundStyle(i < vm.starRating ? .yellow : theme.colors.textSecondary.opacity(0.3))
                }
            }

            Text("+\(vm.mission.xpReward) XP")
                .font(.system(size: 18, weight: .bold, design: .monospaced))
                .foregroundStyle(theme.colors.accent)

            GlassButton("Continue", icon: "arrow.right") {
                vm.saveResults(modelContext: modelContext)
                dismiss()
            }
        }
        .padding(20)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(theme.colors.accent.opacity(0.1))
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(theme.colors.accent.opacity(0.3), lineWidth: 1)
                }
        }
    }

    private func formatTime(_ seconds: Int) -> String {
        let m = seconds / 60
        let s = seconds % 60
        return String(format: "%d:%02d", m, s)
    }
}
