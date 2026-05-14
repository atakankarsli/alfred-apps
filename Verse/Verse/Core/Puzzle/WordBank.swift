import Foundation

struct WordEntry {
    let word: String
    let syllables: Int
    let theme: WordTheme

    init(_ word: String, syllables: Int? = nil, theme: WordTheme = .nature) {
        self.word = word
        self.syllables = syllables ?? SyllableDictionary.count(word)
        self.theme = theme
    }
}

enum WordTheme: CaseIterable {
    case nature, emotion, playful, classic, cosmic
}

enum WordBank {
    static func words(for theme: WordTheme) -> [WordEntry] {
        switch theme {
        case .nature: return natureWords
        case .emotion: return emotionWords
        case .playful: return playfulWords
        case .classic: return classicWords
        case .cosmic: return cosmicWords
        }
    }

    static let natureWords: [WordEntry] = [
        // 1 syllable
        WordEntry("rain", syllables: 1, theme: .nature), WordEntry("wind", syllables: 1, theme: .nature),
        WordEntry("leaf", syllables: 1, theme: .nature), WordEntry("stream", syllables: 1, theme: .nature),
        WordEntry("stone", syllables: 1, theme: .nature), WordEntry("snow", syllables: 1, theme: .nature),
        WordEntry("bloom", syllables: 1, theme: .nature), WordEntry("lake", syllables: 1, theme: .nature),
        WordEntry("tree", syllables: 1, theme: .nature), WordEntry("moss", syllables: 1, theme: .nature),
        WordEntry("sky", syllables: 1, theme: .nature), WordEntry("moon", syllables: 1, theme: .nature),
        WordEntry("sun", syllables: 1, theme: .nature), WordEntry("dew", syllables: 1, theme: .nature),
        WordEntry("pond", syllables: 1, theme: .nature), WordEntry("mist", syllables: 1, theme: .nature),
        WordEntry("seed", syllables: 1, theme: .nature), WordEntry("frost", syllables: 1, theme: .nature),
        WordEntry("spring", syllables: 1, theme: .nature), WordEntry("cloud", syllables: 1, theme: .nature),
        WordEntry("light", syllables: 1, theme: .nature), WordEntry("night", syllables: 1, theme: .nature),
        WordEntry("dawn", syllables: 1, theme: .nature), WordEntry("bird", syllables: 1, theme: .nature),
        WordEntry("fall", syllables: 1, theme: .nature), WordEntry("green", syllables: 1, theme: .nature),
        WordEntry("deep", syllables: 1, theme: .nature), WordEntry("still", syllables: 1, theme: .nature),
        WordEntry("bright", syllables: 1, theme: .nature), WordEntry("cold", syllables: 1, theme: .nature),
        WordEntry("warm", syllables: 1, theme: .nature), WordEntry("wave", syllables: 1, theme: .nature),
        WordEntry("breeze", syllables: 1, theme: .nature), WordEntry("shore", syllables: 1, theme: .nature),
        WordEntry("field", syllables: 1, theme: .nature), WordEntry("hill", syllables: 1, theme: .nature),
        WordEntry("drift", syllables: 1, theme: .nature), WordEntry("earth", syllables: 1, theme: .nature),
        WordEntry("the", syllables: 1, theme: .nature), WordEntry("a", syllables: 1, theme: .nature),
        WordEntry("in", syllables: 1, theme: .nature), WordEntry("on", syllables: 1, theme: .nature),
        WordEntry("of", syllables: 1, theme: .nature), WordEntry("and", syllables: 1, theme: .nature),
        WordEntry("with", syllables: 1, theme: .nature), WordEntry("through", syllables: 1, theme: .nature),
        WordEntry("to", syllables: 1, theme: .nature), WordEntry("so", syllables: 1, theme: .nature),
        WordEntry("its", syllables: 1, theme: .nature), WordEntry("my", syllables: 1, theme: .nature),
        WordEntry("old", syllables: 1, theme: .nature),
        // 2 syllables
        WordEntry("petal", syllables: 2, theme: .nature), WordEntry("river", syllables: 2, theme: .nature),
        WordEntry("meadow", syllables: 2, theme: .nature), WordEntry("garden", syllables: 2, theme: .nature),
        WordEntry("morning", syllables: 2, theme: .nature), WordEntry("feather", syllables: 2, theme: .nature),
        WordEntry("shadow", syllables: 2, theme: .nature), WordEntry("gentle", syllables: 2, theme: .nature),
        WordEntry("winter", syllables: 2, theme: .nature), WordEntry("summer", syllables: 2, theme: .nature),
        WordEntry("autumn", syllables: 2, theme: .nature), WordEntry("flower", syllables: 2, theme: .nature),
        WordEntry("moonlight", syllables: 2, theme: .nature), WordEntry("sunlight", syllables: 2, theme: .nature),
        WordEntry("quiet", syllables: 2, theme: .nature), WordEntry("slowly", syllables: 2, theme: .nature),
        WordEntry("softly", syllables: 2, theme: .nature), WordEntry("golden", syllables: 2, theme: .nature),
        WordEntry("silver", syllables: 2, theme: .nature), WordEntry("falling", syllables: 2, theme: .nature),
        WordEntry("floating", syllables: 2, theme: .nature), WordEntry("flowing", syllables: 2, theme: .nature),
        WordEntry("glowing", syllables: 2, theme: .nature), WordEntry("drifting", syllables: 2, theme: .nature),
        WordEntry("resting", syllables: 2, theme: .nature), WordEntry("misty", syllables: 2, theme: .nature),
        WordEntry("water", syllables: 2, theme: .nature), WordEntry("forest", syllables: 2, theme: .nature),
        WordEntry("upon", syllables: 2, theme: .nature),
        // 3 syllables
        WordEntry("beautiful", syllables: 3, theme: .nature), WordEntry("waterfall", syllables: 3, theme: .nature),
        WordEntry("butterfly", syllables: 3, theme: .nature), WordEntry("silently", syllables: 3, theme: .nature),
        WordEntry("shimmering", syllables: 3, theme: .nature), WordEntry("wandering", syllables: 3, theme: .nature),
        WordEntry("murmuring", syllables: 3, theme: .nature), WordEntry("blossoming", syllables: 3, theme: .nature),
        WordEntry("evergreen", syllables: 3, theme: .nature), WordEntry("listening", syllables: 3, theme: .nature),
    ]

