import SwiftUI
import SwiftData

struct PlayView: View {
    @Environment(\.theme) private var theme
    @Environment(\.modelContext) private var modelContext
    @Environment(AppState.self) private var appState

    let trackIndex: Int
    var isDaily: Bool = false
    var isFreestyle: Bool = false

    @State private var vm = PlayViewModel()

    var body: some View {
        ZStack {
            FloatingOrbsView().ignoresSafeArea()

            if vm.isComplete {
                completionView
            } else {
                rhythmView
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .themedBackground()
        .navigationBarBackButtonHidden(vm.isPlaying)
        .onAppear { vm.startTrack(index: trackIndex, isDaily: isDaily, isFreestyle: isFreestyle) }
        .onDisappear { vm.cleanup() }
    }

    private var rhythmView: some View {
        GeometryReader { geo in
            ZStack {
                laneLines(in: geo.size)
                hitLine(in: geo.size)
                fallingNotes(in: geo.size)
                tapZones(in: geo.size)
                headerOverlay
                judgmentDisplay(in: geo.size)
                comboDisplay(in: geo.size)
            }
        }
    }

    private func laneLines(in size: CGSize) -> some View {
        let laneWidth = size.width / 3
        return ZStack {
            ForEach(1..<3, id: \.self) { i in
                Rectangle()
                    .fill(theme.colors.cardBorder.opacity(0.15))
                    .frame(width: 1)
                    .position(x: laneWidth * CGFloat(i), y: size.height / 2)
                    .frame(height: size.height)
            }
        }
    }

    private func hitLine(in size: CGSize) -> some View {
        let y = size.height * 0.85
        return ZStack {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [theme.colors.accent.opacity(0.0), theme.colors.accent.opacity(0.4), theme.colors.accent.opacity(0.0)],
                        startPoint: .leading, endPoint: .trailing
                    )
                )
                .frame(height: 3)
                .position(x: size.width / 2, y: y)

            ForEach(0..<3, id: \.self) { lane in
                let laneWidth = size.width / 3
                let x = laneWidth * CGFloat(lane) + laneWidth / 2
                Circle()
                    .fill(theme.colors.accent.opacity(0.08))
                    .frame(width: 60, height: 60)
                    .position(x: x, y: y)
            }
        }
    }

    private func fallingNotes(in size: CGSize) -> some View {
        let laneWidth = size.width / 3
        return ZStack {
            ForEach(vm.visibleNotes) { note in
                let x = laneWidth * CGFloat(note.lane) + laneWidth / 2
                let y = vm.noteYPosition(note: note, height: size.height)
                let noteColor = Color(hex: note.type.colorHex)

                noteShape(note: note, color: noteColor)
                    .position(x: x, y: y)
            }
        }
    }

    private func noteShape(note: BeatNote, color: Color) -> some View {
        Group {
            switch note.type {
            case .tap:
                Circle()
                    .fill(color)
                    .frame(width: 44, height: 44)
                    .overlay {
                        Circle().strokeBorder(.white.opacity(0.3), lineWidth: 2)
                    }
                    .shadow(color: color.opacity(0.5), radius: 8)
            case .hold:
                RoundedRectangle(cornerRadius: 22)
                    .fill(color)
                    .frame(width: 44, height: 80)
                    .overlay {
                        RoundedRectangle(cornerRadius: 22).strokeBorder(.white.opacity(0.3), lineWidth: 2)
                    }
                    .shadow(color: color.opacity(0.4), radius: 6)
            case .double:
                RoundedRectangle(cornerRadius: 10)
                    .fill(color)
                    .frame(width: 52, height: 44)
                    .overlay {
                        RoundedRectangle(cornerRadius: 10).strokeBorder(.white.opacity(0.3), lineWidth: 2)
                    }
                    .shadow(color: color.opacity(0.5), radius: 8)
            case .swipe:
                Diamond()
                    .fill(color)
                    .frame(width: 44, height: 44)
                    .overlay {
                        Diamond().strokeBorder(.white.opacity(0.3), lineWidth: 2)
                    }
                    .shadow(color: color.opacity(0.5), radius: 8)
            }
        }
    }

    private func tapZones(in size: CGSize) -> some View {
        let laneWidth = size.width / 3
        let tapY = size.height * 0.85
        return HStack(spacing: 0) {
            ForEach(0..<3, id: \.self) { lane in
                Color.clear
                    .frame(width: laneWidth, height: size.height * 0.35)
                    .contentShape(Rectangle())
                    .onTapGesture { vm.tapLane(lane) }
            }
        }
        .position(x: size.width / 2, y: tapY)
    }

