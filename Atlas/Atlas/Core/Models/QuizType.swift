import SwiftUI

enum QuizType: String, CaseIterable, Identifiable, Sendable {
    case flag, capital, mapShape, landmark

    var id: String { rawValue }
    var displayName: String {
        switch self { case .flag: "Flags"; case .capital: "Capitals"; case .mapShape: "Map Shapes"; case .landmark: "Landmarks" }
    }
    var icon: String {
        switch self { case .flag: "flag.fill"; case .capital: "building.columns.fill"; case .mapShape: "map.fill"; case .landmark: "photo.fill" }
    }
    var color: Color {
        switch self { case .flag: Color(hex: "E53E3E"); case .capital: Color(hex: "2D6A4F"); case .mapShape: Color(hex: "2B6CB0"); case .landmark: Color(hex: "B7791F") }
    }
    var description: String {
        switch self { case .flag: "Name the country from its flag"; case .capital: "Match capitals to countries"; case .mapShape: "Identify countries by outline"; case .landmark: "Guess the country from landmarks" }
    }
}
