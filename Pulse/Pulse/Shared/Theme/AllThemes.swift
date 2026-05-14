import SwiftUI

enum Themes {
    static let pulse = Theme(
        id: "pulse", name: "Pulse",
        colors: ThemeColors(
            background: "#1A0A2E", surface: "#231445", primary: "#FF6B6B", secondary: "#FF4081",
            accent: "#FF6B6B", text: "#F0E6FF", textSecondary: "#B08CDB", textMuted: "#5A3F7D",
            textOnPrimary: "#FFFFFF", cardBorder: "#3A2260", cardBackground: "#231445",
            cardHighlight: "#2D1A55", cardSelected: "#FF6B6B", success: "#69F0AE",
            warning: "#FFD740", error: "#FF5252"
        ),
        isDark: true,
        gradientColors: [Color(hex: "#1A0A2E"), Color(hex: "#231445"), Color(hex: "#2D1A55")],
        iconName: "waveform.path.ecg"
    )

    static let neon = Theme(
        id: "neon", name: "Neon",
        colors: ThemeColors(
            background: "#0A0A1A", surface: "#14142A", primary: "#00E5FF", secondary: "#FF4DFF",
            accent: "#00E5FF", text: "#E8F0FF", textSecondary: "#7DA8CC", textMuted: "#3A4466",
            textOnPrimary: "#0A0A1A", cardBorder: "#1A1A3A", cardBackground: "#14142A",
            cardHighlight: "#1E1E40", cardSelected: "#00E5FF", success: "#00E676",
            warning: "#FFD740", error: "#FF5252"
        ),
        isDark: true,
        gradientColors: [Color(hex: "#0A0A1A"), Color(hex: "#14142A"), Color(hex: "#1E1E40")],
        iconName: "lightbulb.fill"
    )

    static let vinyl = Theme(
        id: "vinyl", name: "Vinyl",
        colors: ThemeColors(
            background: "#F5F0E6", surface: "#FDFBF5", primary: "#6B4226", secondary: "#9C6B44",
            accent: "#C84B31", text: "#2E1F0F", textSecondary: "#6B4226", textMuted: "#BCA88E",
            textOnPrimary: "#FFFFFF", cardBorder: "#6B4226", cardBackground: "#FDFBF5",
            cardHighlight: "#EBE2D2", cardSelected: "#9C6B44", success: "#4CAF50",
            warning: "#FF9800", error: "#D32F2F"
        ),
        isDark: false,
        gradientColors: [Color(hex: "#F5F0E6"), Color(hex: "#EBE2D2"), Color(hex: "#E0D5C0")],
        iconName: "opticaldisc.fill"
    )

    static let jazz = Theme(
        id: "jazz", name: "Jazz",
        colors: ThemeColors(
            background: "#0F1520", surface: "#182030", primary: "#C9A355", secondary: "#8C7330",
            accent: "#C9A355", text: "#E8E0D0", textSecondary: "#A09080", textMuted: "#4A4030",
            textOnPrimary: "#0F1520", cardBorder: "#2A2A40", cardBackground: "#182030",
            cardHighlight: "#222838", cardSelected: "#C9A355", success: "#66BB6A",
            warning: "#FFA726", error: "#EF5350"
        ),
        isDark: true,
        gradientColors: [Color(hex: "#0F1520"), Color(hex: "#182030"), Color(hex: "#222838")],
        iconName: "music.quarternote.3"
    )

    static let techno = Theme(
        id: "techno", name: "Techno",
        colors: ThemeColors(
            background: "#0D0D0D", surface: "#1A1A1A", primary: "#39FF14", secondary: "#00CC00",
            accent: "#39FF14", text: "#E0FFE0", textSecondary: "#66CC66", textMuted: "#335533",
            textOnPrimary: "#0D0D0D", cardBorder: "#1A331A", cardBackground: "#1A1A1A",
            cardHighlight: "#222222", cardSelected: "#39FF14", success: "#39FF14",
            warning: "#FFD740", error: "#FF5252"
        ),
        isDark: true,
        gradientColors: [Color(hex: "#0D0D0D"), Color(hex: "#1A1A1A"), Color(hex: "#222222")],
        iconName: "waveform"
    )

