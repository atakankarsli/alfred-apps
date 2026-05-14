import SwiftUI
import SwiftData

struct FlowView: View {
    @Environment(\.theme) private var theme
    @Environment(\.modelContext) private var context
    @Environment(AppState.self) private var appState
    @State private var vm: FlowViewModel

    init(element: FluidElement, level: Int) {
        _vm = State(initialValue: FlowViewModel(element: element, level: level))
    }

    var body: some View {
        ZStack {
            theme.gradient.ignoresSafeArea()
            if vm.isFinished { completionView } else { gameplayView }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear { vm.start() }
    }

    private var gameplayView: some View {
        VStack(spacing: 0) {
            header.padding()
            particleCanvas
            footer.padding()
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(vm.challenge.title).font(.title3.bold()).primaryText()
                HStack(spacing: 4) {
                    Image(systemName: vm.challenge.element.icon).foregroundStyle(vm.challenge.element.baseColor)
                    Text(vm.challenge.element.displayName).font(.caption).secondaryText()
                }
            }
            Spacer()
            ZStack {
                Circle().stroke(theme.colors.surface.opacity(0.3), lineWidth: 3).frame(width: 50, height: 50)
                Circle().trim(from: 0, to: vm.timeRemaining / 30.0)
                    .stroke(vm.timeRemaining < 5 ? .red : theme.colors.primary, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                    .frame(width: 50, height: 50).rotationEffect(.degrees(-90))
                Text("\(Int(vm.timeRemaining))").font(.caption.bold().monospacedDigit()).primaryText()
            }
        }
    }

    private var particleCanvas: some View {
        GeometryReader { geo in
            Canvas { context, size in
                for p in vm.particles {
                    for (i, pos) in p.trail.enumerated() {
                        let opacity = Double(i) / Double(max(p.trail.count, 1)) * 0.3 * p.life
                        let trailSize = p.size * CGFloat(Double(i) / Double(max(p.trail.count, 1)))
                        let rect = CGRect(x: pos.0 * size.width - Double(trailSize / 2),
                                          y: pos.1 * size.height - Double(trailSize / 2),
                                          width: Double(trailSize), height: Double(trailSize))
                        context.opacity = opacity
                        context.fill(Path(ellipseIn: rect), with: .color(p.color))
                    }
                    let rect = CGRect(x: p.x * size.width - Double(p.size / 2),
                                      y: p.y * size.height - Double(p.size / 2),
                                      width: Double(p.size), height: Double(p.size))
                    context.opacity = p.life
                    context.fill(Path(ellipseIn: rect), with: .color(p.color))
                    let glowRect = rect.insetBy(dx: -2, dy: -2)
                    context.opacity = p.life * 0.3
                    context.fill(Path(ellipseIn: glowRect), with: .color(p.color))
                }
            }
            .background(theme.colors.surface.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { val in vm.spawnAt(val.location, in: geo.size) }
            )
        }
        .padding(.horizontal)
    }

    private var footer: some View {
        HStack {
            Label("\(vm.particles.count)", systemImage: "circle.fill").font(.caption).secondaryText()
            Spacer()
            Label("\(vm.totalSpawned)", systemImage: "drop.fill").font(.caption).secondaryText()
            Spacer()
            Button { vm.finish() } label: {
                Text("Done").font(.caption.bold()).foregroundStyle(theme.colors.primary)
            }
        }
    }

    private var completionView: some View {
        VStack(spacing: 24) {
            ConfettiView()
            Spacer()
            Image(systemName: vm.challenge.element.icon).font(.system(size: 48))
                .foregroundStyle(vm.challenge.element.baseColor)
                .padding(24).background(Circle().fill(vm.challenge.element.baseColor.opacity(0.15)))
            Text("Flow Complete!").font(.largeTitle.bold()).primaryText()
            HStack(spacing: 4) {
                ForEach(1...3, id: \.self) { i in
                    Image(systemName: i <= vm.stars ? "star.fill" : "star")
                        .font(.title).foregroundStyle(i <= vm.stars ? .yellow : theme.colors.textMuted)
                }
            }
            GlassCard {
                VStack(spacing: 12) {
                    row("Score", "\(Int(vm.score * 100))%")
                    row("Particles", "\(vm.totalSpawned)")
                    row("XP Earned", "+\(FluxConfig.xpForFlow(stars: vm.stars, zoneId: "ripple"))")
                }
            }
            Spacer()
            GlassButton("Continue", icon: "arrow.right") {
                vm.updateStats(context: context)
                appState.path.removeLast()
            }
        }
        .padding()
    }

    private func row(_ label: String, _ value: String) -> some View {
        HStack { Text(label).secondaryText(); Spacer(); Text(value).font(.headline).primaryText() }
    }
}
