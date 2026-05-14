import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.theme) private var theme
    @Environment(\.modelContext) private var context
    @State private var page = 0

    var body: some View {
        ZStack {
            FloatingOrbsView()
            TabView(selection: $page) {
                welcomePage.tag(0)
                elementsPage.tag(1)
                startPage.tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
        }
        .themedBackground()
    }

    private var welcomePage: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: "drop.fill").font(.system(size: 64)).foregroundStyle(theme.colors.primary)
                .padding(32).background(Circle().fill(theme.colors.primary.opacity(0.15)))
            Text("Welcome to Flux").font(.largeTitle.bold()).primaryText()
            Text("Interactive fluid dynamics.\nPour, mix, create.").font(.body).multilineTextAlignment(.center).secondaryText()
            Spacer()
            GlassButton("Next", icon: "arrow.right") { withAnimation { page = 1 } }
        }
        .padding(32)
    }

    private var elementsPage: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("5 Elements").font(.title.bold()).primaryText()
            ForEach(FluidElement.allCases) { el in
                HStack(spacing: 12) {
                    Image(systemName: el.icon).font(.title3).foregroundStyle(el.baseColor)
                        .frame(width: 40, height: 40).background(Circle().fill(el.baseColor.opacity(0.15)))
                    VStack(alignment: .leading, spacing: 2) {
                        Text(el.displayName).font(.headline).primaryText()
                        Text("Viscosity: \(el.viscosity, specifier: "%.1f")").font(.caption).secondaryText()
                    }
                    Spacer()
                }
                .padding(.horizontal)
            }
            Spacer()
            GlassButton("Next", icon: "arrow.right") { withAnimation { page = 2 } }
        }
        .padding(32)
    }

    private var startPage: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: "waveform.path").font(.system(size: 64)).foregroundStyle(theme.colors.accent)
                .padding(32).background(Circle().fill(theme.colors.accent.opacity(0.15)))
            Text("Ready to Flow?").font(.largeTitle.bold()).primaryText()
            Text("Touch the canvas.\nWatch the magic unfold.").font(.body).multilineTextAlignment(.center).secondaryText()
            Spacer()
            GlassButton("Let's Flow!", icon: "arrow.right") {
                let settings = SettingsRecord(); settings.onboardingDone = true
                context.insert(settings); try? context.save()
                NotificationService.requestPermission()
            }
        }
        .padding(32)
    }
}
