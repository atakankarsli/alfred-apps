import SwiftUI

enum Themes {
    static let all: [Theme] = [
        aether, stone, verdant, arcane, gilded, frost, shadow, crystal, scarlet, void
    ]

    static func theme(for id: String) -> Theme {
        all.first { $0.id == id } ?? aether
    }

    static let aether = Theme(
        id: "aether", name: "Aether", isDark: true,
        gradientColors: [Color(hex: "0A0A1E"), Color(hex: "1A1A3E"), Color(hex: "0A0A1E")],
        iconName: "atom",
        colors: ThemeColors(
            background: "0A0A1E", surface: "1A1A3E", primary: "7C4DFF", secondary: "536DFE", accent: "B388FF",
            text: "E8E0FF", textSecondary: "9088CC", textMuted: "605899", textOnPrimary: "FFFFFF",
            cardBorder: "7C4DFF", cardBackground: "1A1A3E", cardHighlight: "2A2A4E", cardSelected: "3A3A5E",
            success: "69F0AE", warning: "FFD740", error: "FF5252"
        )
    )

    static let stone = Theme(
        id: "stone", name: "Stone", isDark: true,
        gradientColors: [Color(hex: "121210"), Color(hex: "1E1E1A"), Color(hex: "121210")],
        iconName: "cube.fill",
        colors: ThemeColors(
            background: "121210", surface: "1E1E1A", primary: "8D6E63", secondary: "A1887F", accent: "BCAAA4",
            text: "E8E0D8", textSecondary: "A09888", textMuted: "605848", textOnPrimary: "FFFFFF",
            cardBorder: "8D6E63", cardBackground: "1E1E1A", cardHighlight: "2E2E2A", cardSelected: "3E3E3A",
            success: "66BB6A", warning: "FFB74D", error: "EF5350"
        )
    )

    static let verdant = Theme(
        id: "verdant", name: "Verdant", isDark: true,
        gradientColors: [Color(hex: "051A0A"), Color(hex: "0A2E14"), Color(hex: "051A0A")],
        iconName: "leaf.fill",
        colors: ThemeColors(
            background: "051A0A", surface: "0A2E14", primary: "4CAF50", secondary: "66BB6A", accent: "81C784",
            text: "E0F0E8", textSecondary: "80C090", textMuted: "407050", textOnPrimary: "FFFFFF",
            cardBorder: "4CAF50", cardBackground: "0A2E14", cardHighlight: "1A3E24", cardSelected: "2A4E34",
            success: "A5D6A7", warning: "FFD54F", error: "E57373"
        )
    )

    static let arcane = Theme(
        id: "arcane", name: "Arcane", isDark: true,
        gradientColors: [Color(hex: "1A0A20"), Color(hex: "2D1540"), Color(hex: "1A0A20")],
        iconName: "sparkles",
        colors: ThemeColors(
            background: "1A0A20", surface: "2D1540", primary: "E040FB", secondary: "CE93D8", accent: "F48FB1",
            text: "F0E0FF", textSecondary: "B090D0", textMuted: "705090", textOnPrimary: "FFFFFF",
            cardBorder: "E040FB", cardBackground: "2D1540", cardHighlight: "3D2550", cardSelected: "4D3560",
            success: "69F0AE", warning: "FFD740", error: "FF5252"
        )
    )

    static let gilded = Theme(
        id: "gilded", name: "Gilded", isDark: true,
        gradientColors: [Color(hex: "0D0A00"), Color(hex: "1E1500"), Color(hex: "0D0A00")],
        iconName: "seal.fill",
        colors: ThemeColors(
            background: "0D0A00", surface: "1E1500", primary: "FFD700", secondary: "FFC107", accent: "FFE082",
            text: "FFF8D0", textSecondary: "C8B060", textMuted: "7A6830", textOnPrimary: "1A1000",
            cardBorder: "FFD700", cardBackground: "1E1500", cardHighlight: "2E2500", cardSelected: "3E3500",
            success: "A5D6A7", warning: "FFE082", error: "EF9A9A"
        )
    )

    static let frost = Theme(
        id: "frost", name: "Frost", isDark: true,
        gradientColors: [Color(hex: "051520"), Color(hex: "0A2535"), Color(hex: "051520")],
        iconName: "snowflake",
        colors: ThemeColors(
            background: "051520", surface: "0A2535", primary: "4FC3F7", secondary: "29B6F6", accent: "81D4FA",
            text: "E0F0FF", textSecondary: "80B8D0", textMuted: "406878", textOnPrimary: "051520",
            cardBorder: "4FC3F7", cardBackground: "0A2535", cardHighlight: "1A3545", cardSelected: "2A4555",
            success: "80CBC4", warning: "FFD54F", error: "EF9A9A"
        )
    )

    static let shadow = Theme(
        id: "shadow", name: "Shadow", isDark: true,
        gradientColors: [Color(hex: "050505"), Color(hex: "101010"), Color(hex: "050505")],
        iconName: "moon.fill",
        colors: ThemeColors(
            background: "050505", surface: "101010", primary: "9E9E9E", secondary: "757575", accent: "BDBDBD",
            text: "E0E0E0", textSecondary: "909090", textMuted: "505050", textOnPrimary: "050505",
            cardBorder: "9E9E9E", cardBackground: "101010", cardHighlight: "202020", cardSelected: "303030",
            success: "66BB6A", warning: "FFA726", error: "EF5350"
        )
    )

    static let crystal = Theme(
        id: "crystal", name: "Crystal", isDark: false,
        gradientColors: [Color(hex: "F0F0FF"), Color(hex: "E0E0F8"), Color(hex: "F0F0FF")],
        iconName: "diamond.fill",
        colors: ThemeColors(
            background: "F0F0FF", surface: "FFFFFF", primary: "5C6BC0", secondary: "7986CB", accent: "9FA8DA",
            text: "1A1A2E", textSecondary: "3D3D6E", textMuted: "8888AA", textOnPrimary: "FFFFFF",
            cardBorder: "5C6BC0", cardBackground: "FFFFFF", cardHighlight: "F0F0FF", cardSelected: "E0E0F8",
            success: "2E7D32", warning: "F57F17", error: "C62828"
        )
    )

    static let scarlet = Theme(
        id: "scarlet", name: "Scarlet", isDark: true,
        gradientColors: [Color(hex: "1A0505"), Color(hex: "2D0A0A"), Color(hex: "1A0505")],
        iconName: "flame.fill",
        colors: ThemeColors(
            background: "1A0505", surface: "2D0A0A", primary: "F44336", secondary: "E57373", accent: "FFCDD2",
            text: "FFE0E0", textSecondary: "CC8080", textMuted: "884040", textOnPrimary: "FFFFFF",
            cardBorder: "F44336", cardBackground: "2D0A0A", cardHighlight: "3D1A1A", cardSelected: "4D2A2A",
            success: "69F0AE", warning: "FFD740", error: "FF1744"
        )
    )

    static let void = Theme(
        id: "void", name: "Void", isDark: true,
        gradientColors: [Color(hex: "000000"), Color(hex: "080008"), Color(hex: "000000")],
        iconName: "circle.fill",
        colors: ThemeColors(
            background: "000000", surface: "080008", primary: "AA00FF", secondary: "7B1FA2", accent: "D500F9",
            text: "D0C0E0", textSecondary: "806090", textMuted: "403050", textOnPrimary: "FFFFFF",
            cardBorder: "AA00FF", cardBackground: "080008", cardHighlight: "180018", cardSelected: "280028",
            success: "388E3C", warning: "FFA000", error: "D32F2F"
        )
    )
}
