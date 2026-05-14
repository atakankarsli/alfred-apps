import SwiftUI

enum Themes {
    static let helix = Theme(
        id: "helix", name: "Helix", isDark: true,
        gradientColors: [Color(hex: "0D1B2A"), Color(hex: "1B2838")],
        iconName: "line.3.crossed.swirl.circle.fill",
        colors: ThemeColors(
            background: "0D1B2A", surface: "1B2838", primary: "00B4D8", secondary: "0077B6", accent: "48CAE4",
            text: "E0F7FF", textSecondary: "90CAF9", textMuted: "546E7A", textOnPrimary: "FFFFFF",
            cardBorder: "00B4D8", cardBackground: "1B2838", cardHighlight: "243447", cardSelected: "2D4456",
            success: "4CAF50", warning: "FFC107", error: "FF5252"
        )
    )
    static let nucleus = Theme(
        id: "nucleus", name: "Nucleus", isDark: true,
        gradientColors: [Color(hex: "1A0033"), Color(hex: "2D0066")],
        iconName: "circle.hexagongrid.fill",
        colors: ThemeColors(
            background: "1A0033", surface: "2D0066", primary: "BB86FC", secondary: "9C27B0", accent: "CE93D8",
            text: "F3E5F5", textSecondary: "BA68C8", textMuted: "6A1B9A", textOnPrimary: "FFFFFF",
            cardBorder: "BB86FC", cardBackground: "2D0066", cardHighlight: "3D0088", cardSelected: "4D00AA",
            success: "4CAF50", warning: "FFC107", error: "FF5252"
        )
    )
    static let cytoplasm = Theme(
        id: "cytoplasm", name: "Cytoplasm", isDark: false,
        gradientColors: [Color(hex: "E8F5E9"), Color(hex: "C8E6C9")],
        iconName: "drop.halffull",
        colors: ThemeColors(
            background: "E8F5E9", surface: "C8E6C9", primary: "4CAF50", secondary: "66BB6A", accent: "81C784",
            text: "1B5E20", textSecondary: "388E3C", textMuted: "A5D6A7", textOnPrimary: "FFFFFF",
            cardBorder: "4CAF50", cardBackground: "C8E6C9", cardHighlight: "B9DEB9", cardSelected: "A5D6A7",
            success: "2E7D32", warning: "F57F17", error: "C62828"
        )
    )
    static let chloroplast = Theme(
        id: "chloroplast", name: "Chloroplast", isDark: true,
        gradientColors: [Color(hex: "0A1F0A"), Color(hex: "1B3A1B")],
        iconName: "leaf.fill",
        colors: ThemeColors(
            background: "0A1F0A", surface: "1B3A1B", primary: "76FF03", secondary: "64DD17", accent: "B2FF59",
            text: "E8FFE0", textSecondary: "A5D6A7", textMuted: "4E6E4E", textOnPrimary: "0A1F0A",
            cardBorder: "76FF03", cardBackground: "1B3A1B", cardHighlight: "2B4A2B", cardSelected: "3B5A3B",
            success: "00E676", warning: "FFD600", error: "FF1744"
        )
    )
    static let mitochondria = Theme(
        id: "mitochondria", name: "Mitochondria", isDark: true,
        gradientColors: [Color(hex: "1A0A00"), Color(hex: "331500")],
        iconName: "bolt.fill",
        colors: ThemeColors(
            background: "1A0A00", surface: "331500", primary: "FF6D00", secondary: "FF9100", accent: "FFAB40",
            text: "FFF3E0", textSecondary: "FFB74D", textMuted: "8B5E34", textOnPrimary: "FFFFFF",
            cardBorder: "FF6D00", cardBackground: "331500", cardHighlight: "442200", cardSelected: "553300",
            success: "4CAF50", warning: "FFC107", error: "FF5252"
        )
    )
    static let membrane = Theme(
        id: "membrane", name: "Membrane", isDark: true,
        gradientColors: [Color(hex: "0D1520"), Color(hex: "1A2535")],
        iconName: "circle.dashed",
        colors: ThemeColors(
            background: "0D1520", surface: "1A2535", primary: "42A5F5", secondary: "1E88E5", accent: "90CAF9",
            text: "E3F2FD", textSecondary: "64B5F6", textMuted: "455A64", textOnPrimary: "FFFFFF",
            cardBorder: "42A5F5", cardBackground: "1A2535", cardHighlight: "253545", cardSelected: "304555",
            success: "4CAF50", warning: "FFC107", error: "FF5252"
        )
    )
    static let ribosome = Theme(
        id: "ribosome", name: "Ribosome", isDark: true,
        gradientColors: [Color(hex: "1A1A00"), Color(hex: "333300")],
        iconName: "circle.grid.3x3.fill",
        colors: ThemeColors(
            background: "1A1A00", surface: "333300", primary: "FFEB3B", secondary: "FDD835", accent: "FFF176",
            text: "FFFDE7", textSecondary: "FFF59D", textMuted: "827717", textOnPrimary: "1A1A00",
            cardBorder: "FFEB3B", cardBackground: "333300", cardHighlight: "444400", cardSelected: "555500",
            success: "4CAF50", warning: "FF9800", error: "FF5252"
        )
    )
    static let enzyme = Theme(
        id: "enzyme", name: "Enzyme", isDark: true,
        gradientColors: [Color(hex: "0A001A"), Color(hex: "1A0033")],
        iconName: "wand.and.stars",
        colors: ThemeColors(
            background: "0A001A", surface: "1A0033", primary: "E040FB", secondary: "AB47BC", accent: "EA80FC",
            text: "F3E5F5", textSecondary: "CE93D8", textMuted: "6A1B9A", textOnPrimary: "FFFFFF",
            cardBorder: "E040FB", cardBackground: "1A0033", cardHighlight: "2A0044", cardSelected: "3A0055",
            success: "4CAF50", warning: "FFC107", error: "FF5252"
        )
    )
    static let virus = Theme(
        id: "virus", name: "Virus", isDark: true,
        gradientColors: [Color(hex: "1A0000"), Color(hex: "330000")],
        iconName: "allergens.fill",
        colors: ThemeColors(
            background: "1A0000", surface: "330000", primary: "FF1744", secondary: "D50000", accent: "FF5252",
            text: "FFEBEE", textSecondary: "EF9A9A", textMuted: "8B3A3A", textOnPrimary: "FFFFFF",
            cardBorder: "FF1744", cardBackground: "330000", cardHighlight: "440000", cardSelected: "550000",
            success: "4CAF50", warning: "FFC107", error: "FF8A80"
        )
    )
    static let genome = Theme(
        id: "genome", name: "Genome", isDark: true,
        gradientColors: [Color(hex: "001A1A"), Color(hex: "003333")],
        iconName: "waveform.path.ecg",
        colors: ThemeColors(
            background: "001A1A", surface: "003333", primary: "00BFA5", secondary: "009688", accent: "64FFDA",
            text: "E0F2F1", textSecondary: "80CBC4", textMuted: "4A6E6E", textOnPrimary: "FFFFFF",
            cardBorder: "00BFA5", cardBackground: "003333", cardHighlight: "004444", cardSelected: "005555",
            success: "4CAF50", warning: "FFC107", error: "FF5252"
        )
    )

    static let all: [Theme] = [helix, nucleus, cytoplasm, chloroplast, mitochondria, membrane, ribosome, enzyme, virus, genome]

    static func theme(for id: String) -> Theme {
        all.first { $0.id == id } ?? helix
    }
}
