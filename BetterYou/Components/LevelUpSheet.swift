import SwiftUI

struct LevelUpSheet: View {
    let newLevel: Int
    let grantedFreeze: Bool
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "sparkles")
                .font(.system(size: 60))
                .foregroundStyle(AppTheme.accentTertiary)
                .neonGlow(AppTheme.accentTertiary)

            Text("LEVEL UP!")
                .font(AppTheme.headline(36))
                .foregroundStyle(AppTheme.accent)
                .neonGlow()

            Text("You reached Level \(newLevel)")
                .font(AppTheme.title())
                .foregroundStyle(AppTheme.textPrimary)

            if grantedFreeze {
                HStack(spacing: 8) {
                    Image(systemName: "snowflake")
                        .foregroundStyle(AppTheme.accentSecondary)
                    Text("+1 Streak Freeze!")
                        .font(AppTheme.body())
                        .foregroundStyle(AppTheme.accentSecondary)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(AppTheme.accentSecondary.opacity(0.15))
                .clipShape(Capsule())
            }

            Spacer()

            PrimaryButton("Continue") {
                dismiss()
            }
            .padding(.horizontal, 40)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppTheme.background)
    }
}

#Preview {
    LevelUpSheet(newLevel: 5, grantedFreeze: true)
}
