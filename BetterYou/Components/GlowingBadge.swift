import SwiftUI

struct GlowingBadge: View {
    let level: Int
    let progress: Double

    var body: some View {
        ZStack {
            Circle()
                .stroke(AppTheme.surface, lineWidth: 12)
                .frame(width: 140, height: 140)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(AppTheme.accent, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                .frame(width: 140, height: 140)
                .rotationEffect(.degrees(-90))
                .neonGlow()

            VStack(spacing: 2) {
                Text("\(level)")
                    .font(AppTheme.headline(48))
                    .foregroundStyle(AppTheme.accent)
                    .neonGlow()
                Text("LEVEL")
                    .font(AppTheme.caption(11))
                    .foregroundStyle(AppTheme.textSecondary)
            }
        }
    }
}

#Preview {
    GlowingBadge(level: 5, progress: 0.65)
        .background(AppTheme.background)
}
