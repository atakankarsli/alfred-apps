import SwiftUI

enum Themes {
    static let amethyst = Theme(id: "amethyst", name: "Amethyst", colors: ThemeColors(
        background: "#F5F0FF", surface: "#FFFFFF", primary: "#9B59B6", secondary: "#BB8FCE",
        accent: "#9B59B6", text: "#2C1445", textSecondary: "#7D3C98", textMuted: "#D2B4DE",
        textOnPrimary: "#FFFFFF", cardBorder: "#9B59B6", cardBackground: "#FFFFFF",
        cardHighlight: "#EDE0FF", cardSelected: "#BB8FCE", success: "#27AE60", warning: "#F39C12", error: "#E74C3C"
    ), isDark: false, gradientColors: [Color(hex: "#F5F0FF"), Color(hex: "#EDE0FF"), Color(hex: "#D7BDE2")], iconName: "diamond.fill")

    static let ice = Theme(id: "ice", name: "Ice Cave", colors: ThemeColors(
        background: "#EAF6FF", surface: "#FFFFFF", primary: "#2980B9", secondary: "#5DADE2",
        accent: "#2980B9", text: "#1B3A4B", textSecondary: "#2E86C1", textMuted: "#AED6F1",
        textOnPrimary: "#FFFFFF", cardBorder: "#2980B9", cardBackground: "#FFFFFF",
        cardHighlight: "#D6EAF8", cardSelected: "#5DADE2", success: "#27AE60", warning: "#F39C12", error: "#E74C3C"
    ), isDark: false, gradientColors: [Color(hex: "#EAF6FF"), Color(hex: "#D6EAF8"), Color(hex: "#AED6F1")], iconName: "snowflake")

    static let volcano = Theme(id: "volcano", name: "Volcano", colors: ThemeColors(
        background: "#FFF3E6", surface: "#FFFFFF", primary: "#E74C3C", secondary: "#F1948A",
        accent: "#E74C3C", text: "#3D1008", textSecondary: "#C0392B", textMuted: "#FADBD8",
        textOnPrimary: "#FFFFFF", cardBorder: "#E74C3C", cardBackground: "#FFFFFF",
        cardHighlight: "#FDEDEC", cardSelected: "#F1948A", success: "#27AE60", warning: "#F39C12", error: "#E74C3C"
    ), isDark: false, gradientColors: [Color(hex: "#FFF3E6"), Color(hex: "#FDEDEC"), Color(hex: "#FADBD8")], iconName: "flame.fill")

    static let emerald = Theme(id: "emerald", name: "Emerald", colors: ThemeColors(
        background: "#EAFAF1", surface: "#FFFFFF", primary: "#27AE60", secondary: "#58D68D",
        accent: "#27AE60", text: "#0E3D20", textSecondary: "#1E8449", textMuted: "#ABEBC6",
        textOnPrimary: "#FFFFFF", cardBorder: "#27AE60", cardBackground: "#FFFFFF",
        cardHighlight: "#D5F5E3", cardSelected: "#58D68D", success: "#27AE60", warning: "#F39C12", error: "#E74C3C"
    ), isDark: false, gradientColors: [Color(hex: "#EAFAF1"), Color(hex: "#D5F5E3"), Color(hex: "#ABEBC6")], iconName: "leaf.fill")

    static let citrine = Theme(id: "citrine", name: "Citrine", colors: ThemeColors(
        background: "#FEF9E7", surface: "#FFFFFF", primary: "#F39C12", secondary: "#F7DC6F",
        accent: "#F39C12", text: "#3D2607", textSecondary: "#D68910", textMuted: "#F9E79F",
        textOnPrimary: "#FFFFFF", cardBorder: "#F39C12", cardBackground: "#FFFFFF",
        cardHighlight: "#FCF3CF", cardSelected: "#F7DC6F", success: "#27AE60", warning: "#F39C12", error: "#E74C3C"
    ), isDark: false, gradientColors: [Color(hex: "#FEF9E7"), Color(hex: "#FCF3CF"), Color(hex: "#F9E79F")], iconName: "sun.max.fill")

