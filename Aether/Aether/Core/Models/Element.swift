import Foundation

struct Element: Identifiable, Hashable, Sendable {
    let id: String
    let name: String
    let icon: String
    let realm: AlchemyRealm
    let tier: Int
    let recipe: (String, String)?

    var isBase: Bool { recipe == nil }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Element, rhs: Element) -> Bool {
        lhs.id == rhs.id
    }
}
