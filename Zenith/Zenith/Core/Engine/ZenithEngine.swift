import SwiftUI

@MainActor
@Observable
final class ZenithEngine {
    let constellation: Constellation
    private(set) var connectedPairs: Set<String> = []
    private(set) var selectedStarIndex: Int? = nil
    private(set) var isComplete = false
    private(set) var wrongAttempts = 0
    private(set) var hintsUsed = 0
    var showHint = false

    var correctCount: Int { connectedPairs.count }
    var totalConnections: Int { constellation.connections.count }
    var progress: Double {
        guard totalConnections > 0 else { return 0 }
        return Double(correctCount) / Double(totalConnections)
    }

    init(constellation: Constellation) {
        self.constellation = constellation
    }

    func selectStar(_ index: Int) {
        guard !isComplete else { return }

        if let selected = selectedStarIndex {
            if selected == index {
                selectedStarIndex = nil
                return
            }
            attemptConnection(from: selected, to: index)
            selectedStarIndex = nil
        } else {
            selectedStarIndex = index
            HapticsService.selection()
        }
    }

    func useHint() {
        guard !isComplete else { return }
        let remaining = constellation.connections.filter { !connectedPairs.contains(pairKey($0.from, $0.to)) }
        guard let next = remaining.first else { return }
        hintsUsed += 1
        showHint = false
        addConnection(next.from, next.to)
    }

    func reset() {
        connectedPairs = []
        selectedStarIndex = nil
        isComplete = false
        wrongAttempts = 0
        hintsUsed = 0
        showHint = false
    }

    private func attemptConnection(from: Int, to: Int) {
        let key = pairKey(from, to)
        if connectedPairs.contains(key) { return }

        let isValid = constellation.connections.contains { conn in
            pairKey(conn.from, conn.to) == key
        }

        if isValid {
            addConnection(from, to)
        } else {
            wrongAttempts += 1
            HapticsService.error()
        }
    }

    private func addConnection(_ from: Int, _ to: Int) {
        connectedPairs.insert(pairKey(from, to))
        HapticsService.light()
        checkCompletion()
    }

    private func checkCompletion() {
        if correctCount == totalConnections {
            isComplete = true
            HapticsService.success()
        }
    }

    private func pairKey(_ a: Int, _ b: Int) -> String {
        let lo = min(a, b)
        let hi = max(a, b)
        return "\(lo)-\(hi)"
    }

    func isConnected(_ from: Int, _ to: Int) -> Bool {
        connectedPairs.contains(pairKey(from, to))
    }

    func isStarConnected(_ index: Int) -> Bool {
        constellation.connections.contains { conn in
            (conn.from == index || conn.to == index) && isConnected(conn.from, conn.to)
        }
    }
}
