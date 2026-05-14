import SwiftUI

enum Nucleotide: String, CaseIterable, Sendable, Identifiable {
    case adenine = "A"
    case thymine = "T"
    case cytosine = "C"
    case guanine = "G"

    var id: String { rawValue }

    var color: Color {
        switch self {
        case .adenine: Color(hex: "FF4444")
        case .thymine: Color(hex: "4488FF")
        case .cytosine: Color(hex: "44CC44")
        case .guanine: Color(hex: "FFBB33")
        }
    }

    var complement: Nucleotide {
        switch self {
        case .adenine: .thymine
        case .thymine: .adenine
        case .cytosine: .guanine
        case .guanine: .cytosine
        }
    }

    var icon: String {
        switch self {
        case .adenine: "a.circle.fill"
        case .thymine: "t.circle.fill"
        case .cytosine: "c.circle.fill"
        case .guanine: "g.circle.fill"
        }
    }
}
