import SwiftUI

enum Themes {
    static let blueprint = Theme(
        id: "blueprint", name: "Blueprint",
        colors: ThemeColors(
            background: "#0A1628", surface: "#122040", primary: "#4FC3F7", secondary: "#29B6F6",
            accent: "#4FC3F7", text: "#E0F0FF", textSecondary: "#7AADD0", textMuted: "#2D4A6A",
            textOnPrimary: "#0A1628", cardBorder: "#2D5A8A", cardBackground: "#122040",
            cardHighlight: "#1A2D50", cardSelected: "#4FC3F7", success: "#00E676",
            warning: "#FFD740", error: "#FF5252"
        ),
        isDark: true,
        gradientColors: [Color(hex: "#0A1628"), Color(hex: "#0E1C35"), Color(hex: "#122040")],
        iconName: "ruler.fill"
    )

    static let compass = Theme(
        id: "compass", name: "Compass",
        colors: ThemeColors(
            background: "#1A1410", surface: "#241E18", primary: "#C47830", secondary: "#E8A04C",
            accent: "#C47830", text: "#F0E8D8", textSecondary: "#A89070", textMuted: "#5A4830",
            textOnPrimary: "#1A1410", cardBorder: "#6A5030", cardBackground: "#241E18",
            cardHighlight: "#2E2620", cardSelected: "#C47830", success: "#66BB6A",
            warning: "#FFA726", error: "#EF5350"
        ),
        isDark: true,
        gradientColors: [Color(hex: "#1A1410"), Color(hex: "#201A14"), Color(hex: "#241E18")],
        iconName: "safari.fill"
    )

    static let graphPaper = Theme(
        id: "graphpaper", name: "Graph Paper",
        colors: ThemeColors(
            background: "#F5F5F0", surface: "#FFFFFF", primary: "#2196F3", secondary: "#64B5F6",
            accent: "#2196F3", text: "#1A2A3A", textSecondary: "#4A6A8A", textMuted: "#A0B8D0",
            textOnPrimary: "#FFFFFF", cardBorder: "#2196F3", cardBackground: "#FFFFFF",
            cardHighlight: "#E3F2FD", cardSelected: "#64B5F6", success: "#4CAF50",
            warning: "#FF9800", error: "#D32F2F"
        ),
        isDark: false,
        gradientColors: [Color(hex: "#F5F5F0"), Color(hex: "#EEF0EB"), Color(hex: "#E8EBE5")],
        iconName: "grid"
    )

    static let neonGeometry = Theme(
        id: "neongeometry", name: "Neon Geometry",
        colors: ThemeColors(
            background: "#0A0A1A", surface: "#14142A", primary: "#00FF88", secondary: "#00CC6A",
            accent: "#00FF88", text: "#E0FFE8", textSecondary: "#70C080", textMuted: "#2A5A3A",
            textOnPrimary: "#0A0A1A", cardBorder: "#2A6A3A", cardBackground: "#14142A",
            cardHighlight: "#1A1E2A", cardSelected: "#00FF88", success: "#00E676",
            warning: "#FFD740", error: "#FF5252"
        ),
        isDark: true,
        gradientColors: [Color(hex: "#0A0A1A"), Color(hex: "#0D0D22"), Color(hex: "#14142A")],
        iconName: "triangle"
    )

    static let marble = Theme(
        id: "marble", name: "Marble",
        colors: ThemeColors(
            background: "#F8F6F2", surface: "#FFFFFF", primary: "#607D8B", secondary: "#90A4AE",
            accent: "#607D8B", text: "#263238", textSecondary: "#546E7A", textMuted: "#B0BEC5",
            textOnPrimary: "#FFFFFF", cardBorder: "#607D8B", cardBackground: "#FFFFFF",
            cardHighlight: "#ECEFF1", cardSelected: "#90A4AE", success: "#4CAF50",
            warning: "#FF9800", error: "#D32F2F"
        ),
        isDark: false,
        gradientColors: [Color(hex: "#F8F6F2"), Color(hex: "#F0EDE8"), Color(hex: "#E8E4DE")],
        iconName: "circle.hexagongrid.fill"
    )

