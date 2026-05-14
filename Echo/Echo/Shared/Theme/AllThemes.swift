import SwiftUI

enum Themes {
    static let neonGrid = Theme(
        id: "neongrid", name: "Neon Grid",
        colors: ThemeColors(
            background: "#0A0A1A", surface: "#14142A", primary: "#FF007F", secondary: "#00D4FF",
            accent: "#FF007F", text: "#F0E8FF", textSecondary: "#9080C0", textMuted: "#3D3060",
            textOnPrimary: "#FFFFFF", cardBorder: "#4A2060", cardBackground: "#14142A",
            cardHighlight: "#1E1838", cardSelected: "#FF007F", success: "#00E676",
            warning: "#FFD740", error: "#FF5252"
        ),
        isDark: true,
        gradientColors: [Color(hex: "#0A0A1A"), Color(hex: "#100F22"), Color(hex: "#14142A")],
        iconName: "grid"
    )

    static let vinyl = Theme(
        id: "vinyl", name: "Vinyl",
        colors: ThemeColors(
            background: "#1A1410", surface: "#241E18", primary: "#E8A04C", secondary: "#C47830",
            accent: "#E8A04C", text: "#F0E8D8", textSecondary: "#A89070", textMuted: "#5A4830",
            textOnPrimary: "#1A1410", cardBorder: "#6A5030", cardBackground: "#241E18",
            cardHighlight: "#2E2620", cardSelected: "#E8A04C", success: "#66BB6A",
            warning: "#FFA726", error: "#EF5350"
        ),
        isDark: true,
        gradientColors: [Color(hex: "#1A1410"), Color(hex: "#201A14"), Color(hex: "#241E18")],
        iconName: "opticaldisc.fill"
    )

    static let crystalClear = Theme(
        id: "crystalclear", name: "Crystal Clear",
        colors: ThemeColors(
            background: "#F0F8FF", surface: "#FFFFFF", primary: "#0088CC", secondary: "#44BBEE",
            accent: "#0088CC", text: "#0D2137", textSecondary: "#3D6E8C", textMuted: "#99BDD4",
            textOnPrimary: "#FFFFFF", cardBorder: "#0088CC", cardBackground: "#FFFFFF",
            cardHighlight: "#E0F2FF", cardSelected: "#44BBEE", success: "#4CAF50",
            warning: "#FF9800", error: "#D32F2F"
        ),
        isDark: false,
        gradientColors: [Color(hex: "#F0F8FF"), Color(hex: "#E0F2FF"), Color(hex: "#D0ECFF")],
        iconName: "diamond.fill"
    )

    static let synthwave = Theme(
        id: "synthwave", name: "Synthwave",
        colors: ThemeColors(
            background: "#1A0A2E", surface: "#240E3E", primary: "#FF6EC7", secondary: "#7B68EE",
            accent: "#FF6EC7", text: "#F0E0FF", textSecondary: "#A080D0", textMuted: "#503880",
            textOnPrimary: "#1A0A2E", cardBorder: "#6A3090", cardBackground: "#240E3E",
            cardHighlight: "#2E1648", cardSelected: "#FF6EC7", success: "#00E676",
            warning: "#FFD740", error: "#FF5252"
        ),
        isDark: true,
        gradientColors: [Color(hex: "#1A0A2E"), Color(hex: "#200C38"), Color(hex: "#240E3E")],
        iconName: "waveform.path"
    )

    static let acoustic = Theme(
        id: "acoustic", name: "Acoustic",
        colors: ThemeColors(
            background: "#FFF8F0", surface: "#FFFFFF", primary: "#8B6914", secondary: "#C4A35A",
            accent: "#8B6914", text: "#33280A", textSecondary: "#7A6030", textMuted: "#C4B08A",
            textOnPrimary: "#FFFFFF", cardBorder: "#8B6914", cardBackground: "#FFFFFF",
            cardHighlight: "#FFF2E0", cardSelected: "#C4A35A", success: "#4CAF50",
            warning: "#FF9800", error: "#D32F2F"
        ),
        isDark: false,
        gradientColors: [Color(hex: "#FFF8F0"), Color(hex: "#FFF2E0"), Color(hex: "#FFECD0")],
        iconName: "guitars.fill"
    )

