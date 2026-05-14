import Foundation

struct SoundChannel: Identifiable, Hashable {
    let id: Int
    let name: String
    let icon: String
    let colorHex: String
}

struct SoundscapePuzzle {
    let level: Int
    let channels: [SoundChannel]
    let targetVolumes: [Double]
    let environment: SoundEnvironment

    var channelCount: Int { channels.count }

    enum SoundEnvironment: String, CaseIterable {
        case nature, urban, space, indoor, mystic
    }

    static func environmentForLevel(_ level: Int) -> SoundEnvironment {
        switch level {
        case 0..<16: return .nature
        case 16..<32: return .urban
        case 32..<48: return .space
        case 48..<64: return .indoor
        default: return .mystic
        }
    }

    static func channelsForEnvironment(_ env: SoundEnvironment) -> [SoundChannel] {
        switch env {
        case .nature: return natureChannels
        case .urban: return urbanChannels
        case .space: return spaceChannels
        case .indoor: return indoorChannels
        case .mystic: return mysticChannels
        }
    }

    static func generate(level: Int) -> SoundscapePuzzle {
        var rng = SeededRNG(seed: UInt64(level * 7919 + 104729))
        let env = environmentForLevel(level)
        let allChannels = channelsForEnvironment(env)

        let count = channelCountForLevel(level)
        let selected = Array(allChannels.shuffled(using: &rng).prefix(count))

        var targets = [Double]()
        for _ in 0..<count {
            let raw = Double.random(in: 0...1, using: &rng)
            targets.append((raw * 10).rounded() / 10)
        }
        if targets.allSatisfy({ $0 == 0 }) { targets[0] = 0.5 }

        return SoundscapePuzzle(level: level, channels: selected, targetVolumes: targets, environment: env)
    }

    static func channelCountForLevel(_ level: Int) -> Int {
        switch level {
        case 0..<8: return 3
        case 8..<24: return 4
        case 24..<48: return 5
        case 48..<64: return 6
        default: return 7
        }
    }

    static func accuracy(guess: [Double], target: [Double]) -> Double {
        guard guess.count == target.count, !target.isEmpty else { return 0 }
        let totalError = zip(guess, target).reduce(0.0) { $0 + abs($1.0 - $1.1) }
        let maxError = Double(target.count)
        return max(0, 1.0 - totalError / maxError)
    }

    static func starsForAccuracy(_ accuracy: Double) -> Int {
        if accuracy >= 0.90 { return 3 }
        if accuracy >= 0.70 { return 2 }
        return 1
    }

    // MARK: - Channel Data

    private static let natureChannels = [
        SoundChannel(id: 0, name: "Rain", icon: "cloud.rain.fill", colorHex: "5BC0EB"),
        SoundChannel(id: 1, name: "Thunder", icon: "cloud.bolt.fill", colorHex: "9B5DE5"),
        SoundChannel(id: 2, name: "Wind", icon: "wind", colorHex: "00BBF9"),
        SoundChannel(id: 3, name: "Birds", icon: "bird.fill", colorHex: "00F5D4"),
        SoundChannel(id: 4, name: "Crickets", icon: "ant.fill", colorHex: "76C893"),
        SoundChannel(id: 5, name: "Campfire", icon: "flame.fill", colorHex: "FF6B35"),
        SoundChannel(id: 6, name: "River", icon: "water.waves", colorHex: "3A86FF"),
        SoundChannel(id: 7, name: "Waves", icon: "water.waves.and.arrow.down", colorHex: "0077B6"),
    ]

