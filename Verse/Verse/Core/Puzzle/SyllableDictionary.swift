import Foundation

enum SyllableDictionary {
    static func count(_ word: String) -> Int {
        let w = word.lowercased().trimmingCharacters(in: .whitespaces)
        if let cached = overrides[w] { return cached }
        return heuristic(w)
    }

    private static func heuristic(_ word: String) -> Int {
        let vowels: Set<Character> = ["a", "e", "i", "o", "u", "y"]
        var count = 0
        var prevVowel = false
        let chars = Array(word)

        for (i, ch) in chars.enumerated() {
            let isVowel = vowels.contains(ch)
            if isVowel && !prevVowel { count += 1 }
            prevVowel = isVowel

            if ch == "e" && i == chars.count - 1 && count > 1 {
                let prev = i > 0 ? chars[i - 1] : " "
                if prev != "l" && prev != "c" && prev != "s" {
                    count -= 1
                }
            }
        }

        return max(count, 1)
    }

    static let overrides: [String: Int] = [
        "the": 1, "a": 1, "an": 1, "is": 1, "am": 1, "are": 1, "was": 1, "were": 1,
        "be": 1, "been": 1, "being": 2, "have": 1, "has": 1, "had": 1, "do": 1,
        "does": 1, "did": 1, "will": 1, "would": 1, "could": 1, "should": 1,
        "may": 1, "might": 1, "shall": 1, "can": 1, "need": 1, "must": 1,
        "i": 1, "me": 1, "my": 1, "we": 1, "our": 1, "you": 1, "your": 1,
        "he": 1, "she": 1, "it": 1, "they": 1, "them": 1, "their": 1,
        "this": 1, "that": 1, "these": 1, "those": 1,
        "in": 1, "on": 1, "at": 1, "to": 1, "for": 1, "of": 1, "with": 1,
        "by": 1, "from": 1, "up": 1, "out": 1, "off": 1, "down": 1, "through": 1,
        "and": 1, "but": 1, "or": 1, "nor": 1, "not": 1, "no": 1, "so": 1, "yet": 1,
        "here": 1, "there": 1, "where": 1, "when": 1, "then": 1, "than": 1,
        "like": 1, "just": 1, "come": 1, "some": 1, "one": 1, "once": 1,
        "still": 1, "while": 1, "fire": 1, "tire": 1, "wire": 1,
        "real": 1, "feel": 1, "steal": 1, "heal": 1, "deal": 1,

        "above": 2, "across": 2, "after": 2, "again": 2, "along": 2,
        "also": 2, "always": 2, "among": 2, "away": 2, "before": 2,
        "begin": 2, "behind": 2, "below": 2, "beneath": 2, "beside": 2,
        "beyond": 2, "broken": 2, "calling": 2, "carry": 2, "catching": 2,
        "changing": 2, "chasing": 2, "climbing": 2, "closing": 2, "coming": 2,
        "dancing": 2, "drifting": 2, "dreaming": 2, "dying": 2, "early": 2,
        "easy": 2, "empty": 2, "endless": 2, "evening": 2, "every": 2,
        "fading": 2, "falling": 2, "feather": 2, "finding": 2, "floating": 2,
        "flowing": 2, "flying": 2, "golden": 2, "growing": 2, "gently": 2,
        "glowing": 2, "hidden": 2, "holding": 2, "hoping": 2, "into": 2,
        "knowing": 2, "leaving": 2, "lightly": 2, "little": 2, "living": 2,
        "lonely": 2, "longer": 2, "looking": 2, "lovely": 2, "making": 2,
        "maybe": 2, "meadow": 2, "merely": 2, "misty": 2, "moment": 2,
        "moonlight": 2, "morning": 2, "moving": 2, "never": 2, "nothing": 2,
        "ocean": 2, "only": 2, "open": 2, "other": 2, "over": 2,
        "passing": 2, "patient": 2, "petal": 2, "playing": 2, "quiet": 2,
        "raining": 2, "reaching": 2, "rising": 2, "river": 2, "roaming": 2,
        "running": 2, "sailing": 2, "shadow": 2, "shining": 2, "sighing": 2,
        "silence": 2, "silver": 2, "simple": 2, "singing": 2, "sleeping": 2,
        "slowly": 2, "softly": 2, "soaring": 2, "spoken": 2, "starlight": 2,
        "standing": 2, "summer": 2, "sunlight": 2, "swaying": 2, "sweetly": 2,
        "tender": 2, "giver": 2, "timer": 2, "tiny": 2, "under": 2,
        "until": 2, "upon": 2, "very": 2, "waiting": 2, "waking": 2,
        "walking": 2, "water": 2, "weaving": 2, "whisper": 2,
        "winding": 2, "winter": 2, "within": 2, "without": 2, "wonder": 2,

        "another": 3, "awakening": 4, "beautiful": 3, "becoming": 3,
        "beginning": 3, "belonging": 3, "between": 2,
        "blossoming": 3, "butterfly": 3, "carefully": 3, "carrying": 3,
        "celebrating": 5, "colorful": 3, "creating": 3, "delicate": 3,
        "disappearing": 4, "discovering": 4, "embracing": 3, "emerging": 3,
        "endlessly": 3, "eternal": 3, "everything": 3, "everywhere": 3,
        "following": 3, "forever": 3, "gathering": 3, "glittering": 3,
        "happening": 3, "harmony": 3, "imagining": 4, "infinite": 3,
        "journeying": 3, "lingering": 3, "listening": 3, "memory": 3,
        "murmuring": 3, "mystery": 3, "opening": 3, "patiently": 3,
        "quietly": 3, "remember": 3, "returning": 3, "scattering": 3,
        "shimmering": 3, "silently": 3, "silvery": 3, "together": 3,
        "tomorrow": 3, "traveling": 3, "unfolding": 3, "universe": 3,
        "wandering": 3, "waterfall": 3, "whispering": 3, "wonderful": 3,
        "yesterday": 3,
    ]
}
