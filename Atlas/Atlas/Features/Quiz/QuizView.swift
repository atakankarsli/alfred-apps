import SwiftUI

struct QuizView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss

    let quizType: QuizType
    let continent: Continent

    @State private var round: QuizRound?
    @State private var currentIndex = 0
    @State private var selectedAnswer: Int?
    @State private var correctAnswers = 0
    @State private var showResult = false
    @State private var timeRemaining: Double = 15
    @State private var timerActive = true

    private var question: QuizQuestion? { round?.questions[safe: currentIndex] }
    private var progress: Double { guard let r = round else { return 0 }; return Double(currentIndex) / Double(r.questions.count) }

    var body: some View {
        Group {
            if let round, let question {
                quizContent(round: round, question: question)
            } else {
                ProgressView().onAppear(perform: generateRound)
            }
        }
        .themedBackground()
        .navigationTitle(round?.title ?? quizType.displayName)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(round != nil && !showResult)
        .fullScreenCover(isPresented: $showResult) {
            if let round {
                QuizResultView(
                    quizType: quizType,
                    continent: continent,
                    correctCount: correctAnswers,
                    totalCount: round.questions.count
                )
            }
        }
    }

    private func quizContent(round: QuizRound, question: QuizQuestion) -> some View {
        VStack(spacing: 24) {
            ProgressView(value: progress)
                .tint(theme.colors.primary)

            HStack {
                Text("\(currentIndex + 1)/\(round.questions.count)")
                    .font(.caption.bold()).secondaryText()
                Spacer()
                Label("\(Int(timeRemaining))", systemImage: "clock")
                    .font(.caption.bold())
                    .foregroundStyle(timeRemaining < 5 ? .red : theme.colors.textSecondary)
            }

            Spacer()

            Text(question.prompt)
                .font(.title2.bold())
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Spacer()

            VStack(spacing: 12) {
                ForEach(Array(question.options.enumerated()), id: \.offset) { idx, option in
                    optionButton(idx: idx, option: option, question: question)
                }
            }
            .padding(.bottom)
        }
        .padding()
        .onAppear { timeRemaining = round.timePerQuestion; startTimer() }
    }

    private func optionButton(idx: Int, option: String, question: QuizQuestion) -> some View {
        Button {
            guard selectedAnswer == nil else { return }
            selectAnswer(idx, correct: question.correctIndex)
        } label: {
            HStack {
                Text(option).font(.body.weight(.medium))
                Spacer()
                if let sel = selectedAnswer {
                    if idx == question.correctIndex {
                        Image(systemName: "checkmark.circle.fill").foregroundStyle(.green)
                    } else if idx == sel {
                        Image(systemName: "xmark.circle.fill").foregroundStyle(.red)
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(optionColor(idx: idx, correct: question.correctIndex))
            }
        }
        .buttonStyle(ScaleButtonStyle())
        .disabled(selectedAnswer != nil)
    }

    private func optionColor(idx: Int, correct: Int) -> Color {
        guard let sel = selectedAnswer else {
            return theme.colors.surface.opacity(0.6)
        }
        if idx == correct { return .green.opacity(0.2) }
        if idx == sel { return .red.opacity(0.2) }
        return theme.colors.surface.opacity(0.3)
    }

    private func generateRound() {
        let dayOffset = Calendar.current.ordinality(of: .day, in: .era, for: Date()) ?? 0
        round = QuizEngine.generateRound(type: quizType, dayOffset: dayOffset, level: appState.fetchProfile()?.level ?? 0, continentId: continent.rawValue)
    }

    private func selectAnswer(_ idx: Int, correct: Int) {
        selectedAnswer = idx
        timerActive = false
        if idx == correct {
            correctAnswers += 1
            SoundService.playCorrect()
            HapticsService.success()
        } else {
            SoundService.playWrong()
            HapticsService.error()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { advance() }
    }

    private func advance() {
        guard let round else { return }
        if currentIndex + 1 < round.questions.count {
            currentIndex += 1
            selectedAnswer = nil
            timeRemaining = round.timePerQuestion
            timerActive = true
            startTimer()
        } else {
            showResult = true
        }
    }

    private func startTimer() {
        timerActive = true
        Task {
            while timerActive && timeRemaining > 0 {
                try? await Task.sleep(for: .milliseconds(100))
                if timerActive { timeRemaining = max(0, timeRemaining - 0.1) }
            }
            if timerActive && timeRemaining <= 0 {
                await MainActor.run {
                    guard selectedAnswer == nil else { return }
                    selectAnswer(-1, correct: question?.correctIndex ?? 0)
                }
            }
        }
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
