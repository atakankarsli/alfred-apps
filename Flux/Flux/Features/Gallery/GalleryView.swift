import SwiftUI
import SwiftData

struct GalleryView: View {
    @Environment(\.theme) private var theme
    @Query private var statsRecords: [StatsRecord]
    private var stats: StatsRecord? { statsRecords.first }

    var body: some View {
        ZStack {
            FloatingOrbsView()
            ScrollView {
                VStack(spacing: 16) {
                    GlassCard {
                        VStack(spacing: 8) {
                            Image(systemName: "photo.on.rectangle").font(.title).foregroundStyle(theme.colors.primary)
                            Text("Flow Gallery").font(.title2.bold()).primaryText()
                            Text("\(stats?.flowsCompleted ?? 0) flows created").font(.subheadline).secondaryText()
                        }
                        .frame(maxWidth: .infinity)
                    }
                    LazyVGrid(columns: [.init(.flexible()), .init(.flexible()), .init(.flexible())], spacing: 12) {
                        ForEach(0..<min(stats?.flowsCompleted ?? 0, 30), id: \.self) { i in
                            let element = FluidElement.allCases[i % FluidElement.allCases.count]
                            RoundedRectangle(cornerRadius: 12)
                                .fill(element.baseColor.opacity(0.3).gradient)
                                .frame(height: 100)
                                .overlay {
                                    VStack {
                                        Image(systemName: element.icon).foregroundStyle(element.baseColor)
                                        Text(element.displayName).font(.caption2).secondaryText()
                                    }
                                }
                        }
                    }
                }
                .padding()
            }
        }
        .themedBackground()
        .navigationTitle("Gallery")
    }
}
