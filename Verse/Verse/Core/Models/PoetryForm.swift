import Foundation

enum PoetryForm: String, CaseIterable, Identifiable {
    case haiku
    case tanka
    case limerick
    case couplet
    case quatrain

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .haiku: "Haiku"
        case .tanka: "Tanka"
        case .limerick: "Limerick"
        case .couplet: "Couplet"
        case .quatrain: "Quatrain"
        }
    }

    var lineCount: Int {
        switch self {
        case .haiku: 3
        case .tanka: 5
        case .limerick: 5
        case .couplet: 2
        case .quatrain: 4
        }
    }

    var syllablesPerLine: [Int] {
        switch self {
        case .haiku: [5, 7, 5]
        case .tanka: [5, 7, 5, 7, 7]
        case .limerick: [8, 8, 5, 5, 8]
        case .couplet: [10, 10]
        case .quatrain: [8, 6, 8, 6]
        }
    }

    var rhymeScheme: [Character]? {
        switch self {
        case .haiku, .tanka: nil
        case .limerick: ["A", "A", "B", "B", "A"]
        case .couplet: ["A", "A"]
        case .quatrain: ["A", "B", "A", "B"]
        }
    }

    var requiresRhyme: Bool { rhymeScheme != nil }

    var icon: String {
        switch self {
        case .haiku: "leaf.fill"
        case .tanka: "wind"
        case .limerick: "music.note"
        case .couplet: "text.quote"
        case .quatrain: "book.fill"
        }
    }

    var totalSyllables: Int { syllablesPerLine.reduce(0, +) }
}
