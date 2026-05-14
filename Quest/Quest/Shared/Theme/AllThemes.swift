import SwiftUI

enum Themes {
    static let explorer = Theme(id: "explorer", name: "Explorer", colors: ThemeColors(
        background: "#F5F8F0", surface: "#FFFFFF", primary: "#4A8C3F", secondary: "#7AB86E",
        accent: "#4A8C3F", text: "#1A3315", textSecondary: "#4A6A40", textMuted: "#A0B898",
        textOnPrimary: "#FFFFFF", cardBorder: "#4A8C3F", cardBackground: "#FFFFFF",
        cardHighlight: "#E8F0E5", cardSelected: "#7AB86E", success: "#4CAF50", warning: "#FF9800", error: "#D32F2F"
    ), isDark: false, gradientColors: [Color(hex: "#F5F8F0"), Color(hex: "#E8F0E5"), Color(hex: "#DCE8D5")], iconName: "leaf.fill")

    static let compass = Theme(id: "compass", name: "Compass", colors: ThemeColors(
        background: "#F0F4F8", surface: "#FFFFFF", primary: "#2E6B9C", secondary: "#5A9FCC",
        accent: "#2E6B9C", text: "#0F2840", textSecondary: "#3A5A78", textMuted: "#90B0C8",
        textOnPrimary: "#FFFFFF", cardBorder: "#2E6B9C", cardBackground: "#FFFFFF",
        cardHighlight: "#E0ECF5", cardSelected: "#5A9FCC", success: "#4CAF50", warning: "#FF9800", error: "#D32F2F"
    ), isDark: false, gradientColors: [Color(hex: "#F0F4F8"), Color(hex: "#E0ECF5"), Color(hex: "#D0E4F0")], iconName: "safari.fill")

    static let desert = Theme(id: "desert", name: "Desert", colors: ThemeColors(
        background: "#FBF5EC", surface: "#FFFFFF", primary: "#CC8833", secondary: "#E6A855",
        accent: "#CC8833", text: "#3D2810", textSecondary: "#8C6030", textMuted: "#CCB888",
        textOnPrimary: "#FFFFFF", cardBorder: "#CC8833", cardBackground: "#FFFFFF",
        cardHighlight: "#F5E8D5", cardSelected: "#E6A855", success: "#4CAF50", warning: "#FF9800", error: "#D32F2F"
    ), isDark: false, gradientColors: [Color(hex: "#FBF5EC"), Color(hex: "#F5E8D5"), Color(hex: "#EFDCC0")], iconName: "sun.max.fill")

    static let arctic = Theme(id: "arctic", name: "Arctic", colors: ThemeColors(
        background: "#F0F8FF", surface: "#FFFFFF", primary: "#5588BB", secondary: "#88BBDD",
        accent: "#5588BB", text: "#152535", textSecondary: "#456080", textMuted: "#A0C0DD",
        textOnPrimary: "#FFFFFF", cardBorder: "#5588BB", cardBackground: "#FFFFFF",
        cardHighlight: "#E0F0FF", cardSelected: "#88BBDD", success: "#4CAF50", warning: "#FF9800", error: "#D32F2F"
    ), isDark: false, gradientColors: [Color(hex: "#F0F8FF"), Color(hex: "#E0F0FF"), Color(hex: "#D0E8FF")], iconName: "snowflake")

    static let volcano = Theme(id: "volcano", name: "Volcano", colors: ThemeColors(
        background: "#FFF5F0", surface: "#FFFFFF", primary: "#CC4422", secondary: "#E67755",
        accent: "#CC4422", text: "#3D1510", textSecondary: "#993322", textMuted: "#CCA088",
        textOnPrimary: "#FFFFFF", cardBorder: "#CC4422", cardBackground: "#FFFFFF",
        cardHighlight: "#FFE8E0", cardSelected: "#E67755", success: "#4CAF50", warning: "#FF9800", error: "#D32F2F"
    ), isDark: false, gradientColors: [Color(hex: "#FFF5F0"), Color(hex: "#FFE8E0"), Color(hex: "#FFDDD0")], iconName: "flame.fill")

