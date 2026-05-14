import SwiftUI

enum ComponentType: String, CaseIterable, Identifiable, Codable, Hashable {
    case wire, switchToggle, led, notGate, andGate, orGate, xorGate, splitter

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .wire: "Wire"
        case .switchToggle: "Switch"
        case .led: "LED"
        case .notGate: "NOT"
        case .andGate: "AND"
        case .orGate: "OR"
        case .xorGate: "XOR"
        case .splitter: "Splitter"
        }
    }

    var icon: String {
        switch self {
        case .wire: "minus"
        case .switchToggle: "power"
        case .led: "lightbulb.fill"
        case .notGate: "exclamationmark.triangle.fill"
        case .andGate: "arrow.triangle.merge"
        case .orGate: "arrow.triangle.branch"
        case .xorGate: "bolt.trianglebadge.exclamationmark.fill"
        case .splitter: "arrow.branch"
        }
    }

    var colorHex: String {
        switch self {
        case .wire: "8E8E93"
        case .switchToggle: "FF9500"
        case .led: "FFD60A"
        case .notGate: "FF453A"
        case .andGate: "30D158"
        case .orGate: "0A84FF"
        case .xorGate: "BF5AF2"
        case .splitter: "64D2FF"
        }
    }

    var color: Color { Color(hex: colorHex) }

    var inputCount: Int {
        switch self {
        case .wire, .switchToggle, .led, .splitter: 1
        case .notGate: 1
        case .andGate, .orGate, .xorGate: 2
        }
    }

    var outputCount: Int {
        switch self {
        case .wire, .switchToggle, .notGate, .andGate, .orGate, .xorGate: 1
        case .led: 0
        case .splitter: 2
        }
    }

    func evaluate(inputs: [Bool]) -> [Bool] {
        switch self {
        case .wire: return [inputs.first ?? false]
        case .switchToggle: return [inputs.first ?? false]
        case .led: return [Bool]()
        case .notGate: return [!(inputs.first ?? false)]
        case .andGate: return [inputs.count >= 2 && inputs[0] && inputs[1]]
        case .orGate: return [inputs.count >= 2 && (inputs[0] || inputs[1])]
        case .xorGate: return [inputs.count >= 2 && (inputs[0] != inputs[1])]
        case .splitter:
            let v = inputs.first ?? false
            return [v, v]
        }
    }

    var seasonUnlock: Int {
        switch self {
        case .wire, .switchToggle, .led, .notGate: 0
        case .andGate, .orGate: 1
        case .xorGate, .splitter: 2
        }
    }
}

struct PlacedComponent: Identifiable, Hashable {
    let id: UUID
    let type: ComponentType
    var row: Int
    var col: Int
    var rotation: Int

    init(type: ComponentType, row: Int, col: Int, rotation: Int = 0) {
        self.id = UUID()
        self.type = type
        self.row = row
        self.col = col
        self.rotation = rotation
    }
}
