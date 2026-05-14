import SwiftUI

struct Chapter: Identifiable {
    let id: Int
    let name: String
    let subtitle: String
    let icon: String
    let form: PoetryForm
    let levelRange: Range<Int>
    let accentHex: String

    var levelCount: Int { levelRange.count }
    var firstLevel: Int { levelRange.lowerBound }

    static let all: [Chapter] = [
        Chapter(id: 0, name: "Whisper", subtitle: "Nature Haiku", icon: "leaf.fill", form: .haiku, levelRange: 0..<16, accentHex: "7B9E6B"),
        Chapter(id: 1, name: "Murmur", subtitle: "Reflective Tanka", icon: "wind", form: .tanka, levelRange: 16..<32, accentHex: "6B8C9E"),
        Chapter(id: 2, name: "Rhythm", subtitle: "Playful Limericks", icon: "music.note", form: .limerick, levelRange: 32..<48, accentHex: "C4856A"),
        Chapter(id: 3, name: "Verse", subtitle: "Elegant Couplets", icon: "text.quote", form: .couplet, levelRange: 48..<64, accentHex: "9E6B8C"),
        Chapter(id: 4, name: "Opus", subtitle: "Grand Quatrains", icon: "book.fill", form: .quatrain, levelRange: 64..<80, accentHex: "8C7B6B"),
    ]

    static func chapterForLevel(_ level: Int) -> Chapter {
        all.first { $0.levelRange.contains(level) } ?? all[0]
    }

    static func localIndex(forLevel level: Int) -> Int {
        let chapter = chapterForLevel(level)
        return level - chapter.firstLevel
    }
}
