import SwiftUI

enum Themes {
    static let deepOcean = Theme(
        id: "deepocean", name: "Deep Ocean",
        colors: ThemeColors(
            background: "#0A1628", surface: "#132038", primary: "#1E90FF", secondary: "#4FC3F7",
            accent: "#1E90FF", text: "#E0ECF8", textSecondary: "#7EB0D8", textMuted: "#3D5A80",
            textOnPrimary: "#FFFFFF", cardBorder: "#1E4D7A", cardBackground: "#132038",
            cardHighlight: "#1A2D4D", cardSelected: "#1E90FF", success: "#00E676",
            warning: "#FFD740", error: "#FF5252"
        ),
        isDark: true,
        gradientColors: [Color(hex: "#0A1628"), Color(hex: "#0D1E35"), Color(hex: "#132038")],
        iconName: "water.waves"
    )

    static let tidePool = Theme(
        id: "tidepool", name: "Tide Pool",
        colors: ThemeColors(
            background: "#F0FAFA", surface: "#FFFFFF", primary: "#00ACC1", secondary: "#4DD0E1",
            accent: "#00ACC1", text: "#1A3A3D", textSecondary: "#3D7A80", textMuted: "#99C4C9",
            textOnPrimary: "#FFFFFF", cardBorder: "#00ACC1", cardBackground: "#FFFFFF",
            cardHighlight: "#E0F7FA", cardSelected: "#4DD0E1", success: "#4CAF50",
            warning: "#FF9800", error: "#D32F2F"
        ),
        isDark: false,
        gradientColors: [Color(hex: "#F0FAFA"), Color(hex: "#E0F7FA"), Color(hex: "#D0F2F5")],
        iconName: "drop.fill"
    )

    static let moonlight = Theme(
        id: "moonlight", name: "Moonlight",
        colors: ThemeColors(
            background: "#F2F4FA", surface: "#FFFFFF", primary: "#5C6BC0", secondary: "#9FA8DA",
            accent: "#5C6BC0", text: "#1A1F33", textSecondary: "#5C6380", textMuted: "#A0A8C0",
            textOnPrimary: "#FFFFFF", cardBorder: "#5C6BC0", cardBackground: "#FFFFFF",
            cardHighlight: "#E8EAF6", cardSelected: "#9FA8DA", success: "#4CAF50",
            warning: "#FF9800", error: "#D32F2F"
        ),
        isDark: false,
        gradientColors: [Color(hex: "#F2F4FA"), Color(hex: "#E8EAF6"), Color(hex: "#DDE0F2")],
        iconName: "moon.fill"
    )

    static let coralReef = Theme(
        id: "coralreef", name: "Coral Reef",
        colors: ThemeColors(
            background: "#FFF3F0", surface: "#FFFFFF", primary: "#FF7043", secondary: "#FFAB91",
            accent: "#FF7043", text: "#3D1F14", textSecondary: "#B05540", textMuted: "#D4A898",
            textOnPrimary: "#FFFFFF", cardBorder: "#FF7043", cardBackground: "#FFFFFF",
            cardHighlight: "#FFE8E0", cardSelected: "#FFAB91", success: "#4CAF50",
            warning: "#FF9800", error: "#D32F2F"
        ),
        isDark: false,
        gradientColors: [Color(hex: "#FFF3F0"), Color(hex: "#FFE8E0"), Color(hex: "#FFDDD0")],
        iconName: "sparkles"
    )

    static let arctic = Theme(
        id: "arctic", name: "Arctic",
        colors: ThemeColors(
            background: "#F0F8FF", surface: "#FFFFFF", primary: "#0288D1", secondary: "#4FC3F7",
            accent: "#0288D1", text: "#0D2137", textSecondary: "#3D6E8C", textMuted: "#99BDD4",
            textOnPrimary: "#FFFFFF", cardBorder: "#0288D1", cardBackground: "#FFFFFF",
            cardHighlight: "#E1F5FE", cardSelected: "#4FC3F7", success: "#4CAF50",
            warning: "#FF9800", error: "#D32F2F"
        ),
        isDark: false,
        gradientColors: [Color(hex: "#F0F8FF"), Color(hex: "#E1F5FE"), Color(hex: "#D0ECFF")],
        iconName: "snowflake"
    )

