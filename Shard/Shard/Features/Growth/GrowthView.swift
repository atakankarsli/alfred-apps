import SwiftUI
import SwiftData

struct GrowthView: View {
    @Environment(\.theme) private var theme
    @Environment(AppState.self) private var appState
    @Environment(\.modelContext) private var modelContext
    @Query private var stats: [StatsRecord]

    let crystalIndex: Int
    @State private var viewModel = GrowthViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                crystalPreview
                if viewModel.showResult, let crystal = viewModel.grownCrystal {
                    resultSection(crystal)
                } else {
                    controlsSection
                    if viewModel.isGrowing { growthProgressView }
                    else { growButton }
                }
            }
            .padding(16)
        }
        .themedBackground()
        .navigationTitle("Grow Crystal")
        .onDisappear { viewModel.reset() }
    }

    private var crystalPreview: some View {
        ZStack {
            Circle()
                .fill(viewModel.params.selectedType.color.opacity(0.08))
                .frame(width: 180, height: 180)

            CrystalShapeView(
                type: viewModel.params.selectedType,
                progress: viewModel.isGrowing ? viewModel.growthProgress : (viewModel.showResult ? 1.0 : 0.3),
                quality: viewModel.grownCrystal?.quality ?? 0.5
            )
            .frame(width: 120, height: 120)
        }
        .padding(.top, 8)
    }

    private var controlsSection: some View {
        VStack(spacing: 16) {
            crystalTypePicker
            sliderControl(label: "Temperature", value: $viewModel.params.temperature, icon: "thermometer.medium", color: .red)
            sliderControl(label: "Pressure", value: $viewModel.params.pressure, icon: "gauge.medium", color: .blue)
            optimalHint
        }
    }

    private var crystalTypePicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Crystal Seed")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .primaryText()

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(CrystalType.allCases) { type in
                        Button {
                            viewModel.params.selectedType = type
                            HapticsService.selection()
                        } label: {
                            VStack(spacing: 4) {
                                Circle().fill(type.color).frame(width: 28, height: 28)
                                Text(type.displayName)
                                    .font(.system(size: 10, weight: .medium))
                                    .lineLimit(1)
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 8)
                            .background {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(viewModel.params.selectedType == type ? type.color.opacity(0.15) : theme.colors.surface.opacity(0.3))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 10)
                                            .strokeBorder(viewModel.params.selectedType == type ? type.color.opacity(0.4) : .clear, lineWidth: 1.5)
                                    }
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .padding(14)
        .background {
            RoundedRectangle(cornerRadius: 14)
                .fill(theme.colors.surface.opacity(0.4))
                .overlay { RoundedRectangle(cornerRadius: 14).strokeBorder(theme.colors.cardBorder.opacity(0.12), lineWidth: 1) }
        }
    }

    private func sliderControl(label: String, value: Binding<Double>, icon: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon).foregroundStyle(color)
                Text(label).font(.system(size: 14, weight: .bold, design: .rounded)).primaryText()
                Spacer()
                Text("\(Int(value.wrappedValue * 100))%")
                    .font(.system(size: 13, weight: .medium, design: .monospaced))
                    .secondaryText()
            }
            Slider(value: value, in: 0...1, step: 0.01)
                .tint(color)
        }
        .padding(14)
        .background {
            RoundedRectangle(cornerRadius: 14)
                .fill(theme.colors.surface.opacity(0.4))
                .overlay { RoundedRectangle(cornerRadius: 14).strokeBorder(theme.colors.cardBorder.opacity(0.12), lineWidth: 1) }
        }
    }

    private var optimalHint: some View {
        let range = CrystalEngine.optimalRange(for: viewModel.params.selectedType)
        return HStack(spacing: 6) {
            Image(systemName: "lightbulb.fill").font(.system(size: 12)).foregroundStyle(.yellow)
            Text("Optimal: Temp \(Int(range.tempMin * 100))-\(Int(range.tempMax * 100))%, Press \(Int(range.pressMin * 100))-\(Int(range.pressMax * 100))%")
                .font(.system(size: 12))
                .secondaryText()
        }
        .padding(10)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(theme.colors.surface.opacity(0.3))
        }
    }

    private var growthProgressView: some View {
        VStack(spacing: 10) {
            ProgressView(value: viewModel.growthProgress)
                .tint(viewModel.params.selectedType.color)
            Text("Growing...")
                .font(.system(size: 14, weight: .medium))
                .secondaryText()
        }
        .padding(14)
    }

    private var growButton: some View {
        GlassButton("Start Growth", icon: "sparkle") {
            viewModel.startGrowth()
        }
        .padding(.horizontal, 16)
    }

    private func resultSection(_ crystal: Crystal) -> some View {
        VStack(spacing: 14) {
            HStack(spacing: 2) {
                ForEach(0..<3, id: \.self) { i in
                    Image(systemName: i < crystal.stars ? "star.fill" : "star")
                        .font(.system(size: 24))
                        .foregroundStyle(i < crystal.stars ? .yellow : theme.colors.textMuted)
                }
            }

            Text(crystal.type.displayName)
                .font(.system(size: 22, weight: .black, design: .rounded))
                .primaryText()

            VStack(spacing: 6) {
                statRow("Quality", "\(Int(crystal.quality * 100))%")
                statRow("Size", String(format: "%.1fcm", crystal.size * 10))
                statRow("Clarity", "\(Int(crystal.clarity * 100))%")
                statRow("Facets", "\(crystal.facets)")
                statRow("XP Earned", "+\(crystal.xp)")
            }
            .padding(14)
            .background {
                RoundedRectangle(cornerRadius: 14)
                    .fill(theme.colors.surface.opacity(0.4))
                    .overlay { RoundedRectangle(cornerRadius: 14).strokeBorder(theme.colors.cardBorder.opacity(0.12), lineWidth: 1) }
            }

            HStack(spacing: 12) {
                GlassButton("Collect", icon: "tray.full.fill") {
                    viewModel.saveCrystal(stats: stats.first, context: modelContext)
                    appState.pop()
                }
                GlassButton("Grow Again", icon: "arrow.counterclockwise", style: .secondary) {
                    viewModel.reset()
                }
            }
        }
    }

    private func statRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label).font(.system(size: 14)).secondaryText()
            Spacer()
            Text(value).font(.system(size: 14, weight: .semibold, design: .rounded)).primaryText()
        }
    }
}

struct CrystalShapeView: View {
    let type: CrystalType
    let progress: Double
    let quality: Double

    var body: some View {
        ZStack {
            ForEach(0..<type.facetCount, id: \.self) { i in
                let angle = Double(i) / Double(type.facetCount) * 360
                let scale = 0.3 + progress * 0.7
                let opacity = 0.3 + quality * 0.5

                RoundedRectangle(cornerRadius: 4)
                    .fill(type.color.opacity(opacity))
                    .frame(width: 20 * scale, height: 50 * scale)
                    .rotationEffect(.degrees(angle))
                    .offset(y: -15 * scale)
            }

            Circle()
                .fill(type.color.opacity(0.6 + quality * 0.3))
                .frame(width: 30 * (0.3 + progress * 0.7), height: 30 * (0.3 + progress * 0.7))
        }
        .animation(.easeInOut(duration: 0.3), value: progress)
    }
}