    static let emotionWords: [WordEntry] = [
        // 1 syllable
        WordEntry("love", syllables: 1, theme: .emotion), WordEntry("hope", syllables: 1, theme: .emotion),
        WordEntry("dream", syllables: 1, theme: .emotion), WordEntry("heart", syllables: 1, theme: .emotion),
        WordEntry("soul", syllables: 1, theme: .emotion), WordEntry("tears", syllables: 1, theme: .emotion),
        WordEntry("joy", syllables: 1, theme: .emotion), WordEntry("pain", syllables: 1, theme: .emotion),
        WordEntry("peace", syllables: 1, theme: .emotion), WordEntry("grace", syllables: 1, theme: .emotion),
        WordEntry("lost", syllables: 1, theme: .emotion), WordEntry("find", syllables: 1, theme: .emotion),
        WordEntry("hold", syllables: 1, theme: .emotion), WordEntry("free", syllables: 1, theme: .emotion),
        WordEntry("trust", syllables: 1, theme: .emotion), WordEntry("fear", syllables: 1, theme: .emotion),
        WordEntry("light", syllables: 1, theme: .emotion), WordEntry("dark", syllables: 1, theme: .emotion),
        WordEntry("warm", syllables: 1, theme: .emotion), WordEntry("whole", syllables: 1, theme: .emotion),
        WordEntry("calm", syllables: 1, theme: .emotion), WordEntry("brave", syllables: 1, theme: .emotion),
        WordEntry("deep", syllables: 1, theme: .emotion), WordEntry("wide", syllables: 1, theme: .emotion),
        WordEntry("true", syllables: 1, theme: .emotion), WordEntry("my", syllables: 1, theme: .emotion),
        WordEntry("the", syllables: 1, theme: .emotion), WordEntry("a", syllables: 1, theme: .emotion),
        WordEntry("in", syllables: 1, theme: .emotion), WordEntry("of", syllables: 1, theme: .emotion),
        WordEntry("and", syllables: 1, theme: .emotion), WordEntry("to", syllables: 1, theme: .emotion),
        WordEntry("with", syllables: 1, theme: .emotion), WordEntry("this", syllables: 1, theme: .emotion),
        WordEntry("we", syllables: 1, theme: .emotion), WordEntry("through", syllables: 1, theme: .emotion),
        WordEntry("still", syllables: 1, theme: .emotion),
        // 2 syllables
        WordEntry("feeling", syllables: 2, theme: .emotion), WordEntry("longing", syllables: 2, theme: .emotion),
        WordEntry("morning", syllables: 2, theme: .emotion), WordEntry("moment", syllables: 2, theme: .emotion),
        WordEntry("silence", syllables: 2, theme: .emotion), WordEntry("gentle", syllables: 2, theme: .emotion),
        WordEntry("tender", syllables: 2, theme: .emotion), WordEntry("dreaming", syllables: 2, theme: .emotion),
        WordEntry("healing", syllables: 2, theme: .emotion), WordEntry("moving", syllables: 2, theme: .emotion),
        WordEntry("broken", syllables: 2, theme: .emotion), WordEntry("whisper", syllables: 2, theme: .emotion),
        WordEntry("softly", syllables: 2, theme: .emotion), WordEntry("slowly", syllables: 2, theme: .emotion),
        WordEntry("within", syllables: 2, theme: .emotion), WordEntry("waiting", syllables: 2, theme: .emotion),
        WordEntry("lonely", syllables: 2, theme: .emotion), WordEntry("kindness", syllables: 2, theme: .emotion),
        WordEntry("being", syllables: 2, theme: .emotion), WordEntry("only", syllables: 2, theme: .emotion),
        WordEntry("always", syllables: 2, theme: .emotion), WordEntry("never", syllables: 2, theme: .emotion),
        WordEntry("again", syllables: 2, theme: .emotion), WordEntry("upon", syllables: 2, theme: .emotion),
        // 3 syllables
        WordEntry("forever", syllables: 3, theme: .emotion), WordEntry("remember", syllables: 3, theme: .emotion),
        WordEntry("together", syllables: 3, theme: .emotion), WordEntry("beautiful", syllables: 3, theme: .emotion),
        WordEntry("quietly", syllables: 3, theme: .emotion), WordEntry("silently", syllables: 3, theme: .emotion),
        WordEntry("patiently", syllables: 3, theme: .emotion), WordEntry("endlessly", syllables: 3, theme: .emotion),
        WordEntry("becoming", syllables: 3, theme: .emotion), WordEntry("returning", syllables: 3, theme: .emotion),
        WordEntry("unfolding", syllables: 3, theme: .emotion),
    ]

