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
    func playSuccess() { play("success") }
    func playFail() { play("fail") }
    func playCelebration() { play("celebration") }
    func playWaveDrop() { play("wave_drop") }
    func playWaveRise() { play("wave_rise") }

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
        buffers["tick"] = synthesize(duration: 0.035) { t in
            let env = Self.quickDecay(t: t, attack: 0.002, decay: 0.033)
            return sinf(2 * .pi * 1200 * t) * env * 0.4
        }
        buffers["success"] = synthesize(duration: 0.4) { t in
            let notes: [(Float, Float, Float)] = [(523.25, 0.0, 0.1), (659.25, 0.08, 0.1), (783.99, 0.16, 0.12), (1046.5, 0.24, 0.16)]
            var sample: Float = 0
            for (freq, start, dur) in notes {
                let nt = t - start
                guard nt >= 0 else { continue }
                let env: Float = nt < 0.005 ? nt / 0.005 : (nt < dur ? 1 - (nt - 0.005) / (dur - 0.005) * 0.4 : 0.6 * expf(-(nt - dur) * 15))
                sample += sinf(2 * .pi * freq * t) * env * 0.25
            }
            return sample
        }
        buffers["fail"] = synthesize(duration: 0.12) { t in
            let freq: Float = 180 + 40 * sinf(2 * .pi * 12 * t)
            let env = Self.quickDecay(t: t, attack: 0.005, decay: 0.115)
            return sinf(2 * .pi * freq * t) * env * 0.4
        }
        buffers["celebration"] = synthesize(duration: 0.6) { t in
            let notes: [(Float, Float, Float)] = [(523.25, 0.0, 0.1), (587.33, 0.06, 0.1), (659.25, 0.12, 0.1), (783.99, 0.18, 0.12), (1046.5, 0.26, 0.2)]
            var sample: Float = 0
            for (freq, start, dur) in notes {
                let nt = t - start
                guard nt >= 0 else { continue }
                let env: Float = nt < 0.008 ? nt / 0.008 : (nt < dur ? 1 - (nt - 0.008) / (dur - 0.008) * 0.4 : 0.6 * expf(-(nt - dur) * 15))
                sample += (sinf(2 * .pi * freq * t) + sinf(2 * .pi * freq * 2 * t) * 0.15) * env * 0.22
            }
            return sample
        }
        buffers["wave_drop"] = synthesize(duration: 0.25) { t in
            let freq: Float = 400 - 200 * t / 0.25
            let env: Float = t < 0.01 ? t / 0.01 : expf(-(t - 0.01) * 8)
            return sinf(2 * .pi * freq * t) * env * 0.3
        }
        buffers["wave_rise"] = synthesize(duration: 0.3) { t in
            let freq: Float = 300 + 400 * t / 0.3
            let env: Float = t < 0.05 ? t / 0.05 : (0.3 - t) / 0.25
            return sinf(2 * .pi * freq * t) * max(0, env) * 0.2
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
