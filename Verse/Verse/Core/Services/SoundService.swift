import AVFoundation

@MainActor
final class SoundService {
    static let shared = SoundService()

    private let engine = AVAudioEngine()
    private let playerNode = AVAudioPlayerNode()
    private var buffers: [String: AVAudioPCMBuffer] = [:]
    private var isEnabled: Bool = true

    private let sampleRate: Double = 44100
    private lazy var format: AVAudioFormat = {
        AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: sampleRate, channels: 1, interleaved: false)!
    }()

    private init() {
        configureAudioSession()
        setupEngine()
        generateAllSounds()
    }

    func configure(enabled: Bool) { isEnabled = enabled }

    func playTileDrop() { play("tile_drop") }
    func playLineComplete() { play("line_complete") }
    func playInvalid() { play("invalid") }
    func playCelebration() { play("celebration") }
    func playTap() { play("tap") }

    private func setupEngine() {
        engine.attach(playerNode)
        engine.connect(playerNode, to: engine.mainMixerNode, format: format)
        try? engine.start()
    }

    private func play(_ name: String) {
        guard isEnabled, let buffer = buffers[name] else { return }
        if !engine.isRunning { try? engine.start() }
        playerNode.stop()
        playerNode.scheduleBuffer(buffer, at: nil, options: .interrupts)
        playerNode.play()
    }

    private func generateAllSounds() {
        buffers["tap"] = generateTap()
        buffers["tile_drop"] = generateTileDrop()
        buffers["line_complete"] = generateLineComplete()
        buffers["invalid"] = generateInvalid()
        buffers["celebration"] = generateCelebration()
    }

    private func generateTap() -> AVAudioPCMBuffer {
        synthesize(duration: 0.02) { t in
            let freq: Float = 1800
            let env = Self.quickDecay(t: t, attack: 0.001, decay: 0.019)
            return sinf(2 * .pi * freq * t) * env * 0.3
        }
    }

    private func generateTileDrop() -> AVAudioPCMBuffer {
        synthesize(duration: 0.06) { t in
            let freq: Float = 600 + 400 * (1 - t / 0.06)
            let env = Self.quickDecay(t: t, attack: 0.003, decay: 0.057)
            return sinf(2 * .pi * freq * t) * env * 0.35
        }
    }

    private func generateLineComplete() -> AVAudioPCMBuffer {
        let frequencies: [Float] = [523.25, 659.25, 783.99]
        let noteDur: Float = 0.08
        let total = noteDur * Float(frequencies.count) + 0.06

        return synthesize(duration: total) { t in
            let idx = Int(t / noteDur)
            guard idx < frequencies.count else {
                let tail = t - noteDur * Float(frequencies.count)
                return sinf(2 * .pi * frequencies.last! * t) * expf(-tail * 18) * 0.15
            }
            let noteT = t - Float(idx) * noteDur
            let attack: Float = 0.005
            let env: Float = noteT < attack ? noteT / attack : expf(-(noteT - attack) * 8)
            return sinf(2 * .pi * frequencies[idx] * t) * env * 0.35
        }
    }

    private func generateInvalid() -> AVAudioPCMBuffer {
        synthesize(duration: 0.12) { t in
            let freq: Float = 180 + 40 * sinf(2 * .pi * 12 * t)
            let env = Self.quickDecay(t: t, attack: 0.005, decay: 0.115)
            return sinf(2 * .pi * freq * t) * env * 0.4
        }
    }

    private func generateCelebration() -> AVAudioPCMBuffer {
        let notes: [(freq: Float, start: Float, dur: Float)] = [
            (523.25, 0.0, 0.10), (587.33, 0.06, 0.10), (659.25, 0.12, 0.10),
            (783.99, 0.18, 0.12), (1046.50, 0.26, 0.20),
        ]
        return synthesize(duration: 0.6) { t in
            var sample: Float = 0
            for note in notes {
                let noteT = t - note.start
                guard noteT >= 0 else { continue }
                let attack: Float = 0.008
                let env: Float
                if noteT < attack { env = noteT / attack }
                else if noteT < note.dur { env = 1.0 - (noteT - attack) / (note.dur - attack) * 0.4 }
                else { env = 0.6 * expf(-(noteT - note.dur) * 15) }
                sample += sinf(2 * .pi * note.freq * t) * env * 0.22
            }
            return sample
        }
    }

    private func synthesize(duration: Float, generator: (Float) -> Float) -> AVAudioPCMBuffer {
        let frameCount = AVAudioFrameCount(sampleRate * Double(duration))
        let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount)!
        buffer.frameLength = frameCount
        let data = buffer.floatChannelData![0]
        for i in 0..<Int(frameCount) {
            let t = Float(i) / Float(sampleRate)
            data[i] = min(max(generator(t), -1), 1)
        }
        return buffer
    }

    private static func quickDecay(t: Float, attack: Float, decay: Float) -> Float {
        t < attack ? t / attack : expf(-(t - attack) / decay * 4)
    }

    private func configureAudioSession() {
        try? AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: .mixWithOthers)
        try? AVAudioSession.sharedInstance().setActive(true)
    }
}
