import Foundation

struct WordTile: Identifiable, Equatable {
    let id: UUID
    let word: String
    let syllables: Int
    var isBonus: Bool = false

    init(word: String, syllables: Int, isBonus: Bool = false) {
        self.id = UUID()
        self.word = word
        self.syllables = syllables
        self.isBonus = isBonus
    }

    static func == (lhs: WordTile, rhs: WordTile) -> Bool { lhs.id == rhs.id }
}

struct VersePuzzle {
    let level: Int
    let form: PoetryForm
    let tiles: [WordTile]
    let solutionLines: [[String]]

    var totalTiles: Int { tiles.count }

    static func generate(level: Int) -> VersePuzzle {
        let chapter = Chapter.chapterForLevel(level)
        let form = chapter.form
        var rng = SeededRNG(seed: UInt64(level &* 7919 &+ 31337))

        let theme = themeForChapter(chapter)
        let wordPool = WordBank.words(for: theme)

        for attempt in 0..<200 {
            let seed = UInt64(level &* 7919 &+ 31337 &+ attempt &* 13)
            var tryRng = SeededRNG(seed: seed)

            if let result = tryGenerate(form: form, wordPool: wordPool, level: level, rng: &tryRng) {
                return result
            }
        }

        return fallback(level: level, form: form, wordPool: wordPool, rng: &rng)
    }

    private static func themeForChapter(_ chapter: Chapter) -> WordTheme {
        switch chapter.id {
        case 0: return .nature
        case 1: return .emotion
        case 2: return .playful
        case 3: return .classic
        case 4: return .cosmic
        default: return .nature
        }
    }

    private static func tryGenerate(form: PoetryForm, wordPool: [WordEntry], level: Int, rng: inout SeededRNG) -> VersePuzzle? {
        var solutionLines: [[String]] = []
        var usedWords: Set<String> = []

        let localIndex = Chapter.localIndex(forLevel: level)
        let needsRhyme = form.requiresRhyme && localIndex >= 4

        for lineIdx in 0..<form.lineCount {
            let targetSyllables = form.syllablesPerLine[lineIdx]

            var rhymeTarget: String? = nil
            if needsRhyme, let scheme = form.rhymeScheme {
                let currentGroup = scheme[lineIdx]
                for prevIdx in 0..<lineIdx {
                    if scheme[prevIdx] == currentGroup && !solutionLines[prevIdx].isEmpty {
                        rhymeTarget = solutionLines[prevIdx].last
                        break
                    }
                }
            }

            guard let lineWords = buildLine(
                targetSyllables: targetSyllables,
                wordPool: wordPool,
                usedWords: usedWords,
                rhymeTarget: rhymeTarget,
                rng: &rng
            ) else {
                return nil
            }

            solutionLines.append(lineWords)
            for w in lineWords { usedWords.insert(w.lowercased()) }
        }

        var tiles = solutionLines.flatMap { line in
            line.map { WordTile(word: $0, syllables: SyllableDictionary.count($0)) }
        }

        let bonusCount = min(max(0, localIndex / 4), 3)
        let available = wordPool.filter { !usedWords.contains($0.word.lowercased()) }
        var bonusAdded = 0
        var shuffled = available.shuffled(using: &rng)
        while bonusAdded < bonusCount && !shuffled.isEmpty {
            let entry = shuffled.removeFirst()
            tiles.append(WordTile(word: entry.word, syllables: entry.syllables, isBonus: true))
            bonusAdded += 1
        }

        tiles.shuffle(using: &rng)

        return VersePuzzle(level: level, form: form, tiles: tiles, solutionLines: solutionLines)
    }

    private static func buildLine(targetSyllables: Int, wordPool: [WordEntry], usedWords: Set<String>, rhymeTarget: String?, rng: inout SeededRNG) -> [String]? {
        for _ in 0..<50 {
            var line: [String] = []
            var remaining = targetSyllables
            var localUsed = usedWords
            var pool = wordPool.shuffled(using: &rng)

            if let target = rhymeTarget, remaining > 0 {
                let rhymeKey = RhymeEngine.rhymeKey(target)
                if let words = RhymeEngine.rhymeGroups[rhymeKey] {
                    let candidates = words.filter { w in
                        !localUsed.contains(w) && w != target.lowercased()
                    }
                    if let rhymeWord = candidates.shuffled(using: &rng).first {
                        let syl = SyllableDictionary.count(rhymeWord)
                        if syl <= remaining {
                            let entry = pool.first { $0.word.lowercased() == rhymeWord } ?? WordEntry(rhymeWord, syllables: syl)
                            _ = entry
                            line.append(rhymeWord)
                            remaining -= syl
                            localUsed.insert(rhymeWord)
                        }
                    }
                }

                if line.isEmpty { return nil }
            }

            while remaining > 0 {
                let candidates = pool.filter { entry in
                    entry.syllables <= remaining && !localUsed.contains(entry.word.lowercased())
                }
                guard let pick = candidates.first else { break }

                line.insert(pick.word, at: line.isEmpty || rhymeTarget != nil ? line.count - (rhymeTarget != nil && !line.isEmpty ? 1 : 0) : line.count)
                remaining -= pick.syllables
                localUsed.insert(pick.word.lowercased())
                pool.removeAll { $0.word.lowercased() == pick.word.lowercased() }
            }

            if remaining == 0 && !line.isEmpty {
                if rhymeTarget != nil && line.count > 1 {
                    let last = line.removeLast()
                    line.append(last)
                }
                return line
            }
        }
        return nil
    }

    private static func fallback(level: Int, form: PoetryForm, wordPool: [WordEntry], rng: inout SeededRNG) -> VersePuzzle {
        var solutionLines: [[String]] = []

        for lineIdx in 0..<form.lineCount {
            let target = form.syllablesPerLine[lineIdx]
            var line: [String] = []
            var remaining = target
            var pool = wordPool.shuffled(using: &rng)

            while remaining > 0 && !pool.isEmpty {
                if let idx = pool.firstIndex(where: { $0.syllables <= remaining }) {
                    let entry = pool.remove(at: idx)
                    line.append(entry.word)
                    remaining -= entry.syllables
                } else {
                    break
                }
            }

            if remaining > 0 {
                for _ in 0..<remaining { line.append("the") }
            }

            solutionLines.append(line)
        }

        var tiles = solutionLines.flatMap { line in
            line.map { WordTile(word: $0, syllables: SyllableDictionary.count($0)) }
        }
        tiles.shuffle(using: &rng)

        return VersePuzzle(level: level, form: form, tiles: tiles, solutionLines: solutionLines)
    }
}

struct SeededRNG: RandomNumberGenerator {
    private var state: UInt64

    init(seed: UInt64) { state = seed == 0 ? 1 : seed }

    mutating func next() -> UInt64 {
        state &+= 0x9E3779B97F4A7C15
        var z = state
        z = (z ^ (z >> 30)) &* 0xBF58476D1CE4E5B9
        z = (z ^ (z >> 27)) &* 0x94D049BB133111EB
        return z ^ (z >> 31)
    }
}
