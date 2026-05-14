import SwiftUI

enum Themes {
    static let dawn = Theme(
        id: "dawn",
        name: "Dawn",
        colors: ThemeColors(
            background: "#FDF8F3",
            surface: "#FDF8F3",
            primary: "#8B7355",
            secondary: "#C9A691",
            accent: "#9CAF88",
            text: "#4A3F33",
            textSecondary: "#8B7355",
            textMuted: "#B8B0A5",
            textOnPrimary: "#FFFDFB",
            boardBorder: "#8B7355",
            cellBackground: "#FDF8F3",
            cellHighlight: "#F5EFE5",
            cellSelected: "#D4A574",
            cellError: "#FDECEA",
            cellConflicting: "#F5D0C5",
            numberPrefilled: "#4A3F33",
            numberUser: "#A67D62",
            numberError: "#D32F2F",
            numberSelected: "#FFFDFB",
            note: "#B8B0A5"
        ),
        numberFont: .serif,
        isDark: false,
        gradientColors: [Color(hex: "#FDF8F3"), Color(hex: "#FFF0E0"), Color(hex: "#FFE5D0")],
        iconName: "sun.max.fill",
        patternOpacity: 0.1
    )

    static let bamboo = Theme(
        id: "bamboo",
        name: "Bamboo",
        colors: ThemeColors(
            background: "#F1F8F1",
            surface: "#FFFFFF",
            primary: "#5D8C61",
            secondary: "#8FB392",
            accent: "#D4C76D",
            text: "#2D4430",
            textSecondary: "#5D8C61",
            textMuted: "#A3BDA5",
            textOnPrimary: "#FFFFFF",
            boardBorder: "#5D8C61",
            cellBackground: "#FFFFFF",
            cellHighlight: "#E6F0E6",
            cellSelected: "#8FB392",
            cellError: "#F8E1E1",
            cellConflicting: "#E1EBE1",
            numberPrefilled: "#2D4430",
            numberUser: "#5D8C61",
            numberError: "#C44D4D",
            numberSelected: "#FFFFFF",
            note: "#A3BDA5"
        ),
        numberFont: .rounded,
        isDark: false,
        gradientColors: [Color(hex: "#F1F8F1"), Color(hex: "#E0F2E0"), Color(hex: "#D0EBD0")],
        iconName: "leaf.fill",
        patternOpacity: 0.15
    )

    static let paper = Theme(
        id: "paper",
        name: "Paper",
        colors: ThemeColors(
            background: "#F5F1E6",
            surface: "#FDFBF7",
            primary: "#5C5346",
            secondary: "#8C8376",
            accent: "#B85C5C",
            text: "#2E2A23",
            textSecondary: "#5C5346",
            textMuted: "#A69F94",
            textOnPrimary: "#FDFBF7",
            boardBorder: "#5C5346",
            cellBackground: "#FDFBF7",
            cellHighlight: "#EBE6DA",
            cellSelected: "#8C8376",
            cellError: "#EBCBCB",
            cellConflicting: "#E6E1D6",
            numberPrefilled: "#2E2A23",
            numberUser: "#5C5346",
            numberError: "#B85C5C",
            numberSelected: "#FDFBF7",
            note: "#A69F94"
        ),
        numberFont: .serif,
        isDark: false,
        gradientColors: [Color(hex: "#F5F1E6"), Color(hex: "#EBE5D5"), Color(hex: "#DFD9C9")],
        iconName: "doc.text.fill",
        patternOpacity: 0.08
    )

