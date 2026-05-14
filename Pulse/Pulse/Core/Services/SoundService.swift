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

    func playTick() { play("tick") }
    func playPerfect() { play("perfect") }
    func playGreat() { play("great") }
    func playMiss() { play("miss") }
    func playCelebration() { play("celebration") }
    func playCountdown() { play("countdown") }
    func playComboBreak() { play("combo_break") }

    func playBeatHit(semitone: Int = 0) {
        let key = "beat_\(semitone)"
        if buffers[key] == nil {
            let baseFreq: Float = 440.0
            let freq = baseFreq * powf(2.0, Float(semitone) / 12.0)
            buffers[key] = synthesize(duration: 0.15) { t in
                let env: Float = t < 0.003 ? t / 0.003 : expf(-(t - 0.003) * 12)
                return sinf(2 * .pi * freq * t) * env * 0.35
            }
        }
        play(key)
    }

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
        buffers["tick"] = synthesize(duration: 0.025) { t in
            let env = Self.quickDecay(t: t, attack: 0.001, decay: 0.024)
            return sinf(2 * .pi * 1400 * t) * env * 0.4
        }
        buffers["perfect"] = synthesize(duration: 0.15) { t in
            let env: Float = t < 0.005 ? t / 0.005 : expf(-(t - 0.005) * 10)
            let f1 = sinf(2 * .pi * 880 * t)
            let f2 = sinf(2 * .pi * 1320 * t) * 0.3
            return (f1 + f2) * env * 0.3
        }
        buffers["great"] = synthesize(duration: 0.1) { t in
            let env: Float = t < 0.003 ? t / 0.003 : expf(-(t - 0.003) * 15)
            return sinf(2 * .pi * 660 * t) * env * 0.25
        }
        buffers["miss"] = synthesize(duration: 0.08) { t in
            let freq: Float = 200 + 30 * sinf(2 * .pi * 10 * t)
            let env = Self.quickDecay(t: t, attack: 0.003, decay: 0.077)
            return sinf(2 * .pi * freq * t) * env * 0.3
        }
        buffers["countdown"] = synthesize(duration: 0.05) { t in
            let env = Self.quickDecay(t: t, attack: 0.002, decay: 0.048)
            return sinf(2 * .pi * 800 * t) * env * 0.35
        }
        buffers["combo_break"] = synthesize(duration: 0.15) { t in
            let freq: Float = 300 - 200 * t / 0.15
            let env = Self.quickDecay(t: t, attack: 0.005, decay: 0.145)
            return sinf(2 * .pi * freq * t) * env * 0.35
        }
        buffers["celebration"] = synthesize(duration: 0.6) { t in
            let notes: [(Float, Float, Float)] = [
                (523.25, 0.0, 0.1), (659.25, 0.06, 0.1), (783.99, 0.12, 0.1),
                (880.0, 0.18, 0.12), (1046.5, 0.26, 0.2)
            ]
            var sample: Float = 0
            for (freq, start, dur) in notes {
                let nt = t - start
                guard nt >= 0 else { continue }
                let env: Float = nt < 0.008 ? nt / 0.008 : (nt < dur ? 1 - (nt - 0.008) / (dur - 0.008) * 0.4 : 0.6 * expf(-(nt - dur) * 15))
                sample += (sinf(2 * .pi * freq * t) + sinf(2 * .pi * freq * 2 * t) * 0.15) * env * 0.22
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
            data[i] = min(1, max(-1, generator(t)))
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
