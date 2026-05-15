import SwiftUI
import SwiftData

struct StoreView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [UserProfile]
    @Query(sort: \StoreItem.cost) private var storeItems: [StoreItem]

    private var profile: UserProfile? { profiles.first }

    private var avatars: [StoreItem] { storeItems.filter { $0.category == .avatar } }
    private var badges: [StoreItem] { storeItems.filter { $0.category == .badge } }
    private var freezes: [StoreItem] { storeItems.filter { $0.category == .freeze } }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Coin balance
                    HStack(spacing: 8) {
                        Image(systemName: "circle.fill")
                            .foregroundStyle(AppTheme.accentTertiary)
                        Text("\(profile?.coinBalance ?? 0)")
                            .font(AppTheme.headline(24))
                            .foregroundStyle(AppTheme.accentTertiary)
                        Text("coins")
                            .font(AppTheme.body())
                            .foregroundStyle(AppTheme.textSecondary)
                    }
                    .frame(maxWidth: .infinity)
                    .surfaceCard()

                    storeSection("Avatars", items: avatars)
                    storeSection("Badges & Titles", items: badges)
                    storeSection("Power-ups", items: freezes)
                }
                .padding()
            }
            .background(AppTheme.background)
            .navigationTitle("Store")
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }

    @ViewBuilder
    private func storeSection(_ title: String, items: [StoreItem]) -> some View {
        if !items.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(AppTheme.title())
                    .foregroundStyle(AppTheme.textPrimary)

                ForEach(items) { item in
                    StoreItemCard(
                        item: item,
                        coinBalance: profile?.coinBalance ?? 0,
                        onPurchase: { purchase(item) },
                        onEquip: { equip(item) }
                    )
                }
            }
            .surfaceCard()
        }
    }

    private func purchase(_ item: StoreItem) {
        guard let profile else { return }
        let success = XPEngine.purchaseItem(profile: profile, item: item)
        if success {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
    }

    private func equip(_ item: StoreItem) {
        guard let profile else { return }
        let sameCategory = storeItems.filter { $0.category == item.category }
        for other in sameCategory { other.isEquipped = false }
        item.isEquipped = true

        if item.category == .avatar {
            profile.avatarID = item.assetName
        } else if item.category == .badge {
            profile.selectedTitle = item.name
        }
    }
}
