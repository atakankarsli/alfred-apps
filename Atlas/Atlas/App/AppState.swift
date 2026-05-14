import SwiftUI
import SwiftData

@Observable
final class AppState {
    var selectedTab: Tab = .home
    var selectedTheme: Theme = Themes.default

    enum Tab: Hashable { case home, achievements, stats, settings }

    private var modelContext: ModelContext?

    func configure(with context: ModelContext) {
        self.modelContext = context
        if let profile = fetchProfile() {
            selectedTheme = Themes.all.first { $0.id == profile.selectedThemeId } ?? Themes.default
        }
    }

    func fetchProfile() -> UserProfileModel? {
        guard let ctx = modelContext else { return nil }
        let descriptor = FetchDescriptor<UserProfileModel>()
        return (try? ctx.fetch(descriptor))?.first
    }

    func ensureProfile() -> UserProfileModel {
        if let p = fetchProfile() { return p }
        let p = UserProfileModel()
        modelContext?.insert(p)
        try? modelContext?.save()
        return p
    }

    func recordQuiz(type: QuizType, continentId: String, level: Int, score: Double, correct: Int, total: Int) -> (xp: Int, stars: Int, newAchievements: [AchievementDef]) {
        guard let ctx = modelContext else { return (0, 0, []) }

        let record = QuizRecordModel(type: type, continentId: continentId, level: level, score: score, correctCount: correct, totalCount: total)
        ctx.insert(record)

        let profile = ensureProfile()
        profile.totalXP += record.xpEarned
        profile.totalQuizzes += 1
        profile.quizCounts[type.rawValue, default: 0] += 1
        if record.stars == 3 { profile.perfectQuizzes += 1 }
        profile.updateStreak()

        selectedTheme = Themes.all.first { $0.id == profile.selectedThemeId } ?? Themes.default
        let newAch = checkAchievements(profile: profile, ctx: ctx)
        try? ctx.save()

        return (record.xpEarned, record.stars, newAch)
    }

    func updateTheme(_ theme: Theme) {
        selectedTheme = theme
        let profile = ensureProfile()
        profile.selectedThemeId = theme.id
        try? modelContext?.save()
    }

    private func checkAchievements(profile: UserProfileModel, ctx: ModelContext) -> [AchievementDef] {
        let unlocked = Set((try? ctx.fetch(FetchDescriptor<AchievementRecordModel>()))?.map(\.achievementId) ?? [])
        var newlyUnlocked: [AchievementDef] = []

        let records = (try? ctx.fetch(FetchDescriptor<QuizRecordModel>())) ?? []
        let continentsPlayed = Set(records.map(\.continentId))
        let europaPlayed = records.contains { $0.continentId == "europa" && $0.stars >= 1 }
        let allContinents = Continent.allCases.allSatisfy { c in records.contains { $0.continentId == c.rawValue && $0.stars >= 1 } }

        let checks: [(String, Bool)] = [
            ("first_quiz", profile.totalQuizzes >= 1),
            ("five_quizzes", profile.totalQuizzes >= 5),
            ("ten_quizzes", profile.totalQuizzes >= 10),
            ("fifty_quizzes", profile.totalQuizzes >= 50),
            ("hundred_quizzes", profile.totalQuizzes >= 100),
            ("streak_3", profile.currentStreak >= 3),
            ("streak_7", profile.currentStreak >= 7),
            ("streak_30", profile.currentStreak >= 30),
            ("streak_100", profile.currentStreak >= 100),
            ("flag_expert", profile.quizCount(for: .flag) >= 50),
            ("capital_expert", profile.quizCount(for: .capital) >= 50),
            ("map_expert", profile.quizCount(for: .mapShape) >= 50),
            ("landmark_expert", profile.quizCount(for: .landmark) >= 50),
            ("all_types", profile.typesPlayed().count >= 4),
            ("level_5", profile.level >= 5),
            ("level_max", profile.level >= AtlasConfig.levelThresholds.count - 1),
            ("perfect_10", profile.perfectQuizzes >= 10),
            ("europa_done", europaPlayed),
            ("all_continents", allContinents),
        ]

        for (id, met) in checks where met && !unlocked.contains(id) {
            if let def = Achievements.all.first(where: { $0.id == id }) {
                ctx.insert(AchievementRecordModel(achievementId: id))
                newlyUnlocked.append(def)
            }
        }
        return newlyUnlocked
    }
}
