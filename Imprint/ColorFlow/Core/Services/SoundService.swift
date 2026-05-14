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

    func configure(enabled: Bool) {
        isEnabled = enabled
    }

    func playTick() { play("tick") }
    func playWordFound() { play("word_found") }
    func playInvalid() { play("invalid") }
    func playWhoosh() { play("whoosh") }
    func playCelebration() { play("celebration") }
    func playTap() { play("tap") }

    func playNote(_ semitone: Int) {
        let key = "note_\(semitone)"
        if buffers[key] == nil {
            buffers[key] = generateBellNote(semitone: semitone)
        }
        play(key)
    }

    // MARK: - Engine

    private func setupEngine() {
        engine.attach(playerNode)
        engine.connect(playerNode, to: engine.mainMixerNode, format: format)

        do {
            try engine.start()
        } catch {
            #if DEBUG
            print("SoundService: Engine start failed: \(error.localizedDescription)")
            #endif
        }
    }

    private func play(_ name: String) {
        guard isEnabled, let buffer = buffers[name] else { return }

        if !engine.isRunning {
            try? engine.start()
        }

        playerNode.stop()
        playerNode.scheduleBuffer(buffer, at: nil, options: .interrupts)
        playerNode.play()
    }

    // MARK: - Sound Generation

    private func generateAllSounds() {
        buffers["tick"] = generateTick()
        buffers["tap"] = generateTap()
        buffers["word_found"] = generateWordFound()
        buffers["invalid"] = generateInvalid()
        buffers["whoosh"] = generateWhoosh()
        buffers["celebration"] = generateCelebration()
    }

    private func generateTick() -> AVAudioPCMBuffer {
        synthesize(duration: 0.035) { t in
            let freq: Float = 1200
            let envelope = Self.quickDecay(t: t, attack: 0.002, decay: 0.033)
            return sinf(2 * .pi * freq * t) * envelope * 0.4
        }
    }

    private func generateTap() -> AVAudioPCMBuffer {
        synthesize(duration: 0.02) { t in
            let freq: Float = 1800
            let envelope = Self.quickDecay(t: t, attack: 0.001, decay: 0.019)
            return sinf(2 * .pi * freq * t) * envelope * 0.3
        }
    }

    private func generateWordFound() -> AVAudioPCMBuffer {
        let noteDuration: Float = 0.09
        let frequencies: [Float] = [523.25, 659.25, 783.99, 1046.50] // C5, E5, G5, C6
        let totalDuration = noteDuration * Float(frequencies.count) + 0.08

        return synthesize(duration: totalDuration) { t in
            let noteIndex = Int(t / noteDuration)
            guard noteIndex < frequencies.count else {
                let tail = t - noteDuration * Float(frequencies.count)
                let freq = frequencies.last!
                let decay = expf(-tail * 18)
                return sinf(2 * .pi * freq * t) * decay * 0.15
            }

            let noteT = t - Float(noteIndex) * noteDuration
            let attack: Float = 0.005
            let env: Float = if noteT < attack {
                noteT / attack
            } else {
                expf(-(noteT - attack) * 8)
            }

            let freq = frequencies[noteIndex]
            let fundamental = sinf(2 * .pi * freq * t)
            let harmonic = sinf(2 * .pi * freq * 2 * t) * 0.2
            return (fundamental + harmonic) * env * 0.35
        }
    }

    private func generateInvalid() -> AVAudioPCMBuffer {
        synthesize(duration: 0.12) { t in
            let freq: Float = 180 + 40 * sinf(2 * .pi * 12 * t)
            let envelope = Self.quickDecay(t: t, attack: 0.005, decay: 0.115)
            let wave = sinf(2 * .pi * freq * t)
            let noise = Float.random(in: -0.15...0.15)
            return (wave * 0.6 + noise) * envelope * 0.4
        }
    }

    private func generateWhoosh() -> AVAudioPCMBuffer {
        synthesize(duration: 0.15) { t in
            let sweep = 200 + 2000 * t / 0.15
            let envelope: Float = if t < 0.03 {
                t / 0.03
            } else {
                expf(-(t - 0.03) * 12)
            }
            let noise = Float.random(in: -1...1)
            let filtered = sinf(2 * .pi * sweep * t) * 0.3 + noise * 0.2
            return filtered * envelope * 0.35
        }
    }

    private func generateCelebration() -> AVAudioPCMBuffer {
        let notes: [(freq: Float, start: Float, dur: Float)] = [
            (523.25, 0.0, 0.10),   // C5
            (587.33, 0.06, 0.10),  // D5
            (659.25, 0.12, 0.10),  // E5
            (783.99, 0.18, 0.12),  // G5
            (1046.50, 0.26, 0.20), // C6
        ]
        let totalDuration: Float = 0.6

        return synthesize(duration: totalDuration) { t in
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
                let h3 = sinf(2 * .pi * note.freq * 3 * t) * 0.05
                sample += (fundamental + h2 + h3) * env * 0.22
            }
            return sample
        }
    }

    private func generateBellNote(semitone: Int) -> AVAudioPCMBuffer {
        let baseFreq: Float = 440.0
        let freq = baseFreq * powf(2.0, Float(semitone) / 12.0)

        return synthesize(duration: 0.25) { t in
            let attack: Float = 0.005
            let env: Float = if t < attack {
                t / attack
            } else {
                expf(-(t - attack) * 8)
            }

            let fundamental = sinf(2 * .pi * freq * t)
            let h2 = sinf(2 * .pi * freq * 2.0 * t) * 0.3
            let h3 = sinf(2 * .pi * freq * 3.0 * t) * 0.1
            let h5 = sinf(2 * .pi * freq * 5.0 * t) * 0.03
            return (fundamental + h2 + h3 + h5) * env * 0.3
        }
    }

    // MARK: - DSP Helpers

    private func synthesize(duration: Float, generator: (Float) -> Float) -> AVAudioPCMBuffer {
        let frameCount = AVAudioFrameCount(sampleRate * Double(duration))
        let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount)!
        buffer.frameLength = frameCount

        let data = buffer.floatChannelData![0]
        for i in 0..<Int(frameCount) {
            let t = Float(i) / Float(sampleRate)
            data[i] = generator(t).clamped(to: -1...1)
        }
        return buffer
    }

    private static func quickDecay(t: Float, attack: Float, decay: Float) -> Float {
        if t < attack {
            return t / attack
        }
        return expf(-(t - attack) / decay * 4)
    }

    // MARK: - Audio Session

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

private extension Float {
    func clamped(to range: ClosedRange<Float>) -> Float {
        Swift.min(Swift.max(self, range.lowerBound), range.upperBound)
    }
}