    static let sunsetShore = Theme(
        id: "sunsetshore", name: "Sunset Shore",
        colors: ThemeColors(
            background: "#FFF8F0", surface: "#FFFFFF", primary: "#F57C00", secondary: "#FFB74D",
            accent: "#F57C00", text: "#33240A", textSecondary: "#8C6E30", textMuted: "#C9B87A",
            textOnPrimary: "#FFFFFF", cardBorder: "#F57C00", cardBackground: "#FFFFFF",
            cardHighlight: "#FFF3E0", cardSelected: "#FFB74D", success: "#4CAF50",
            warning: "#FF9800", error: "#D32F2F"
        ),
        isDark: false,
        gradientColors: [Color(hex: "#FFF8F0"), Color(hex: "#FFF3E0"), Color(hex: "#FFE8CC")],
        iconName: "sun.horizon.fill"
    )

    static let bioluminescent = Theme(
        id: "bioluminescent", name: "Bioluminescent",
        colors: ThemeColors(
            background: "#050D14", surface: "#0A1A24", primary: "#00E5A0", secondary: "#00BCD4",
            accent: "#00E5A0", text: "#D0F0E8", textSecondary: "#5ABFA0", textMuted: "#2A5548",
            textOnPrimary: "#050D14", cardBorder: "#00604A", cardBackground: "#0A1A24",
            cardHighlight: "#0D2A32", cardSelected: "#00E5A0", success: "#00E676",
            warning: "#FFD740", error: "#FF5252"
        ),
        isDark: true,
        gradientColors: [Color(hex: "#050D14"), Color(hex: "#081820"), Color(hex: "#0A1A24")],
        iconName: "bubbles.and.sparkles.fill"
    )

    static let storm = Theme(
        id: "storm", name: "Storm",
        colors: ThemeColors(
            background: "#1A1525", surface: "#241E33", primary: "#9C27B0", secondary: "#CE93D8",
            accent: "#9C27B0", text: "#E0D8F0", textSecondary: "#8870A8", textMuted: "#4A3D60",
            textOnPrimary: "#FFFFFF", cardBorder: "#5A3D7A", cardBackground: "#241E33",
            cardHighlight: "#2E2542", cardSelected: "#9C27B0", success: "#66BB6A",
            warning: "#FFA726", error: "#EF5350"
        ),
        isDark: true,
        gradientColors: [Color(hex: "#1A1525"), Color(hex: "#201830"), Color(hex: "#241E33")],
        iconName: "cloud.bolt.fill"
    )

    static let abyss = Theme(
        id: "abyss", name: "Abyss",
        colors: ThemeColors(
            background: "#000008", surface: "#0A0A1A", primary: "#304FFE", secondary: "#536DFE",
            accent: "#304FFE", text: "#D0D4F0", textSecondary: "#6870A8", textMuted: "#2D3060",
            textOnPrimary: "#FFFFFF", cardBorder: "#1A1D4A", cardBackground: "#0A0A1A",
            cardHighlight: "#12142A", cardSelected: "#304FFE", success: "#00E676",
            warning: "#FFD740", error: "#FF5252"
        ),
        isDark: true,
        gradientColors: [Color(hex: "#000008"), Color(hex: "#050510"), Color(hex: "#0A0A1A")],
        iconName: "circle.fill"
    )

    static let crystal = Theme(
        id: "crystal", name: "Crystal",
        colors: ThemeColors(
            background: "#F8F5FF", surface: "#FFFFFF", primary: "#7C4DFF", secondary: "#B388FF",
            accent: "#7C4DFF", text: "#1A0F33", textSecondary: "#6A50A0", textMuted: "#B0A0D0",
            textOnPrimary: "#FFFFFF", cardBorder: "#7C4DFF", cardBackground: "#FFFFFF",
            cardHighlight: "#EDE7F6", cardSelected: "#B388FF", success: "#4CAF50",
            warning: "#FF9800", error: "#D32F2F"
        ),
        isDark: false,
        gradientColors: [Color(hex: "#F8F5FF"), Color(hex: "#EDE7F6"), Color(hex: "#E3DAF0")],
        iconName: "diamond.fill"
    )

    static let all: [Theme] = [deepOcean, tidePool, moonlight, coralReef, arctic, sunsetShore, bioluminescent, storm, abyss, crystal]
    static let lightThemes: [Theme] = [tidePool, moonlight, coralReef, arctic, sunsetShore, crystal]
    static let darkThemes: [Theme] = [deepOcean, bioluminescent, storm, abyss]
    static let `default` = deepOcean

    static func theme(for id: String) -> Theme {
        all.first { $0.id == id } ?? `default`
    }
}
