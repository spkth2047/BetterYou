import SwiftUI
import SwiftData

struct AvatarPickerView: View {
    @Query private var allStoreItems: [StoreItem]

    private var ownedAvatars: [StoreItem] {
        allStoreItems.filter { $0.category == .avatar && $0.isOwned }
            .sorted { $0.cost < $1.cost }
    }

    let selectedAsset: String
    let onSelect: (StoreItem) -> Void

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4), spacing: 12) {
            ForEach(ownedAvatars) { item in
                Button {
                    onSelect(item)
                } label: {
                    Image(systemName: item.assetName)
                        .font(.title2)
                        .foregroundStyle(item.assetName == selectedAsset ? AppTheme.accent : AppTheme.textSecondary)
                        .frame(width: 56, height: 56)
                        .background(
                            item.assetName == selectedAsset
                                ? AppTheme.accent.opacity(0.15)
                                : AppTheme.surface
                        )
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(
                                    item.assetName == selectedAsset ? AppTheme.accent : Color.clear,
                                    lineWidth: 2
                                )
                        )
                }
            }
        }
    }
}