    private static let urbanChannels = [
        SoundChannel(id: 0, name: "Café", icon: "cup.and.saucer.fill", colorHex: "C9A96E"),
        SoundChannel(id: 1, name: "Train", icon: "tram.fill", colorHex: "6C757D"),
        SoundChannel(id: 2, name: "Traffic", icon: "car.fill", colorHex: "ADB5BD"),
        SoundChannel(id: 3, name: "Keyboard", icon: "keyboard.fill", colorHex: "495057"),
        SoundChannel(id: 4, name: "Library", icon: "book.fill", colorHex: "8B5CF6"),
        SoundChannel(id: 5, name: "Market", icon: "basket.fill", colorHex: "F59E0B"),
        SoundChannel(id: 6, name: "Rain City", icon: "umbrella.fill", colorHex: "6366F1"),
        SoundChannel(id: 7, name: "Subway", icon: "tram.tunnel.fill", colorHex: "EF4444"),
    ]

    private static let spaceChannels = [
        SoundChannel(id: 0, name: "Deep Hum", icon: "globe", colorHex: "1E1B4B"),
        SoundChannel(id: 1, name: "Solar Wind", icon: "sun.max.fill", colorHex: "FDE74C"),
        SoundChannel(id: 2, name: "Static", icon: "antenna.radiowaves.left.and.right", colorHex: "94A3B8"),
        SoundChannel(id: 3, name: "Nebula", icon: "sparkles", colorHex: "C084FC"),
        SoundChannel(id: 4, name: "Pulsar", icon: "dot.radiowaves.right", colorHex: "06B6D4"),
        SoundChannel(id: 5, name: "Void", icon: "circle.dashed", colorHex: "475569"),
        SoundChannel(id: 6, name: "Comet", icon: "arrow.up.right", colorHex: "F97316"),
        SoundChannel(id: 7, name: "Signal", icon: "wave.3.right", colorHex: "22D3EE"),
    ]

    private static let indoorChannels = [
        SoundChannel(id: 0, name: "Fireplace", icon: "fireplace.fill", colorHex: "EA580C"),
        SoundChannel(id: 1, name: "Fan", icon: "fan.fill", colorHex: "64748B"),
        SoundChannel(id: 2, name: "AC", icon: "air.conditioner.horizontal.fill", colorHex: "38BDF8"),
        SoundChannel(id: 3, name: "Clock", icon: "clock.fill", colorHex: "A16207"),
        SoundChannel(id: 4, name: "Vinyl", icon: "opticaldisc.fill", colorHex: "1C1917"),
        SoundChannel(id: 5, name: "Washer", icon: "washer.fill", colorHex: "CBD5E1"),
        SoundChannel(id: 6, name: "Cat Purr", icon: "cat.fill", colorHex: "FB923C"),
        SoundChannel(id: 7, name: "Pages", icon: "book.pages.fill", colorHex: "D4C5A9"),
    ]

    private static let mysticChannels = [
        SoundChannel(id: 0, name: "Bells", icon: "bell.fill", colorHex: "FFD700"),
        SoundChannel(id: 1, name: "Bowl", icon: "circle.circle.fill", colorHex: "8B5CF6"),
        SoundChannel(id: 2, name: "Chimes", icon: "wind.circle.fill", colorHex: "A5F3FC"),
        SoundChannel(id: 3, name: "Drone", icon: "waveform", colorHex: "7C3AED"),
        SoundChannel(id: 4, name: "Waterfall", icon: "water.waves", colorHex: "06B6D4"),
        SoundChannel(id: 5, name: "Flute", icon: "music.note", colorHex: "F472B6"),
        SoundChannel(id: 6, name: "Gong", icon: "circle.fill", colorHex: "B45309"),
        SoundChannel(id: 7, name: "Forest", icon: "tree.fill", colorHex: "16A34A"),
    ]
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

extension Double {
    static func random(in range: ClosedRange<Double>, using rng: inout SeededRNG) -> Double {
        let raw = Double(rng.next()) / Double(UInt64.max)
        return range.lowerBound + raw * (range.upperBound - range.lowerBound)
    }
}

extension Array {
    func shuffled(using rng: inout SeededRNG) -> [Element] {
        var copy = self
        for i in stride(from: copy.count - 1, through: 1, by: -1) {
            let j = Int(rng.next() % UInt64(i + 1))
            copy.swapAt(i, j)
        }
        return copy
    }
}
