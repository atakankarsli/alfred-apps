import Foundation

struct SeededRNG: RandomNumberGenerator {
    private var state: UInt64
    init(seed: UInt64) { state = seed }
    mutating func next() -> UInt64 {
        state &+= 0x9e3779b97f4a7c15; var z = state
        z = (z ^ (z >> 30)) &* 0xbf58476d1ce4e5b9
        z = (z ^ (z >> 27)) &* 0x94d049bb133111eb
        return z ^ (z >> 31)
    }
}

struct QuizQuestion: Identifiable, Sendable {
    let id: Int
    let type: QuizType
    let country: Country
    let options: [String]
    let correctIndex: Int
    let prompt: String
}

struct QuizRound: Sendable {
    let title: String
    let questions: [QuizQuestion]
    let quizType: QuizType
    let level: Int
    let timePerQuestion: Double
}

enum QuizEngine {
    static func generateRound(type: QuizType, dayOffset: Int, level: Int, continentId: String? = nil) -> QuizRound {
        let seed = UInt64(dayOffset * 1000 + level * 10 + type.hashValue)
        var rng = SeededRNG(seed: seed)

        let continentPool = continentId.flatMap { id in
            let filtered = Countries.forContinent(id)
            return filtered.count >= 4 ? filtered : nil
        }
        let pool = (continentPool ?? Countries.all).shuffled(using: &rng)
        let count = min(10, pool.count)
        var questions: [QuizQuestion] = []

        for i in 0..<count {
            let country = pool[i]
            let (prompt, correct, wrongPool) = questionData(type: type, country: country)
            var wrongs = wrongPool.filter { $0 != correct }.shuffled(using: &rng)
            let options3 = Array(wrongs.prefix(3))
            var allOptions = options3 + [correct]
            allOptions.shuffle(using: &rng)
            let correctIdx = allOptions.firstIndex(of: correct) ?? 0

            questions.append(QuizQuestion(id: i, type: type, country: country, options: allOptions, correctIndex: correctIdx, prompt: prompt))
        }

        let titles = roundTitles[type] ?? ["Quiz"]
        let title = titles[Int(rng.next() % UInt64(titles.count))]
        let time = max(8.0, 15.0 - Double(level) * 0.08)

        return QuizRound(title: title, questions: questions, quizType: type, level: level, timePerQuestion: time)
    }

    private static func questionData(type: QuizType, country: Country) -> (prompt: String, correct: String, pool: [String]) {
        switch type {
        case .flag:
            return ("Which country has this flag?\n\(country.flag)", country.name, Countries.all.map(\.name))
        case .capital:
            return ("What is the capital of \(country.name)?", country.capital, Countries.all.map(\.capital))
        case .mapShape:
            return ("\(country.flag) Which continent is \(country.name) in?", continentName(country.continent),
                    Continent.allCases.map(\.subtitle))
        case .landmark:
            return ("Where is the \(country.landmark)?", country.name, Countries.all.map(\.name))
        }
    }

    private static func continentName(_ id: String) -> String {
        Continent.allCases.first { $0.rawValue == id }?.subtitle ?? "Unknown"
    }

    private static let roundTitles: [QuizType: [String]] = [
        .flag: ["Flag Frenzy", "Banner Quest", "Colors of the World", "Flag Master", "Vexillology 101", "Flag Sprint", "World Flags", "Flag Challenge", "Banner Blitz", "National Colors"],
        .capital: ["Capital Quest", "City Finder", "Seat of Power", "Capital Sprint", "Metro Challenge", "City Match", "Capital Dash", "World Capitals", "Urban Explorer", "Capital Expert"],
        .mapShape: ["Continent Quest", "World Map", "Globe Trotter", "Map Master", "Earth Explorer", "Continental", "Geography Bee", "Atlas Challenge", "World Regions", "Map Sprint"],
        .landmark: ["Landmark Hunt", "World Wonders", "Famous Places", "Monument Quest", "Iconic Sites", "Travel Quiz", "Photo Safari", "Landmark Dash", "Wonder Walk", "World Tour"],
    ]
}
