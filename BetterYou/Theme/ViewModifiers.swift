import SwiftUI

struct NeonGlow: ViewModifier {
    var color: Color = AppTheme.accent
    var radius: CGFloat = AppTheme.glowRadius

    func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(0.6), radius: radius)
    }
}

struct SurfaceCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(AppTheme.surface)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                    .stroke(AppTheme.textSecondary.opacity(0.15), lineWidth: 1)
            )
    }
}

extension View {
    func neonGlow(_ color: Color = AppTheme.accent, radius: CGFloat = AppTheme.glowRadius) -> some View {
        modifier(NeonGlow(color: color, radius: radius))
    }

    func surfaceCard() -> some View {
        modifier(SurfaceCard())
    }
}