    static let playfulWords: [WordEntry] = [
        WordEntry("there", syllables: 1, theme: .playful), WordEntry("once", syllables: 1, theme: .playful),
        WordEntry("was", syllables: 1, theme: .playful), WordEntry("who", syllables: 1, theme: .playful),
        WordEntry("all", syllables: 1, theme: .playful), WordEntry("day", syllables: 1, theme: .playful),
        WordEntry("fun", syllables: 1, theme: .playful), WordEntry("run", syllables: 1, theme: .playful),
        WordEntry("cat", syllables: 1, theme: .playful), WordEntry("hat", syllables: 1, theme: .playful),
        WordEntry("sat", syllables: 1, theme: .playful), WordEntry("mat", syllables: 1, theme: .playful),
        WordEntry("sing", syllables: 1, theme: .playful), WordEntry("ring", syllables: 1, theme: .playful),
        WordEntry("dance", syllables: 1, theme: .playful), WordEntry("prance", syllables: 1, theme: .playful),
        WordEntry("wild", syllables: 1, theme: .playful), WordEntry("smile", syllables: 1, theme: .playful),
        WordEntry("quite", syllables: 1, theme: .playful), WordEntry("night", syllables: 1, theme: .playful),
        WordEntry("bright", syllables: 1, theme: .playful), WordEntry("flight", syllables: 1, theme: .playful),
        WordEntry("man", syllables: 1, theme: .playful), WordEntry("plan", syllables: 1, theme: .playful),
        WordEntry("town", syllables: 1, theme: .playful), WordEntry("down", syllables: 1, theme: .playful),
        WordEntry("say", syllables: 1, theme: .playful), WordEntry("play", syllables: 1, theme: .playful),
        WordEntry("way", syllables: 1, theme: .playful), WordEntry("stay", syllables: 1, theme: .playful),
        WordEntry("a", syllables: 1, theme: .playful), WordEntry("the", syllables: 1, theme: .playful),
        WordEntry("from", syllables: 1, theme: .playful), WordEntry("in", syllables: 1, theme: .playful),
        WordEntry("with", syllables: 1, theme: .playful), WordEntry("could", syllables: 1, theme: .playful),
        WordEntry("would", syllables: 1, theme: .playful), WordEntry("so", syllables: 1, theme: .playful),
        WordEntry("and", syllables: 1, theme: .playful), WordEntry("but", syllables: 1, theme: .playful),
        // 2 syllables
        WordEntry("funny", syllables: 2, theme: .playful), WordEntry("silly", syllables: 2, theme: .playful),
        WordEntry("dancing", syllables: 2, theme: .playful), WordEntry("singing", syllables: 2, theme: .playful),
        WordEntry("jolly", syllables: 2, theme: .playful), WordEntry("happy", syllables: 2, theme: .playful),
        WordEntry("bouncing", syllables: 2, theme: .playful), WordEntry("tumbling", syllables: 2, theme: .playful),
        WordEntry("crazy", syllables: 2, theme: .playful), WordEntry("dizzy", syllables: 2, theme: .playful),
        WordEntry("twirling", syllables: 2, theme: .playful), WordEntry("prancing", syllables: 2, theme: .playful),
        WordEntry("always", syllables: 2, theme: .playful), WordEntry("never", syllables: 2, theme: .playful),
        WordEntry("ever", syllables: 2, theme: .playful), WordEntry("clever", syllables: 2, theme: .playful),
        // 3 syllables
        WordEntry("wonderful", syllables: 3, theme: .playful), WordEntry("everyone", syllables: 3, theme: .playful),
        WordEntry("merrily", syllables: 3, theme: .playful), WordEntry("happily", syllables: 3, theme: .playful),
    ]

