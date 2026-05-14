import SwiftUI

enum Themes {
    static let all: [Theme] = [atlas, compass, parchment, oceanic, savanna, glacier, sunrise, midnight, satellite, voidTheme]
    static let `default` = atlas

    static let atlas = Theme(id: "atlas", name: "Atlas", colors: ThemeColors(
        background: "F5F0E8", surface: "FFFFFF", primary: "2D6A4F", secondary: "40916C",
        accent: "52B788", text: "1B1B1B", textSecondary: "4A5568", textMuted: "A0AEC0",
        textOnPrimary: "FFFFFF", boardBorder: "D5C9B1", cellBackground: "FBF8F3",
        cellHighlight: "E8E0D0", cellSelected: "2D6A4F"
    ), isDark: false, gradientColors: [Color(hex: "F5F0E8"), Color(hex: "E8E0D0")], iconName: "globe.americas.fill")

    static let compass = Theme(id: "compass", name: "Compass", colors: ThemeColors(
        background: "EDF2F7", surface: "FFFFFF", primary: "2B6CB0", secondary: "4299E1",
        accent: "63B3ED", text: "1A202C", textSecondary: "4A5568", textMuted: "A0AEC0",
        textOnPrimary: "FFFFFF", boardBorder: "CBD5E0", cellBackground: "F7FAFC",
        cellHighlight: "E2E8F0", cellSelected: "2B6CB0"
    ), isDark: false, gradientColors: [Color(hex: "EDF2F7"), Color(hex: "E2E8F0")], iconName: "safari.fill")

    static let parchment = Theme(id: "parchment", name: "Parchment", colors: ThemeColors(
        background: "FAF5E4", surface: "FFFDF5", primary: "B7791F", secondary: "D69E2E",
        accent: "ECC94B", text: "2D3748", textSecondary: "4A5568", textMuted: "A0AEC0",
        textOnPrimary: "FFFFFF", boardBorder: "E2D5B0", cellBackground: "FFFEF8",
        cellHighlight: "FEFCBF", cellSelected: "B7791F"
    ), isDark: false, gradientColors: [Color(hex: "FAF5E4"), Color(hex: "F0E8C8")], iconName: "scroll.fill")

    static let oceanic = Theme(id: "oceanic", name: "Oceanic", colors: ThemeColors(
        background: "EBF8FF", surface: "FFFFFF", primary: "0987A0", secondary: "38B2AC",
        accent: "4FD1C5", text: "1A202C", textSecondary: "4A5568", textMuted: "A0AEC0",
        textOnPrimary: "FFFFFF", boardBorder: "B2F5EA", cellBackground: "F0FFFF",
        cellHighlight: "E6FFFA", cellSelected: "0987A0"
    ), isDark: false, gradientColors: [Color(hex: "EBF8FF"), Color(hex: "E6FFFA")], iconName: "water.waves")

    static let savanna = Theme(id: "savanna", name: "Savanna", colors: ThemeColors(
        background: "FFFAF0", surface: "FFFFFF", primary: "C05621", secondary: "DD6B20",
        accent: "ED8936", text: "1A202C", textSecondary: "4A5568", textMuted: "A0AEC0",
        textOnPrimary: "FFFFFF", boardBorder: "FEEBC8", cellBackground: "FFFEFA",
        cellHighlight: "FEFCBF", cellSelected: "C05621"
    ), isDark: false, gradientColors: [Color(hex: "FFFAF0"), Color(hex: "FEEBC8")], iconName: "sun.max.fill")

    static let glacier = Theme(id: "glacier", name: "Glacier", colors: ThemeColors(
        background: "F0F4FF", surface: "FFFFFF", primary: "5A67D8", secondary: "7F9CF5",
        accent: "A3BFFA", text: "1A202C", textSecondary: "4A5568", textMuted: "A0AEC0",
        textOnPrimary: "FFFFFF", boardBorder: "C3DAFE", cellBackground: "F7F9FF",
        cellHighlight: "EBF4FF", cellSelected: "5A67D8"
    ), isDark: false, gradientColors: [Color(hex: "F0F4FF"), Color(hex: "EBF4FF")], iconName: "snowflake")

    static let sunrise = Theme(id: "sunrise", name: "Sunrise", colors: ThemeColors(
        background: "FFF5F5", surface: "FFFFFF", primary: "E53E3E", secondary: "FC8181",
        accent: "FEB2B2", text: "1A202C", textSecondary: "4A5568", textMuted: "A0AEC0",
        textOnPrimary: "FFFFFF", boardBorder: "FED7D7", cellBackground: "FFF5F5",
        cellHighlight: "FED7D7", cellSelected: "E53E3E"
    ), isDark: false, gradientColors: [Color(hex: "FFF5F5"), Color(hex: "FED7D7")], iconName: "sunrise.fill")

    static let midnight = Theme(id: "midnight", name: "Midnight", colors: ThemeColors(
        background: "0F1B2D", surface: "1A2942", primary: "48BB78", secondary: "68D391",
        accent: "9AE6B4", text: "F0F4FF", textSecondary: "A0B4D0", textMuted: "5A6B8A",
        textOnPrimary: "0F1B2D", boardBorder: "2D3E58", cellBackground: "1A2942",
        cellHighlight: "2D3E58", cellSelected: "48BB78"
    ), isDark: true, gradientColors: [Color(hex: "0F1B2D"), Color(hex: "162238")], iconName: "moon.stars.fill")

    static let satellite = Theme(id: "satellite", name: "Satellite", colors: ThemeColors(
        background: "0A1628", surface: "142240", primary: "4299E1", secondary: "63B3ED",
        accent: "90CDF4", text: "E8F0FE", textSecondary: "8DA4C0", textMuted: "4A6080",
        textOnPrimary: "0A1628", boardBorder: "1E3A5F", cellBackground: "142240",
        cellHighlight: "1E3A5F", cellSelected: "4299E1"
    ), isDark: true, gradientColors: [Color(hex: "0A1628"), Color(hex: "0E1E38")], iconName: "antenna.radiowaves.left.and.right")

    static let voidTheme = Theme(id: "void", name: "Void", colors: ThemeColors(
        background: "050505", surface: "111111", primary: "ECC94B", secondary: "D69E2E",
        accent: "F6E05E", text: "F0F0F0", textSecondary: "999999", textMuted: "555555",
        textOnPrimary: "050505", boardBorder: "222222", cellBackground: "111111",
        cellHighlight: "1A1A1A", cellSelected: "ECC94B"
    ), isDark: true, gradientColors: [Color(hex: "050505"), Color(hex: "0A0A0A")], iconName: "circle.dashed")
}
