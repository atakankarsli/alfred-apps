import SwiftUI

enum Themes {
    static let all: [Theme] = [
        ember, charcoal, magma, candle, forge, ash, sunset, obsidian, copper, void
    ]

    static func theme(for id: String) -> Theme {
        all.first { $0.id == id } ?? ember
    }

    static let ember = Theme(
        id: "ember", name: "Ember", isDark: true,
        gradientColors: [Color(hex: "1A0A00"), Color(hex: "3D1500"), Color(hex: "1A0500")],
        iconName: "flame.fill",
        colors: ThemeColors(
            background: "1A0A00", surface: "2D1200", primary: "FF6B35", secondary: "FF9F1C", accent: "FFB347",
            text: "FFF0E0", textSecondary: "CC9B7A", textMuted: "8B6248", textOnPrimary: "FFFFFF",
            cardBorder: "FF6B35", cardBackground: "2D1200", cardHighlight: "3D2200", cardSelected: "4D3200",
            success: "4CAF50", warning: "FFC107", error: "FF5252"
        )
    )

    static let charcoal = Theme(
        id: "charcoal", name: "Charcoal", isDark: true,
        gradientColors: [Color(hex: "0D0D0D"), Color(hex: "1A1A1A"), Color(hex: "0A0A0A")],
        iconName: "circle.grid.cross.fill",
        colors: ThemeColors(
            background: "0D0D0D", surface: "1C1C1C", primary: "E55B3C", secondary: "8B4513", accent: "D2691E",
            text: "E8E0D8", textSecondary: "A09088", textMuted: "605850", textOnPrimary: "FFFFFF",
            cardBorder: "E55B3C", cardBackground: "1C1C1C", cardHighlight: "2C2C2C", cardSelected: "3C3C3C",
            success: "66BB6A", warning: "FFB74D", error: "EF5350"
        )
    )

    static let magma = Theme(
        id: "magma", name: "Magma", isDark: true,
        gradientColors: [Color(hex: "1A0005"), Color(hex: "4A0010"), Color(hex: "1A0005")],
        iconName: "mountain.2.fill",
        colors: ThemeColors(
            background: "1A0005", surface: "2D0010", primary: "FF3D00", secondary: "FF6E40", accent: "FF9E80",
            text: "FFE0D0", textSecondary: "CC8070", textMuted: "8B5040", textOnPrimary: "FFFFFF",
            cardBorder: "FF3D00", cardBackground: "2D0010", cardHighlight: "3D0020", cardSelected: "4D0030",
            success: "69F0AE", warning: "FFD740", error: "FF1744"
        )
    )

    static let candle = Theme(
        id: "candle", name: "Candle", isDark: true,
        gradientColors: [Color(hex: "0F0800"), Color(hex: "1E1000"), Color(hex: "0F0800")],
        iconName: "candle.fill",
        colors: ThemeColors(
            background: "0F0800", surface: "1E1000", primary: "FFD54F", secondary: "FFE082", accent: "FFF8E1",
            text: "FFF8E1", textSecondary: "C8B080", textMuted: "7A6840", textOnPrimary: "1A1000",
            cardBorder: "FFD54F", cardBackground: "1E1000", cardHighlight: "2E2000", cardSelected: "3E3000",
            success: "A5D6A7", warning: "FFE082", error: "EF9A9A"
        )
    )

    static let forge = Theme(
        id: "forge", name: "Forge", isDark: true,
        gradientColors: [Color(hex: "0A0A12"), Color(hex: "1A1A2E"), Color(hex: "0A0A12")],
        iconName: "hammer.fill",
        colors: ThemeColors(
            background: "0A0A12", surface: "1A1A2E", primary: "FF7043", secondary: "5C6BC0", accent: "90A4AE",
            text: "ECEFF1", textSecondary: "90A4AE", textMuted: "546E7A", textOnPrimary: "FFFFFF",
            cardBorder: "FF7043", cardBackground: "1A1A2E", cardHighlight: "2A2A3E", cardSelected: "3A3A4E",
            success: "80CBC4", warning: "FFD54F", error: "FF8A80"
        )
    )

