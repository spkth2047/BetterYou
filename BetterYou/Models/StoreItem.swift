import Foundation
import SwiftData

@Model
final class StoreItem {
    var id: UUID
    var name: String
    var category: StoreCategory
    var cost: Int
    var assetName: String
    var isOwned: Bool
    var isEquipped: Bool

    init(
        name: String,
        category: StoreCategory,
        cost: Int,
        assetName: String,
        isOwned: Bool = false,
        isEquipped: Bool = false
    ) {
        self.id = UUID()
        self.name = name
        self.category = category
        self.cost = cost
        self.assetName = assetName
        self.isOwned = isOwned
        self.isEquipped = isEquipped
    }
}