    static let classicWords: [WordEntry] = [
        WordEntry("love", syllables: 1, theme: .classic), WordEntry("rose", syllables: 1, theme: .classic),
        WordEntry("time", syllables: 1, theme: .classic), WordEntry("night", syllables: 1, theme: .classic),
        WordEntry("soul", syllables: 1, theme: .classic), WordEntry("fair", syllables: 1, theme: .classic),
        WordEntry("sweet", syllables: 1, theme: .classic), WordEntry("grace", syllables: 1, theme: .classic),
        WordEntry("truth", syllables: 1, theme: .classic), WordEntry("art", syllables: 1, theme: .classic),
        WordEntry("heart", syllables: 1, theme: .classic), WordEntry("song", syllables: 1, theme: .classic),
        WordEntry("dream", syllables: 1, theme: .classic), WordEntry("shine", syllables: 1, theme: .classic),
        WordEntry("fate", syllables: 1, theme: .classic), WordEntry("days", syllables: 1, theme: .classic),
        WordEntry("gold", syllables: 1, theme: .classic), WordEntry("words", syllables: 1, theme: .classic),
        WordEntry("hope", syllables: 1, theme: .classic), WordEntry("shall", syllables: 1, theme: .classic),
        WordEntry("still", syllables: 1, theme: .classic), WordEntry("bright", syllables: 1, theme: .classic),
        WordEntry("eyes", syllables: 1, theme: .classic), WordEntry("fire", syllables: 1, theme: .classic),
        WordEntry("when", syllables: 1, theme: .classic), WordEntry("we", syllables: 1, theme: .classic),
        WordEntry("the", syllables: 1, theme: .classic), WordEntry("a", syllables: 1, theme: .classic),
        WordEntry("of", syllables: 1, theme: .classic), WordEntry("and", syllables: 1, theme: .classic),
        WordEntry("in", syllables: 1, theme: .classic), WordEntry("to", syllables: 1, theme: .classic),
        WordEntry("with", syllables: 1, theme: .classic), WordEntry("our", syllables: 1, theme: .classic),
        WordEntry("this", syllables: 1, theme: .classic), WordEntry("through", syllables: 1, theme: .classic),
        WordEntry("that", syllables: 1, theme: .classic), WordEntry("for", syllables: 1, theme: .classic),
        // 2 syllables
        WordEntry("beauty", syllables: 2, theme: .classic), WordEntry("lover", syllables: 2, theme: .classic),
        WordEntry("golden", syllables: 2, theme: .classic), WordEntry("moment", syllables: 2, theme: .classic),
        WordEntry("wonder", syllables: 2, theme: .classic), WordEntry("honor", syllables: 2, theme: .classic),
        WordEntry("gentle", syllables: 2, theme: .classic), WordEntry("tender", syllables: 2, theme: .classic),
        WordEntry("sorrow", syllables: 2, theme: .classic), WordEntry("glory", syllables: 2, theme: .classic),
        WordEntry("starlight", syllables: 2, theme: .classic), WordEntry("midnight", syllables: 2, theme: .classic),
        WordEntry("passion", syllables: 2, theme: .classic), WordEntry("desire", syllables: 2, theme: .classic),
        WordEntry("endure", syllables: 2, theme: .classic), WordEntry("always", syllables: 2, theme: .classic),
        WordEntry("within", syllables: 2, theme: .classic),
        // 3 syllables
        WordEntry("forever", syllables: 3, theme: .classic), WordEntry("beautiful", syllables: 3, theme: .classic),
        WordEntry("eternal", syllables: 3, theme: .classic), WordEntry("delicate", syllables: 3, theme: .classic),
        WordEntry("remember", syllables: 3, theme: .classic), WordEntry("together", syllables: 3, theme: .classic),
    ]

