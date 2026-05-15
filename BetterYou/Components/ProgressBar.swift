import SwiftUI

struct ProgressBar: View {
    let value: Double
    var color: Color = AppTheme.accent
    var height: CGFloat = 10

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(AppTheme.surface)
                    .frame(height: height)

                RoundedRectangle(cornerRadius: height / 2)
                    .fill(color)
                    .frame(width: geo.size.width * min(max(value, 0), 1), height: height)
                    .neonGlow(color, radius: 6)
            }
        }
        .frame(height: height)
    }
}

#Preview {
    VStack(spacing: 20) {
        ProgressBar(value: 0.7)
        ProgressBar(value: 0.3, color: AppTheme.accentSecondary)
        ProgressBar(value: 1.0, color: AppTheme.accentTertiary)
    }
    .padding()
    .background(AppTheme.background)
}
