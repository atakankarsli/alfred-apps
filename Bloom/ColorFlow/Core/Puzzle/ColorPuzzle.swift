import Foundation

struct Emotion: Identifiable, Hashable {
    let id: String
    let name: String
    let icon: String
    let colorHex: String
    let plantType: PlantType

    static let all: [Emotion] = [
        Emotion(id: "joy", name: "Joy", icon: "sun.max.fill", colorHex: "FFD93D", plantType: .sunflower),
        Emotion(id: "calm", name: "Calm", icon: "leaf.fill", colorHex: "6BCB77", plantType: .fern),
        Emotion(id: "love", name: "Love", icon: "heart.fill", colorHex: "FF6B6B", plantType: .rose),
        Emotion(id: "energy", name: "Energy", icon: "bolt.fill", colorHex: "FF8C42", plantType: .cactus),
        Emotion(id: "wonder", name: "Wonder", icon: "sparkles", colorHex: "9B5DE5", plantType: .orchid),
        Emotion(id: "peace", name: "Peace", icon: "cloud.fill", colorHex: "5BC0EB", plantType: .lily),
        Emotion(id: "focus", name: "Focus", icon: "scope", colorHex: "4A90D9", plantType: .bamboo),
        Emotion(id: "gratitude", name: "Gratitude", icon: "hands.sparkles.fill", colorHex: "F2A65A", plantType: .daisy),
    ]

    static func find(_ id: String) -> Emotion? {
        all.first { $0.id == id }
    }
}

enum PlantType: String, Codable, Hashable {
    case sunflower, fern, rose, cactus, orchid, lily, bamboo, daisy

    var stages: Int { 5 }

    var displayName: String {
        switch self {
        case .sunflower: "Sunflower"
        case .fern: "Fern"
        case .rose: "Rose"
        case .cactus: "Cactus"
        case .orchid: "Orchid"
        case .lily: "Lily"
        case .bamboo: "Bamboo"
        case .daisy: "Daisy"
        }
    }

    var growthIcons: [String] {
        switch self {
        case .sunflower: ["seedling", "leaf.fill", "leaf.fill", "sun.max.fill", "sun.max.fill"]
        case .fern: ["seedling", "leaf.fill", "leaf.fill", "tree.fill", "tree.fill"]
        case .rose: ["seedling", "leaf.fill", "camera.macro", "camera.macro", "heart.fill"]
        case .cactus: ["seedling", "leaf.fill", "bolt.fill", "bolt.fill", "bolt.circle.fill"]
        case .orchid: ["seedling", "leaf.fill", "sparkles", "sparkles", "star.fill"]
        case .lily: ["seedling", "drop.fill", "cloud.fill", "cloud.fill", "cloud.sun.fill"]
        case .bamboo: ["seedling", "leaf.fill", "scope", "scope", "circle.hexagongrid.fill"]
        case .daisy: ["seedling", "leaf.fill", "hands.sparkles.fill", "hands.sparkles.fill", "crown.fill"]
        }
    }
}

struct GardenPlant: Identifiable, Codable, Hashable {
    let id: String
    let emotionId: String
    let plantType: PlantType
    var growthStage: Int
    var waterCount: Int
    let plantedDate: String
    var position: Int

    var isFullyGrown: Bool { growthStage >= 4 }

    mutating func water() {
        waterCount += 1
        if waterCount >= waterNeeded && growthStage < 4 {
            growthStage += 1
            waterCount = 0
        }
    }

    var waterNeeded: Int {
        switch growthStage {
        case 0: 2
        case 1: 3
        case 2: 4
        case 3: 5
        default: 999
        }
    }

    var waterProgress: Double {
        guard !isFullyGrown else { return 1.0 }
        return Double(waterCount) / Double(waterNeeded)
    }
}

struct Garden: Codable {
    var plants: [GardenPlant]
    var gridSize: Int
    var seasonId: Int

    var totalCells: Int { gridSize * gridSize }
    var filledCells: Int { plants.count }
    var completionRatio: Double { Double(filledCells) / Double(totalCells) }
    var isComplete: Bool { filledCells >= totalCells }

    var fullyGrownCount: Int {
        plants.filter(\.isFullyGrown).count
    }

    static func generate(seasonIndex: Int, gardenIndex: Int) -> Garden {
        let gridSize: Int
        switch gardenIndex {
        case 0..<5: gridSize = 3
        case 5..<12: gridSize = 4
        case 12..<20: gridSize = 5
        default: gridSize = 4
        }

        return Garden(plants: [], gridSize: gridSize, seasonId: seasonIndex)
    }

    mutating func addPlant(emotion: Emotion, at position: Int) {
        guard position < totalCells else { return }
        guard !plants.contains(where: { $0.position == position }) else { return }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        let plant = GardenPlant(
            id: UUID().uuidString,
            emotionId: emotion.id,
            plantType: emotion.plantType,
            growthStage: 0,
            waterCount: 0,
            plantedDate: formatter.string(from: .now),
            position: position
        )
        plants.append(plant)
    }

    mutating func waterPlant(at position: Int) {
        guard let idx = plants.firstIndex(where: { $0.position == position }) else { return }
        plants[idx].water()
    }

    func plantAt(_ position: Int) -> GardenPlant? {
        plants.first { $0.position == position }
    }
}