    static let cosmicWords: [WordEntry] = [
        WordEntry("star", syllables: 1, theme: .cosmic), WordEntry("void", syllables: 1, theme: .cosmic),
        WordEntry("dust", syllables: 1, theme: .cosmic), WordEntry("space", syllables: 1, theme: .cosmic),
        WordEntry("light", syllables: 1, theme: .cosmic), WordEntry("vast", syllables: 1, theme: .cosmic),
        WordEntry("dawn", syllables: 1, theme: .cosmic), WordEntry("dark", syllables: 1, theme: .cosmic),
        WordEntry("time", syllables: 1, theme: .cosmic), WordEntry("age", syllables: 1, theme: .cosmic),
        WordEntry("spin", syllables: 1, theme: .cosmic), WordEntry("glow", syllables: 1, theme: .cosmic),
        WordEntry("fall", syllables: 1, theme: .cosmic), WordEntry("rise", syllables: 1, theme: .cosmic),
        WordEntry("burn", syllables: 1, theme: .cosmic), WordEntry("bright", syllables: 1, theme: .cosmic),
        WordEntry("night", syllables: 1, theme: .cosmic), WordEntry("far", syllables: 1, theme: .cosmic),
        WordEntry("deep", syllables: 1, theme: .cosmic), WordEntry("old", syllables: 1, theme: .cosmic),
        WordEntry("we", syllables: 1, theme: .cosmic), WordEntry("the", syllables: 1, theme: .cosmic),
        WordEntry("a", syllables: 1, theme: .cosmic), WordEntry("in", syllables: 1, theme: .cosmic),
        WordEntry("of", syllables: 1, theme: .cosmic), WordEntry("and", syllables: 1, theme: .cosmic),
        WordEntry("to", syllables: 1, theme: .cosmic), WordEntry("through", syllables: 1, theme: .cosmic),
        WordEntry("from", syllables: 1, theme: .cosmic), WordEntry("where", syllables: 1, theme: .cosmic),
        WordEntry("all", syllables: 1, theme: .cosmic), WordEntry("are", syllables: 1, theme: .cosmic),
        // 2 syllables
        WordEntry("cosmos", syllables: 2, theme: .cosmic), WordEntry("planet", syllables: 2, theme: .cosmic),
        WordEntry("orbit", syllables: 2, theme: .cosmic), WordEntry("comet", syllables: 2, theme: .cosmic),
        WordEntry("endless", syllables: 2, theme: .cosmic), WordEntry("spinning", syllables: 2, theme: .cosmic),
        WordEntry("falling", syllables: 2, theme: .cosmic), WordEntry("glowing", syllables: 2, theme: .cosmic),
        WordEntry("drifting", syllables: 2, theme: .cosmic), WordEntry("floating", syllables: 2, theme: .cosmic),
        WordEntry("burning", syllables: 2, theme: .cosmic), WordEntry("distant", syllables: 2, theme: .cosmic),
        WordEntry("silent", syllables: 2, theme: .cosmic), WordEntry("ancient", syllables: 2, theme: .cosmic),
        WordEntry("beyond", syllables: 2, theme: .cosmic), WordEntry("above", syllables: 2, theme: .cosmic),
        WordEntry("between", syllables: 2, theme: .cosmic),
        // 3 syllables
        WordEntry("universe", syllables: 3, theme: .cosmic), WordEntry("infinite", syllables: 3, theme: .cosmic),
        WordEntry("eternal", syllables: 3, theme: .cosmic), WordEntry("galaxy", syllables: 3, theme: .cosmic),
        WordEntry("forever", syllables: 3, theme: .cosmic), WordEntry("wandering", syllables: 3, theme: .cosmic),
        WordEntry("traveling", syllables: 3, theme: .cosmic), WordEntry("discover", syllables: 3, theme: .cosmic),
    ]
}
