import Foundation

struct Star: Sendable {
    let position: CGPoint
    let magnitude: Double
}

struct StarConnection: Sendable {
    let from: Int
    let to: Int
}

struct Constellation: Sendable {
    let name: String
    let latinName: String
    let stars: [Star]
    let connections: [StarConnection]
    let difficulty: Int

    var starCount: Int { stars.count }
    var connectionCount: Int { connections.count }
}
