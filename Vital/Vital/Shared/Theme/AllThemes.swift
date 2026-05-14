import SwiftUI

enum Themes {
    static let vitality = Theme(id: "vitality", name: "Vitality", colors: ThemeColors(
        background: "#F0FFF4", surface: "#FFFFFF", primary: "#38A169", secondary: "#68D391",
        accent: "#38A169", text: "#1A3A2A", textSecondary: "#4A7A5A", textMuted: "#A0C8B0",
        textOnPrimary: "#FFFFFF", cardBorder: "#38A169", cardBackground: "#FFFFFF",
        cardHighlight: "#E6F7ED", cardSelected: "#68D391", success: "#38A169", warning: "#DD6B20", error: "#E53E3E"
    ), isDark: false, gradientColors: [Color(hex: "#F0FFF4"), Color(hex: "#E6F7ED"), Color(hex: "#C6F6D5")], iconName: "heart.fill")

    static let ocean = Theme(id: "ocean", name: "Ocean", colors: ThemeColors(
        background: "#EBF8FF", surface: "#FFFFFF", primary: "#3182CE", secondary: "#63B3ED",
        accent: "#3182CE", text: "#1A365D", textSecondary: "#4A6FA5", textMuted: "#90CDF4",
        textOnPrimary: "#FFFFFF", cardBorder: "#3182CE", cardBackground: "#FFFFFF",
        cardHighlight: "#E0F0FF", cardSelected: "#63B3ED", success: "#38A169", warning: "#DD6B20", error: "#E53E3E"
    ), isDark: false, gradientColors: [Color(hex: "#EBF8FF"), Color(hex: "#E0F0FF"), Color(hex: "#BEE3F8")], iconName: "drop.fill")

    static let sunrise = Theme(id: "sunrise", name: "Sunrise", colors: ThemeColors(
        background: "#FFFAF0", surface: "#FFFFFF", primary: "#DD6B20", secondary: "#ED8936",
        accent: "#DD6B20", text: "#3D2008", textSecondary: "#9C4221", textMuted: "#FBD38D",
        textOnPrimary: "#FFFFFF", cardBorder: "#DD6B20", cardBackground: "#FFFFFF",
        cardHighlight: "#FFF0DB", cardSelected: "#ED8936", success: "#38A169", warning: "#DD6B20", error: "#E53E3E"
    ), isDark: false, gradientColors: [Color(hex: "#FFFAF0"), Color(hex: "#FFF0DB"), Color(hex: "#FEEBC8")], iconName: "sunrise.fill")

    static let lavender = Theme(id: "lavender", name: "Lavender", colors: ThemeColors(
        background: "#FAF5FF", surface: "#FFFFFF", primary: "#805AD5", secondary: "#B794F4",
        accent: "#805AD5", text: "#322659", textSecondary: "#6B46C1", textMuted: "#D6BCFA",
        textOnPrimary: "#FFFFFF", cardBorder: "#805AD5", cardBackground: "#FFFFFF",
        cardHighlight: "#F3E8FF", cardSelected: "#B794F4", success: "#38A169", warning: "#DD6B20", error: "#E53E3E"
    ), isDark: false, gradientColors: [Color(hex: "#FAF5FF"), Color(hex: "#F3E8FF"), Color(hex: "#E9D8FD")], iconName: "sparkle")

    static let cherry = Theme(id: "cherry", name: "Cherry", colors: ThemeColors(
        background: "#FFF5F5", surface: "#FFFFFF", primary: "#E53E3E", secondary: "#FC8181",
        accent: "#E53E3E", text: "#3D1010", textSecondary: "#C53030", textMuted: "#FEB2B2",
        textOnPrimary: "#FFFFFF", cardBorder: "#E53E3E", cardBackground: "#FFFFFF",
        cardHighlight: "#FFE0E0", cardSelected: "#FC8181", success: "#38A169", warning: "#DD6B20", error: "#E53E3E"
    ), isDark: false, gradientColors: [Color(hex: "#FFF5F5"), Color(hex: "#FFE0E0"), Color(hex: "#FED7D7")], iconName: "leaf.fill")

