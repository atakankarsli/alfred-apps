import SwiftUI

struct QuizView: View {
    @Environment(\.theme) private var theme
    @Environment(AppState.self) private var appState
    @State private var currentIndex = 0
    @State private var score = 0
    @State private var selectedAnswer: String?
    @State private var showResult = false
    @State private var quizCompleted = false

    private let questions: [(glyph: Glyph, options: [String], correct: String)] = {
        var qs: [(Glyph, [String], String)] = []
        for realm in ScriptRealm.allCases.prefix(3) {
            let glyphs = GlyphData.glyphs(for: realm).shuffled().prefix(4)
            for g in glyphs {
                let correct = g.latinLetter
                let others = GlyphData.glyphs(for: realm).filter { $0.id != g.id }.shuffled().prefix(3).map(\.latinLetter)
                var opts = [correct] + others
                opts.shuffle()
                qs.append((g, opts, correct))
            }
        }
        return Array(qs.shuffled().prefix(10))
    }()

    var body: some View {
        ZStack {
            theme.gradient.ignoresSafeArea()
            FloatingOrbsView()

            if quizCompleted { quizComplete } else { quizContent }
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

    private var quizContent: some View {
        let q = questions[currentIndex]
        return VStack(spacing: 24) {
            Text("Question \(currentIndex + 1)/\(questions.count)")
                .font(.subheadline).foregroundStyle(theme.colors.textSecondary)

            Text("What letter does this symbol represent?")
                .font(.title3.weight(.semibold)).foregroundStyle(theme.colors.text)

            Text(q.glyph.symbol)
                .font(.system(size: 80))
                .foregroundStyle(theme.colors.primary)
                .padding(24)
                .background {
                    RoundedRectangle(cornerRadius: 16).fill(theme.colors.surface.opacity(0.3))
                }

            Text(q.glyph.name)
                .font(.caption).foregroundStyle(theme.colors.textMuted)

            ForEach(q.options, id: \.self) { option in
                Button {
                    guard selectedAnswer == nil else { return }
                    selectedAnswer = option
                    if option == q.correct { score += 1 }
                    showResult = true
                    Task {
                        try? await Task.sleep(for: .seconds(1))
                        if currentIndex < questions.count - 1 {
                            currentIndex += 1; selectedAnswer = nil; showResult = false
                        } else { quizCompleted = true }
                    }
                } label: {
                    HStack {
                        Text(option).font(.body.weight(.medium))
                        Spacer()
                        if showResult && option == q.correct {
                            Image(systemName: "checkmark.circle.fill").foregroundStyle(theme.colors.success)
                        } else if showResult && option == selectedAnswer && option != q.correct {
                            Image(systemName: "xmark.circle.fill").foregroundStyle(theme.colors.error)
                        }
                    }
                    .padding()
                    .background {
                        let bg: Color = {
                            if showResult && option == q.correct { return theme.colors.success.opacity(0.2) }
                            if showResult && option == selectedAnswer { return theme.colors.error.opacity(0.2) }
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
                Image(systemName: "trophy.fill").font(.system(size: 48)).foregroundStyle(theme.colors.warning)
                Text("Quiz Complete!").font(.title2.weight(.bold)).foregroundStyle(theme.colors.text)
                Text("\(score)/\(questions.count)").font(.largeTitle.weight(.black).monospacedDigit()).foregroundStyle(theme.colors.primary)
                GlassButton("Done", icon: "checkmark") { appState.pop() }
            }
        }
        .frame(maxWidth: 320)
    }
}
