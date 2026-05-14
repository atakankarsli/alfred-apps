import SwiftUI

@MainActor
@Observable
final class RuneEngine {
    let puzzle: DecodePuzzle
    private(set) var decodedMap: [String: Character] = [:]
    private(set) var selectedGlyphId: String?
    private(set) var isComplete = false
    private(set) var wrongAttempts = 0
    private(set) var hintsUsed = 0

    var decodedCount: Int {
        decodedMap.count
    }

    var totalGlyphs: Int {
        puzzle.uniqueGlyphs.count
    }

    var progress: Double {
        guard totalGlyphs > 0 else { return 0 }
        return Double(decodedCount) / Double(totalGlyphs)
    }

    init(puzzle: DecodePuzzle) {
        self.puzzle = puzzle
    }

    func selectGlyph(_ glyphId: String) {
        guard !isComplete else { return }
        if selectedGlyphId == glyphId {
            selectedGlyphId = nil
        } else {
            selectedGlyphId = glyphId
            HapticsService.selection()
        }
    }

    func guessLetter(_ letter: Character) {
        guard !isComplete, let glyphId = selectedGlyphId else { return }

        if let pair = puzzle.encodedPairs.first(where: { $0.glyph.id == glyphId }) {
            if pair.letter == letter {
                decodedMap[glyphId] = letter
                selectedGlyphId = nil
                HapticsService.light()
                checkCompletion()
            } else {
                wrongAttempts += 1
                HapticsService.error()
            }
        }
    }

    func useHint() {
        guard !isComplete else { return }
        let undecoded = puzzle.uniqueGlyphs.filter { decodedMap[$0.id] == nil }
        guard let next = undecoded.first else { return }
        if let pair = puzzle.encodedPairs.first(where: { $0.glyph.id == next.id }) {
            hintsUsed += 1
            decodedMap[next.id] = pair.letter
            HapticsService.light()
            checkCompletion()
        }
    }

    func reset() {
        decodedMap = [:]
        selectedGlyphId = nil
        isComplete = false
        wrongAttempts = 0
        hintsUsed = 0
    }

    func isDecoded(_ glyphId: String) -> Bool {
        decodedMap[glyphId] != nil
    }

    func decodedLetter(for glyphId: String) -> Character? {
        decodedMap[glyphId]
    }

    private func checkCompletion() {
        if decodedCount == totalGlyphs {
            isComplete = true
            HapticsService.success()
        }
    }

    var availableLetters: [Character] {
        let allLetters = Set(puzzle.plainText.filter { $0.isLetter })
        return allLetters.sorted()
    }

    var usedLetters: Set<Character> {
        Set(decodedMap.values)
    }
}
