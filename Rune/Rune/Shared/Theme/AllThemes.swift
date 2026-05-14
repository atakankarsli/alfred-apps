import SwiftUI

enum Themes {
    static let all: [Theme] = [papyrus, stone, sand, obsidian, bronze, jade, parchment, raven, amber, void]
    static let `default` = papyrus

    static func theme(for id: String) -> Theme {
        all.first { $0.id == id } ?? `default`
    }

    static let papyrus = Theme(
        id: "papyrus", name: "Papyrus", isDark: true,
        gradientColors: [Color(hex: "1A140A"), Color(hex: "2A1E10"), Color(hex: "1E1508")],
        iconName: "scroll.fill",
        colors: ThemeColors(
            background: "1A140A", surface: "2A1E10", primary: "D4A052", secondary: "C8935A", accent: "E8C068",
            text: "F5E8D0", textSecondary: "B8A080", textMuted: "706048", textOnPrimary: "1A140A",
            cardBorder: "3A2E18", cardBackground: "241A0E", cardHighlight: "322412", cardSelected: "D4A052",
            success: "69F0AE", warning: "FFD740", error: "FF5252"
        )
    )

    static let stone = Theme(
        id: "stone", name: "Stone", isDark: true,
        gradientColors: [Color(hex: "181818"), Color(hex: "252525"), Color(hex: "1A1A1A")],
        iconName: "mountain.2.fill",
        colors: ThemeColors(
            background: "181818", surface: "252525", primary: "90A4AE", secondary: "78909C", accent: "B0BEC5",
            text: "ECEFF1", textSecondary: "9E9E9E", textMuted: "616161", textOnPrimary: "181818",
            cardBorder: "333333", cardBackground: "202020", cardHighlight: "2C2C2C", cardSelected: "90A4AE",
            success: "69F0AE", warning: "FFD740", error: "FF5252"
        )
    )

    static let sand = Theme(
        id: "sand", name: "Sand", isDark: false,
        gradientColors: [Color(hex: "F5ECD8"), Color(hex: "F0E4C8"), Color(hex: "EDE0C0")],
        iconName: "sun.max.fill",
        colors: ThemeColors(
            background: "F5ECD8", surface: "FFFFFF", primary: "8B6914", secondary: "A07828", accent: "C49A28",
            text: "2A2010", textSecondary: "5A4A30", textMuted: "8A7A60", textOnPrimary: "FFFFFF",
            cardBorder: "D8C8A0", cardBackground: "FAF4E8", cardHighlight: "F0E4C8", cardSelected: "8B6914",
            success: "2E7D32", warning: "E65100", error: "C62828"
        )
    )

    static let obsidian = Theme(
        id: "obsidian", name: "Obsidian", isDark: true,
        gradientColors: [Color(hex: "050508"), Color(hex: "0E0E14"), Color(hex: "08080C")],
        iconName: "diamond.fill",
        colors: ThemeColors(
            background: "050508", surface: "0E0E14", primary: "7B7BFF", secondary: "6060D0", accent: "9090FF",
            text: "E8E8FF", textSecondary: "9090B0", textMuted: "505068", textOnPrimary: "050508",
            cardBorder: "1A1A28", cardBackground: "0A0A12", cardHighlight: "141420", cardSelected: "7B7BFF",
            success: "69F0AE", warning: "FFD740", error: "FF5252"
        )
    )

    static let bronze = Theme(
        id: "bronze", name: "Bronze", isDark: true,
        gradientColors: [Color(hex: "1A1008"), Color(hex: "281810"), Color(hex: "1E1208")],
        iconName: "shield.fill",
        colors: ThemeColors(
            background: "1A1008", surface: "281810", primary: "CD7F32", secondary: "B87333", accent: "E09040",
            text: "F0E0C8", textSecondary: "B89870", textMuted: "705838", textOnPrimary: "1A1008",
            cardBorder: "382818", cardBackground: "221408", cardHighlight: "302010", cardSelected: "CD7F32",
            success: "69F0AE", warning: "FFD740", error: "FF5252"
        )
    )

    static let jade = Theme(
        id: "jade", name: "Jade", isDark: true,
        gradientColors: [Color(hex: "081A10"), Color(hex: "0E2818"), Color(hex: "0A1E12")],
        iconName: "leaf.fill",
        colors: ThemeColors(
            background: "081A10", surface: "0E2818", primary: "00A86B", secondary: "00896B", accent: "00C878",
            text: "E0F8E8", textSecondary: "80B898", textMuted: "407858", textOnPrimary: "081A10",
            cardBorder: "183820", cardBackground: "0C2014", cardHighlight: "143018", cardSelected: "00A86B",
            success: "69F0AE", warning: "FFD740", error: "FF5252"
        )
    )

    static let parchment = Theme(
        id: "parchment", name: "Parchment", isDark: false,
        gradientColors: [Color(hex: "F8F0E0"), Color(hex: "F0E8D0"), Color(hex: "EDE4C8")],
        iconName: "doc.text.fill",
        colors: ThemeColors(
            background: "F8F0E0", surface: "FFFFFF", primary: "6B4226", secondary: "7B5236", accent: "8B6246",
            text: "2A1A0A", textSecondary: "5A4A38", textMuted: "8A7A68", textOnPrimary: "FFFFFF",
            cardBorder: "D8C8B0", cardBackground: "FBF6EC", cardHighlight: "F0E4D0", cardSelected: "6B4226",
            success: "2E7D32", warning: "E65100", error: "C62828"
        )
    )

    static let raven = Theme(
        id: "raven", name: "Raven", isDark: true,
        gradientColors: [Color(hex: "08080C"), Color(hex: "101018"), Color(hex: "0C0C12")],
        iconName: "bird.fill",
        colors: ThemeColors(
            background: "08080C", surface: "101018", primary: "A0A0C0", secondary: "8080A0", accent: "C0C0E0",
            text: "E8E8F0", textSecondary: "8888A0", textMuted: "505068", textOnPrimary: "08080C",
            cardBorder: "1A1A28", cardBackground: "0C0C14", cardHighlight: "141420", cardSelected: "A0A0C0",
            success: "69F0AE", warning: "FFD740", error: "FF5252"
        )
    )

    static let amber = Theme(
        id: "amber", name: "Amber", isDark: true,
        gradientColors: [Color(hex: "1A1000"), Color(hex: "281A00"), Color(hex: "1E1200")],
        iconName: "flame.fill",
        colors: ThemeColors(
            background: "1A1000", surface: "281A00", primary: "FFBF00", secondary: "E5A800", accent: "FFD740",
            text: "FFF0C8", textSecondary: "C8A850", textMuted: "706020", textOnPrimary: "1A1000",
            cardBorder: "382800", cardBackground: "221600", cardHighlight: "302000", cardSelected: "FFBF00",
            success: "69F0AE", warning: "FFD740", error: "FF5252"
        )
    )

    static let void = Theme(
        id: "void", name: "Void", isDark: true,
        gradientColors: [Color(hex: "000000"), Color(hex: "0A0A0A"), Color(hex: "050505")],
        iconName: "circle.fill",
        colors: ThemeColors(
            background: "000000", surface: "0A0A0A", primary: "FFFFFF", secondary: "C0C0C0", accent: "808080",
            text: "FFFFFF", textSecondary: "A0A0A0", textMuted: "505050", textOnPrimary: "000000",
            cardBorder: "1A1A1A", cardBackground: "0D0D0D", cardHighlight: "151515", cardSelected: "FFFFFF",
            success: "69F0AE", warning: "FFD740", error: "FF5252"
        )
    )
}
