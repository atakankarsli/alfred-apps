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
        ensureEngine(); guard let p = playerNode else { return }
        let sr = 44100.0; let count = Int(sr * duration)
        guard let fmt = AVAudioFormat(standardFormatWithSampleRate: sr, channels: 1),
              let buf = AVAudioPCMBuffer(pcmFormat: fmt, frameCapacity: AVAudioFrameCount(count)) else { return }
        buf.frameLength = AVAudioFrameCount(count); let d = buf.floatChannelData![0]
        for i in 0..<count {
            let t = Double(i) / sr
            let env = Float(min(t * 20, 1.0) * max(1.0 - (t - duration + 0.05) * 20, 0))
            d[i] = amplitude * env * sin(Float(2.0 * .pi * frequency * t))
        }
        if p.isPlaying { p.stop() }; p.play(); p.scheduleBuffer(buf, at: nil)
    }
    static func playCorrect() { playTone(frequency: 880, duration: 0.12, amplitude: 0.2) }
    static func playWrong() { playTone(frequency: 220, duration: 0.2, amplitude: 0.15) }
    static func playStreak() { playTone(frequency: 660, duration: 0.1); DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { playTone(frequency: 880, duration: 0.15) } }
    static func playCelebration() { for (i, f) in [523.0, 659.0, 784.0, 1047.0].enumerated() { DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.12) { playTone(frequency: f, duration: 0.2, amplitude: 0.25) } } }
}
