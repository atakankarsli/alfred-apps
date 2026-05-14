import SwiftUI

struct Spectrum: Identifiable {
    let id: Int
    let name: String
    let subtitle: String
    let icon: String
    let levelRange: Range<Int>
    let accentHex: String

    var levelCount: Int { levelRange.count }
    var firstLevel: Int { levelRange.lowerBound }

    static let all: [Spectrum] = [
        Spectrum(id: 0, name: "First Light", subtitle: "Basic Optics", icon: "sun.max.fill", levelRange: 0..<16, accentHex: "FF3B30"),
        Spectrum(id: 1, name: "Refraction", subtitle: "Bending Beams", icon: "triangle.fill", levelRange: 16..<32, accentHex: "34C759"),
        Spectrum(id: 2, name: "Chromatic", subtitle: "Color Mixing", icon: "paintpalette.fill", levelRange: 32..<48, accentHex: "5856D6"),
        Spectrum(id: 3, name: "Prismatic", subtitle: "Complex Paths", icon: "diamond.fill", levelRange: 48..<64, accentHex: "FF9500"),
        Spectrum(id: 4, name: "Luminance", subtitle: "Master of Light", icon: "sparkles", levelRange: 64..<80, accentHex: "AF52DE"),
    ]

    static func spectrumForLevel(_ level: Int) -> Spectrum {
        all.first { $0.levelRange.contains(level) } ?? all[0]
    }

    static func localIndex(forLevel level: Int) -> Int {
        let spectrum = spectrumForLevel(level)
        return level - spectrum.firstLevel
    }
}