    static let lavender = Theme(
        id: "lavender",
        name: "Lavender",
        colors: ThemeColors(
            background: "#F6F4F9",
            surface: "#FFFFFF",
            primary: "#8E7DA6",
            secondary: "#B8A9CC",
            accent: "#E6A8D7",
            text: "#463C52",
            textSecondary: "#8E7DA6",
            textMuted: "#C4BBD1",
            textOnPrimary: "#FFFFFF",
            boardBorder: "#8E7DA6",
            cellBackground: "#FFFFFF",
            cellHighlight: "#EEEBF5",
            cellSelected: "#B8A9CC",
            cellError: "#F9E6E6",
            cellConflicting: "#E6E1ED",
            numberPrefilled: "#463C52",
            numberUser: "#8E7DA6",
            numberError: "#C76D6D",
            numberSelected: "#FFFFFF",
            note: "#C4BBD1"
        ),
        numberFont: .default,
        isDark: false,
        gradientColors: [Color(hex: "#F6F4F9"), Color(hex: "#EDE8F5"), Color(hex: "#E5DEF0")],
        iconName: "sparkles",
        patternOpacity: 0.12
    )

    static let ocean = Theme(
        id: "ocean",
        name: "Ocean",
        colors: ThemeColors(
            background: "#E8F4F7",
            surface: "#FFFFFF",
            primary: "#4B90A6",
            secondary: "#7FB8CA",
            accent: "#F7A87B",
            text: "#244552",
            textSecondary: "#4B90A6",
            textMuted: "#9CC3D1",
            textOnPrimary: "#FFFFFF",
            boardBorder: "#4B90A6",
            cellBackground: "#FFFFFF",
            cellHighlight: "#D9EDF2",
            cellSelected: "#7FB8CA",
            cellError: "#F7E1E1",
            cellConflicting: "#D4E6EC",
            numberPrefilled: "#244552",
            numberUser: "#4B90A6",
            numberError: "#D65C5C",
            numberSelected: "#FFFFFF",
            note: "#9CC3D1"
        ),
        numberFont: .rounded,
        isDark: false,
        gradientColors: [Color(hex: "#E8F4F7"), Color(hex: "#D8EEF5"), Color(hex: "#C9E8F2")],
        iconName: "water.waves",
        patternOpacity: 0.15
    )

    static let sunset = Theme(
        id: "sunset",
        name: "Sunset",
        colors: ThemeColors(
            background: "#FFF5F0",
            surface: "#FFFFFF",
            primary: "#D97B66",
            secondary: "#F2A68C",
            accent: "#8C6A9E",
            text: "#522E24",
            textSecondary: "#D97B66",
            textMuted: "#E0C2B8",
            textOnPrimary: "#FFFFFF",
            boardBorder: "#D97B66",
            cellBackground: "#FFFFFF",
            cellHighlight: "#FFE8E0",
            cellSelected: "#F2A68C",
            cellError: "#FCE1E1",
            cellConflicting: "#F5DCD6",
            numberPrefilled: "#522E24",
            numberUser: "#D97B66",
            numberError: "#C44D4D",
            numberSelected: "#FFFFFF",
            note: "#E0C2B8"
        ),
        numberFont: .handwritten,
        isDark: false,
        gradientColors: [Color(hex: "#FFF5F0"), Color(hex: "#FFE0D0"), Color(hex: "#FFCCB0")],
        iconName: "sun.haze.fill",
        patternOpacity: 0.15
    )

    static let berry = Theme(
        id: "berry",
        name: "Berry",
        colors: ThemeColors(
            background: "#FDF2F4",
            surface: "#FFFFFF",
            primary: "#AD3E5B",
            secondary: "#D67A91",
            accent: "#5C3EAD",
            text: "#4A1A26",
            textSecondary: "#AD3E5B",
            textMuted: "#D1B8C0",
            textOnPrimary: "#FFFFFF",
            boardBorder: "#AD3E5B",
            cellBackground: "#FFFFFF",
            cellHighlight: "#FAE6EB",
            cellSelected: "#D67A91",
            cellError: "#FCE1CA",
            cellConflicting: "#F0D5DD",
            numberPrefilled: "#4A1A26",
            numberUser: "#AD3E5B",
            numberError: "#D32F2F",
            numberSelected: "#FFFFFF",
            note: "#D1B8C0"
        ),
        numberFont: .default,
        isDark: false,
        gradientColors: [Color(hex: "#FDF2F4"), Color(hex: "#FCE0E8"), Color(hex: "#FAD0DC")],
        iconName: "heart.fill",
        patternOpacity: 0.12
    )