    static let rose = Theme(id: "rose", name: "Rose Quartz", colors: ThemeColors(
        background: "#FDF2F8", surface: "#FFFFFF", primary: "#E8A0BF", secondary: "#F0C6D9",
        accent: "#E8A0BF", text: "#4A1A30", textSecondary: "#CC7A9E", textMuted: "#F5D0E0",
        textOnPrimary: "#FFFFFF", cardBorder: "#E8A0BF", cardBackground: "#FFFFFF",
        cardHighlight: "#FDE8F0", cardSelected: "#F0C6D9", success: "#27AE60", warning: "#F39C12", error: "#E74C3C"
    ), isDark: false, gradientColors: [Color(hex: "#FDF2F8"), Color(hex: "#FDE8F0"), Color(hex: "#F5D0E0")], iconName: "heart.fill")

    static let obsidian = Theme(id: "obsidian", name: "Obsidian", colors: ThemeColors(
        background: "#0D0D0D", surface: "#1A1A1A", primary: "#8E8E93", secondary: "#636366",
        accent: "#8E8E93", text: "#E5E5EA", textSecondary: "#AEAEB2", textMuted: "#3A3A3C",
        textOnPrimary: "#0D0D0D", cardBorder: "#2C2C2E", cardBackground: "#1A1A1A",
        cardHighlight: "#2C2C2E", cardSelected: "#8E8E93", success: "#30D158", warning: "#FFD60A", error: "#FF453A"
    ), isDark: true, gradientColors: [Color(hex: "#0D0D0D"), Color(hex: "#1A1A1A"), Color(hex: "#2C2C2E")], iconName: "moon.fill")

    static let deepCave = Theme(id: "deepcave", name: "Deep Cave", colors: ThemeColors(
        background: "#0A1628", surface: "#132238", primary: "#3498DB", secondary: "#2980B9",
        accent: "#3498DB", text: "#D6EAF8", textSecondary: "#85C1E9", textMuted: "#1B4F72",
        textOnPrimary: "#0A1628", cardBorder: "#1B4F72", cardBackground: "#132238",
        cardHighlight: "#1A3050", cardSelected: "#3498DB", success: "#2ECC71", warning: "#F1C40F", error: "#E74C3C"
    ), isDark: true, gradientColors: [Color(hex: "#0A1628"), Color(hex: "#132238"), Color(hex: "#1A3050")], iconName: "mountain.2.fill")

    static let magma = Theme(id: "magma", name: "Magma", colors: ThemeColors(
        background: "#1A0A0A", surface: "#241414", primary: "#E74C3C", secondary: "#C0392B",
        accent: "#E74C3C", text: "#FADBD8", textSecondary: "#F1948A", textMuted: "#4A2020",
        textOnPrimary: "#1A0A0A", cardBorder: "#3A1A1A", cardBackground: "#241414",
        cardHighlight: "#2A1818", cardSelected: "#E74C3C", success: "#2ECC71", warning: "#F1C40F", error: "#E74C3C"
    ), isDark: true, gradientColors: [Color(hex: "#1A0A0A"), Color(hex: "#241414"), Color(hex: "#2A1818")], iconName: "flame.fill")

    static let cosmos = Theme(id: "cosmos", name: "Cosmos", colors: ThemeColors(
        background: "#0A0A1A", surface: "#12122A", primary: "#9B59B6", secondary: "#8E44AD",
        accent: "#9B59B6", text: "#E8DAEF", textSecondary: "#BB8FCE", textMuted: "#311B42",
        textOnPrimary: "#0A0A1A", cardBorder: "#1A1A3A", cardBackground: "#12122A",
        cardHighlight: "#161630", cardSelected: "#9B59B6", success: "#2ECC71", warning: "#F1C40F", error: "#E74C3C"
    ), isDark: true, gradientColors: [Color(hex: "#0A0A1A"), Color(hex: "#12122A"), Color(hex: "#161630")], iconName: "sparkles")

    static let all: [Theme] = [amethyst, ice, volcano, emerald, citrine, rose, obsidian, deepCave, magma, cosmos]
    static let `default` = amethyst
    static func theme(for id: String) -> Theme { all.first { $0.id == id } ?? `default` }
}
