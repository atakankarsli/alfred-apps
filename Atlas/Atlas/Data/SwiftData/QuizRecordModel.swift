import Foundation
import SwiftData

@Model
final class QuizRecordModel {
    var quizType: String = ""
    var continentId: String = ""
    var level: Int = 0
    var score: Double = 0
    var stars: Int = 0
    var xpEarned: Int = 0
    var date: Date = Date()
    var correctCount: Int = 0
    var totalCount: Int = 10

    init() {}

    init(type: QuizType, continentId: String, level: Int, score: Double, correctCount: Int, totalCount: Int) {
        self.quizType = type.rawValue
        self.continentId = continentId
        self.level = level
        self.score = score
        self.stars = AtlasConfig.starsForScore(score)
        self.xpEarned = AtlasConfig.xpForQuiz(stars: self.stars, continentId: continentId)
        self.date = Date()
        self.correctCount = correctCount
        self.totalCount = totalCount
    }
}
