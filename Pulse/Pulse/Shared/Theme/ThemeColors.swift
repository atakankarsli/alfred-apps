import SwiftUI

struct ThemeColors: Sendable {
    let background: Color
    let surface: Color
    let primary: Color
    let secondary: Color
    let accent: Color
    let text: Color
    let textSecondary: Color
    let textMuted: Color
    let textOnPrimary: Color
    let cardBorder: Color
    let cardBackground: Color
    let cardHighlight: Color
    let cardSelected: Color
    let success: Color
    let warning: Color
    let error: Color

    init(
        background: String, surface: String, primary: String, secondary: String,
        accent: String, text: String, textSecondary: String, textMuted: String,
        textOnPrimary: String, cardBorder: String, cardBackground: String,
        cardHighlight: String, cardSelected: String, success: String,
        warning: String, error: String
    ) {
        self.background = Color(hex: background)
        self.surface = Color(hex: surface)
        self.primary = Color(hex: primary)
        self.secondary = Color(hex: secondary)
        self.accent = Color(hex: accent)
        self.text = Color(hex: text)
        self.textSecondary = Color(hex: textSecondary)
        self.textMuted = Color(hex: textMuted)
        self.textOnPrimary = Color(hex: textOnPrimary)
        self.cardBorder = Color(hex: cardBorder)
        self.cardBackground = Color(hex: cardBackground)
        self.cardHighlight = Color(hex: cardHighlight)
        self.cardSelected = Color(hex: cardSelected)
        self.success = Color(hex: success)
        self.warning = Color(hex: warning)
        self.error = Color(hex: error)
    }
}