    private var headerOverlay: some View {
        VStack {
            HStack {
                if let track = vm.track {
                    HStack(spacing: 6) {
                        Image(systemName: "metronome.fill")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(theme.colors.accent)
                        Text(vm.bpmDisplay)
                            .font(.system(size: 14, weight: .bold, design: .monospaced))
                            .primaryText()
                    }

                    Spacer()

                    Text("Track \(track.index + 1)")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .primaryText()

                    Spacer()

                    Text(track.season.name)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color(hex: track.season.accentHex))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background {
                RoundedRectangle(cornerRadius: 14)
                    .fill(theme.colors.surface.opacity(0.5))
                    .overlay {
                        RoundedRectangle(cornerRadius: 14)
                            .strokeBorder(theme.colors.cardBorder.opacity(0.12), lineWidth: 1)
                    }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)

            Spacer()
        }
    }

    private func judgmentDisplay(in size: CGSize) -> some View {
        Group {
            if let judgment = vm.lastJudgment,
               let time = vm.lastJudgmentTime,
               Date().timeIntervalSince(time) < 0.5 {
                Text(judgment.rawValue)
                    .font(.system(size: 24, weight: .black, design: .rounded))
                    .foregroundStyle(Color(hex: judgment.colorHex))
                    .shadow(color: Color(hex: judgment.colorHex).opacity(0.5), radius: 8)
                    .position(x: size.width / 2, y: size.height * 0.65)
                    .transition(.scale.combined(with: .opacity))
            }
        }
    }

    private func comboDisplay(in size: CGSize) -> some View {
        Group {
            if vm.combo > 2 {
                VStack(spacing: 2) {
                    Text("\(vm.combo)")
                        .font(.system(size: 36, weight: .black, design: .rounded))
                        .foregroundStyle(theme.colors.accent)
                    Text("COMBO")
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundStyle(theme.colors.accent.opacity(0.7))
                    if vm.comboMultiplier > 1 {
                        Text("×\(vm.comboMultiplier)")
                            .font(.system(size: 16, weight: .black, design: .rounded))
                            .foregroundStyle(.yellow)
                    }
                }
                .position(x: size.width * 0.85, y: size.height * 0.2)
            }
        }
    }

    private var completionView: some View {
        VStack(spacing: 20) {
            Spacer()

            ZStack {
                Circle()
                    .fill(theme.colors.accent.opacity(0.1))
                    .frame(width: 120, height: 120)
                Image(systemName: vm.stars >= 2 ? "waveform.badge.exclamationmark" : "waveform")
                    .font(.system(size: 52))
                    .foregroundStyle(theme.colors.accent)
            }

            Text(completionTitle)
                .font(.system(size: 28, weight: .black, design: .rounded))
                .primaryText()

            HStack(spacing: 8) {
                ForEach(1...3, id: \.self) { star in
                    Image(systemName: star <= vm.stars ? "star.fill" : "star")
                        .font(.system(size: 32))
                        .foregroundStyle(star <= vm.stars ? .yellow : theme.colors.textMuted.opacity(0.3))
                }
            }

            VStack(spacing: 6) {
                statRow("Accuracy", String(format: "%.1f%%", vm.accuracy * 100))
                statRow("Max Combo", "\(vm.maxCombo)×")
                statRow("Perfect", "\(vm.perfectCount)")
                statRow("Great", "\(vm.greatCount)")
                statRow("Good", "\(vm.goodCount)")
                statRow("Miss", "\(vm.missCount)")
            }
            .padding(16)
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(theme.colors.surface.opacity(0.4))
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(theme.colors.cardBorder.opacity(0.12), lineWidth: 1)
                    }
            }
            .padding(.horizontal, 32)

            Spacer()

            GlassButton("Continue", icon: "arrow.right") {
                vm.updateStats(modelContext: modelContext)
                vm.checkAchievements(modelContext: modelContext)
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
        if vm.stars >= 3 { return "FLAWLESS!" }
        if vm.stars >= 2 { return "Excellent!" }
        if vm.stars >= 1 { return "Nice Groove!" }
        return "Keep Practicing!"
    }
}

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.closeSubpath()
        return path
    }
}

extension Diamond: InsettableShape {
    func inset(by amount: CGFloat) -> some InsettableShape {
        self
    }
}
