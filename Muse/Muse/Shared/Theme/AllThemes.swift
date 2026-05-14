import SwiftUI

enum Themes {
    static let canvas = Theme(
        id: "canvas", name: "Canvas",
        colors: ThemeColors(
            background: "#FFFDF7", surface: "#FFFFFF", primary: "#D4764E", secondary: "#F2A884",
            accent: "#D4764E", text: "#3D2415", textSecondary: "#9C6B4A", textMuted: "#C9B09A",
            textOnPrimary: "#FFFFFF", cardBorder: "#D4764E", cardBackground: "#FFFFFF",
            cardHighlight: "#FFF0E5", cardSelected: "#F2A884", success: "#4CAF50",
            warning: "#FF9800", error: "#D32F2F"
        ),
        isDark: false,
        gradientColors: [Color(hex: "#FFFDF7"), Color(hex: "#FFF0E5"), Color(hex: "#FFE5D5")],
        iconName: "paintbrush.fill"
    )

    static let ink = Theme(
        id: "ink", name: "Ink",
        colors: ThemeColors(
            background: "#F5F3F0", surface: "#FFFFFF", primary: "#4A4A4A", secondary: "#7A7A7A",
            accent: "#4A4A4A", text: "#1A1A1A", textSecondary: "#5A5A5A", textMuted: "#A0A0A0",
            textOnPrimary: "#FFFFFF", cardBorder: "#4A4A4A", cardBackground: "#FFFFFF",
            cardHighlight: "#EAEAE8", cardSelected: "#7A7A7A", success: "#4CAF50",
            warning: "#FF9800", error: "#D32F2F"
        ),
        isDark: false,
        gradientColors: [Color(hex: "#F5F3F0"), Color(hex: "#ECEAE6"), Color(hex: "#E3E0DC")],
        iconName: "pencil.tip"
    )

    static let bloom = Theme(
        id: "bloom", name: "Bloom",
        colors: ThemeColors(
            background: "#FFF5F8", surface: "#FFFFFF", primary: "#E06B8A", secondary: "#F4A0B5",
            accent: "#E06B8A", text: "#3D1520", textSecondary: "#A04060", textMuted: "#D0A0B0",
            textOnPrimary: "#FFFFFF", cardBorder: "#E06B8A", cardBackground: "#FFFFFF",
            cardHighlight: "#FFE8EF", cardSelected: "#F4A0B5", success: "#4CAF50",
            warning: "#FF9800", error: "#D32F2F"
        ),
        isDark: false,
        gradientColors: [Color(hex: "#FFF5F8"), Color(hex: "#FFE8EF"), Color(hex: "#FFDCE6")],
        iconName: "camera.macro"
    )

    static let ocean = Theme(
        id: "ocean", name: "Ocean",
        colors: ThemeColors(
            background: "#F0F6FA", surface: "#FFFFFF", primary: "#3D7EB5", secondary: "#6BA8D4",
            accent: "#3D7EB5", text: "#152535", textSecondary: "#3D6A90", textMuted: "#90B5CC",
            textOnPrimary: "#FFFFFF", cardBorder: "#3D7EB5", cardBackground: "#FFFFFF",
            cardHighlight: "#E0EEF8", cardSelected: "#6BA8D4", success: "#4CAF50",
            warning: "#FF9800", error: "#D32F2F"
        ),
        isDark: false,
        gradientColors: [Color(hex: "#F0F6FA"), Color(hex: "#E0EEF8"), Color(hex: "#D0E6F5")],
        iconName: "water.waves"
    )

    static let honey = Theme(
        id: "honey", name: "Honey",
        colors: ThemeColors(
            background: "#FFFCF0", surface: "#FFFFFF", primary: "#CC8C1A", secondary: "#E8B84D",
            accent: "#CC8C1A", text: "#332200", textSecondary: "#8C6010", textMuted: "#CCB880",
            textOnPrimary: "#FFFFFF", cardBorder: "#CC8C1A", cardBackground: "#FFFFFF",
            cardHighlight: "#FFF5D6", cardSelected: "#E8B84D", success: "#4CAF50",
            warning: "#FF9800", error: "#D32F2F"
        ),
        isDark: false,
        gradientColors: [Color(hex: "#FFFCF0"), Color(hex: "#FFF5D6"), Color(hex: "#FFEEBB")],
        iconName: "sun.max.fill"
    )

