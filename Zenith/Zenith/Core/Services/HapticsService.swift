import SwiftUI

@MainActor
enum HapticsService {
    private static var isEnabled: Bool = true
    private static let selectionGenerator = UISelectionFeedbackGenerator()
    private static let lightGenerator = UIImpactFeedbackGenerator(style: .light)
    private static let mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
    private static let heavyGenerator = UIImpactFeedbackGenerator(style: .heavy)
    private static let notificationGenerator = UINotificationFeedbackGenerator()

    static func configure(enabled: Bool) { isEnabled = enabled }
    static func selection() { guard isEnabled else { return }; selectionGenerator.selectionChanged() }
    static func light() { guard isEnabled else { return }; lightGenerator.impactOccurred() }
    static func medium() { guard isEnabled else { return }; mediumGenerator.impactOccurred() }
    static func heavy() { guard isEnabled else { return }; heavyGenerator.impactOccurred() }
    static func success() { guard isEnabled else { return }; notificationGenerator.notificationOccurred(.success) }
    static func error() { guard isEnabled else { return }; notificationGenerator.notificationOccurred(.error) }
}
