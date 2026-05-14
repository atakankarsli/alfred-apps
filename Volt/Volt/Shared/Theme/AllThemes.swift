import SwiftUI

enum Themes {
    static let blueprint = Theme(id: "blueprint", name: "Blueprint", colors: ThemeColors(
        background: "#EDF2F9", surface: "#FFFFFF", primary: "#2E6DB4", secondary: "#5B9BD5",
        accent: "#2E6DB4", text: "#1A2A42", textSecondary: "#4A6FA5", textMuted: "#A0B4CC",
        textOnPrimary: "#FFFFFF", cardBorder: "#2E6DB4", cardBackground: "#FFFFFF",
        cardHighlight: "#DCE8F5", cardSelected: "#5B9BD5", success: "#27AE60", warning: "#F39C12", error: "#E74C3C"
    ), isDark: false, gradientColors: [Color(hex: "#EDF2F9"), Color(hex: "#DCE8F5"), Color(hex: "#C5D9EF")], iconName: "doc.text.fill")

    static let neon = Theme(id: "neon", name: "Neon", colors: ThemeColors(
        background: "#0A0A14", surface: "#141428", primary: "#00FF88", secondary: "#00CC6A",
        accent: "#00FF88", text: "#E0FFE0", textSecondary: "#80FFB0", textMuted: "#1A3A2A",
        textOnPrimary: "#0A0A14", cardBorder: "#00FF88", cardBackground: "#141428",
        cardHighlight: "#1A2A20", cardSelected: "#00FF88", success: "#00FF88", warning: "#FFDD00", error: "#FF4444"
    ), isDark: true, gradientColors: [Color(hex: "#0A0A14"), Color(hex: "#141428"), Color(hex: "#0A1A14")], iconName: "bolt.fill")

    static let copper = Theme(id: "copper", name: "Copper", colors: ThemeColors(
        background: "#F5EDE0", surface: "#FFFFFF", primary: "#B87333", secondary: "#D4956A",
        accent: "#B87333", text: "#3A2510", textSecondary: "#8B5E3C", textMuted: "#D4C4A8",
        textOnPrimary: "#FFFFFF", cardBorder: "#B87333", cardBackground: "#FFFFFF",
        cardHighlight: "#F0E0CC", cardSelected: "#D4956A", success: "#27AE60", warning: "#F39C12", error: "#E74C3C"
    ), isDark: false, gradientColors: [Color(hex: "#F5EDE0"), Color(hex: "#F0E0CC"), Color(hex: "#E8D5B8")], iconName: "cable.connector")

    static let silicon = Theme(id: "silicon", name: "Silicon", colors: ThemeColors(
        background: "#F0F0F5", surface: "#FFFFFF", primary: "#6B7280", secondary: "#9CA3AF",
        accent: "#6B7280", text: "#1F2937", textSecondary: "#4B5563", textMuted: "#D1D5DB",
        textOnPrimary: "#FFFFFF", cardBorder: "#6B7280", cardBackground: "#FFFFFF",
        cardHighlight: "#E5E7EB", cardSelected: "#9CA3AF", success: "#10B981", warning: "#F59E0B", error: "#EF4444"
    ), isDark: false, gradientColors: [Color(hex: "#F0F0F5"), Color(hex: "#E5E7EB"), Color(hex: "#D1D5DB")], iconName: "cpu.fill")

    static let retro = Theme(id: "retro", name: "Retro", colors: ThemeColors(
        background: "#0A1A0A", surface: "#0F2A0F", primary: "#33FF33", secondary: "#22CC22",
        accent: "#33FF33", text: "#CCFFCC", textSecondary: "#66FF66", textMuted: "#1A3A1A",
        textOnPrimary: "#0A1A0A", cardBorder: "#33FF33", cardBackground: "#0F2A0F",
        cardHighlight: "#1A3A1A", cardSelected: "#33FF33", success: "#33FF33", warning: "#FFFF33", error: "#FF3333"
    ), isDark: true, gradientColors: [Color(hex: "#0A1A0A"), Color(hex: "#0F2A0F"), Color(hex: "#1A3A1A")], iconName: "desktopcomputer")

