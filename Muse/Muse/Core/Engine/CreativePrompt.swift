import Foundation

struct CreativePrompt {
    let index: Int
    let word: String
    let mode: ChallengeMode
    let palette: [String]
    let gridSize: Int
    let targetPattern: [Int]
    let timeLimit: Int

    var season: Season { Season.seasonForChallenge(index) }

    func similarityScore(userPattern: [Int]) -> Double {
        guard targetPattern.count == userPattern.count, !targetPattern.isEmpty else { return 0 }
        var matches = 0
        for i in targetPattern.indices {
            if targetPattern[i] == userPattern[i] { matches += 1 }
        }
        return Double(matches) / Double(targetPattern.count)
    }

    static func generate(index: Int, mode: ChallengeMode? = nil) -> CreativePrompt {
        var rng = SeededRNG(seed: UInt64(index * 31337 + 42))
        let season = Season.seasonForChallenge(index)
        let resolvedMode = mode ?? season.modes[Int.random(in: 0..<season.modes.count, using: &rng)]
        let gridSize = gridSizeFor(seasonId: season.id)
        let palette = paletteFor(mode: resolvedMode, index: index, rng: &rng)
        let total = gridSize * gridSize
        let target = (0..<total).map { _ in Int.random(in: 0..<palette.count, using: &rng) }
        let word = promptWord(for: resolvedMode, index: index, rng: &rng)

        return CreativePrompt(
            index: index,
            word: word,
            mode: resolvedMode,
            palette: palette,
            gridSize: gridSize,
            targetPattern: target,
            timeLimit: resolvedMode.timeLimit
        )
    }

    private static func gridSizeFor(seasonId: Int) -> Int {
        switch seasonId {
        case 0: 4
        case 1: 5
        case 2: 5
        case 3: 6
        default: 6
        }
    }

    private static func paletteFor(mode: ChallengeMode, index: Int, rng: inout SeededRNG) -> [String] {
        let palettes: [[String]] = [
            ["E85D3A", "FF9F43", "FECA57", "FF6B6B", "54A0FF"],
            ["6B7FD6", "48DBFB", "5F27CD", "01CDC5", "F368E0"],
            ["4CAF50", "8BC34A", "CDDC39", "009688", "2E86DE"],
            ["FF9800", "F44336", "9C27B0", "3F51B5", "00BCD4"],
            ["E91E63", "9C27B0", "673AB7", "3F51B5", "00BCD4"],
            ["FF5252", "FF4081", "7C4DFF", "448AFF", "69F0AE"],
            ["FFD54F", "FF8A65", "A1887F", "90A4AE", "81C784"],
            ["F06292", "BA68C8", "7986CB", "4FC3F7", "4DB6AC"],
        ]
        let i = (index + Int.random(in: 0..<palettes.count, using: &rng)) % palettes.count
        let base = palettes[i]
        let count = mode == .remix ? min(6, base.count + 1) : base.count
        return Array(base.prefix(count))
    }

    private static func promptWord(for mode: ChallengeMode, index: Int, rng: inout SeededRNG) -> String {
        let words: [ChallengeMode: [String]] = [
            .sketch: ["Mountain", "Sunset", "Flower", "Tree", "Ocean", "Star", "Cloud", "Bird", "House", "Moon",
                       "River", "Flame", "Heart", "Crown", "Wave", "Feather", "Lightning", "Butterfly", "Castle", "Dragon"],
            .write: ["Joy", "Storm", "Dream", "Silence", "Echo", "Dawn", "Whisper", "Rhythm", "Hope", "Shadow",
                      "Melody", "Courage", "Wonder", "Spark", "Bloom", "Drift", "Pulse", "Glow", "Journey", "Peace"],
            .photo: ["Reflection", "Texture", "Light", "Pattern", "Color", "Shape", "Symmetry", "Contrast", "Motion", "Still",
                      "Frame", "Depth", "Angle", "Focus", "Mood", "Detail", "Line", "Curve", "Warmth", "Cool"],
            .sound: ["Rain", "Wind", "Heartbeat", "Thunder", "Lullaby", "March", "Whistle", "Chime", "Drum", "Hum",
                      "Ripple", "Crash", "Buzz", "Tick", "Flow", "Echo", "Roar", "Chirp", "Sizzle", "Rustle"],
            .remix: ["Invert", "Mirror", "Rotate", "Blend", "Shift", "Layer", "Fragment", "Amplify", "Reduce", "Morph",
                      "Twist", "Fade", "Saturate", "Abstract", "Simplify", "Embellish", "Distort", "Harmonize", "Contrast", "Evolve"],
        ]
        let list = words[mode] ?? words[.sketch]!
        return list[index % list.count]
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
