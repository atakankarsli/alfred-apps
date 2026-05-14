import AVFoundation

enum SoundService {
    nonisolated(unsafe) private static var engine: AVAudioEngine?
    nonisolated(unsafe) private static var playerNode: AVAudioPlayerNode?

    private static func ensureEngine() {
        guard engine == nil else { return }
        let e = AVAudioEngine(); let p = AVAudioPlayerNode()
        e.attach(p); e.connect(p, to: e.mainMixerNode, format: nil)
        try? e.start(); engine = e; playerNode = p
    }

    private static func playTone(frequency: Double, duration: Double, amplitude: Float = 0.3) {
        ensureEngine()
        guard let p = playerNode else { return }
        let sampleRate = 44100.0; let count = Int(sampleRate * duration)
        guard let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1),
              let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: AVAudioFrameCount(count)) else { return }
        buffer.frameLength = AVAudioFrameCount(count)
        let data = buffer.floatChannelData![0]
        for i in 0..<count {
            let t = Double(i) / sampleRate
            let envelope = Float(min(t * 20, 1.0) * max(1.0 - (t - duration + 0.05) * 20, 0))
            data[i] = amplitude * envelope * sin(Float(2.0 * .pi * frequency * t))
        }
        if p.isPlaying { p.stop() }
        p.play(); p.scheduleBuffer(buffer, at: nil)
    }

    static func playDrop() { playTone(frequency: 440, duration: 0.15, amplitude: 0.2) }
    static func playMix() { playTone(frequency: 330, duration: 0.2, amplitude: 0.15) }
    static func playFlow() { playTone(frequency: 220, duration: 0.3, amplitude: 0.1) }
    static func playSplash() { playTone(frequency: 523, duration: 0.1); DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { playTone(frequency: 660, duration: 0.15) } }
    static func playCelebration() { for (i, f) in [523.0, 659.0, 784.0, 1047.0].enumerated() { DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.12) { playTone(frequency: f, duration: 0.2, amplitude: 0.25) } } }
}
