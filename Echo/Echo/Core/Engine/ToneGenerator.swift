import AVFoundation

@MainActor
final class ToneGenerator {
    static let shared = ToneGenerator()

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
        generateAllTones()
        generateUISounds()
    }

    func configure(enabled: Bool) { isEnabled = enabled }

    func playTone(_ index: Int, realm: SonicRealm) {
        let key = "\(realm.rawValue)_\(index)"
        play(key)
    }

    func playSuccess() { play("success") }
    func playFail() { play("fail") }
    func playCelebration() { play("celebration") }
    func playTick() { play("tick") }

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

    private func generateAllTones() {
        let toneFreqs: [Float] = [261.63, 329.63, 392.0, 523.25, 659.25, 783.99]
        for (i, freq) in toneFreqs.enumerated() {
            buffers["0_\(i)"] = synthesizeTone(freq: freq, duration: 0.4)
        }

        let melodyFreqs: [Float] = [261.63, 293.66, 329.63, 349.23, 392.0, 440.0, 493.88, 523.25]
        for (i, freq) in melodyFreqs.enumerated() {
            buffers["1_\(i)"] = synthesizePiano(freq: freq, duration: 0.5)
        }

        let rhythmNames = ["kick", "snare", "hihat", "tom"]
        for (i, name) in rhythmNames.enumerated() {
            buffers["2_\(i)"] = synthesizePercussion(type: name, duration: 0.2)
        }

        let chordSets: [[Float]] = [
            [261.63, 329.63, 392.0],
            [293.66, 349.23, 440.0],
            [329.63, 392.0, 493.88],
            [349.23, 440.0, 523.25],
            [392.0, 493.88, 587.33],
            [440.0, 523.25, 659.25],
            [261.63, 311.13, 392.0],
        ]
        for (i, freqs) in chordSets.enumerated() {
            buffers["3_\(i)"] = synthesizeChord(freqs: freqs, duration: 0.5)
        }

        let chaosFreqs: [Float] = [220.0, 277.18, 349.23, 440.0, 554.37, 698.46, 880.0, 1108.73]
        for (i, freq) in chaosFreqs.enumerated() {
            let waveType = i % 3
            buffers["4_\(i)"] = synthesizeChaos(freq: freq, waveType: waveType, duration: 0.35)
        }
    }

    private func generateUISounds() {
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
    }

    private func synthesizeTone(freq: Float, duration: Float) -> AVAudioPCMBuffer {
        synthesize(duration: duration) { t in
            let env: Float = t < 0.01 ? t / 0.01 : (duration - t) / (duration - 0.01)
            return sinf(2 * .pi * freq * t) * max(0, env) * 0.5
        }
    }

    private func synthesizePiano(freq: Float, duration: Float) -> AVAudioPCMBuffer {
        synthesize(duration: duration) { t in
            let env: Float = t < 0.005 ? t / 0.005 : expf(-t * 4)
            let harm1 = sinf(2 * .pi * freq * t)
            let harm2 = sinf(2 * .pi * freq * 2 * t) * 0.3
            let harm3 = sinf(2 * .pi * freq * 3 * t) * 0.1
            return (harm1 + harm2 + harm3) * env * 0.35
        }
    }

    private func synthesizePercussion(type: String, duration: Float) -> AVAudioPCMBuffer {
        synthesize(duration: duration) { t in
            switch type {
            case "kick":
                let freq: Float = 80 * expf(-t * 20)
                let env = expf(-t * 15)
                return sinf(2 * .pi * freq * t) * env * 0.6
            case "snare":
                let noise = Float.random(in: -1...1)
                let tone = sinf(2 * .pi * 200 * t)
                let env = expf(-t * 25)
                return (noise * 0.4 + tone * 0.3) * env
            case "hihat":
                let noise = Float.random(in: -1...1)
                let env = expf(-t * 40)
                return noise * env * 0.3
            default:
                let freq: Float = 150 * expf(-t * 10)
                let env = expf(-t * 12)
                return sinf(2 * .pi * freq * t) * env * 0.5
            }
        }
    }

    private func synthesizeChord(freqs: [Float], duration: Float) -> AVAudioPCMBuffer {
        synthesize(duration: duration) { t in
            let env: Float = t < 0.01 ? t / 0.01 : expf(-t * 3)
            var sample: Float = 0
            for freq in freqs {
                sample += sinf(2 * .pi * freq * t) + sinf(2 * .pi * freq * 2 * t) * 0.15
            }
            return sample / Float(freqs.count) * env * 0.4
        }
    }

    private func synthesizeChaos(freq: Float, waveType: Int, duration: Float) -> AVAudioPCMBuffer {
        synthesize(duration: duration) { t in
            let env: Float = t < 0.01 ? t / 0.01 : expf(-t * 5)
            let wave: Float
            switch waveType {
            case 0:
                wave = sinf(2 * .pi * freq * t) + sinf(2 * .pi * freq * 1.5 * t) * 0.3
            case 1:
                let phase = 2 * Float.pi * freq * t
                wave = phase.truncatingRemainder(dividingBy: 2 * .pi) < .pi ? 0.5 : -0.5
            default:
                let phase = freq * t
                wave = 2 * (phase - floorf(phase + 0.5))
            }
            return wave * env * 0.35
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
