import SwiftUI

enum BreathPhase: Sendable {
    case inhale
    case hold1
    case exhale
    case hold2
    case idle

    var displayName: String {
        switch self {
        case .inhale: "Breathe In"
        case .hold1: "Hold"
        case .exhale: "Breathe Out"
        case .hold2: "Hold"
        case .idle: "Ready"
        }
    }
}

@MainActor
@Observable
final class EmberEngine {
    let session: FocusSession
    private(set) var currentPhase: BreathPhase = .idle
    private(set) var phaseProgress: Double = 0
    private(set) var currentCycle = 0
    private(set) var isRunning = false
    private(set) var isComplete = false
    private(set) var tapHits = 0
    private(set) var tapMisses = 0
    private(set) var totalTapPoints = 0

    var flameIntensity: Double {
        switch currentPhase {
        case .inhale: phaseProgress
        case .hold1: 1.0
        case .exhale: 1.0 - phaseProgress
        case .hold2: 0.2
        case .idle: 0.3
        }
    }

    var accuracy: Double {
        guard totalTapPoints > 0 else { return 0 }
        return Double(tapHits) / Double(totalTapPoints)
    }

    var cycleProgress: Double {
        guard session.targetCycles > 0 else { return 0 }
        return Double(currentCycle) / Double(session.targetCycles)
    }

    private var timerTask: Task<Void, Never>?

    init(session: FocusSession) {
        self.session = session
    }

    func start() {
        guard !isRunning else { return }
        isRunning = true
        currentCycle = 0
        tapHits = 0
        tapMisses = 0
        totalTapPoints = 0
        isComplete = false
        runBreathLoop()
    }

    func stop() {
        isRunning = false
        timerTask?.cancel()
        timerTask = nil
        currentPhase = .idle
    }

    func tapAtTransition() {
        guard isRunning else { return }
        let isNearTransition = phaseProgress > 0.85 || phaseProgress < 0.15
        totalTapPoints += 1
        if isNearTransition {
            tapHits += 1
            HapticsService.light()
        } else {
            tapMisses += 1
            HapticsService.error()
        }
    }

    private func runBreathLoop() {
        timerTask?.cancel()
        timerTask = Task {
            let pattern = session.pattern
            while !Task.isCancelled && currentCycle < session.targetCycles {
                await animatePhase(.inhale, duration: pattern.inhale)
                if Task.isCancelled { return }

                if pattern.hold1 > 0 {
                    await animatePhase(.hold1, duration: pattern.hold1)
                    if Task.isCancelled { return }
                }

                await animatePhase(.exhale, duration: pattern.exhale)
                if Task.isCancelled { return }

                if pattern.hold2 > 0 {
                    await animatePhase(.hold2, duration: pattern.hold2)
                    if Task.isCancelled { return }
                }

                currentCycle += 1
            }

            if !Task.isCancelled {
                isComplete = true
                isRunning = false
                HapticsService.success()
            }
        }
    }

    private func animatePhase(_ phase: BreathPhase, duration: Double) async {
        currentPhase = phase
        phaseProgress = 0
        let steps = Int(duration * 20)
        let stepDuration = duration / Double(steps)

        for i in 0..<steps {
            guard !Task.isCancelled else { return }
            try? await Task.sleep(for: .milliseconds(Int(stepDuration * 1000)))
            phaseProgress = Double(i + 1) / Double(steps)
        }
    }
}
