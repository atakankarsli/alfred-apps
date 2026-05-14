import SwiftUI

enum Themes {
    static let runestone = Theme(
        id: "runestone", name: "Rune Stone",
        colors: ThemeColors(
            background: "#E8E4E0", surface: "#F5F2EE", primary: "#5A6A7A", secondary: "#8899AA",
            accent: "#5A6A7A", text: "#2A2A2E", textSecondary: "#6A6A70", textMuted: "#A0A0A5",
            textOnPrimary: "#FFFFFF", cardBorder: "#5A6A7A", cardBackground: "#F5F2EE",
            cardHighlight: "#DDD8D2", cardSelected: "#8899AA", success: "#4CAF50",
            warning: "#FF9800", error: "#D32F2F"
        ),
        isDark: false,
        gradientColors: [Color(hex: "#E8E4E0"), Color(hex: "#DDD8D2"), Color(hex: "#D2CCC5")],
        iconName: "shield.fill"
    )

    static let papyrus = Theme(
        id: "papyrus", name: "Papyrus",
        colors: ThemeColors(
            background: "#F5EED8", surface: "#FFF8E8", primary: "#8B6914", secondary: "#C49A2A",
            accent: "#8B6914", text: "#3A2A0A", textSecondary: "#7A6030", textMuted: "#B8A878",
            textOnPrimary: "#FFFFFF", cardBorder: "#8B6914", cardBackground: "#FFF8E8",
            cardHighlight: "#F0E5C8", cardSelected: "#C49A2A", success: "#4CAF50",
            warning: "#FF9800", error: "#D32F2F"
        ),
        isDark: false,
        gradientColors: [Color(hex: "#F5EED8"), Color(hex: "#F0E5C8"), Color(hex: "#EADCB8")],
        iconName: "scroll.fill"
    )

    static let inkbrush = Theme(
        id: "inkbrush", name: "Ink & Brush",
        colors: ThemeColors(
            background: "#F8F6F4", surface: "#FFFFFF", primary: "#2A2A2A", secondary: "#666666",
            accent: "#2A2A2A", text: "#1A1A1A", textSecondary: "#555555", textMuted: "#AAAAAA",
            textOnPrimary: "#FFFFFF", cardBorder: "#2A2A2A", cardBackground: "#FFFFFF",
            cardHighlight: "#F0EEEC", cardSelected: "#666666", success: "#4CAF50",
            warning: "#FF9800", error: "#D32F2F"
        ),
        isDark: false,
        gradientColors: [Color(hex: "#F8F6F4"), Color(hex: "#F0EEEC"), Color(hex: "#E8E6E4")],
        iconName: "pencil.tip"
    )

    static let sand = Theme(
        id: "sand", name: "Sand",
        colors: ThemeColors(
            background: "#F5EFE0", surface: "#FFF9F0", primary: "#C4883A", secondary: "#D4A85A",
            accent: "#C4883A", text: "#3A2810", textSecondary: "#8A6A40", textMuted: "#C0A880",
            textOnPrimary: "#FFFFFF", cardBorder: "#C4883A", cardBackground: "#FFF9F0",
            cardHighlight: "#F0E8D5", cardSelected: "#D4A85A", success: "#4CAF50",
            warning: "#FF9800", error: "#D32F2F"
        ),
        isDark: false,
        gradientColors: [Color(hex: "#F5EFE0"), Color(hex: "#F0E8D5"), Color(hex: "#E8DCCA")],
        iconName: "sun.dust.fill"
    )

    static let frost = Theme(
        id: "frost", name: "Frost",
        colors: ThemeColors(
            background: "#EEF4F8", surface: "#FFFFFF", primary: "#4A8EB5", secondary: "#7AB0D0",
            accent: "#4A8EB5", text: "#1A2A3A", textSecondary: "#4A6A8A", textMuted: "#90B0C8",
            textOnPrimary: "#FFFFFF", cardBorder: "#4A8EB5", cardBackground: "#FFFFFF",
            cardHighlight: "#E0EEF5", cardSelected: "#7AB0D0", success: "#4CAF50",
            warning: "#FF9800", error: "#D32F2F"
        ),
        isDark: false,
        gradientColors: [Color(hex: "#EEF4F8"), Color(hex: "#E0EEF5"), Color(hex: "#D0E5F0")],
        iconName: "snowflake"
    )

