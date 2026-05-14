import SwiftUI
import SwiftData

struct StatsView: View {
    @Environment(\.theme) private var theme
    @Query private var profiles: [UserProfileModel]
    @Query(sort: \QuizRecordModel.date, order: .reverse) private var records: [QuizRecordModel]

    private var profile: UserProfileModel? { profiles.first }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                overviewSection
                typeBreakdown
                recentActivity
            }
            .padding()
        }
        .themedBackground()
        .navigationTitle("Statistics")
    }

    private var overviewSection: some View {
        GlassCard {
            VStack(spacing: 16) {
                statRow("Total Quizzes", value: "\(profile?.totalQuizzes ?? 0)")
                statRow("Total XP", value: "\(profile?.totalXP ?? 0)")
                statRow("Current Streak", value: "\(profile?.currentStreak ?? 0) days")
                statRow("Best Streak", value: "\(profile?.bestStreak ?? 0) days")
                statRow("Perfect Scores", value: "\(profile?.perfectQuizzes ?? 0)")
                statRow("Average Score", value: averageScore)
            }
        }
    }

    private var typeBreakdown: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("By Type").font(.title3.bold())
            ForEach(QuizType.allCases) { type in
                GlassCard {
                    HStack {
                        Image(systemName: type.icon).foregroundStyle(type.color)
                        Text(type.displayName).font(.subheadline.bold())
                        Spacer()
                        Text("\(profile?.quizCount(for: type) ?? 0) played")
                            .font(.caption).secondaryText()
                    }
                }
            }
        }
    }

    private var recentActivity: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent").font(.title3.bold())
            if records.isEmpty {
                Text("No quizzes yet").font(.subheadline).secondaryText().padding()
            } else {
                ForEach(records.prefix(10)) { record in
                    GlassCard {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(record.quizType.capitalized).font(.subheadline.bold())
                                Text(record.date.formatted(date: .abbreviated, time: .shortened))
                                    .font(.caption).mutedText()
                            }
                            Spacer()
                            HStack(spacing: 2) {
                                ForEach(0..<3, id: \.self) { i in
                                    Image(systemName: i < record.stars ? "star.fill" : "star")
                                        .font(.caption)
                                        .foregroundStyle(i < record.stars ? .yellow : theme.colors.textMuted)
                                }
                            }
                            Text("\(record.correctCount)/\(record.totalCount)")
                                .font(.caption.bold()).secondaryText()
                        }
                    }
                }
            }
        }
    }

    private func statRow(_ label: String, value: String) -> some View {
        HStack {
            Text(label).font(.subheadline).secondaryText()
            Spacer()
            Text(value).font(.subheadline.bold())
        }
    }

    private var averageScore: String {
        guard !records.isEmpty else { return "—" }
        let avg = records.map(\.score).reduce(0, +) / Double(records.count)
        return "\(Int(avg * 100))%"
    }
}
