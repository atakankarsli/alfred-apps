import SwiftUI

struct QuizView: View {
    @Environment(\.theme) private var theme
    @Environment(AppState.self) private var appState
    @State private var currentPattern = BreathPattern.all.randomElement() ?? .box
    @State private var options: [String] = []
    @State private var selectedAnswer: String?
    @State private var score = 0
    @State private var round = 0
    @State private var totalRounds = 10

    var body: some View {
        ZStack {
            theme.gradient.ignoresSafeArea()
            FloatingOrbsView()

            VStack(spacing: 24) {
                topBar
                Spacer()
                questionCard
                optionsGrid
                Spacer()
            }
            .padding()
        }
        .navigationBarBackButtonHidden()
        .onAppear { generateQuestion() }
    }

    private var topBar: some View {
        HStack {
            Button { appState.pop() } label: {
                Image(systemName: "chevron.left")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(theme.colors.text)
            }
            Spacer()
            Text("Round \(round + 1)/\(totalRounds)")
                .font(.headline)
                .foregroundStyle(theme.colors.text)
            Spacer()
            Text("\(score) pts")
                .font(.subheadline.weight(.semibold).monospacedDigit())
                .foregroundStyle(theme.colors.primary)
        }
    }

    private var questionCard: some View {
        GlassCard {
            VStack(spacing: 16) {
                Image(systemName: "waveform.path")
                    .font(.system(size: 48))
                    .foregroundStyle(theme.colors.primary)

                Text("Which breathing pattern is this?")
                    .font(.headline)
                    .foregroundStyle(theme.colors.text)
                    .multilineTextAlignment(.center)

                HStack(spacing: 16) {
                    patternDetail("In", value: currentPattern.inhale)
                    if currentPattern.hold1 > 0 {
                        patternDetail("Hold", value: currentPattern.hold1)
                    }
                    patternDetail("Out", value: currentPattern.exhale)
                    if currentPattern.hold2 > 0 {
                        patternDetail("Hold", value: currentPattern.hold2)
                    }
                }
            }
        }
    }

    private func patternDetail(_ label: String, value: Double) -> some View {
        VStack(spacing: 4) {
            Text("\(Int(value))s")
                .font(.title2.weight(.bold).monospacedDigit())
                .foregroundStyle(theme.colors.primary)
            Text(label)
                .font(.caption)
                .foregroundStyle(theme.colors.textSecondary)
        }
    }

    private var optionsGrid: some View {
        VStack(spacing: 12) {
            ForEach(options, id: \.self) { option in
                let isCorrect = option == currentPattern.name
                let isSelected = selectedAnswer == option
                Button {
                    guard selectedAnswer == nil else { return }
                    selectedAnswer = option
                    if isCorrect { score += 1 }
                    HapticsService.light()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        if round < totalRounds - 1 {
                            round += 1
                            selectedAnswer = nil
                            generateQuestion()
                        }
                    }
                } label: {
                    Text(option)
                        .font(.body.weight(.medium))
                        .foregroundStyle(
                            isSelected
                                ? (isCorrect ? theme.colors.success : theme.colors.error)
                                : theme.colors.text
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(
                                    isSelected
                                        ? (isCorrect ? theme.colors.success.opacity(0.2) : theme.colors.error.opacity(0.2))
                                        : theme.colors.surface.opacity(0.3)
                                )
                                .overlay {
                                    if isSelected {
                                        RoundedRectangle(cornerRadius: 12)
                                            .strokeBorder(isCorrect ? theme.colors.success : theme.colors.error, lineWidth: 2)
                                    }
                                }
                        }
                }
                .buttonStyle(ScaleButtonStyle())
            }
        }
    }

    private func generateQuestion() {
        let patterns = BreathPattern.all
        currentPattern = patterns.randomElement() ?? .box
        var opts = [currentPattern.name]
        while opts.count < 4 {
            if let random = patterns.randomElement(), !opts.contains(random.name) {
                opts.append(random.name)
            }
        }
        options = opts.shuffled()
    }
}