    static let acoustic = Theme(
        id: "acoustic", name: "Acoustic",
        colors: ThemeColors(
            background: "#FFF8F0", surface: "#FFFFFF", primary: "#CC7744", secondary: "#E6A070",
            accent: "#CC7744", text: "#3D2010", textSecondary: "#8C6040", textMuted: "#CCA888",
            textOnPrimary: "#FFFFFF", cardBorder: "#CC7744", cardBackground: "#FFFFFF",
            cardHighlight: "#FFF0E0", cardSelected: "#E6A070", success: "#4CAF50",
            warning: "#FF9800", error: "#D32F2F"
        ),
        isDark: false,
        gradientColors: [Color(hex: "#FFF8F0"), Color(hex: "#FFF0E0"), Color(hex: "#FFE8D0")],
        iconName: "guitars.fill"
    )

    static let synthwave = Theme(
        id: "synthwave", name: "Synthwave",
        colors: ThemeColors(
            background: "#1A0533", surface: "#260845", primary: "#FF71CE", secondary: "#B967FF",
            accent: "#FF71CE", text: "#FFE5F8", textSecondary: "#CC88BB", textMuted: "#553366",
            textOnPrimary: "#1A0533", cardBorder: "#3D1A5C", cardBackground: "#260845",
            cardHighlight: "#301055", cardSelected: "#FF71CE", success: "#01CDFE",
            warning: "#FFD740", error: "#FF5252"
        ),
        isDark: true,
        gradientColors: [Color(hex: "#1A0533"), Color(hex: "#260845"), Color(hex: "#301055")],
        iconName: "sun.haze.fill"
    )

    static let funk = Theme(
        id: "funk", name: "Funk",
        colors: ThemeColors(
            background: "#FFF5E6", surface: "#FFFFFF", primary: "#FF6F00", secondary: "#FF9E40",
            accent: "#FF6F00", text: "#331A00", textSecondary: "#995200", textMuted: "#CCB088",
            textOnPrimary: "#FFFFFF", cardBorder: "#FF6F00", cardBackground: "#FFFFFF",
            cardHighlight: "#FFECD0", cardSelected: "#FF9E40", success: "#4CAF50",
            warning: "#FF9800", error: "#D32F2F"
        ),
        isDark: false,
        gradientColors: [Color(hex: "#FFF5E6"), Color(hex: "#FFECD0"), Color(hex: "#FFE2B8")],
        iconName: "speaker.wave.3.fill"
    )

    static let classical = Theme(
        id: "classical", name: "Classical",
        colors: ThemeColors(
            background: "#F8F5F0", surface: "#FFFFFF", primary: "#5A4A3A", secondary: "#8C7A6A",
            accent: "#8C3030", text: "#2A2018", textSecondary: "#6A5A4A", textMuted: "#B0A090",
            textOnPrimary: "#FFFFFF", cardBorder: "#5A4A3A", cardBackground: "#FFFFFF",
            cardHighlight: "#F0E8DE", cardSelected: "#8C7A6A", success: "#4CAF50",
            warning: "#FF9800", error: "#D32F2F"
        ),
        isDark: false,
        gradientColors: [Color(hex: "#F8F5F0"), Color(hex: "#F0E8DE"), Color(hex: "#E8DDCC")],
        iconName: "music.note"
    )

    static let ambient = Theme(
        id: "ambient", name: "Ambient",
        colors: ThemeColors(
            background: "#000510", surface: "#0A1020", primary: "#4488CC", secondary: "#336699",
            accent: "#4488CC", text: "#C0D8F0", textSecondary: "#6690B0", textMuted: "#2A3A50",
            textOnPrimary: "#000510", cardBorder: "#1A2A40", cardBackground: "#0A1020",
            cardHighlight: "#141830", cardSelected: "#4488CC", success: "#4DB6AC",
            warning: "#FFD740", error: "#EF5350"
        ),
        isDark: true,
        gradientColors: [Color(hex: "#000510"), Color(hex: "#0A1020"), Color(hex: "#141830")],
        iconName: "moon.stars.fill"
    )

    static let all: [Theme] = [pulse, neon, vinyl, jazz, techno, acoustic, synthwave, funk, classical, ambient]
    static let lightThemes: [Theme] = [vinyl, acoustic, funk, classical]
    static let darkThemes: [Theme] = [pulse, neon, jazz, techno, synthwave, ambient]
    static let `default` = pulse

    static func theme(for id: String) -> Theme {
        all.first { $0.id == id } ?? `default`
    }
}
