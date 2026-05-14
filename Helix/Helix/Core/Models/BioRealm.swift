import Foundation

enum BioRealm: Int, CaseIterable, Sendable {
    case nucleus = 0
    case ribosome = 1
    case membrane = 2
    case helicase = 3
    case evolution = 4

    var name: String {
        switch self {
        case .nucleus: "Nucleus"
        case .ribosome: "Ribosome"
        case .membrane: "Membrane"
        case .helicase: "Helicase"
        case .evolution: "Evolution"
        }
    }

    var icon: String {
        switch self {
        case .nucleus: "circle.hexagongrid.fill"
        case .ribosome: "circle.grid.3x3.fill"
        case .membrane: "circle.dashed"
        case .helicase: "arrow.triangle.swap"
        case .evolution: "leaf.arrow.circlepath"
        }
    }

    var subtitle: String {
        switch self {
        case .nucleus: "Base pair matching fundamentals"
        case .ribosome: "Codon translation puzzles"
        case .membrane: "Signal sequence patterns"
        case .helicase: "Speed unwinding challenges"
        case .evolution: "Mutation chain puzzles"
        }
    }

    var levelRange: Range<Int> {
        let start = rawValue * 16
        return start..<(start + 16)
    }
}