    static let crystal = Theme(id: "crystal", name: "Crystal", colors: ThemeColors(
        background: "#EAF6FF", surface: "#FFFFFF", primary: "#4FC3F7", secondary: "#81D4FA",
        accent: "#4FC3F7", text: "#0D3B5E", textSecondary: "#2196F3", textMuted: "#B3E5FC",
        textOnPrimary: "#FFFFFF", cardBorder: "#4FC3F7", cardBackground: "#FFFFFF",
        cardHighlight: "#E1F5FE", cardSelected: "#81D4FA", success: "#26A69A", warning: "#FFA726", error: "#EF5350"
    ), isDark: false, gradientColors: [Color(hex: "#EAF6FF"), Color(hex: "#E1F5FE"), Color(hex: "#B3E5FC")], iconName: "diamond.fill")

    static let solar = Theme(id: "solar", name: "Solar", colors: ThemeColors(
        background: "#FFF8E1", surface: "#FFFFFF", primary: "#FF8F00", secondary: "#FFB300",
        accent: "#FF8F00", text: "#3E2723", textSecondary: "#BF360C", textMuted: "#FFE082",
        textOnPrimary: "#FFFFFF", cardBorder: "#FF8F00", cardBackground: "#FFFFFF",
        cardHighlight: "#FFF3C4", cardSelected: "#FFB300", success: "#43A047", warning: "#FF8F00", error: "#D32F2F"
    ), isDark: false, gradientColors: [Color(hex: "#FFF8E1"), Color(hex: "#FFF3C4"), Color(hex: "#FFE082")], iconName: "sun.max.fill")

    static let midnight = Theme(id: "midnight", name: "Midnight", colors: ThemeColors(
        background: "#0D1B2A", surface: "#1B2838", primary: "#415A77", secondary: "#778DA9",
        accent: "#415A77", text: "#E0E1DD", textSecondary: "#778DA9", textMuted: "#1B2838",
        textOnPrimary: "#E0E1DD", cardBorder: "#415A77", cardBackground: "#1B2838",
        cardHighlight: "#253545", cardSelected: "#415A77", success: "#52B788", warning: "#F4A261", error: "#E76F51"
    ), isDark: true, gradientColors: [Color(hex: "#0D1B2A"), Color(hex: "#1B2838"), Color(hex: "#253545")], iconName: "moon.fill")

    static let magma = Theme(id: "magma", name: "Magma", colors: ThemeColors(
        background: "#1A0A0A", surface: "#241414", primary: "#FF6B35", secondary: "#FF9F1C",
        accent: "#FF6B35", text: "#FFE0CC", textSecondary: "#FF9F1C", textMuted: "#4A2020",
        textOnPrimary: "#1A0A0A", cardBorder: "#3A1A1A", cardBackground: "#241414",
        cardHighlight: "#2A1818", cardSelected: "#FF6B35", success: "#68D391", warning: "#F6E05E", error: "#FF6B35"
    ), isDark: true, gradientColors: [Color(hex: "#1A0A0A"), Color(hex: "#241414"), Color(hex: "#2A1818")], iconName: "flame.fill")

    static let quantum = Theme(id: "quantum", name: "Quantum", colors: ThemeColors(
        background: "#0A0A1A", surface: "#12122A", primary: "#7C3AED", secondary: "#A78BFA",
        accent: "#7C3AED", text: "#EDE9FE", textSecondary: "#A78BFA", textMuted: "#312E81",
        textOnPrimary: "#FFFFFF", cardBorder: "#1A1A3A", cardBackground: "#12122A",
        cardHighlight: "#161630", cardSelected: "#7C3AED", success: "#34D399", warning: "#FBBF24", error: "#F87171"
    ), isDark: true, gradientColors: [Color(hex: "#0A0A1A"), Color(hex: "#12122A"), Color(hex: "#161630")], iconName: "atom")

    static let all: [Theme] = [blueprint, neon, copper, silicon, retro, crystal, solar, midnight, magma, quantum]
    static let `default` = blueprint
    static func theme(for id: String) -> Theme { all.first { $0.id == id } ?? `default` }
}
