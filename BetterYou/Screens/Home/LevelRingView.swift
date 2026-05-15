import SwiftUI

struct LevelRingView: View {
    let level: Int
    let progress: Double

    @State private var animatedProgress: Double = 0

    var body: some View {
        GlowingBadge(level: level, progress: animatedProgress)
            .onAppear {
                withAnimation(.easeOut(duration: 0.8)) {
                    animatedProgress = progress
                }
            }
            .onChange(of: progress) { _, newValue in
                withAnimation(.easeOut(duration: 0.5)) {
                    animatedProgress = newValue
                }
            }
    }
}

#Preview {
    LevelRingView(level: 3, progress: 0.6)
        .background(AppTheme.background)
}
