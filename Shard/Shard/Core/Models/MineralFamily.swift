import SwiftUI

struct MineralFamily: Identifiable {
    let id: Int
    let name: String
    let subtitle: String
    let icon: String
    let crystalRange: Range<Int>
    let accentHex: String
    let crystalTypes: [CrystalType]

    var crystalCount: Int { crystalRange.count }
    func color(_ theme: Theme) -> Color { Color(hex: accentHex) }

    static let all: [MineralFamily] = [
        MineralFamily(id: 0, name: "Quartz", subtitle: "Silicon Dioxide", icon: "diamond.fill",
                      crystalRange: 0..<16, accentHex: "9B59B6", crystalTypes: [.amethyst, .citrine, .roseQuartz, .smokyQuartz]),
        MineralFamily(id: 1, name: "Beryl", subtitle: "Beryllium Aluminum", icon: "hexagon.fill",
                      crystalRange: 16..<32, accentHex: "2ECC71", crystalTypes: [.emerald, .aquamarine, .morganite]),
        MineralFamily(id: 2, name: "Corundum", subtitle: "Aluminum Oxide", icon: "seal.fill",
                      crystalRange: 32..<48, accentHex: "E74C3C", crystalTypes: [.ruby, .sapphire]),
        MineralFamily(id: 3, name: "Fluorite", subtitle: "Calcium Fluoride", icon: "cube.fill",
                      crystalRange: 48..<64, accentHex: "3498DB", crystalTypes: [.greenFluorite, .purpleFluorite, .blueFluorite]),
        MineralFamily(id: 4, name: "Carbon", subtitle: "Pure Carbon", icon: "sparkle",
                      crystalRange: 64..<80, accentHex: "F1C40F", crystalTypes: [.diamond]),
    ]

    static func familyForCrystal(_ idx: Int) -> MineralFamily {
        all.first { $0.crystalRange.contains(idx) } ?? all[0]
    }
}
