import SwiftUI
import SwiftData

struct ElementMapView: View {
    @Environment(\.theme) private var theme
    @Environment(AppState.self) private var appState
    @Query private var statsRecords: [StatsRecord]
    private var stats: StatsRecord? { statsRecords.first }

    var body: some View {
        ZStack {
            FloatingOrbsView()
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(FlowZone.allCases) { zone in
                        zoneCard(zone)
                    }
                }
                .padding()
            }
        }
        .themedBackground()
        .navigationTitle("Flow Zones")
    }

    private func zoneCard(_ zone: FlowZone) -> some View {
        GlassCard {
            VStack(spacing: 12) {
                HStack {
                    Image(systemName: zone.icon).font(.title2).foregroundStyle(zone.color)
                    VStack(alignment: .leading) {
                        Text(zone.displayName).font(.headline).primaryText()
                        Text("Levels \(zone.levelRange.lowerBound + 1)–\(zone.levelRange.upperBound)")
                            .font(.caption).secondaryText()
                    }
                    Spacer()
                }
                ProgressView(value: Double(min(stats?.flowsCompleted ?? 0, 16)), total: 16).tint(zone.color)
                LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 8), spacing: 6) {
                    ForEach(zone.levelRange, id: \.self) { level in
                        let el = FluidElement.allCases[level % FluidElement.allCases.count]
                        Button { appState.path.append(Route.flow(element: el, level: level)) } label: {
                            RoundedRectangle(cornerRadius: 4).fill(zone.color.opacity(0.3)).frame(height: 28)
                                .overlay { Text("\(level - zone.levelRange.lowerBound + 1)").font(.system(size: 10, weight: .bold)).foregroundStyle(theme.colors.text) }
                        }
                        .buttonStyle(ScaleButtonStyle())
                    }
                }
            }
        }
    }
}
