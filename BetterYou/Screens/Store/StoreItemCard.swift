import SwiftUI

struct StoreItemCard: View {
    let item: StoreItem
    let coinBalance: Int
    let onPurchase: () -> Void
    let onEquip: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: item.assetName)
                .font(.title)
                .foregroundStyle(item.isOwned ? AppTheme.accent : AppTheme.textSecondary)
                .frame(width: 44, height: 44)
                .background(AppTheme.surface)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                    .font(AppTheme.body())
                    .foregroundStyle(AppTheme.textPrimary)

                if !item.isOwned {
                    HStack(spacing: 4) {
                        Image(systemName: "circle.fill")
                            .font(.caption2)
                            .foregroundStyle(AppTheme.accentTertiary)
                        Text("\(item.cost)")
                            .font(AppTheme.caption())
                            .foregroundStyle(AppTheme.accentTertiary)
                    }
                }
            }

            Spacer()

            if item.isEquipped {
                Text("Equipped")
                    .font(AppTheme.caption())
                    .foregroundStyle(AppTheme.accent)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(AppTheme.accent.opacity(0.15))
                    .clipShape(Capsule())
            } else if item.isOwned {
                Button("Equip") { onEquip() }
                    .font(AppTheme.caption())
                    .foregroundStyle(AppTheme.accentSecondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(AppTheme.accentSecondary.opacity(0.15))
                    .clipShape(Capsule())
            } else {
                Button("Buy") { onPurchase() }
                    .font(AppTheme.caption())
                    .foregroundStyle(coinBalance >= item.cost ? AppTheme.accent : AppTheme.textSecondary)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        (coinBalance >= item.cost ? AppTheme.accent : AppTheme.textSecondary)
                            .opacity(0.15)
                    )
                    .clipShape(Capsule())
                    .disabled(coinBalance < item.cost)
            }
        }
        .padding(.vertical, 4)
    }
}