    static let jade = Theme(
        id: "jade", name: "Jade",
        colors: ThemeColors(
            background: "#EEF5F0", surface: "#FFFFFF", primary: "#3A8A5A", secondary: "#6AB08A",
            accent: "#3A8A5A", text: "#1A3A22", textSecondary: "#4A7A5A", textMuted: "#90C0A0",
            textOnPrimary: "#FFFFFF", cardBorder: "#3A8A5A", cardBackground: "#FFFFFF",
            cardHighlight: "#E0F0E5", cardSelected: "#6AB08A", success: "#4CAF50",
            warning: "#FF9800", error: "#D32F2F"
        ),
        isDark: false,
        gradientColors: [Color(hex: "#EEF5F0"), Color(hex: "#E0F0E5"), Color(hex: "#D0EAD8")],
        iconName: "leaf.fill"
    )

    static let neonglow = Theme(
        id: "neonglow", name: "Neon Glow",
        colors: ThemeColors(
            background: "#0A0F14", surface: "#141C24", primary: "#00FF88", secondary: "#00CC6A",
            accent: "#00FF88", text: "#E0F0E8", textSecondary: "#80C0A0", textMuted: "#305540",
            textOnPrimary: "#0A0F14", cardBorder: "#1A3028", cardBackground: "#141C24",
            cardHighlight: "#1A2830", cardSelected: "#00FF88", success: "#00E676",
            warning: "#FFD740", error: "#FF5252"
        ),
        isDark: true,
        gradientColors: [Color(hex: "#0A0F14"), Color(hex: "#141C24"), Color(hex: "#1A2830")],
        iconName: "bolt.fill"
    )

    static let bloodmoon = Theme(
        id: "bloodmoon", name: "Blood Moon",
        colors: ThemeColors(
            background: "#1A0A0A", surface: "#241414", primary: "#CC3333", secondary: "#992222",
            accent: "#CC3333", text: "#F0D8D8", textSecondary: "#C08080", textMuted: "#553030",
            textOnPrimary: "#1A0A0A", cardBorder: "#3A1818", cardBackground: "#241414",
            cardHighlight: "#2E1A1A", cardSelected: "#CC3333", success: "#66BB6A",
            warning: "#FFA726", error: "#EF5350"
        ),
        isDark: true,
        gradientColors: [Color(hex: "#1A0A0A"), Color(hex: "#241414"), Color(hex: "#2E1A1A")],
        iconName: "moon.fill"
    )

    static let obsidian = Theme(
        id: "obsidian", name: "Obsidian",
        colors: ThemeColors(
            background: "#0A0A0E", surface: "#14141A", primary: "#D4A84A", secondary: "#B08830",
            accent: "#D4A84A", text: "#F0EAD8", textSecondary: "#A09880", textMuted: "#484438",
            textOnPrimary: "#0A0A0E", cardBorder: "#2A2820", cardBackground: "#14141A",
            cardHighlight: "#1E1E24", cardSelected: "#D4A84A", success: "#00E676",
            warning: "#FFD740", error: "#FF5252"
        ),
        isDark: true,
        gradientColors: [Color(hex: "#0A0A0E"), Color(hex: "#14141A"), Color(hex: "#1E1E24")],
        iconName: "diamond.fill"
    )

    static let aurora = Theme(
        id: "aurora", name: "Aurora",
        colors: ThemeColors(
            background: "#080818", surface: "#121228", primary: "#7B4DFF", secondary: "#00D4AA",
            accent: "#7B4DFF", text: "#E8E0FF", textSecondary: "#9088CC", textMuted: "#3A3466",
            textOnPrimary: "#080818", cardBorder: "#2A2850", cardBackground: "#121228",
            cardHighlight: "#1A1A38", cardSelected: "#7B4DFF", success: "#00E676",
            warning: "#FFD740", error: "#FF5252"
        ),
        isDark: true,
        gradientColors: [Color(hex: "#080818"), Color(hex: "#121228"), Color(hex: "#1A1A38")],
        iconName: "sparkles"
    )

    static let all: [Theme] = [runestone, papyrus, inkbrush, sand, frost, jade, neonglow, bloodmoon, obsidian, aurora]
    static let lightThemes: [Theme] = [runestone, papyrus, inkbrush, sand, frost, jade]
    static let darkThemes: [Theme] = [neonglow, bloodmoon, obsidian, aurora]
    static let `default` = runestone

    static func theme(for id: String) -> Theme {
        all.first { $0.id == id } ?? `default`
    }
}