    static let mint = Theme(id: "mint", name: "Mint", colors: ThemeColors(
        background: "#F0FFFA", surface: "#FFFFFF", primary: "#319795", secondary: "#4FD1C5",
        accent: "#319795", text: "#1D4044", textSecondary: "#2C7A7B", textMuted: "#81E6D9",
        textOnPrimary: "#FFFFFF", cardBorder: "#319795", cardBackground: "#FFFFFF",
        cardHighlight: "#E0FFF8", cardSelected: "#4FD1C5", success: "#38A169", warning: "#DD6B20", error: "#E53E3E"
    ), isDark: false, gradientColors: [Color(hex: "#F0FFFA"), Color(hex: "#E0FFF8"), Color(hex: "#B2F5EA")], iconName: "wind")

    static let nightOwl = Theme(id: "nightowl", name: "Night Owl", colors: ThemeColors(
        background: "#0D1117", surface: "#161B22", primary: "#58A6FF", secondary: "#388BFD",
        accent: "#58A6FF", text: "#C9D1D9", textSecondary: "#8B949E", textMuted: "#30363D",
        textOnPrimary: "#0D1117", cardBorder: "#21262D", cardBackground: "#161B22",
        cardHighlight: "#1C2128", cardSelected: "#58A6FF", success: "#3FB950", warning: "#D29922", error: "#F85149"
    ), isDark: true, gradientColors: [Color(hex: "#0D1117"), Color(hex: "#161B22"), Color(hex: "#1C2128")], iconName: "moon.fill")

    static let deepBreath = Theme(id: "deepbreath", name: "Deep Breath", colors: ThemeColors(
        background: "#0A1628", surface: "#132238", primary: "#48BB78", secondary: "#38A169",
        accent: "#48BB78", text: "#C6F6D5", textSecondary: "#68D391", textMuted: "#1A4731",
        textOnPrimary: "#0A1628", cardBorder: "#1A3A28", cardBackground: "#132238",
        cardHighlight: "#162A38", cardSelected: "#48BB78", success: "#48BB78", warning: "#ECC94B", error: "#FC8181"
    ), isDark: true, gradientColors: [Color(hex: "#0A1628"), Color(hex: "#132238"), Color(hex: "#162A38")], iconName: "lungs.fill")

    static let ember = Theme(id: "ember", name: "Ember", colors: ThemeColors(
        background: "#1A0A0A", surface: "#241414", primary: "#F56565", secondary: "#E53E3E",
        accent: "#F56565", text: "#FED7D7", textSecondary: "#FC8181", textMuted: "#4A2020",
        textOnPrimary: "#1A0A0A", cardBorder: "#3A1A1A", cardBackground: "#241414",
        cardHighlight: "#2A1818", cardSelected: "#F56565", success: "#68D391", warning: "#F6E05E", error: "#F56565"
    ), isDark: true, gradientColors: [Color(hex: "#1A0A0A"), Color(hex: "#241414"), Color(hex: "#2A1818")], iconName: "flame.fill")

    static let cosmos = Theme(id: "cosmos", name: "Cosmos", colors: ThemeColors(
        background: "#0A0A1A", surface: "#12122A", primary: "#9F7AEA", secondary: "#805AD5",
        accent: "#9F7AEA", text: "#E9D8FD", textSecondary: "#B794F4", textMuted: "#322659",
        textOnPrimary: "#0A0A1A", cardBorder: "#1A1A3A", cardBackground: "#12122A",
        cardHighlight: "#161630", cardSelected: "#9F7AEA", success: "#68D391", warning: "#F6E05E", error: "#FC8181"
    ), isDark: true, gradientColors: [Color(hex: "#0A0A1A"), Color(hex: "#12122A"), Color(hex: "#161630")], iconName: "sparkles")

    static let all: [Theme] = [vitality, ocean, sunrise, lavender, cherry, mint, nightOwl, deepBreath, ember, cosmos]
    static let `default` = vitality
    static func theme(for id: String) -> Theme { all.first { $0.id == id } ?? `default` }
}
