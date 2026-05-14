import Foundation

struct BeatNote: Identifiable {
    let id = UUID()
    let lane: Int
    let beatTime: Double
    let type: NoteType
    let holdDuration: Double

    enum NoteType: Int, CaseIterable {
        case tap = 0
        case hold = 1
        case double = 2
        case swipe = 3

        var colorHex: String {
            switch self {
            case .tap: "FF6B6B"
            case .hold: "6B7FD6"
            case .swipe: "FFD93D"
            case .double: "4CAF50"
            }
        }

        var label: String {
            switch self {
            case .tap: "Tap"
            case .hold: "Hold"
            case .swipe: "Swipe"
            case .double: "Double"
            }
        }
    }
}

enum HitJudgment: String {
    case perfect = "Perfect"
    case great = "Great"
    case good = "Good"
    case miss = "Miss"

    var scoreMultiplier: Double {
        switch self {
        case .perfect: 1.0
        case .great: 0.8
        case .good: 0.5
        case .miss: 0
        }
    }

    var colorHex: String {
        switch self {
        case .perfect: "FFD700"
        case .great: "4CAF50"
        case .good: "5BC0EB"
        case .miss: "FF5252"
        }
    }

    static func judge(deltaMs: Double) -> HitJudgment {
        let abs = Swift.abs(deltaMs)
        if abs <= 20 { return .perfect }
        if abs <= 50 { return .great }
        if abs <= 100 { return .good }
        return .miss
    }
}

struct BeatTrack {
    let index: Int
    let bpm: Int
    let notes: [BeatNote]
    let duration: Double
    let season: Season

    var beatInterval: Double { 60.0 / Double(bpm) }

    static func generate(index: Int) -> BeatTrack {
        var rng = SeededRNG(seed: UInt64(index * 31337 + 2027))
        let season = Season.seasonForTrack(index)
        let bpm = bpmForSeason(season.id, rng: &rng)
        let beatInterval = 60.0 / Double(bpm)
        let totalBeats = beatsForSeason(season.id)
        let duration = Double(totalBeats) * beatInterval + 2.0

        var notes: [BeatNote] = []
        let noteTypes = noteTypesForSeason(season.id)

        for beat in 0..<totalBeats {
            let beatTime = Double(beat) * beatInterval + 1.5

            if Int.random(in: 0..<10, using: &rng) < densityForSeason(season.id) {
                let lane = Int.random(in: 0..<3, using: &rng)
                let typeIndex = Int.random(in: 0..<noteTypes.count, using: &rng)
                let noteType = noteTypes[typeIndex]
                let holdDur = noteType == .hold ? beatInterval * Double(Int.random(in: 1...2, using: &rng)) : 0

                notes.append(BeatNote(lane: lane, beatTime: beatTime, type: noteType, holdDuration: holdDur))

                if noteType == .double && lane < 2 {
                    notes.append(BeatNote(lane: lane + 1, beatTime: beatTime, type: .tap, holdDuration: 0))
                }
            }
        }

        return BeatTrack(index: index, bpm: bpm, notes: notes, duration: duration, season: season)
    }

    private static func bpmForSeason(_ seasonId: Int, rng: inout SeededRNG) -> Int {
        let ranges: [(Int, Int)] = [(80, 100), (100, 120), (110, 130), (120, 150), (130, 170)]
        let range = ranges[min(seasonId, ranges.count - 1)]
        return Int.random(in: range.0...range.1, using: &rng)
    }

    private static func beatsForSeason(_ seasonId: Int) -> Int {
        [32, 40, 48, 56, 64][min(seasonId, 4)]
    }

    private static func densityForSeason(_ seasonId: Int) -> Int {
        [5, 6, 7, 7, 8][min(seasonId, 4)]
    }

    private static func noteTypesForSeason(_ seasonId: Int) -> [BeatNote.NoteType] {
        switch seasonId {
        case 0: [.tap]
        case 1: [.tap, .tap, .hold]
        case 2: [.tap, .hold, .double]
        case 3: [.tap, .hold, .double, .swipe]
        default: BeatNote.NoteType.allCases
        }
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
