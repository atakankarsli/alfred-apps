import SwiftUI

enum Themes {
    static let all: [Theme] = [liquid, neon, aurora, coral, mint, ember, prism, abyss, mercury, void]
    static let `default` = liquid

    static let liquid = Theme(id: "liquid", name: "Liquid", colors: ThemeColors(
        background: "0A0E27", surface: "151B3D", primary: "00D4FF", secondary: "0099CC",
        accent: "66E5FF", text: "F0F4FF", textSecondary: "A0B4D0", textMuted: "5A6B8A",
        textOnPrimary: "0A0E27", boardBorder: "1E2A50", cellBackground: "151B3D",
        cellHighlight: "1E2A50", cellSelected: "00D4FF"
    ), isDark: true, gradientColors: [Color(hex: "0A0E27"), Color(hex: "0D1230")], iconName: "drop.fill")

    static let neon = Theme(id: "neon", name: "Neon", colors: ThemeColors(
        background: "0D0015", surface: "1A0030", primary: "FF00FF", secondary: "CC00CC",
        accent: "FF66FF", text: "F0E0FF", textSecondary: "B080D0", textMuted: "6A4080",
        textOnPrimary: "0D0015", boardBorder: "2A0050", cellBackground: "1A0030",
        cellHighlight: "2A0050", cellSelected: "FF00FF"
    ), isDark: true, gradientColors: [Color(hex: "0D0015"), Color(hex: "150025")], iconName: "lightbulb.fill")

    static let aurora = Theme(id: "aurora", name: "Aurora", colors: ThemeColors(
        background: "001020", surface: "002040", primary: "00FF88", secondary: "00CC6A",
        accent: "66FFB2", text: "E0FFF0", textSecondary: "80C0A0", textMuted: "406050",
        textOnPrimary: "001020", boardBorder: "003050", cellBackground: "002040",
        cellHighlight: "003050", cellSelected: "00FF88"
    ), isDark: true, gradientColors: [Color(hex: "001020"), Color(hex: "001830")], iconName: "sparkles")

    static let coral = Theme(id: "coral", name: "Coral", colors: ThemeColors(
        background: "200A0A", surface: "3D1515", primary: "FF6B6B", secondary: "CC5555",
        accent: "FF9999", text: "FFF0F0", textSecondary: "D0A0A0", textMuted: "8A5A5A",
        textOnPrimary: "200A0A", boardBorder: "501E1E", cellBackground: "3D1515",
        cellHighlight: "501E1E", cellSelected: "FF6B6B"
    ), isDark: true, gradientColors: [Color(hex: "200A0A"), Color(hex: "2A1010")], iconName: "flame.fill")

    static let mint = Theme(id: "mint", name: "Mint", colors: ThemeColors(
        background: "F0FFF8", surface: "FFFFFF", primary: "20C997", secondary: "38D9A9",
        accent: "63E6BE", text: "1A1A2E", textSecondary: "4A5568", textMuted: "A0AEC0",
        textOnPrimary: "FFFFFF", boardBorder: "C3FAE8", cellBackground: "F0FFF8",
        cellHighlight: "C3FAE8", cellSelected: "20C997"
    ), isDark: false, gradientColors: [Color(hex: "F0FFF8"), Color(hex: "C3FAE8")], iconName: "leaf.fill")

    static let ember = Theme(id: "ember", name: "Ember", colors: ThemeColors(
        background: "FFF8F0", surface: "FFFFFF", primary: "FF6B35", secondary: "FF8C5A",
        accent: "FFB088", text: "1A1A2E", textSecondary: "4A5568", textMuted: "A0AEC0",
        textOnPrimary: "FFFFFF", boardBorder: "FFE0CC", cellBackground: "FFF8F0",
        cellHighlight: "FFE0CC", cellSelected: "FF6B35"
    ), isDark: false, gradientColors: [Color(hex: "FFF8F0"), Color(hex: "FFE0CC")], iconName: "flame.fill")

    static let prism = Theme(id: "prism", name: "Prism", colors: ThemeColors(
        background: "F8F0FF", surface: "FFFFFF", primary: "7C3AED", secondary: "8B5CF6",
        accent: "A78BFA", text: "1A1A2E", textSecondary: "4A5568", textMuted: "A0AEC0",
        textOnPrimary: "FFFFFF", boardBorder: "E9D5FF", cellBackground: "F8F0FF",
        cellHighlight: "E9D5FF", cellSelected: "7C3AED"
    ), isDark: false, gradientColors: [Color(hex: "F8F0FF"), Color(hex: "E9D5FF")], iconName: "rainbow")

    static let abyss = Theme(id: "abyss", name: "Abyss", colors: ThemeColors(
        background: "000810", surface: "001020", primary: "4488FF", secondary: "3366CC",
        accent: "77AAFF", text: "D0E0FF", textSecondary: "8090B0", textMuted: "405060",
        textOnPrimary: "000810", boardBorder: "102040", cellBackground: "001020",
        cellHighlight: "102040", cellSelected: "4488FF"
    ), isDark: true, gradientColors: [Color(hex: "000810"), Color(hex: "001020")], iconName: "water.waves")

    static let mercury = Theme(id: "mercury", name: "Mercury", colors: ThemeColors(
        background: "F0F2F5", surface: "FFFFFF", primary: "6B7280", secondary: "9CA3AF",
        accent: "D1D5DB", text: "1F2937", textSecondary: "4B5563", textMuted: "9CA3AF",
        textOnPrimary: "FFFFFF", boardBorder: "E5E7EB", cellBackground: "F9FAFB",
        cellHighlight: "E5E7EB", cellSelected: "6B7280"
    ), isDark: false, gradientColors: [Color(hex: "F0F2F5"), Color(hex: "E5E7EB")], iconName: "circle.fill")

    static let void = Theme(id: "void", name: "Void", colors: ThemeColors(
        background: "000000", surface: "0A0A0A", primary: "FFFFFF", secondary: "CCCCCC",
        accent: "999999", text: "F0F0F0", textSecondary: "999999", textMuted: "555555",
        textOnPrimary: "000000", boardBorder: "222222", cellBackground: "0A0A0A",
        cellHighlight: "1A1A1A", cellSelected: "FFFFFF"
    ), isDark: true, gradientColors: [Color(hex: "000000"), Color(hex: "0A0A0A")], iconName: "circle.dashed")
}