    static let electric = Theme(
        id: "electric", name: "Electric",
        colors: ThemeColors(
            background: "#0A0A0A", surface: "#1A1A1A", primary: "#FFD600", secondary: "#FFC107",
            accent: "#FFD600", text: "#F0F0E0", textSecondary: "#A0A070", textMuted: "#4A4A30",
            textOnPrimary: "#0A0A0A", cardBorder: "#6A6A20", cardBackground: "#1A1A1A",
            cardHighlight: "#222218", cardSelected: "#FFD600", success: "#00E676",
            warning: "#FFA726", error: "#FF5252"
        ),
        isDark: true,
        gradientColors: [Color(hex: "#0A0A0A"), Color(hex: "#121210"), Color(hex: "#1A1A1A")],
        iconName: "bolt.fill"
    )

    static let oceanDepth = Theme(
        id: "oceandepth", name: "Ocean Depth",
        colors: ThemeColors(
            background: "#F0F6F6", surface: "#FFFFFF", primary: "#00796B", secondary: "#4DB6AC",
            accent: "#00796B", text: "#1A3333", textSecondary: "#3D6666", textMuted: "#99B3B3",
            textOnPrimary: "#FFFFFF", cardBorder: "#00796B", cardBackground: "#FFFFFF",
            cardHighlight: "#E0F2F1", cardSelected: "#4DB6AC", success: "#4CAF50",
            warning: "#FF9800", error: "#D32F2F"
        ),
        isDark: false,
        gradientColors: [Color(hex: "#F0F6F6"), Color(hex: "#E0F2F1"), Color(hex: "#D0ECE9")],
        iconName: "water.waves"
    )

    static let sunset = Theme(
        id: "sunset", name: "Sunset",
        colors: ThemeColors(
            background: "#FFF5F0", surface: "#FFFFFF", primary: "#E64A19", secondary: "#FF8A65",
            accent: "#E64A19", text: "#3D1A0A", textSecondary: "#B05530", textMuted: "#D4A088",
            textOnPrimary: "#FFFFFF", cardBorder: "#E64A19", cardBackground: "#FFFFFF",
            cardHighlight: "#FFEBE0", cardSelected: "#FF8A65", success: "#4CAF50",
            warning: "#FF9800", error: "#D32F2F"
        ),
        isDark: false,
        gradientColors: [Color(hex: "#FFF5F0"), Color(hex: "#FFEBE0"), Color(hex: "#FFE0D0")],
        iconName: "sun.horizon.fill"
    )

    static let midnight = Theme(
        id: "midnight", name: "Midnight",
        colors: ThemeColors(
            background: "#0A0A20", surface: "#14143A", primary: "#536DFE", secondary: "#8C9EFF",
            accent: "#536DFE", text: "#D8DCFF", textSecondary: "#7880C0", textMuted: "#3A3D70",
            textOnPrimary: "#FFFFFF", cardBorder: "#3A3D7A", cardBackground: "#14143A",
            cardHighlight: "#1C1C48", cardSelected: "#536DFE", success: "#66BB6A",
            warning: "#FFA726", error: "#EF5350"
        ),
        isDark: true,
        gradientColors: [Color(hex: "#0A0A20"), Color(hex: "#10102D"), Color(hex: "#14143A")],
        iconName: "moon.stars.fill"
    )

    static let aurora = Theme(
        id: "aurora", name: "Aurora",
        colors: ThemeColors(
            background: "#F2FFF5", surface: "#FFFFFF", primary: "#00C853", secondary: "#69F0AE",
            accent: "#00C853", text: "#0D331A", textSecondary: "#3D8050", textMuted: "#99C4A8",
            textOnPrimary: "#FFFFFF", cardBorder: "#00C853", cardBackground: "#FFFFFF",
            cardHighlight: "#E0FFE8", cardSelected: "#69F0AE", success: "#4CAF50",
            warning: "#FF9800", error: "#D32F2F"
        ),
        isDark: false,
        gradientColors: [Color(hex: "#F2FFF5"), Color(hex: "#E0FFE8"), Color(hex: "#D0FFE0")],
        iconName: "sparkles"
    )

    static let all: [Theme] = [neonGrid, vinyl, crystalClear, synthwave, acoustic, electric, oceanDepth, sunset, midnight, aurora]
    static let lightThemes: [Theme] = [crystalClear, acoustic, oceanDepth, sunset, aurora]
    static let darkThemes: [Theme] = [neonGrid, vinyl, synthwave, electric, midnight]
    static let `default` = neonGrid

    static func theme(for id: String) -> Theme {
        all.first { $0.id == id } ?? `default`
    }
}
