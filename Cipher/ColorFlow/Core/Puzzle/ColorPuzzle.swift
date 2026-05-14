import Foundation

struct CipherPuzzle {
    let level: Int
    let cipherType: CipherType
    let plainText: String
    let encryptedText: String
    let key: String
    let hint: String

    enum CipherType: String, CaseIterable {
        case caesar
        case atbash
        case substitution
        case railFence
        case vigenere
        case columnar
        case rot13
        case keyword
    }

    static func cipherTypeForLevel(_ level: Int) -> CipherType {
        switch level {
        case 0..<10: return .caesar
        case 10..<20: return .atbash
        case 20..<30: return .substitution
        case 30..<40: return .rot13
        case 40..<50: return .railFence
        case 50..<60: return .keyword
        case 60..<70: return .vigenere
        default: return .columnar
        }
    }

    static func generate(level: Int) -> CipherPuzzle {
        var rng = SeededRNG(seed: UInt64(level * 7919 + 104729))
        let phrase = phrases[level % phrases.count]
        let cType = cipherTypeForLevel(level)

        let encrypted: String
        let key: String
        let hint: String

        switch cType {
        case .caesar:
            let shift = Int.random(in: 3...15, using: &rng)
            encrypted = caesarEncrypt(phrase, shift: shift)
            key = "Shift: \(shift)"
            hint = "Each letter shifted by \(shift)"
        case .atbash:
            encrypted = atbashEncrypt(phrase)
            key = "Mirror"
            hint = "A=Z, B=Y, C=X..."
        case .substitution:
            let (enc, mapping) = substitutionEncrypt(phrase, rng: &rng)
            encrypted = enc
            key = mapping
            hint = "Each letter maps to another"
        case .rot13:
            encrypted = caesarEncrypt(phrase, shift: 13)
            key = "ROT13"
            hint = "Rotate each letter by 13"
        case .railFence:
            let rails = Int.random(in: 2...4, using: &rng)
            encrypted = railFenceEncrypt(phrase, rails: rails)
            key = "Rails: \(rails)"
            hint = "Zigzag with \(rails) rails"
        case .keyword:
            let kw = keywords[level % keywords.count]
            encrypted = keywordEncrypt(phrase, keyword: kw)
            key = kw
            hint = "Keyword substitution"
        case .vigenere:
            let kw = keywords[level % keywords.count]
            encrypted = vigenereEncrypt(phrase, keyword: kw)
            key = kw
            hint = "Polyalphabetic with keyword"
        case .columnar:
            let kw = keywords[level % keywords.count]
            encrypted = columnarEncrypt(phrase, keyword: kw)
            key = kw
            hint = "Columnar transposition"
        }

        return CipherPuzzle(
            level: level,
            cipherType: cType,
            plainText: phrase.uppercased(),
            encryptedText: encrypted.uppercased(),
            key: key,
            hint: hint
        )
    }

    static func parTime(for level: Int) -> Int {
        switch level {
        case 0..<10: return 60
        case 10..<20: return 75
        case 20..<40: return 90
        case 40..<60: return 120
        default: return 150
        }
    }

    static func starsForTime(_ seconds: Int, par: Int) -> Int {
        if seconds <= par { return 3 }
        if seconds <= par * 2 { return 2 }
        return 1
    }
}

// MARK: - Cipher Algorithms

extension CipherPuzzle {
    private static let alpha = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")

    static func caesarEncrypt(_ text: String, shift: Int) -> String {
        String(text.uppercased().map { ch in
            guard let idx = alpha.firstIndex(of: ch) else { return ch }
            return alpha[(idx + shift) % 26]
        })
    }

    static func caesarDecrypt(_ text: String, shift: Int) -> String {
        caesarEncrypt(text, shift: 26 - shift)
    }

    static func atbashEncrypt(_ text: String) -> String {
        String(text.uppercased().map { ch in
            guard let idx = alpha.firstIndex(of: ch) else { return ch }
            return alpha[25 - idx]
        })
    }

