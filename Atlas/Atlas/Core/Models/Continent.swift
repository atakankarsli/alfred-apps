import SwiftUI

enum Continent: String, CaseIterable, Identifiable, Sendable {
    case europa, terra, sahara, nova, oceania

    var id: String { rawValue }
    var displayName: String {
        switch self { case .europa: "Europa"; case .terra: "Terra"; case .sahara: "Sahara"; case .nova: "Nova"; case .oceania: "Oceania" }
    }
    var subtitle: String {
        switch self { case .europa: "Europe"; case .terra: "Asia"; case .sahara: "Africa"; case .nova: "Americas"; case .oceania: "Oceania" }
    }
    var icon: String {
        switch self { case .europa: "globe.europe.africa.fill"; case .terra: "globe.asia.australia.fill"; case .sahara: "globe.europe.africa.fill"; case .nova: "globe.americas.fill"; case .oceania: "globe.asia.australia.fill" }
    }
    var color: Color {
        switch self { case .europa: Color(hex: "2B6CB0"); case .terra: Color(hex: "E53E3E"); case .sahara: Color(hex: "D69E2E"); case .nova: Color(hex: "2D6A4F"); case .oceania: Color(hex: "805AD5") }
    }
    var levelRange: Range<Int> {
        switch self { case .europa: 0..<16; case .terra: 16..<32; case .sahara: 32..<48; case .nova: 48..<64; case .oceania: 64..<80 }
    }
}
