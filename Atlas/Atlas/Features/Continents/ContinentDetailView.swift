import SwiftUI

struct ContinentDetailView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.theme) private var theme
    let continent: Continent

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(systemName: continent.icon)
                    .font(.system(size: 60))
                    .foregroundStyle(continent.color)
                    .padding(.top)

                Text(continent.subtitle)
                    .font(.subheadline)
                    .secondaryText()

                Text("\(Countries.forContinent(continent.rawValue).count) countries")
                    .font(.caption)
                    .mutedText()

                VStack(spacing: 12) {
                    Text("Choose Quiz Type").font(.title3.bold())
                    ForEach(QuizType.allCases) { type in
                        NavigationLink {
                            QuizView(quizType: type, continent: continent)
                        } label: {
                            quizTypeRow(type)
                        }
                        .buttonStyle(ScaleButtonStyle())
                    }
                }
                .padding(.top, 8)
            }
            .padding()
        }
        .themedBackground()
        .navigationTitle(continent.displayName)
    }

    private func quizTypeRow(_ type: QuizType) -> some View {
        GlassCard {
            HStack(spacing: 14) {
                Image(systemName: type.icon)
                    .font(.title2)
                    .foregroundStyle(type.color)
                    .frame(width: 40)
                VStack(alignment: .leading, spacing: 2) {
                    Text(type.displayName).font(.headline).primaryText()
                    Text(type.description).font(.caption).secondaryText()
                }
                Spacer()
                Image(systemName: "play.circle.fill")
                    .font(.title2)
                    .foregroundStyle(theme.colors.primary)
            }
        }
    }
}
