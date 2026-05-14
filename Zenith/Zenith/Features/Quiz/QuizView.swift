import SwiftUI

struct QuizView: View {
    @Environment(\.theme) private var theme
    @Environment(AppState.self) private var appState
    @State private var currentIndex = 0
    @State private var score = 0
    @State private var selectedAnswer: String?
    @State private var showResult = false
    @State private var quizCompleted = false

    private let questions: [(constellation: Constellation, options: [String], correct: String)] = {
        let all = ConstellationData.allConstellations
        var qs: [(Constellation, [String], String)] = []
        let indices = Array(0..<min(all.count, 10)).shuffled()
        for i in indices.prefix(10) {
            let correct = all[i].name
            var opts = [correct]
            let others = all.indices.filter { $0 != i }.shuffled().prefix(3)
            for o in others { opts.append(all[o].name) }
            opts.shuffle()
            qs.append((all[i], opts, correct))
        }
        return qs
    }()

    var body: some View {
        ZStack {
            theme.gradient.ignoresSafeArea()
            StarFieldView()

            if quizCompleted {
                quizComplete
            } else {
                quizContent
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

    private var quizContent: some View {
        let q = questions[currentIndex]
        return VStack(spacing: 24) {
            Text("Question \(currentIndex + 1)/\(questions.count)")
                .font(.subheadline)
                .foregroundStyle(theme.colors.textSecondary)

            Text("Name this constellation:")
                .font(.title3.weight(.semibold))
                .foregroundStyle(theme.colors.text)

            StarCanvasView(
                constellation: q.constellation,
                engine: ZenithEngine(constellation: q.constellation),
                onStarTap: { _ in }
            )
            .frame(height: 250)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .fill(theme.colors.surface.opacity(0.3))
            }

            ForEach(q.options, id: \.self) { option in
                Button {
                    guard selectedAnswer == nil else { return }
                    selectedAnswer = option
                    if option == q.correct { score += 1 }
                    showResult = true
                    Task {
                        try? await Task.sleep(for: .seconds(1.2))
                        if currentIndex < questions.count - 1 {
                            currentIndex += 1
                            selectedAnswer = nil
                            showResult = false
                        } else {
                            quizCompleted = true
                        }
                    }
                } label: {
                    HStack {
                        Text(option)
                            .font(.body.weight(.medium))
                        Spacer()
                        if showResult && option == q.correct {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(theme.colors.success)
                        } else if showResult && option == selectedAnswer && option != q.correct {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(theme.colors.error)
                        }
                    }
                    .padding()
                    .background {
                        let bg: Color = {
                            if showResult && option == q.correct { return theme.colors.success.opacity(0.2) }
                            if showResult && option == selectedAnswer { return theme.colors.error.opacity(0.2) }
                            if option == selectedAnswer { return theme.colors.primary.opacity(0.2) }
                            return theme.colors.surface.opacity(0.5)
                        }()
                        RoundedRectangle(cornerRadius: 12).fill(bg)
                    }
                    .foregroundStyle(theme.colors.text)
                }
                .buttonStyle(ScaleButtonStyle())
            }

            Spacer()
        }
        .padding()
    }

    private var quizComplete: some View {
        GlassCard(padding: 24) {
            VStack(spacing: 20) {
                Image(systemName: "trophy.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(theme.colors.warning)

                Text("Quiz Complete!")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(theme.colors.text)

                Text("\(score)/\(questions.count)")
                    .font(.largeTitle.weight(.black).monospacedDigit())
                    .foregroundStyle(theme.colors.primary)

                GlassButton("Done", icon: "checkmark") {
                    appState.pop()
                }
            }
        }
        .frame(maxWidth: 320)
    }
}