    static let ash = Theme(
        id: "ash", name: "Ash", isDark: false,
        gradientColors: [Color(hex: "F5F0EB"), Color(hex: "E8DDD5"), Color(hex: "F0E8E0")],
        iconName: "wind",
        colors: ThemeColors(
            background: "F5F0EB", surface: "FFFFFF", primary: "D84315", secondary: "8D6E63", accent: "A1887F",
            text: "3E2723", textSecondary: "6D4C41", textMuted: "A1887F", textOnPrimary: "FFFFFF",
            cardBorder: "D84315", cardBackground: "FFFFFF", cardHighlight: "F5F0EB", cardSelected: "E8DDD5",
            success: "2E7D32", warning: "F57F17", error: "C62828"
        )
    )

    static let sunset = Theme(
        id: "sunset", name: "Sunset", isDark: true,
        gradientColors: [Color(hex: "1A0A1E"), Color(hex: "3D1535"), Color(hex: "1A0A1E")],
        iconName: "sun.horizon.fill",
        colors: ThemeColors(
            background: "1A0A1E", surface: "2D1535", primary: "FF6F61", secondary: "E040FB", accent: "FF80AB",
            text: "FFE0F0", textSecondary: "CC90B0", textMuted: "8B5070", textOnPrimary: "FFFFFF",
            cardBorder: "FF6F61", cardBackground: "2D1535", cardHighlight: "3D2545", cardSelected: "4D3555",
            success: "69F0AE", warning: "FFD740", error: "FF5252"
        )
    )

    static let obsidian = Theme(
        id: "obsidian", name: "Obsidian", isDark: true,
        gradientColors: [Color(hex: "050505"), Color(hex: "121212"), Color(hex: "050505")],
        iconName: "diamond.fill",
        colors: ThemeColors(
            background: "050505", surface: "121212", primary: "B71C1C", secondary: "880E4F", accent: "E53935",
            text: "E0D0D0", textSecondary: "907070", textMuted: "604040", textOnPrimary: "FFFFFF",
            cardBorder: "B71C1C", cardBackground: "121212", cardHighlight: "222222", cardSelected: "323232",
            success: "4CAF50", warning: "FF9100", error: "FF1744"
        )
    )

    static let copper = Theme(
        id: "copper", name: "Copper", isDark: true,
        gradientColors: [Color(hex: "0D0A05"), Color(hex: "1E1508"), Color(hex: "0D0A05")],
        iconName: "circle.circle.fill",
        colors: ThemeColors(
            background: "0D0A05", surface: "1E1508", primary: "B87333", secondary: "CD7F32", accent: "DAA520",
            text: "F0E0C8", textSecondary: "B09878", textMuted: "706048", textOnPrimary: "FFFFFF",
            cardBorder: "B87333", cardBackground: "1E1508", cardHighlight: "2E2518", cardSelected: "3E3528",
            success: "81C784", warning: "FFD54F", error: "E57373"
        )
    )

    static let void = Theme(
        id: "void", name: "Void", isDark: true,
        gradientColors: [Color(hex: "000000"), Color(hex: "0A0000"), Color(hex: "000000")],
        iconName: "circle.fill",
        colors: ThemeColors(
            background: "000000", surface: "0A0000", primary: "FF4500", secondary: "CC3700", accent: "FF6347",
            text: "D0C0B0", textSecondary: "806050", textMuted: "503020", textOnPrimary: "FFFFFF",
            cardBorder: "FF4500", cardBackground: "0A0000", cardHighlight: "1A1000", cardSelected: "2A2000",
            success: "388E3C", warning: "FFA000", error: "D32F2F"
        )
    )
}