    static let jungle = Theme(id: "jungle", name: "Jungle", colors: ThemeColors(
        background: "#F2F8F0", surface: "#FFFFFF", primary: "#2D8C4E", secondary: "#55BB77",
        accent: "#2D8C4E", text: "#0F3320", textSecondary: "#3A7A4A", textMuted: "#90C0A0",
        textOnPrimary: "#FFFFFF", cardBorder: "#2D8C4E", cardBackground: "#FFFFFF",
        cardHighlight: "#E0F5E8", cardSelected: "#55BB77", success: "#4CAF50", warning: "#FF9800", error: "#D32F2F"
    ), isDark: false, gradientColors: [Color(hex: "#F2F8F0"), Color(hex: "#E0F5E8"), Color(hex: "#D0EDD8")], iconName: "tree.fill")

    static let midnight = Theme(id: "midnight", name: "Midnight", colors: ThemeColors(
        background: "#0A0F1A", surface: "#141C2A", primary: "#5588DD", secondary: "#3366AA",
        accent: "#5588DD", text: "#D0DDEE", textSecondary: "#7A99BB", textMuted: "#334466",
        textOnPrimary: "#0A0F1A", cardBorder: "#1A2A44", cardBackground: "#141C2A",
        cardHighlight: "#1E2838", cardSelected: "#5588DD", success: "#66BB6A", warning: "#FFA726", error: "#EF5350"
    ), isDark: true, gradientColors: [Color(hex: "#0A0F1A"), Color(hex: "#141C2A"), Color(hex: "#1E2838")], iconName: "moon.stars.fill")

    static let aurora = Theme(id: "aurora", name: "Aurora", colors: ThemeColors(
        background: "#0A1520", surface: "#142030", primary: "#44DDAA", secondary: "#22AA88",
        accent: "#44DDAA", text: "#D0F0E8", textSecondary: "#66AA90", textMuted: "#2A5545",
        textOnPrimary: "#0A1520", cardBorder: "#1A3A30", cardBackground: "#142030",
        cardHighlight: "#1E2E38", cardSelected: "#44DDAA", success: "#44DDAA", warning: "#FFD740", error: "#FF5252"
    ), isDark: true, gradientColors: [Color(hex: "#0A1520"), Color(hex: "#142030"), Color(hex: "#1E2E38")], iconName: "sparkles")

    static let cavern = Theme(id: "cavern", name: "Cavern", colors: ThemeColors(
        background: "#121210", surface: "#1C1C18", primary: "#CCAA55", secondary: "#AA8833",
        accent: "#CCAA55", text: "#E0D8C8", textSecondary: "#A09070", textMuted: "#504530",
        textOnPrimary: "#121210", cardBorder: "#2A2820", cardBackground: "#1C1C18",
        cardHighlight: "#242418", cardSelected: "#CCAA55", success: "#66BB6A", warning: "#FFA726", error: "#EF5350"
    ), isDark: true, gradientColors: [Color(hex: "#121210"), Color(hex: "#1C1C18"), Color(hex: "#242418")], iconName: "mountain.2.fill")

    static let abyss = Theme(id: "abyss", name: "Abyss", colors: ThemeColors(
        background: "#050510", surface: "#0A0A1A", primary: "#6666FF", secondary: "#4444CC",
        accent: "#6666FF", text: "#D0D0FF", textSecondary: "#8888CC", textMuted: "#333366",
        textOnPrimary: "#050510", cardBorder: "#1A1A33", cardBackground: "#0A0A1A",
        cardHighlight: "#121225", cardSelected: "#6666FF", success: "#69F0AE", warning: "#FFD740", error: "#FF5252"
    ), isDark: true, gradientColors: [Color(hex: "#050510"), Color(hex: "#0A0A1A"), Color(hex: "#121225")], iconName: "water.waves")

    static let all: [Theme] = [explorer, compass, desert, arctic, volcano, jungle, midnight, aurora, cavern, abyss]
    static let lightThemes: [Theme] = [explorer, compass, desert, arctic, volcano, jungle]
    static let darkThemes: [Theme] = [midnight, aurora, cavern, abyss]
    static let `default` = explorer
    static func theme(for id: String) -> Theme { all.first { $0.id == id } ?? `default` }
}
