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
        try? AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: .mixWithOthers)
        try? AVAudioSession.sharedInstance().setActive(true)
        engine.attach(playerNode)
        engine.connect(playerNode, to: engine.mainMixerNode, format: format)
        try? engine.start()
        generateSounds()
    }

    func configure(enabled: Bool) { isEnabled = enabled }
    func playTick() { play("tick") }
    func playHit() { play("hit") }
    func playMiss() { play("miss") }
    func playComplete() { play("complete") }
    func playCelebration() { play("celebration") }
    func playInhale() { play("inhale") }
    func playExhale() { play("exhale") }

    private func play(_ name: String) {
        guard isEnabled, let buffer = buffers[name] else { return }
        if !engine.isRunning { try? engine.start() }
        playerNode.stop()
        playerNode.scheduleBuffer(buffer, at: nil, options: .interrupts)
        playerNode.play()
    }

    private func generateSounds() {
        buffers["tick"] = synth(0.035) { t in
            sinf(2 * .pi * 1200 * t) * (t < 0.002 ? t / 0.002 : expf(-(t - 0.002) / 0.033 * 4)) * 0.4
        }
        buffers["hit"] = synth(0.15) { t in
            let env: Float = t < 0.005 ? t / 0.005 : expf(-t * 12)
            return sinf(2 * .pi * 880 * t) * env * 0.35
        }
        buffers["miss"] = synth(0.2) { t in
            let env: Float = t < 0.01 ? t / 0.01 : expf(-t * 8)
            return sinf(2 * .pi * 220 * t) * env * 0.3
        }
        buffers["complete"] = synth(0.4) { t in
            let notes: [(Float, Float, Float)] = [(523.25, 0, 0.1), (659.25, 0.08, 0.1), (783.99, 0.16, 0.12), (1046.5, 0.24, 0.16)]
            return notes.reduce(Float(0)) { sum, n in
                let nt = t - n.1; guard nt >= 0 else { return sum }
                let env: Float = nt < 0.005 ? nt / 0.005 : (nt < n.2 ? 1 - (nt - 0.005) / (n.2 - 0.005) * 0.4 : 0.6 * expf(-(nt - n.2) * 15))
                return sum + sinf(2 * .pi * n.0 * t) * env * 0.25
            }
        }
        buffers["celebration"] = synth(0.6) { t in
            let notes: [(Float, Float, Float)] = [(523.25, 0, 0.1), (587.33, 0.06, 0.1), (659.25, 0.12, 0.1), (783.99, 0.18, 0.12), (1046.5, 0.26, 0.2)]
            return notes.reduce(Float(0)) { sum, n in
                let nt = t - n.1; guard nt >= 0 else { return sum }
                let env: Float = nt < 0.008 ? nt / 0.008 : (nt < n.2 ? 1 - (nt - 0.008) / (n.2 - 0.008) * 0.4 : 0.6 * expf(-(nt - n.2) * 15))
                return sum + (sinf(2 * .pi * n.0 * t) + sinf(2 * .pi * n.0 * 2 * t) * 0.15) * env * 0.22
            }
        }
        buffers["inhale"] = synth(0.3) { t in
            let freq: Float = 330 + 110 * t / 0.3
            let env: Float = t < 0.02 ? t / 0.02 : (0.3 - t) / 0.28
            return sinf(2 * .pi * freq * t) * max(0, env) * 0.2
        }
        buffers["exhale"] = synth(0.3) { t in
            let freq: Float = 440 - 110 * t / 0.3
            let env: Float = t < 0.02 ? t / 0.02 : (0.3 - t) / 0.28
            return sinf(2 * .pi * freq * t) * max(0, env) * 0.2
        }
    }

    private func synth(_ dur: Float, _ gen: (Float) -> Float) -> AVAudioPCMBuffer {
        let count = AVAudioFrameCount(sampleRate * Double(dur))
        let buf = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: count)!
        buf.frameLength = count
        let data = buf.floatChannelData![0]
        for i in 0..<Int(count) { data[i] = min(1, max(-1, gen(Float(i) / Float(sampleRate)))) }
        return buf
    }
}
