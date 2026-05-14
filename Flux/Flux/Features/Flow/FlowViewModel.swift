import SwiftUI
import SwiftData

@Observable
final class FlowViewModel {
    let challenge: FlowChallenge
    var particles: [Particle] = []
    var timeRemaining: Double
    var score: Double = 0
    var isFinished = false
    var stars: Int = 0
    var totalSpawned: Int = 0
    private var nextId = 0
    private var timer: Timer?
    private var rng: SeededRNG

    init(element: FluidElement, level: Int) {
        let day = Calendar.current.ordinality(of: .day, in: .year, for: .now) ?? 1
        self.challenge = ParticleEngine.generateChallenge(element: element, dayOffset: day, level: level)
        self.timeRemaining = 30.0
        self.rng = SeededRNG(seed: UInt64(day * 100 + level))
    }

    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0 / 60.0, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }

    func spawnAt(_ point: CGPoint, in size: CGSize) {
        guard !isFinished else { return }
        let count = min(5, challenge.particleCount - particles.count)
        for _ in 0..<max(count, 1) {
            let p = ParticleEngine.createParticle(id: nextId, at: point, element: challenge.element, in: size, rng: &rng)
            particles.append(p)
            nextId += 1; totalSpawned += 1
        }
        HapticsService.light()
    }

    private func tick() {
        let dt = 1.0 / 60.0
        timeRemaining -= dt
        if timeRemaining <= 0 { finish(); return }

        for i in particles.indices {
            ParticleEngine.updateParticle(&particles[i], element: challenge.element, dt: dt)
        }
        particles.removeAll { $0.life <= 0 }
    }

    func finish() {
        timer?.invalidate(); timer = nil; isFinished = true
        let coverage = min(1.0, Double(totalSpawned) / Double(challenge.particleCount))
        let timeBonus = max(0, timeRemaining / 30.0)
        score = coverage * 0.7 + timeBonus * 0.3
        stars = FluxConfig.starsForScore(score)
        HapticsService.success()
        SoundService.playCelebration()
    }

    func updateStats(context: ModelContext) {
        let descriptor = FetchDescriptor<StatsRecord>()
        let stats = (try? context.fetch(descriptor))?.first ?? {
            let s = StatsRecord(); context.insert(s); return s
        }()
        stats.totalXP += FluxConfig.xpForFlow(stars: stars, zoneId: zoneForLevel(challenge.level))
        stats.flowsCompleted += 1
        stats.totalParticlesSpawned += totalSpawned
        if stars == 3 { stats.threeStarFlows += 1 }

        switch challenge.element {
        case .water: stats.waterFlows += 1
        case .lava: stats.lavaFlows += 1
        case .plasma: stats.plasmaFlows += 1
        case .mercury: stats.mercuryFlows += 1
        case .ether: stats.etherFlows += 1
        }

        let today = Calendar.current.startOfDay(for: .now)
        if let last = stats.lastPlayedDate {
            let diff = Calendar.current.dateComponents([.day], from: Calendar.current.startOfDay(for: last), to: today).day ?? 0
            if diff == 1 { stats.currentStreak += 1 }
            else if diff > 1 { stats.currentStreak = 1 }
        } else { stats.currentStreak = 1 }
        stats.bestStreak = max(stats.bestStreak, stats.currentStreak)
        stats.lastPlayedDate = .now
        try? context.save()
    }

    private func zoneForLevel(_ level: Int) -> String {
        for zone in FlowZone.allCases where zone.levelRange.contains(level) { return zone.rawValue }
        return "ripple"
    }
}
