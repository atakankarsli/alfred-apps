import Foundation

enum RhymeEngine {
    static func rhymes(_ a: String, _ b: String) -> Bool {
        let endA = rhymeKey(a)
        let endB = rhymeKey(b)
        return endA == endB && a.lowercased() != b.lowercased()
    }

    static func rhymeKey(_ word: String) -> String {
        let w = word.lowercased()
        if let group = rhymeGroups.first(where: { $0.value.contains(w) }) {
            return group.key
        }
        return phonSuffix(w)
    }

    private static func phonSuffix(_ word: String) -> String {
        let chars = Array(word)
        let vowels: Set<Character> = ["a", "e", "i", "o", "u"]
        var lastVowelIdx = -1
        for i in stride(from: chars.count - 1, through: 0, by: -1) {
            if vowels.contains(chars[i]) { lastVowelIdx = i; break }
        }
        if lastVowelIdx < 0 { return String(chars.suffix(2)) }
        return String(chars[lastVowelIdx...])
    }

    static let rhymeGroups: [String: Set<String>] = [
        "ight": ["light", "night", "bright", "flight", "sight", "might", "right", "white", "delight", "moonlight", "starlight", "sunlight"],
        "ay": ["day", "way", "say", "play", "stay", "away", "gray", "ray", "pray", "display", "sway", "stray", "today", "delay"],
        "ow": ["flow", "grow", "know", "show", "snow", "glow", "slow", "blow", "below", "shadow", "meadow", "follow", "hollow", "sorrow", "tomorrow"],
        "ee": ["tree", "free", "see", "be", "me", "we", "sea", "three", "knee", "flee", "key", "agree"],
        "ine": ["line", "fine", "mine", "shine", "vine", "divine", "pine", "wine", "twine", "define", "combine"],
        "ound": ["sound", "ground", "found", "round", "bound", "around", "wound", "mound"],
        "all": ["fall", "call", "tall", "small", "wall", "all", "hall", "ball", "waterfall"],
        "ream": ["dream", "stream", "gleam", "beam", "seem", "team", "cream"],
        "ake": ["wake", "lake", "make", "take", "shake", "break", "sake", "awake"],
        "ain": ["rain", "pain", "train", "plain", "main", "gain", "again", "remain", "chain"],
        "ong": ["song", "long", "strong", "along", "belong"],
        "air": ["air", "fair", "hair", "pair", "care", "there", "where", "share", "rare", "bare", "dare"],
        "eart": ["heart", "start", "part", "art", "apart", "chart"],
        "end": ["end", "friend", "send", "bend", "blend", "mend", "tend", "spend"],
        "old": ["old", "gold", "cold", "hold", "bold", "fold", "told", "unfold"],
        "oom": ["bloom", "room", "moon", "soon", "tune", "gloom", "doom"],
        "ire": ["fire", "desire", "higher", "inspire"],
        "ore": ["more", "shore", "before", "explore", "restore", "floor", "door", "soar", "adore"],
        "ing": ["sing", "bring", "ring", "spring", "king", "thing", "wing", "string", "swing", "cling"],
        "ide": ["wide", "side", "ride", "hide", "guide", "tide", "inside", "beside", "outside", "glide"],
        "ence": ["silence", "patience", "dance", "chance", "glance", "distance", "romance"],
        "ost": ["lost", "most", "ghost", "coast", "frost", "almost", "host"],
        "urn": ["turn", "burn", "learn", "return", "yearn", "churn"],
        "eep": ["deep", "sleep", "keep", "sweep", "steep", "weep", "creep"],
        "ace": ["place", "face", "space", "grace", "trace", "embrace", "race", "pace"],
    ]
}