    static func substitutionEncrypt(_ text: String, rng: inout SeededRNG) -> (String, String) {
        var shuffled = alpha
        for i in stride(from: shuffled.count - 1, through: 1, by: -1) {
            let j = Int.random(in: 0...i, using: &rng)
            shuffled.swapAt(i, j)
        }
        let result = String(text.uppercased().map { ch in
            guard let idx = alpha.firstIndex(of: ch) else { return ch }
            return shuffled[idx]
        })
        let mapping = String(shuffled)
        return (result, mapping)
    }

    static func railFenceEncrypt(_ text: String, rails: Int) -> String {
        let chars = Array(text.uppercased().filter { $0.isLetter })
        guard rails > 1, !chars.isEmpty else { return text.uppercased() }
        var fence = Array(repeating: [Character](), count: rails)
        var rail = 0
        var direction = 1
        for ch in chars {
            fence[rail].append(ch)
            if rail == 0 { direction = 1 }
            if rail == rails - 1 { direction = -1 }
            rail += direction
        }
        return fence.flatMap { $0 }.map(String.init).joined()
    }

    static func vigenereEncrypt(_ text: String, keyword: String) -> String {
        let keyChars = Array(keyword.uppercased().filter { $0.isLetter })
        guard !keyChars.isEmpty else { return text.uppercased() }
        var keyIdx = 0
        return String(text.uppercased().map { ch in
            guard let idx = alpha.firstIndex(of: ch) else { return ch }
            guard let kIdx = alpha.firstIndex(of: keyChars[keyIdx % keyChars.count]) else { return ch }
            keyIdx += 1
            return alpha[(idx + kIdx) % 26]
        })
    }

    static func keywordEncrypt(_ text: String, keyword: String) -> String {
        var seen = Set<Character>()
        var cipherAlpha = [Character]()
        for ch in keyword.uppercased() where ch.isLetter && !seen.contains(ch) {
            cipherAlpha.append(ch)
            seen.insert(ch)
        }
        for ch in alpha where !seen.contains(ch) {
            cipherAlpha.append(ch)
        }
        return String(text.uppercased().map { ch in
            guard let idx = alpha.firstIndex(of: ch) else { return ch }
            return cipherAlpha[idx]
        })
    }

    static func columnarEncrypt(_ text: String, keyword: String) -> String {
        let chars = Array(text.uppercased().filter { $0.isLetter })
        let keyLen = keyword.count
        guard keyLen > 0 else { return text.uppercased() }
        let order = keyword.uppercased().enumerated()
            .sorted { $0.element < $1.element }
            .map(\.offset)
        var grid = Array(repeating: [Character](), count: keyLen)
        for (i, ch) in chars.enumerated() {
            grid[i % keyLen].append(ch)
        }
        return order.flatMap { grid[$0] }.map(String.init).joined()
    }
}

// MARK: - Phrases

