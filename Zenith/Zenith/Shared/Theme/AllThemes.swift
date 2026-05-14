import SwiftUI

enum Themes {
    static let all: [Theme] = [midnight, aurora, nebula, twilight, polar, eclipse, cosmos, stardust, supernova, void]
    static let `default` = midnight

    static func theme(for id: String) -> Theme {
        all.first { $0.id == id } ?? `default`
    }

    static let midnight = Theme(
        id: "midnight", name: "Midnight", isDark: true,
        gradientColors: [Color(hex: "0A0E27"), Color(hex: "141B3D"), Color(hex: "0D1230")],
        iconName: "moon.stars.fill",
        colors: ThemeColors(
            background: "0A0E27", surface: "151B3D", primary: "4A9EFF", secondary: "7B68EE", accent: "00D4FF",
            text: "F0F4FF", textSecondary: "A8B4D0", textMuted: "5A6580", textOnPrimary: "FFFFFF",
            cardBorder: "2A3560", cardBackground: "1A2248", cardHighlight: "253070", cardSelected: "4A9EFF",
            success: "00E676", warning: "FFD740", error: "FF5252"
        )
    )

    static let aurora = Theme(
        id: "aurora", name: "Aurora", isDark: true,
        gradientColors: [Color(hex: "0B1A0F"), Color(hex: "0A2818"), Color(hex: "061510")],
        iconName: "sparkles",
        colors: ThemeColors(
            background: "0B1A0F", surface: "122818", primary: "00E676", secondary: "69F0AE", accent: "40C4FF",
            text: "E8FFE8", textSecondary: "90C8A0", textMuted: "4A7858", textOnPrimary: "0B1A0F",
            cardBorder: "1A4028", cardBackground: "143020", cardHighlight: "1E4830", cardSelected: "00E676",
            success: "69F0AE", warning: "FFD740", error: "FF5252"
        )
    )

    static let nebula = Theme(
        id: "nebula", name: "Nebula", isDark: true,
        gradientColors: [Color(hex: "1A0A2E"), Color(hex: "2D1250"), Color(hex: "16082A")],
        iconName: "cloud.fill",
        colors: ThemeColors(
            background: "1A0A2E", surface: "2D1250", primary: "CE93D8", secondary: "F48FB1", accent: "EA80FC",
            text: "F5E6FF", textSecondary: "C8A8D8", textMuted: "7A5890", textOnPrimary: "1A0A2E",
            cardBorder: "3D1A60", cardBackground: "251040", cardHighlight: "381558", cardSelected: "CE93D8",
            success: "69F0AE", warning: "FFD740", error: "FF5252"
        )
    )

    static let twilight = Theme(
        id: "twilight", name: "Twilight", isDark: true,
        gradientColors: [Color(hex: "1A1020"), Color(hex: "2E1830"), Color(hex: "3D1A28")],
        iconName: "sun.horizon.fill",
        colors: ThemeColors(
            background: "1A1020", surface: "2E1830", primary: "FF8A65", secondary: "FFB74D", accent: "FF7043",
            text: "FFF0E8", textSecondary: "D0A898", textMuted: "806058", textOnPrimary: "1A1020",
            cardBorder: "402030", cardBackground: "281428", cardHighlight: "382038", cardSelected: "FF8A65",
            success: "69F0AE", warning: "FFD740", error: "FF5252"
        )
    )

    static let polar = Theme(
        id: "polar", name: "Polar", isDark: false,
        gradientColors: [Color(hex: "E8F0FF"), Color(hex: "F0F4FF"), Color(hex: "E0EAFF")],
        iconName: "snowflake",
        colors: ThemeColors(
            background: "E8F0FF", surface: "FFFFFF", primary: "2962FF", secondary: "448AFF", accent: "00B0FF",
            text: "1A1A2E", textSecondary: "4A5080", textMuted: "8890B0", textOnPrimary: "FFFFFF",
            cardBorder: "C8D4F0", cardBackground: "F5F8FF", cardHighlight: "E0E8FF", cardSelected: "2962FF",
            success: "00C853", warning: "FF8F00", error: "D50000"
        )
    )