    static let blackboard = Theme(
        id: "blackboard", name: "Blackboard",
        colors: ThemeColors(
            background: "#1B2A1B", surface: "#233023", primary: "#E8E8D0", secondary: "#C0C0A0",
            accent: "#E8E8D0", text: "#F0F0E0", textSecondary: "#A0A080", textMuted: "#4A5A3A",
            textOnPrimary: "#1B2A1B", cardBorder: "#5A6A4A", cardBackground: "#233023",
            cardHighlight: "#2A382A", cardSelected: "#E8E8D0", success: "#66BB6A",
            warning: "#FFA726", error: "#EF5350"
        ),
        isDark: true,
        gradientColors: [Color(hex: "#1B2A1B"), Color(hex: "#1E2D1E"), Color(hex: "#233023")],
        iconName: "pencil.and.ruler.fill"
    )

    static let origami = Theme(
        id: "origami", name: "Origami",
        colors: ThemeColors(
            background: "#FFF8F5", surface: "#FFFFFF", primary: "#E91E63", secondary: "#F06292",
            accent: "#E91E63", text: "#33121A", textSecondary: "#B04060", textMuted: "#D4A0B0",
            textOnPrimary: "#FFFFFF", cardBorder: "#E91E63", cardBackground: "#FFFFFF",
            cardHighlight: "#FCE4EC", cardSelected: "#F06292", success: "#4CAF50",
            warning: "#FF9800", error: "#D32F2F"
        ),
        isDark: false,
        gradientColors: [Color(hex: "#FFF8F5"), Color(hex: "#FFF0EB"), Color(hex: "#FFE8E0")],
        iconName: "bird.fill"
    )

    static let laser = Theme(
        id: "laser", name: "Laser",
        colors: ThemeColors(
            background: "#0A0A0A", surface: "#1A1A1A", primary: "#FF1744", secondary: "#FF616F",
            accent: "#FF1744", text: "#FFE0E0", textSecondary: "#C07070", textMuted: "#5A2020",
            textOnPrimary: "#0A0A0A", cardBorder: "#8A2020", cardBackground: "#1A1A1A",
            cardHighlight: "#221218", cardSelected: "#FF1744", success: "#00E676",
            warning: "#FFD740", error: "#FF5252"
        ),
        isDark: true,
        gradientColors: [Color(hex: "#0A0A0A"), Color(hex: "#100A0A"), Color(hex: "#1A1A1A")],
        iconName: "line.diagonal"
    )

    static let crystal = Theme(
        id: "crystal", name: "Crystal",
        colors: ThemeColors(
            background: "#F0F8FF", surface: "#FFFFFF", primary: "#7C4DFF", secondary: "#B388FF",
            accent: "#7C4DFF", text: "#1A1040", textSecondary: "#5A4890", textMuted: "#A098C8",
            textOnPrimary: "#FFFFFF", cardBorder: "#7C4DFF", cardBackground: "#FFFFFF",
            cardHighlight: "#EDE7F6", cardSelected: "#B388FF", success: "#4CAF50",
            warning: "#FF9800", error: "#D32F2F"
        ),
        isDark: false,
        gradientColors: [Color(hex: "#F0F8FF"), Color(hex: "#EDE7F6"), Color(hex: "#E8DEF8")],
        iconName: "diamond.fill"
    )

    static let void = Theme(
        id: "void", name: "Void",
        colors: ThemeColors(
            background: "#050510", surface: "#0A0A20", primary: "#6C63FF", secondary: "#8B83FF",
            accent: "#6C63FF", text: "#D0D0FF", textSecondary: "#7070B0", textMuted: "#2A2A60",
            textOnPrimary: "#050510", cardBorder: "#3A3A7A", cardBackground: "#0A0A20",
            cardHighlight: "#10103A", cardSelected: "#6C63FF", success: "#66BB6A",
            warning: "#FFA726", error: "#EF5350"
        ),
        isDark: true,
        gradientColors: [Color(hex: "#050510"), Color(hex: "#080818"), Color(hex: "#0A0A20")],
        iconName: "circle.dashed"
    )

    static let all: [Theme] = [blueprint, compass, graphPaper, neonGeometry, marble, blackboard, origami, laser, crystal, void]
    static let lightThemes: [Theme] = [graphPaper, marble, origami, crystal]
    static let darkThemes: [Theme] = [blueprint, compass, neonGeometry, blackboard, laser, void]
    static let `default` = blueprint

    static func theme(for id: String) -> Theme {
        all.first { $0.id == id } ?? `default`
    }
}
