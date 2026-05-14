import Foundation

enum MissionGenerator {
    static func mission(for level: Int) -> Mission { Mission.generate(index: level) }
}

struct Mission {
    let index: Int
    let title: String
    let type: MissionType
    let objectives: [Objective]
    let region: Region
    let xpReward: Int
    let gridSize: Int
    let fogPattern: [Bool]

    var totalObjectives: Int { objectives.count }

    struct Objective: Identifiable {
        let id: Int
        let description: String
        let icon: String
        let type: ObjectiveType
    }

    enum ObjectiveType: String {
        case explore
        case photo
        case checkpoint
        case discover
        case observe
    }

    func completionScore(completed: Int) -> Double {
        guard totalObjectives > 0 else { return 0 }
        return Double(completed) / Double(totalObjectives)
    }

    static func generate(index: Int) -> Mission {
        var rng = SeededRNG(seed: UInt64(index * 31337 + 2027))
        let region = Region.regionForMission(index)
        let type = region.missionTypes[Int.random(in: 0..<region.missionTypes.count, using: &rng)]
        let gridSize = gridSizeFor(regionId: region.id)
        let objectiveCount = objectiveCountFor(regionId: region.id, rng: &rng)
        let total = gridSize * gridSize
        let fogPattern = (0..<total).map { _ in Bool.random(using: &rng) }
        let title = missionTitle(type: type, index: index, rng: &rng)
        let objectives = (0..<objectiveCount).map { i in
            objectiveFor(type: type, index: i, rng: &rng)
        }
        let xp = QuestConfig.xpForMission(stars: 3, regionId: region.id)

        return Mission(
            index: index, title: title, type: type, objectives: objectives,
            region: region, xpReward: xp, gridSize: gridSize, fogPattern: fogPattern
        )
    }

    private static func gridSizeFor(regionId: Int) -> Int {
        [4, 5, 5, 6, 6][min(regionId, 4)]
    }

    private static func objectiveCountFor(regionId: Int, rng: inout SeededRNG) -> Int {
        let base = [3, 4, 4, 5, 6][min(regionId, 4)]
        return base + Int.random(in: 0...1, using: &rng)
    }

    private static func missionTitle(type: MissionType, index: Int, rng: inout SeededRNG) -> String {
        let titles: [MissionType: [String]] = [
            .explore: ["Urban Wanderer", "Hidden Path", "Street Seeker", "Neighborhood Scout", "City Walker",
                       "Alley Explorer", "Corner Finder", "District Drift", "Block Breaker", "Path Finder"],
            .photo: ["Light Catcher", "Shadow Hunt", "Color Snap", "Detail Focus", "Perspective Shift",
                     "Frame Finder", "Texture Hunt", "Pattern Eye", "Golden Hour", "Street Portrait"],
            .checkpoint: ["Rally Point", "Waypoint Run", "Marker Chase", "Beacon Trail", "Signal Path",
                         "Pin Drop", "Node Runner", "Station Hop", "Route Master", "Ring Circuit"],
            .discover: ["Hidden Gem", "Secret Spot", "Unknown Corner", "Mystery Place", "Lost Find",
                       "Unseen View", "Buried Treasure", "Off the Map", "Terra Nova", "First Steps"],
            .observe: ["Sky Watch", "People Count", "Nature Note", "Sound Map", "Weather Log",
                      "Bird Spot", "Cloud Atlas", "Wind Reader", "Sun Tracker", "Night Watch"],
        ]
        let list = titles[type] ?? titles[.explore]!
        return list[index % list.count]
    }

    private static func objectiveFor(type: MissionType, index: Int, rng: inout SeededRNG) -> Objective {
        let objectives: [MissionType: [(String, String, ObjectiveType)]] = [
            .explore: [
                ("Walk 3 new blocks", "figure.walk", .explore),
                ("Find a park or garden", "leaf.fill", .discover),
                ("Reach a landmark", "mappin.and.ellipse", .checkpoint),
                ("Walk down a street you've never been on", "arrow.triangle.turn.up.right.diamond", .explore),
                ("Find a bridge or overpass", "road.lanes", .discover),
                ("Discover a mural or street art", "paintpalette.fill", .discover),
            ],
            .photo: [
                ("Photograph a reflection", "camera.fill", .photo),
                ("Capture an interesting shadow", "sun.max.fill", .photo),
                ("Find and snap a pattern", "circle.grid.3x3.fill", .photo),
                ("Take a photo from an unusual angle", "rotate.3d", .photo),
                ("Photograph something red", "circle.fill", .photo),
                ("Capture a symmetrical scene", "rectangle.split.2x1", .photo),
            ],
            .checkpoint: [
                ("Reach the nearest park", "leaf.circle.fill", .checkpoint),
                ("Find a cafe or restaurant", "cup.and.saucer.fill", .checkpoint),
                ("Visit a bookstore or library", "book.fill", .checkpoint),
                ("Reach a bus stop or station", "bus.fill", .checkpoint),
                ("Find a fountain or water feature", "drop.fill", .checkpoint),
                ("Reach the highest point nearby", "mountain.2.fill", .checkpoint),
            ],
            .discover: [
                ("Find a historical marker", "building.columns.fill", .discover),
                ("Discover a quiet alley", "figure.walk", .discover),
                ("Find a tree older than you", "tree.fill", .discover),
                ("Spot an animal in the wild", "hare.fill", .discover),
                ("Find something unexpected", "questionmark.circle.fill", .discover),
                ("Discover a hidden courtyard", "door.left.hand.open", .discover),
            ],
            .observe: [
                ("Count 5 different bird species", "bird.fill", .observe),
                ("Note the wind direction", "wind", .observe),
                ("Find 3 types of flowers", "camera.macro", .observe),
                ("Listen to 3 different sounds", "ear.fill", .observe),
                ("Watch the sky for 2 minutes", "cloud.sun.fill", .observe),
                ("Find an insect", "ant.fill", .observe),
            ],
        ]
        let list = objectives[type] ?? objectives[.explore]!
        let item = list[index % list.count]
        return Objective(id: index, description: item.0, icon: item.1, type: item.2)
    }
}

struct SeededRNG: RandomNumberGenerator {
    private var state: UInt64
    init(seed: UInt64) { state = seed == 0 ? 1 : seed }
    mutating func next() -> UInt64 {
        state &+= 0x9E3779B97F4A7C15
        var z = state
        z = (z ^ (z >> 30)) &* 0xBF58476D1CE4E5B9
        z = (z ^ (z >> 27)) &* 0x94D049BB133111EB
        return z ^ (z >> 31)
    }
}
