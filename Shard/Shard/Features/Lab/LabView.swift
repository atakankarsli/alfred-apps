import SwiftUI

struct LabView: View {
    @Environment(\.theme) private var theme
    @State private var temperature: Double = 0.5
    @State private var pressure: Double = 0.5
    @State private var selectedType: CrystalType = .amethyst

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                previewSection
                typeSelector
                parameterSection
                infoCards
            }
            .padding(16)
        }
        .themedBackground()
        .navigationTitle("Lab")
    }

    private var previewSection: some View {
        VStack(spacing: 8) {
            CrystalShapeView(type: selectedType, progress: 1.0, quality: estimatedQuality)
                .frame(width: 100, height: 100)

            Text("Est. Quality: \(Int(estimatedQuality * 100))%")
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundStyle(qualityColor)

            HStack(spacing: 2) {
                let stars = ShardConfig.starsForQuality(estimatedQuality)
                ForEach(0..<3, id: \.self) { i in
                    Image(systemName: i < stars ? "star.fill" : "star")
                        .font(.system(size: 16))
                        .foregroundStyle(i < stars ? .yellow : theme.colors.textMuted)
                }
            }
        }
        .padding(20)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(selectedType.color.opacity(0.06))
                .overlay { RoundedRectangle(cornerRadius: 16).strokeBorder(selectedType.color.opacity(0.15), lineWidth: 1) }
        }
    }

    private var typeSelector: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(CrystalType.allCases) { type in
                    Button {
                        selectedType = type
                        HapticsService.selection()
                    } label: {
                        HStack(spacing: 6) {
                            Circle().fill(type.color).frame(width: 14, height: 14)
                            Text(type.displayName)
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundStyle(selectedType == type ? type.color : theme.colors.textSecondary)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background {
                            Capsule()
                                .fill(selectedType == type ? type.color.opacity(0.12) : theme.colors.surface.opacity(0.3))
                                .overlay {
                                    Capsule().strokeBorder(selectedType == type ? type.color.opacity(0.3) : .clear, lineWidth: 1)
                                }
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var parameterSection: some View {
        VStack(spacing: 14) {
            labSlider("Temperature", value: $temperature, icon: "thermometer.medium", color: .red)
            labSlider("Pressure", value: $pressure, icon: "gauge.medium", color: .blue)
        }
    }

    private func labSlider(_ label: String, value: Binding<Double>, icon: String, color: Color) -> some View {
        let range = CrystalEngine.optimalRange(for: selectedType)
        let isTemp = label == "Temperature"
        let optMin = isTemp ? range.tempMin : range.pressMin
        let optMax = isTemp ? range.tempMax : range.pressMax
        let inRange = value.wrappedValue >= optMin && value.wrappedValue <= optMax

        return VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon).foregroundStyle(color)
                Text(label).font(.system(size: 14, weight: .bold, design: .rounded)).primaryText()
                Spacer()
                Text("\(Int(value.wrappedValue * 100))%")
                    .font(.system(size: 13, weight: .medium, design: .monospaced))
                    .foregroundStyle(inRange ? theme.colors.success : theme.colors.textSecondary)
                if inRange {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(theme.colors.success)
                }
            }
            Slider(value: value, in: 0...1, step: 0.01).tint(color)
            Text("Optimal: \(Int(optMin * 100))% – \(Int(optMax * 100))%")
                .font(.system(size: 11))
                .mutedText()
        }
        .padding(14)
        .background {
            RoundedRectangle(cornerRadius: 14)
                .fill(theme.colors.surface.opacity(0.4))
                .overlay { RoundedRectangle(cornerRadius: 14).strokeBorder(theme.colors.cardBorder.opacity(0.12), lineWidth: 1) }
        }
    }

    private var infoCards: some View {
        VStack(spacing: 10) {
            infoRow("Growth Rate", "\(String(format: "%.1f", selectedType.baseGrowthRate))x")
            infoRow("Facets", "\(selectedType.facetCount)")
            infoRow("Family", MineralFamily.all.first { $0.crystalTypes.contains(selectedType) }?.name ?? "–")
        }
        .padding(14)
        .background {
            RoundedRectangle(cornerRadius: 14)
                .fill(theme.colors.surface.opacity(0.4))
                .overlay { RoundedRectangle(cornerRadius: 14).strokeBorder(theme.colors.cardBorder.opacity(0.12), lineWidth: 1) }
        }
    }

    private func infoRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label).font(.system(size: 14)).secondaryText()
            Spacer()
            Text(value).font(.system(size: 14, weight: .semibold, design: .rounded)).primaryText()
        }
    }

    private var estimatedQuality: Double {
        let range = CrystalEngine.optimalRange(for: selectedType)
        let tScore = proximityScore(temperature, min: range.tempMin, max: range.tempMax)
        let pScore = proximityScore(pressure, min: range.pressMin, max: range.pressMax)
        return max(0, min(1, tScore * 0.5 + pScore * 0.5))
    }

    private var qualityColor: Color {
        if estimatedQuality >= 0.9 { return theme.colors.success }
        if estimatedQuality >= 0.65 { return theme.colors.accent }
        if estimatedQuality >= 0.35 { return theme.colors.warning }
        return theme.colors.error
    }

    private func proximityScore(_ value: Double, min: Double, max: Double) -> Double {
        let mid = (min + max) / 2
        let halfRange = (max - min) / 2
        let distance = abs(value - mid)
        if distance <= halfRange { return 1.0 }
        return Swift.max(0, 1.0 - (distance - halfRange) / 0.3)
    }
}
