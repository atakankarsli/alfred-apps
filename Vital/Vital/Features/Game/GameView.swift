import SwiftUI
import SwiftData

struct GameView: View {
    @Environment(\.theme) private var theme
    @Environment(\.modelContext) private var modelContext
    @Environment(AppState.self) private var appState
    let gameType: GameType
    @State private var vm: GameViewModel

    init(gameType: GameType, level: Int = 0) {
        self.gameType = gameType
        _vm = State(initialValue: GameViewModel(gameType: gameType, level: level))
    }

    var body: some View {
        ZStack {
            if vm.isComplete {
                completionView
            } else {
                gameplayView
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .themedBackground()
        .overlay { FloatingOrbsView() }
        .navigationBarBackButtonHidden(vm.isPlaying)
        .onAppear { vm.start() }
        .onDisappear { vm.cleanup() }
    }

    private var gameplayView: some View {
        GeometryReader { geo in
            ZStack {
                headerBar
                gameContent(in: geo.size)
                timerBar(in: geo.size)
            }
        }
    }

    private var headerBar: some View {
        VStack {
            HStack {
                Image(systemName: gameType.icon)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundStyle(gameType.color)
                Text(gameType.displayName)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .primaryText()
                Spacer()
                Text(formatTime(vm.timeRemaining))
                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                    .primaryText()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background {
                RoundedRectangle(cornerRadius: 14)
                    .fill(theme.colors.surface.opacity(0.5))
                    .overlay { RoundedRectangle(cornerRadius: 14).strokeBorder(theme.colors.cardBorder.opacity(0.12), lineWidth: 1) }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            Spacer()
        }
    }

    @ViewBuilder
    private func gameContent(in size: CGSize) -> some View {
        switch gameType {
        case .eyeFocus:
            eyeFocusContent(in: size)
        case .breathSync:
            breathSyncContent(in: size)
        case .reflexRush:
            reflexRushContent(in: size)
        case .postureCheck:
            postureCheckContent(in: size)
        }
    }

    private func eyeFocusContent(in size: CGSize) -> some View {
        ZStack {
            if let target = vm.currentTarget {
                let appearing = vm.elapsedTime >= target.appearTime
                if appearing {
                    Circle()
                        .fill(gameType.color.opacity(0.15))
                        .frame(width: target.size * 1.8, height: target.size * 1.8)
                        .position(x: size.width * target.x, y: size.height * target.y)

                    Button {
                        vm.tapTarget()
                    } label: {
                        Circle()
                            .fill(gameType.color)
                            .frame(width: target.size, height: target.size)
                            .overlay { Circle().strokeBorder(.white.opacity(0.3), lineWidth: 2) }
                            .shadow(color: gameType.color.opacity(0.4), radius: 8)
                    }
                    .position(x: size.width * target.x, y: size.height * target.y)
                }
            }

            scoreOverlay
        }
    }

    private func breathSyncContent(in size: CGSize) -> some View {
        VStack(spacing: 20) {
            Spacer()

            ZStack {
                Circle()
                    .stroke(theme.colors.cardBorder.opacity(0.15), lineWidth: 6)
                    .frame(width: 180, height: 180)

                Circle()
                    .fill(gameType.color.opacity(0.1 + vm.breathProgress * 0.15))
                    .frame(width: CGFloat(80 + vm.breathProgress * 100), height: CGFloat(80 + vm.breathProgress * 100))
                    .animation(.easeInOut(duration: 0.3), value: vm.breathProgress)

                VStack(spacing: 4) {
                    Text(breathPhaseText)
                        .font(.system(size: 22, weight: .black, design: .rounded))
                        .foregroundStyle(gameType.color)
                    Text(String(format: "%.0f%%", vm.breathProgress * 100))
                        .font(.system(size: 14, weight: .medium, design: .monospaced))
                        .secondaryText()
                }
            }
            .onTapGesture { vm.tapTarget() }

            Text("Follow the rhythm")
                .font(.system(size: 15, weight: .medium))
                .secondaryText()

            Spacer()

            scoreOverlay
        }
    }

    private var breathPhaseText: String {
        switch vm.breathPhase {
        case .idle: "Ready"
        case .inhale: "Breathe In"
        case .hold: "Hold"
        case .exhale: "Breathe Out"
        }
    }

    private func reflexRushContent(in size: CGSize) -> some View {
        ZStack {
            if let target = vm.currentTarget {
                let appearing = vm.elapsedTime >= target.appearTime && vm.elapsedTime < target.appearTime + target.duration
                if appearing {
                    Button {
                        vm.tapTarget()
                    } label: {
                        Circle()
                            .fill(gameType.color)
                            .frame(width: target.size, height: target.size)
                            .overlay { Circle().strokeBorder(.white.opacity(0.3), lineWidth: 2) }
                            .shadow(color: gameType.color.opacity(0.5), radius: 10)
                    }
                    .position(x: size.width * target.x, y: size.height * target.y)
                    .onAppear { vm.showReflexTarget() }
                }
            }

            VStack {
                Spacer()
                HStack(spacing: 16) {
                    statPill("Hits", "\(vm.hits)")
                    if let avg = vm.averageReflexTime {
                        statPill("Avg", String(format: "%.0fms", avg * 1000))
                    }
                }
                .padding(.bottom, 40)
            }
        }
    }

    private func postureCheckContent(in size: CGSize) -> some View {
        ZStack {
            if let target = vm.currentTarget {
                let appearing = vm.elapsedTime >= target.appearTime
                if appearing {
                    Circle()
                        .stroke(gameType.color.opacity(0.3), lineWidth: 4)
                        .frame(width: target.size * 2, height: target.size * 2)
                        .position(x: size.width * target.x, y: size.height * target.y)

                    Button {
                        vm.tapTarget()
                    } label: {
                        ZStack {
                            Circle()
                                .fill(gameType.color.opacity(0.15))
                                .frame(width: target.size * 1.5, height: target.size * 1.5)
                            Image(systemName: "figure.stand")
                                .font(.system(size: target.size * 0.4))
                                .foregroundStyle(gameType.color)
                        }
                    }
                    .position(x: size.width * target.x, y: size.height * target.y)
                }
            }

            scoreOverlay
        }
    }

    private var scoreOverlay: some View {
        VStack {
            Spacer()
            HStack(spacing: 16) {
                statPill("Score", "\(vm.hits)/\(vm.totalTargets)")
            }
            .padding(.bottom, 40)
        }
    }

    private func statPill(_ label: String, _ value: String) -> some View {
        VStack(spacing: 2) {
            Text(value).font(.system(size: 16, weight: .bold, design: .monospaced)).primaryText()
            Text(label).font(.system(size: 11)).mutedText()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background {
            Capsule().fill(theme.colors.surface.opacity(0.5))
                .overlay { Capsule().strokeBorder(theme.colors.cardBorder.opacity(0.12), lineWidth: 1) }
        }
    }

    private func timerBar(in size: CGSize) -> some View {
        VStack {
            Spacer()
            ProgressView(value: vm.progress)
                .tint(gameType.color)
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
        }
    }

    private var completionView: some View {
        VStack(spacing: 20) {
            Spacer()

            ZStack {
                Circle().fill(gameType.color.opacity(0.1)).frame(width: 120, height: 120)
                Image(systemName: gameType.icon).font(.system(size: 48)).foregroundStyle(gameType.color)
            }

            Text(completionTitle)
                .font(.system(size: 26, weight: .black, design: .rounded)).primaryText()

            HStack(spacing: 8) {
                ForEach(1...3, id: \.self) { star in
                    Image(systemName: star <= vm.stars ? "star.fill" : "star")
                        .font(.system(size: 30))
                        .foregroundStyle(star <= vm.stars ? .yellow : theme.colors.textMuted.opacity(0.3))
                }
            }

            VStack(spacing: 6) {
                statRow("Accuracy", String(format: "%.0f%%", vm.accuracy * 100))
                statRow("Hits", "\(vm.hits)/\(vm.totalTargets)")
                if let avg = vm.averageReflexTime {
                    statRow("Avg Reaction", String(format: "%.0fms", avg * 1000))
                }
            }
            .padding(16)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(theme.colors.surface.opacity(0.4))
                    .overlay { RoundedRectangle(cornerRadius: 16).strokeBorder(theme.colors.cardBorder.opacity(0.12), lineWidth: 1) }
            }
            .padding(.horizontal, 32)

            Spacer()

            GlassButton("Continue", icon: "arrow.right") {
                vm.saveResults(modelContext: modelContext)
                appState.pop()
            }
            .padding(.horizontal, 32)
        }
        .padding(24)
    }

    private func statRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label).font(.system(size: 14)).secondaryText()
            Spacer()
            Text(value).font(.system(size: 14, weight: .bold, design: .rounded)).primaryText()
        }
    }

    private var completionTitle: String {
        if vm.stars >= 3 { return "Perfect Health!" }
        if vm.stars >= 2 { return "Great Job!" }
        if vm.stars >= 1 { return "Good Start!" }
        return "Keep Going!"
    }

    private func formatTime(_ seconds: Double) -> String {
        let m = Int(seconds) / 60
        let s = Int(seconds) % 60
        return String(format: "%d:%02d", m, s)
    }
}
