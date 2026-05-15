import SwiftUI

struct QuestCardView: View {
    let quest: Quest

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(quest.title)
                        .font(AppTheme.title(17))
                        .foregroundStyle(AppTheme.textPrimary)
                    Text(quest.detail)
                        .font(AppTheme.caption())
                        .foregroundStyle(AppTheme.textSecondary)
                }
                Spacer()
                if quest.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(AppTheme.accent)
                        .neonGlow()
                }
            }

            HStack {
                ProgressBar(
                    value: quest.progressFraction,
                    color: quest.isCompleted ? AppTheme.accent : AppTheme.accentSecondary,
                    height: 8
                )

                Text("\(Int(quest.progress))/\(Int(quest.targetValue))")
                    .font(AppTheme.caption(12))
                    .foregroundStyle(AppTheme.textSecondary)
                    .frame(width: 60, alignment: .trailing)
            }

            HStack {
                Label("+\(quest.xpReward) XP", systemImage: "bolt.fill")
                    .font(AppTheme.caption())
                    .foregroundStyle(AppTheme.accent)

                Label("+\(quest.coinReward)", systemImage: "circle.fill")
                    .font(AppTheme.caption())
                    .foregroundStyle(AppTheme.accentTertiary)
            }
        }
        .surfaceCard()
        .opacity(quest.isCompleted ? 0.7 : 1.0)
    }
}