extension CipherPuzzle {
    static let phrases: [String] = [
        "THE QUICK BROWN FOX",
        "KNOWLEDGE IS POWER",
        "FORTUNE FAVORS THE BOLD",
        "ACTIONS SPEAK LOUDER",
        "BREAK THE CODE",
        "SECRETS HIDDEN IN PLAIN SIGHT",
        "TRUST NO ONE",
        "EVERY CIPHER HAS A KEY",
        "THE TRUTH IS OUT THERE",
        "DECODE THE MESSAGE",
        "STAY CURIOUS ALWAYS",
        "PATTERNS REVEAL SECRETS",
        "THINK BEFORE YOU ACT",
        "NOTHING IS IMPOSSIBLE",
        "WISDOM COMES WITH TIME",
        "SEEK AND YOU SHALL FIND",
        "THE EARLY BIRD CATCHES",
        "PATIENCE IS A VIRTUE",
        "LOOK BEYOND THE SURFACE",
        "INFORMATION WANTS TO BE FREE",
        "KEEP YOUR FRIENDS CLOSE",
        "ALL THAT GLITTERS IS NOT GOLD",
        "TIME WAITS FOR NO ONE",
        "CURIOSITY KILLED THE CAT",
        "NEVER STOP LEARNING",
        "QUESTION EVERYTHING ALWAYS",
        "GREAT MINDS THINK ALIKE",
        "CARPE DIEM SEIZE THE DAY",
        "PRACTICE MAKES PERFECT",
        "SILENCE IS GOLDEN",
        "ADAPT OR PERISH",
        "EXPLORE THE UNKNOWN",
        "COURAGE IS RESISTANCE",
        "DARE TO BE DIFFERENT",
        "IMAGINATION IS EVERYTHING",
        "UNITED WE STAND STRONG",
        "FREEDOM IS NOT FREE",
        "CHOOSE YOUR PATH WISELY",
        "EMBRACE THE CHALLENGE",
        "RISE ABOVE THE NOISE",
        "DREAM BIG START SMALL",
        "CONQUER YOUR FEARS TODAY",
        "BELIEVE IN YOURSELF",
        "LEARN FROM FAILURE",
        "FOCUS ON THE SOLUTION",
        "ONE STEP AT A TIME",
        "UNLOCK YOUR POTENTIAL",
        "CREATE YOUR OWN DESTINY",
        "THROUGH DARKNESS COMES LIGHT",
        "PERSEVERANCE CONQUERS ALL",
        "BEHIND EVERY CODE A STORY",
        "ENCRYPTED WORLDS AWAIT",
        "MASTER THE ANCIENT ARTS",
        "LOGIC PREVAILS ALWAYS",
        "DECIPHER THE MYSTERY",
        "CODES WITHIN CODES",
        "HIDDEN IN PLAIN VIEW",
        "THE KEY IS PATIENCE",
        "EVERY LOCK HAS A KEY",
        "SOLVE REVEAL ADVANCE",
        "LETTERS HIDE THE TRUTH",
        "SYMBOLS TELL STORIES",
        "FREQUENCY IS YOUR FRIEND",
        "SHIFT YOUR PERSPECTIVE",
        "BEYOND THE ALPHABET",
        "ANCIENT WISDOM ENDURES",
        "THE CIPHER NEVER LIES",
        "CRACK THE IMPOSSIBLE",
        "PATTERNS ARE EVERYWHERE",
        "DECODE YOUR FUTURE",
        "SECRETS OF THE PAST",
        "GUARDIAN OF KNOWLEDGE",
        "THE VAULT OPENS WIDE",
        "INTELLIGENCE WINS WARS",
        "BETWEEN THE LINES",
        "INVISIBLE INK REVEALS",
        "SHADOWS HOLD ANSWERS",
        "TRANSPOSE AND DISCOVER",
        "THE GRID HOLDS THE KEY",
        "POLYALPHABETIC POWER",
    ]

    static let keywords: [String] = [
        "CIPHER", "SECRET", "ENIGMA", "SHADOW", "VAULT",
        "RAVEN", "STORM", "GHOST", "OMEGA", "NOVA",
        "CRYSTAL", "PHOENIX", "DRAGON", "MATRIX", "NEBULA",
        "PRISM", "ZENITH", "TITAN", "ORBIT", "SPARK",
    ]
}

struct SeededRNG: RandomNumberGenerator {
    private var state: UInt64

    init(seed: UInt64) {
        state = seed == 0 ? 1 : seed
    }

    mutating func next() -> UInt64 {
        state &+= 0x9E3779B97F4A7C15
        var z = state
        z = (z ^ (z >> 30)) &* 0xBF58476D1CE4E5B9
        z = (z ^ (z >> 27)) &* 0x94D049BB133111EB
        return z ^ (z >> 31)
    }
}
