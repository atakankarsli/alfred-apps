import Foundation

enum RitualCategory: String, Codable, CaseIterable {
    case morning, wellness, focus, evening
    var displayName: String {
        switch self { case .morning: "Morning"; case .wellness: "Wellness"; case .focus: "Focus"; case .evening: "Evening" }
    }
    var icon: String {
        switch self { case .morning: "sunrise.fill"; case .wellness: "heart.fill"; case .focus: "brain.head.profile"; case .evening: "moon.stars.fill" }
    }
    var colorHex: String {
        switch self { case .morning: "FFD93D"; case .wellness: "FF6B6B"; case .focus: "5BC0EB"; case .evening: "9B5DE5" }
    }
}

struct RitualSet {
    let gridSize: Int; let category: RitualCategory; let level: Int; let habits: [Habit]
    struct Habit: Identifiable { let id: Int; let title: String; let icon: String; let duration: String }

    static func generate(level: Int) -> RitualSet {
        var rng = SeededRNG(seed: UInt64(level * 7919 + 2027))
        let category = RitualCategory.allCases[level % RitualCategory.allCases.count]
        let gridSize = level < 20 ? 3 : (level < 50 ? 4 : 5)
        let pool = habitPool(for: category)
        let habits = (0..<(gridSize * gridSize)).map { i -> Habit in
            let p = pool[Int(rng.next() % UInt64(pool.count))]
            return Habit(id: i, title: p.0, icon: p.1, duration: p.2)
        }
        return RitualSet(gridSize: gridSize, category: category, level: level, habits: habits)
    }

    private static func habitPool(for cat: RitualCategory) -> [(String, String, String)] {
        switch cat {
        case .morning: return [
            ("Make Bed", "bed.double.fill", "1 min"), ("Hydrate", "drop.fill", "30 sec"),
            ("Stretch", "figure.flexibility", "3 min"), ("Journal", "book.fill", "5 min"),
            ("Sunlight", "sun.max.fill", "2 min"), ("Gratitude", "heart.text.clipboard", "2 min"),
            ("No Phone", "iphone.slash", "10 min"), ("Cold Splash", "snowflake", "30 sec"),
            ("Breathe", "wind", "2 min")]
        case .wellness: return [
            ("Walk", "figure.walk", "10 min"), ("Water", "cup.and.saucer.fill", "30 sec"),
            ("Fruit", "carrot.fill", "5 min"), ("Posture", "figure.stand", "1 min"),
            ("Smile", "face.smiling", "10 sec"), ("Eye Rest", "eye.fill", "20 sec"),
            ("Deep Breath", "lungs.fill", "2 min"), ("Vitamin", "pill.fill", "30 sec"),
            ("Stairs", "figure.stairs", "3 min")]
        case .focus: return [
            ("Pomodoro", "timer", "25 min"), ("No Social", "antenna.radiowaves.left.and.right.slash", "30 min"),
            ("One Task", "checklist", "15 min"), ("Clean Desk", "desktopcomputer", "5 min"),
            ("Read", "book.closed.fill", "10 min"), ("Plan Day", "calendar", "5 min"),
            ("Inbox Zero", "envelope.fill", "10 min"), ("Brain Dump", "pencil.and.outline", "5 min"),
            ("Silent Mode", "bell.slash.fill", "30 min")]
        case .evening: return [
            ("Reflect", "text.book.closed.fill", "5 min"), ("Dim Lights", "lightbulb.fill", "1 min"),
            ("No Screen", "display", "30 min"), ("Tea", "mug.fill", "5 min"),
            ("Tidy Up", "sparkles", "10 min"), ("Tomorrow", "calendar.badge.plus", "3 min"),
            ("Skin Care", "drop.triangle.fill", "5 min"), ("Meditation", "figure.mind.and.body", "5 min"),
            ("Gratitude", "heart.fill", "2 min")]
        }
    }

    func completionRatio(completed: Set<Int>) -> Double {
        guard !habits.isEmpty else { return 0 }
        return Double(completed.count) / Double(habits.count)
    }
}

struct SeededRNG: RandomNumberGenerator {
    private var state: UInt64
    init(seed: UInt64) { state = seed == 0 ? 1 : seed }
    mutating func next() -> UInt64 { state ^= state << 13; state ^= state >> 7; state ^= state << 17; return state }
}
