import SwiftUI
import SwiftData

struct CollectionView: View {
    @Environment(\.theme) private var theme
    @Query private var stats: [StatsRecord]

    private var s: StatsRecord? { stats.first }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                summarySection
                familyBreakdown
            }
            .padding(16)
        }
        .themedBackground()
        .navigationTitle("Collection")
    }

    private var summarySection: some View {
        VStack(spacing: 8) {
            Text("\(s?.crystalsGrown ?? 0)")
                .font(.system(size: 48, weight: .black, design: .rounded))
                .foregroundStyle(theme.colors.accent)
            Text("Crystals Grown")
                .font(.system(size: 15, weight: .medium))
                .secondaryText()

            HStack(spacing: 20) {
                statPill("Types", "\(s?.typesGrown.count ?? 0)/\(CrystalType.allCases.count)")
                statPill("Families", "\(s?.familiesPlayed.count ?? 0)/5")
                statPill("3-Star", "\(s?.threeStarCount ?? 0)")
            }
        }
        .padding(20)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(theme.colors.accent.opacity(0.06))
                .overlay { RoundedRectangle(cornerRadius: 16).strokeBorder(theme.colors.accent.opacity(0.15), lineWidth: 1) }
        }
    }

    private func statPill(_ label: String, _ value: String) -> some View {
        VStack(spacing: 2) {
            Text(value).font(.system(size: 16, weight: .bold, design: .rounded)).primaryText()
            Text(label).font(.system(size: 11)).mutedText()
        }
    }

    private var familyBreakdown: some View {
        VStack(spacing: 10) {
            ForEach(MineralFamily.all, id: \.id) { family in
                familyRow(family)
            }
        }
    }

    private func familyRow(_ family: MineralFamily) -> some View {
        let familyColor = Color(hex: family.accentHex)
        let count = familyCount(family)
        let typesUnlocked = family.crystalTypes.filter { s?.typesGrown.contains($0.rawValue) ?? false }

        return VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: family.icon)
                    .font(.system(size: 18))
                    .foregroundStyle(familyColor)
                VStack(alignment: .leading, spacing: 2) {
                    Text(family.name)
                        .font(.system(size: 15, weight: .bold, design: .rounded))
                        .primaryText()
                    Text(family.subtitle)
                        .font(.system(size: 12))
                        .mutedText()
                }
                Spacer()
                Text("\(count)")
                    .font(.system(size: 18, weight: .black, design: .rounded))
                    .foregroundStyle(familyColor)
            }

            HStack(spacing: 6) {
                ForEach(family.crystalTypes, id: \.self) { type in
                    let unlocked = typesUnlocked.contains(type)
                    Circle()
                        .fill(unlocked ? type.color : theme.colors.textMuted.opacity(0.2))
                        .frame(width: 20, height: 20)
                        .overlay {
                            if unlocked {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 9, weight: .bold))
                                    .foregroundStyle(.white)
                            }
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

    private func familyCount(_ family: MineralFamily) -> Int {
        switch family.id {
        case 0: s?.quartzGrown ?? 0
        case 1: s?.berylGrown ?? 0
        case 2: s?.corundumGrown ?? 0
        case 3: s?.fluoriteGrown ?? 0
        case 4: s?.carbonGrown ?? 0
        default: 0
        }
    }
}