    static let sage = Theme(
        id: "sage", name: "Sage",
        colors: ThemeColors(
            background: "#F2F6F2", surface: "#FFFFFF", primary: "#5A8C5A", secondary: "#88B888",
            accent: "#5A8C5A", text: "#1A331A", textSecondary: "#4A7A4A", textMuted: "#A0C0A0",
            textOnPrimary: "#FFFFFF", cardBorder: "#5A8C5A", cardBackground: "#FFFFFF",
            cardHighlight: "#E5F0E5", cardSelected: "#88B888", success: "#4CAF50",
            warning: "#FF9800", error: "#D32F2F"
        ),
        isDark: false,
        gradientColors: [Color(hex: "#F2F6F2"), Color(hex: "#E5F0E5"), Color(hex: "#D8EAD8")],
        iconName: "leaf.fill"
    )

    static let violet = Theme(
        id: "violet", name: "Violet",
        colors: ThemeColors(
            background: "#F5F0FA", surface: "#FFFFFF", primary: "#7B52AB", secondary: "#A880CC",
            accent: "#7B52AB", text: "#20103A", textSecondary: "#6A4A90", textMuted: "#B8A0CC",
            textOnPrimary: "#FFFFFF", cardBorder: "#7B52AB", cardBackground: "#FFFFFF",
            cardHighlight: "#ECE0F5", cardSelected: "#A880CC", success: "#4CAF50",
            warning: "#FF9800", error: "#D32F2F"
        ),
        isDark: false,
        gradientColors: [Color(hex: "#F5F0FA"), Color(hex: "#ECE0F5"), Color(hex: "#E2D0F0")],
        iconName: "sparkles"
    )

    static let darkroom = Theme(
        id: "darkroom", name: "Darkroom",
        colors: ThemeColors(
            background: "#1A1A22", surface: "#24242E", primary: "#E88C5A", secondary: "#CC6A3A",
            accent: "#E88C5A", text: "#E8E4E0", textSecondary: "#A09890", textMuted: "#555058",
            textOnPrimary: "#1A1A22", cardBorder: "#3A3A45", cardBackground: "#24242E",
            cardHighlight: "#2E2E38", cardSelected: "#E88C5A", success: "#66BB6A",
            warning: "#FFA726", error: "#EF5350"
        ),
        isDark: true,
        gradientColors: [Color(hex: "#1A1A22"), Color(hex: "#24242E"), Color(hex: "#2E2E38")],
        iconName: "moon.fill"
    )

    static let neon = Theme(
        id: "neon", name: "Neon",
        colors: ThemeColors(
            background: "#0D0D1A", surface: "#15152A", primary: "#FF4DFF", secondary: "#00E5FF",
            accent: "#FF4DFF", text: "#F0E8FF", textSecondary: "#9988CC", textMuted: "#443866",
            textOnPrimary: "#0D0D1A", cardBorder: "#332266", cardBackground: "#15152A",
            cardHighlight: "#1F1F3A", cardSelected: "#FF4DFF", success: "#00E676",
            warning: "#FFD740", error: "#FF5252"
        ),
        isDark: true,
        gradientColors: [Color(hex: "#0D0D1A"), Color(hex: "#15152A"), Color(hex: "#1F1F3A")],
        iconName: "lightbulb.fill"
    )

    static let void = Theme(
        id: "void", name: "Void",
        colors: ThemeColors(
            background: "#000000", surface: "#0A0A0A", primary: "#FFFFFF", secondary: "#888888",
            accent: "#FFFFFF", text: "#F0F0F0", textSecondary: "#999999", textMuted: "#444444",
            textOnPrimary: "#000000", cardBorder: "#222222", cardBackground: "#0A0A0A",
            cardHighlight: "#151515", cardSelected: "#FFFFFF", success: "#00E676",
            warning: "#FFD740", error: "#FF5252"
        ),
        isDark: true,
        gradientColors: [Color(hex: "#000000"), Color(hex: "#0A0A0A"), Color(hex: "#151515")],
        iconName: "circle.fill"
    )

    static let all: [Theme] = [canvas, ink, bloom, ocean, honey, sage, violet, darkroom, neon, void]
    static let lightThemes: [Theme] = [canvas, ink, bloom, ocean, honey, sage, violet]
    static let darkThemes: [Theme] = [darkroom, neon, void]
    static let `default` = canvas

    static func theme(for id: String) -> Theme {
        all.first { $0.id == id } ?? `default`
    }
}