    static let slate = Theme(
        id: "slate",
        name: "Slate",
        colors: ThemeColors(
            background: "#2C333A",
            surface: "#363E46",
            primary: "#7FA3B5",
            secondary: "#587280",
            accent: "#D69E6B",
            text: "#E6EAED",
            textSecondary: "#9CA8B0",
            textMuted: "#5C6B75",
            textOnPrimary: "#2C333A",
            boardBorder: "#587280",
            cellBackground: "#363E46",
            cellHighlight: "#434D57",
            cellSelected: "#7FA3B5",
            cellError: "#4A2F2F",
            cellConflicting: "#404952",
            numberPrefilled: "#E6EAED",
            numberUser: "#96C2D9",
            numberError: "#E57373",
            numberSelected: "#2C333A",
            note: "#5C6B75"
        ),
        numberFont: .monospace,
        isDark: true,
        gradientColors: [Color(hex: "#2C333A"), Color(hex: "#363E46"), Color(hex: "#404952")],
        iconName: "square.stack.3d.up.fill",
        patternOpacity: 0.2
    )

    static let midnight = Theme(
        id: "midnight",
        name: "Midnight",
        colors: ThemeColors(
            background: "#121629",
            surface: "#1C223B",
            primary: "#6B7FD6",
            secondary: "#3E4C8C",
            accent: "#F2D66D",
            text: "#E3E6F2",
            textSecondary: "#8A96C2",
            textMuted: "#4A5270",
            textOnPrimary: "#FFFFFF",
            boardBorder: "#3E4C8C",
            cellBackground: "#1C223B",
            cellHighlight: "#272F52",
            cellSelected: "#6B7FD6",
            cellError: "#3B1C1C",
            cellConflicting: "#2A3152",
            numberPrefilled: "#E3E6F2",
            numberUser: "#8C9EFF",
            numberError: "#EF5350",
            numberSelected: "#FFFFFF",
            note: "#4A5270"
        ),
        numberFont: .serif,
        isDark: true,
        gradientColors: [Color(hex: "#121629"), Color(hex: "#1A2038"), Color(hex: "#222A47")],
        iconName: "moon.fill",
        patternOpacity: 0.3
    )

    static let eclipse = Theme(
        id: "eclipse",
        name: "Eclipse",
        colors: ThemeColors(
            background: "#000000",
            surface: "#111111",
            primary: "#C9A355",
            secondary: "#665229",
            accent: "#FFFFFF",
            text: "#F0E6D2",
            textSecondary: "#8C7D5E",
            textMuted: "#4D4533",
            textOnPrimary: "#000000",
            boardBorder: "#665229",
            cellBackground: "#111111",
            cellHighlight: "#1F1A0E",
            cellSelected: "#C9A355",
            cellError: "#290E0E",
            cellConflicting: "#1A150A",
            numberPrefilled: "#F0E6D2",
            numberUser: "#DBC186",
            numberError: "#C62828",
            numberSelected: "#000000",
            note: "#4D4533"
        ),
        numberFont: .monospace,
        isDark: true,
        gradientColors: [Color(hex: "#000000"), Color(hex: "#111111"), Color(hex: "#222222")],
        iconName: "circle.fill",
        patternOpacity: 0.4
    )

    static let all: [Theme] = [
        dawn, bamboo, paper, lavender, ocean, sunset, berry,
        slate, midnight, eclipse
    ]

    static let lightThemes: [Theme] = [
        dawn, bamboo, paper, lavender, ocean, sunset, berry
    ]

    static let darkThemes: [Theme] = [
        slate, midnight, eclipse
    ]

    static let `default` = dawn

    static func theme(for id: String) -> Theme {
        all.first { $0.id == id } ?? `default`
    }

    static let worldOrder: [String] = [
        "dawn", "bamboo", "paper", "lavender", "ocean",
        "sunset", "berry", "slate", "midnight", "eclipse"
    ]
}