    static let eclipse = Theme(
        id: "eclipse", name: "Eclipse", isDark: true,
        gradientColors: [Color(hex: "0D0D0D"), Color(hex: "1A1400"), Color(hex: "0D0A00")],
        iconName: "moon.circle.fill",
        colors: ThemeColors(
            background: "0D0D0D", surface: "1A1400", primary: "FFD700", secondary: "FFC107", accent: "FFAB00",
            text: "FFF8E0", textSecondary: "C8B060", textMuted: "706020", textOnPrimary: "0D0D0D",
            cardBorder: "302800", cardBackground: "201C00", cardHighlight: "2A2400", cardSelected: "FFD700",
            success: "69F0AE", warning: "FFD740", error: "FF5252"
        )
    )

    static let cosmos = Theme(
        id: "cosmos", name: "Cosmos", isDark: true,
        gradientColors: [Color(hex: "0A0020"), Color(hex: "180040"), Color(hex: "0D0028")],
        iconName: "globe.americas.fill",
        colors: ThemeColors(
            background: "0A0020", surface: "180040", primary: "B388FF", secondary: "7C4DFF", accent: "D500F9",
            text: "F0E6FF", textSecondary: "B0A0D0", textMuted: "605080", textOnPrimary: "0A0020",
            cardBorder: "2A1060", cardBackground: "150038", cardHighlight: "221058", cardSelected: "B388FF",
            success: "69F0AE", warning: "FFD740", error: "FF5252"
        )
    )

    static let stardust = Theme(
        id: "stardust", name: "Stardust", isDark: true,
        gradientColors: [Color(hex: "101018"), Color(hex: "1A1A28"), Color(hex: "0E0E18")],
        iconName: "sparkle",
        colors: ThemeColors(
            background: "101018", surface: "1A1A28", primary: "C0C0D0", secondary: "A0A0B8", accent: "E0E0F0",
            text: "F0F0FF", textSecondary: "A0A0B8", textMuted: "606078", textOnPrimary: "101018",
            cardBorder: "2A2A40", cardBackground: "181828", cardHighlight: "222238", cardSelected: "C0C0D0",
            success: "69F0AE", warning: "FFD740", error: "FF5252"
        )
    )

    static let supernova = Theme(
        id: "supernova", name: "Supernova", isDark: true,
        gradientColors: [Color(hex: "1A0505"), Color(hex: "2E0A0A"), Color(hex: "180404")],
        iconName: "flame.fill",
        colors: ThemeColors(
            background: "1A0505", surface: "2E0A0A", primary: "FF5252", secondary: "FF8A80", accent: "FF1744",
            text: "FFE8E8", textSecondary: "D09090", textMuted: "805050", textOnPrimary: "1A0505",
            cardBorder: "401010", cardBackground: "280808", cardHighlight: "381010", cardSelected: "FF5252",
            success: "69F0AE", warning: "FFD740", error: "FF8A80"
        )
    )

    static let void = Theme(
        id: "void", name: "Void", isDark: true,
        gradientColors: [Color(hex: "000000"), Color(hex: "0A0A0A"), Color(hex: "050505")],
        iconName: "circle.fill",
        colors: ThemeColors(
            background: "000000", surface: "0A0A0A", primary: "FFFFFF", secondary: "C0C0C0", accent: "808080",
            text: "FFFFFF", textSecondary: "A0A0A0", textMuted: "505050", textOnPrimary: "000000",
            cardBorder: "1A1A1A", cardBackground: "0D0D0D", cardHighlight: "151515", cardSelected: "FFFFFF",
            success: "69F0AE", warning: "FFD740", error: "FF5252"
        )
    )
}
