import SwiftUI

struct ThemeColors: Sendable {
    let background: Color; let surface: Color; let primary: Color; let secondary: Color
    let accent: Color; let text: Color; let textSecondary: Color; let textMuted: Color
    let textOnPrimary: Color; let boardBorder: Color; let cellBackground: Color
    let cellHighlight: Color; let cellSelected: Color
}
extension ThemeColors {
    init(background: String, surface: String, primary: String, secondary: String, accent: String,
         text: String, textSecondary: String, textMuted: String, textOnPrimary: String,
         boardBorder: String, cellBackground: String, cellHighlight: String, cellSelected: String) {
        self.background = Color(hex: background); self.surface = Color(hex: surface)
        self.primary = Color(hex: primary); self.secondary = Color(hex: secondary)
        self.accent = Color(hex: accent); self.text = Color(hex: text)
        self.textSecondary = Color(hex: textSecondary); self.textMuted = Color(hex: textMuted)
        self.textOnPrimary = Color(hex: textOnPrimary); self.boardBorder = Color(hex: boardBorder)
        self.cellBackground = Color(hex: cellBackground); self.cellHighlight = Color(hex: cellHighlight)
        self.cellSelected = Color(hex: cellSelected)
    }
}
