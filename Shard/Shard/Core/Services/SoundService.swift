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
    func playGrow() { play("grow") }
    func playCrack() { play("crack") }
    func playCelebration() { play("celebration") }
    func playTap() { play("tap") }
    func playChime() { play("chime") }

    private func setupEngine() {
        engine.attach(playerNode)
        engine.connect(playerNode, to: engine.mainMixerNode, format: format)
        do { try engine.start() } catch {
            #if DEBUG
            print("SoundService: Engine start failed: \(error.localizedDescription)")
            #endif
        }
    }

    private func play(_ name: String) {
        guard isEnabled, let buffer = buffers[name] else { return }
        if !engine.isRunning { try? engine.start() }
        playerNode.stop()
        playerNode.scheduleBuffer(buffer, at: nil, options: .interrupts)
        playerNode.play()
    }

    private func generateAllSounds() {
        buffers["tick"] = synthesize(duration: 0.035) { t in
            let freq: Float = 1200
            let envelope = Self.quickDecay(t: t, attack: 0.002, decay: 0.033)
            return sinf(2 * .pi * freq * t) * envelope * 0.4
        }
        buffers["tap"] = synthesize(duration: 0.02) { t in
            let freq: Float = 1800
            let envelope = Self.quickDecay(t: t, attack: 0.001, decay: 0.019)
            return sinf(2 * .pi * freq * t) * envelope * 0.3
        }
        buffers["grow"] = synthesize(duration: 0.3) { t in
            let freq: Float = 400 + 200 * t / 0.3
            let env: Float = if t < 0.02 { t / 0.02 } else { expf(-(t - 0.02) * 5) }
            return sinf(2 * .pi * freq * t) * env * 0.35
        }
        buffers["crack"] = synthesize(duration: 0.15) { t in
            let freq: Float = 180 + 40 * sinf(2 * .pi * 12 * t)
            let envelope = Self.quickDecay(t: t, attack: 0.005, decay: 0.115)
            let wave = sinf(2 * .pi * freq * t)
            let noise = Float.random(in: -0.15...0.15)
            return (wave * 0.6 + noise) * envelope * 0.4
        }
        buffers["chime"] = synthesize(duration: 0.25) { t in
            let freq: Float = 880
            let env: Float = if t < 0.005 { t / 0.005 } else { expf(-(t - 0.005) * 8) }
            let fundamental = sinf(2 * .pi * freq * t)
            let h2 = sinf(2 * .pi * freq * 2 * t) * 0.3
            return (fundamental + h2) * env * 0.3
        }
        buffers["celebration"] = generateCelebration()
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
                let env: Float = if noteT < attack {
                    noteT / attack
                } else if noteT < note.dur {
                    1.0 - (noteT - attack) / (note.dur - attack) * 0.4
                } else {
                    0.6 * expf(-(noteT - note.dur) * 15)
                }
                let fundamental = sinf(2 * .pi * note.freq * t)
                let h2 = sinf(2 * .pi * note.freq * 2 * t) * 0.15
                sample += (fundamental + h2) * env * 0.22
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
            data[i] = Swift.min(Swift.max(generator(t), -1), 1)
        }
        return buffer
    }

    private static func quickDecay(t: Float, attack: Float, decay: Float) -> Float {
        if t < attack { return t / attack }
        return expf(-(t - attack) / decay * 4)
    }

    private func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: .mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            #if DEBUG
            print("SoundService: Audio session config failed: \(error.localizedDescription)")
            #endif
        }
    }
}
