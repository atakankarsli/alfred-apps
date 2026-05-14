import Foundation

enum FireRealm: Int, CaseIterable, Sendable {
    case hearth = 0
    case forge = 1
    case volcano = 2
    case aurora = 3
    case phoenix = 4

    var name: String {
        switch self {
        case .hearth: "Hearth"
        case .forge: "Forge"
        case .volcano: "Volcano"
        case .aurora: "Aurora"
        case .phoenix: "Phoenix"
        }
    }

    var icon: String {
        switch self {
        case .hearth: "house.fire"
        case .forge: "hammer.fill"
        case .volcano: "mountain.2.fill"
        case .aurora: "sun.horizon.fill"
        case .phoenix: "bird.fill"
        }
    }

    var subtitle: String {
        switch self {
        case .hearth: "Warmth of the home fire"
        case .forge: "Strength through discipline"
        case .volcano: "Intense inner focus"
        case .aurora: "Dawn light serenity"
        case .phoenix: "Rise from the ashes"
        }
    }

    var levelRange: Range<Int> {
        let start = rawValue * 16
        return start..<(start + 16)
    }
}
