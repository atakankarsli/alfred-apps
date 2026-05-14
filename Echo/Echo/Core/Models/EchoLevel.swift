import Foundation

struct EchoLevel {
    let index: Int
    let sequenceLength: Int
    let buttonCount: Int
    let tempo: Double
    let replaysAllowed: Int
    let timeLimit: Int?
    let lives: Int

    var realm: SonicRealm {
        SonicRealm(rawValue: index / 16) ?? .tones
    }

    var levelInRealm: Int {
        index % 16
    }

    var displayNumber: Int {
        index + 1
    }
}

enum LevelData {
    static func level(_ index: Int) -> EchoLevel {
        let realm = index / 16
        let lvl = index % 16

        let baseLength = 3 + lvl / 2
        let buttons: Int
        let tempo: Double
        let replays: Int
        let timeLimit: Int?

        switch realm {
        case 0:
            buttons = min(4 + lvl / 8, 6)
            tempo = 100 + Double(lvl) * 5
            replays = lvl < 8 ? 2 : (lvl < 12 ? 1 : 0)
            timeLimit = lvl > 12 ? 30 : nil
        case 1:
            buttons = min(5 + lvl / 6, 8)
            tempo = 90 + Double(lvl) * 8
            replays = lvl < 6 ? 2 : (lvl < 10 ? 1 : 0)
            timeLimit = lvl > 10 ? 25 : nil
        case 2:
            buttons = 4
            tempo = 120 + Double(lvl) * 10
            replays = lvl < 4 ? 2 : (lvl < 8 ? 1 : 0)
            timeLimit = lvl > 8 ? 20 : nil
        case 3:
            buttons = min(4 + lvl / 4, 7)
            tempo = 80 + Double(lvl) * 6
            replays = lvl < 6 ? 1 : 0
            timeLimit = lvl > 6 ? 30 : nil
        default:
            buttons = min(6 + lvl / 4, 8)
            tempo = 100 + Double(lvl) * 12
            replays = lvl < 4 ? 1 : 0
            timeLimit = 20
        }

        return EchoLevel(
            index: index,
            sequenceLength: baseLength,
            buttonCount: buttons,
            tempo: tempo,
            replaysAllowed: replays,
            timeLimit: timeLimit,
            lives: 3
        )
    }
}
