import Foundation
import Observation

@Observable
final class AetherEngine: @unchecked Sendable {
    var workspace: [Element] = []
    var discovered: Set<String> = []
    var moveCount = 0
    var hintsUsed = 0
    var hintsRemaining = 0
    var targetElement: Element?
    var isComplete = false
    var startTime: Date?
    var combineHistory: [(Element, Element, Element)] = []

    private var puzzle: LevelPuzzle?

    func startLevel(_ index: Int) {
        let p = ElementData.levelPuzzle(forLevel: index)
        puzzle = p
        workspace = ElementData.baseElements
        discovered = Set(ElementData.baseElements.map { $0.id })
        moveCount = 0
        hintsUsed = 0
        hintsRemaining = p.hintCount
        targetElement = p.targetElement
        isComplete = false
        startTime = Date()
        combineHistory = []
    }

    func startSandbox() {
        puzzle = nil
        workspace = ElementData.baseElements
        discovered = Set(ElementData.baseElements.map { $0.id })
        moveCount = 0
        hintsUsed = 0
        hintsRemaining = 0
        targetElement = nil
        isComplete = false
        startTime = Date()
        combineHistory = []
    }

    func combine(_ a: Element, _ b: Element) -> Element? {
        guard let result = ElementData.combine(a.id, b.id) else { return nil }
        moveCount += 1
        combineHistory.append((a, b, result))
        if !discovered.contains(result.id) {
            discovered.insert(result.id)
            workspace.append(result)
        }
        if let target = targetElement, result.id == target.id {
            isComplete = true
        }
        return result
    }

    func useHint() -> (String, String)? {
        guard hintsRemaining > 0, let target = targetElement else { return nil }
        hintsUsed += 1
        hintsRemaining -= 1

        if let recipe = target.recipe, discovered.contains(recipe.0), discovered.contains(recipe.1) {
            return recipe
        }

        let needed = findPath(to: target.id)
        for elementId in needed {
            guard let element = ElementData.elementMap[elementId],
                  let recipe = element.recipe,
                  discovered.contains(recipe.0),
                  discovered.contains(recipe.1),
                  !discovered.contains(elementId) else { continue }
            return recipe
        }
        return target.recipe
    }

    private func findPath(to targetId: String) -> [String] {
        guard let target = ElementData.elementMap[targetId],
              let recipe = target.recipe else { return [] }
        var path: [String] = []
        if !discovered.contains(recipe.0) {
            path += findPath(to: recipe.0)
        }
        if !discovered.contains(recipe.1) {
            path += findPath(to: recipe.1)
        }
        path.append(targetId)
        return path
    }

    var elapsed: TimeInterval {
        guard let start = startTime else { return 0 }
        return Date().timeIntervalSince(start)
    }

    var stars: Int {
        guard let p = puzzle else { return 0 }
        return AetherConfig.starsForMoves(moveCount, target: p.targetMoves)
    }

    var xpEarned: Int {
        var xp = AetherConfig.xpPerLevel
        xp += AetherConfig.xpPerDiscovery * (discovered.count - 4)
        if stars == 3 { xp += AetherConfig.xpBonusPerfect }
        if hintsUsed == 0 { xp += AetherConfig.xpBonusNoHint }
        return xp
    }
}
