import SwiftUI

enum CrystalType: String, CaseIterable, Identifiable, Codable, Hashable {
    case amethyst, citrine, roseQuartz, smokyQuartz
    case emerald, aquamarine, morganite
    case ruby, sapphire
    case greenFluorite, purpleFluorite, blueFluorite
    case diamond

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .amethyst: "Amethyst"
        case .citrine: "Citrine"
        case .roseQuartz: "Rose Quartz"
        case .smokyQuartz: "Smoky Quartz"
        case .emerald: "Emerald"
        case .aquamarine: "Aquamarine"
        case .morganite: "Morganite"
        case .ruby: "Ruby"
        case .sapphire: "Sapphire"
        case .greenFluorite: "Green Fluorite"
        case .purpleFluorite: "Purple Fluorite"
        case .blueFluorite: "Blue Fluorite"
        case .diamond: "Diamond"
        }
    }

    var colorHex: String {
        switch self {
        case .amethyst: "9B59B6"
        case .citrine: "F39C12"
        case .roseQuartz: "E8A0BF"
        case .smokyQuartz: "7F8C8D"
        case .emerald: "2ECC71"
        case .aquamarine: "76D7EA"
        case .morganite: "F5B7B1"
        case .ruby: "E74C3C"
        case .sapphire: "2980B9"
        case .greenFluorite: "1ABC9C"
        case .purpleFluorite: "8E44AD"
        case .blueFluorite: "3498DB"
        case .diamond: "ECF0F1"
        }
    }

    var facetCount: Int {
        switch self {
        case .amethyst, .citrine, .roseQuartz, .smokyQuartz: 6
        case .emerald, .aquamarine, .morganite: 6
        case .ruby, .sapphire: 6
        case .greenFluorite, .purpleFluorite, .blueFluorite: 4
        case .diamond: 8
        }
    }

    var baseGrowthRate: Double {
        switch self {
        case .amethyst, .citrine: 1.0
        case .roseQuartz, .smokyQuartz: 0.9
        case .emerald, .aquamarine: 0.7
        case .morganite: 0.8
        case .ruby, .sapphire: 0.5
        case .greenFluorite, .purpleFluorite, .blueFluorite: 1.2
        case .diamond: 0.2
        }
    }

    var color: Color { Color(hex: colorHex) }
}
