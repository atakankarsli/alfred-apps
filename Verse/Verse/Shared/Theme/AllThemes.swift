import SwiftUI

enum Themes {
    static let parchment = Theme(
        id: "parchment",
        name: "Parchment",
        colors: ThemeColors(
            background: "#F5F1E6", surface: "#FDFBF7", primary: "#5C5346", secondary: "#8C8376",
            accent: "#7B6B8A", text: "#2E2A23", textSecondary: "#5C5346", textMuted: "#A69F94",
            textOnPrimary: "#FDFBF7", boardBorder: "#5C5346", cellBackground: "#FDFBF7",
            cellHighlight: "#EBE6DA", cellSelected: "#8C8376", cellError: "#EBCBCB",
            cellConflicting: "#E6E1D6", numberPrefilled: "#2E2A23", numberUser: "#5C5346",
            numberError: "#B85C5C", numberSelected: "#FDFBF7", note: "#A69F94"
        ),
        isDark: false,
        gradientColors: [Color(hex: "#F5F1E6"), Color(hex: "#EBE5D5"), Color(hex: "#DFD9C9")],
        iconName: "book.fill"
    )

    static let garden = Theme(
        id: "garden",
        name: "Garden",
        colors: ThemeColors(
            background: "#F1F8F1", surface: "#FFFFFF", primary: "#5D8C61", secondary: "#8FB392",
            accent: "#C4956A", text: "#2D4430", textSecondary: "#5D8C61", textMuted: "#A3BDA5",
            textOnPrimary: "#FFFFFF", boardBorder: "#5D8C61", cellBackground: "#FFFFFF",
            cellHighlight: "#E6F0E6", cellSelected: "#8FB392", cellError: "#F8E1E1",
            cellConflicting: "#E1EBE1", numberPrefilled: "#2D4430", numberUser: "#5D8C61",
            numberError: "#C44D4D", numberSelected: "#FFFFFF", note: "#A3BDA5"
        ),
        isDark: false,
        gradientColors: [Color(hex: "#F1F8F1"), Color(hex: "#E0F2E0"), Color(hex: "#D0EBD0")],
        iconName: "leaf.fill"
    )

    static let lavender = Theme(
        id: "lavender",
        name: "Lavender",
        colors: ThemeColors(
            background: "#F6F4F9", surface: "#FFFFFF", primary: "#8E7DA6", secondary: "#B8A9CC",
            accent: "#C77DB2", text: "#463C52", textSecondary: "#8E7DA6", textMuted: "#C4BBD1",
            textOnPrimary: "#FFFFFF", boardBorder: "#8E7DA6", cellBackground: "#FFFFFF",
            cellHighlight: "#EEEBF5", cellSelected: "#B8A9CC", cellError: "#F9E6E6",
            cellConflicting: "#E6E1ED", numberPrefilled: "#463C52", numberUser: "#8E7DA6",
            numberError: "#C76D6D", numberSelected: "#FFFFFF", note: "#C4BBD1"
        ),
        isDark: false,
        gradientColors: [Color(hex: "#F6F4F9"), Color(hex: "#EDE8F5"), Color(hex: "#E5DEF0")],
        iconName: "sparkles"
    )

    static let ocean = Theme(
        id: "ocean",
        name: "Ocean",
        colors: ThemeColors(
            background: "#E8F4F7", surface: "#FFFFFF", primary: "#4B90A6", secondary: "#7FB8CA",
            accent: "#D4956A", text: "#244552", textSecondary: "#4B90A6", textMuted: "#9CC3D1",
            textOnPrimary: "#FFFFFF", boardBorder: "#4B90A6", cellBackground: "#FFFFFF",
            cellHighlight: "#D9EDF2", cellSelected: "#7FB8CA", cellError: "#F7E1E1",
            cellConflicting: "#D4E6EC", numberPrefilled: "#244552", numberUser: "#4B90A6",
            numberError: "#D65C5C", numberSelected: "#FFFFFF", note: "#9CC3D1"
        ),
        isDark: false,
        gradientColors: [Color(hex: "#E8F4F7"), Color(hex: "#D8EEF5"), Color(hex: "#C9E8F2")],
        iconName: "water.waves"
    )

    static let sunset = Theme(
        id: "sunset",
        name: "Sunset",
        colors: ThemeColors(
            background: "#FFF5F0", surface: "#FFFFFF", primary: "#D97B66", secondary: "#F2A68C",
            accent: "#8C6A9E", text: "#522E24", textSecondary: "#D97B66", textMuted: "#E0C2B8",
            textOnPrimary: "#FFFFFF", boardBorder: "#D97B66", cellBackground: "#FFFFFF",
            cellHighlight: "#FFE8E0", cellSelected: "#F2A68C", cellError: "#FCE1E1",
            cellConflicting: "#F5DCD6", numberPrefilled: "#522E24", numberUser: "#D97B66",
            numberError: "#C44D4D", numberSelected: "#FFFFFF", note: "#E0C2B8"
        ),
        isDark: false,
        gradientColors: [Color(hex: "#FFF5F0"), Color(hex: "#FFE0D0"), Color(hex: "#FFCCB0")],
        iconName: "sun.haze.fill"
    )

    static let slate = Theme(
        id: "slate",
        name: "Slate",
        colors: ThemeColors(
            background: "#2C333A", surface: "#363E46", primary: "#7FA3B5", secondary: "#587280",
            accent: "#C4956A", text: "#E6EAED", textSecondary: "#9CA8B0", textMuted: "#5C6B75",
            textOnPrimary: "#2C333A", boardBorder: "#587280", cellBackground: "#363E46",
            cellHighlight: "#434D57", cellSelected: "#7FA3B5", cellError: "#4A2F2F",
            cellConflicting: "#404952", numberPrefilled: "#E6EAED", numberUser: "#96C2D9",
            numberError: "#E57373", numberSelected: "#2C333A", note: "#5C6B75"
        ),
        isDark: true,
        gradientColors: [Color(hex: "#2C333A"), Color(hex: "#363E46"), Color(hex: "#404952")],
        iconName: "moon.fill"
    )

    static let midnight = Theme(
        id: "midnight",
        name: "Midnight",
        colors: ThemeColors(
            background: "#121629", surface: "#1C223B", primary: "#6B7FD6", secondary: "#3E4C8C",
            accent: "#D4A86D", text: "#E3E6F2", textSecondary: "#8A96C2", textMuted: "#4A5270",
            textOnPrimary: "#FFFFFF", boardBorder: "#3E4C8C", cellBackground: "#1C223B",
            cellHighlight: "#272F52", cellSelected: "#6B7FD6", cellError: "#3B1C1C",
            cellConflicting: "#2A3152", numberPrefilled: "#E3E6F2", numberUser: "#8C9EFF",
            numberError: "#EF5350", numberSelected: "#FFFFFF", note: "#4A5270"
        ),
        isDark: true,
        gradientColors: [Color(hex: "#121629"), Color(hex: "#1A2038"), Color(hex: "#222A47")],
        iconName: "moon.stars.fill"
    )

    static let all: [Theme] = [parchment, garden, lavender, ocean, sunset, slate, midnight]
    static let lightThemes: [Theme] = [parchment, garden, lavender, ocean, sunset]
    static let darkThemes: [Theme] = [slate, midnight]
    static let `default` = parchment

    static func theme(for id: String) -> Theme {
        all.first { $0.id == id } ?? `default`
    }
}
