import UIKit

class StoreViewController: UIViewController {

    // MARK: - IBOutlets (connected to Storyboard elements)

    /// Label showing current coin balance (e.g. "🪙 180 coins")
    @IBOutlet weak var coinBalanceLabel: UILabel!

    /// Section header "Avatars"
    @IBOutlet weak var avatarsSectionLabel: UILabel!

    /// First store item row label (e.g. "Runner  Equipped")
    @IBOutlet weak var item1Label: UILabel!

    /// Second store item row label (e.g. "Lifter  100 coins")
    @IBOutlet weak var item2Label: UILabel!

    /// "Buy" button for purchasing items
    @IBOutlet weak var buyButton: UIButton!

    /// Section header "Power-ups"
    @IBOutlet weak var powerupsSectionLabel: UILabel!

    /// Streak Freeze item label
    @IBOutlet weak var streakFreezeLabel: UILabel!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Store"
        view.backgroundColor = UIColor(red: 0.043, green: 0.043, blue: 0.071, alpha: 1.0)
        loadStoreItems()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadStoreItems()
    }

    // MARK: - IBActions (user interactions)

    /// Called when user taps the "Buy" button on a store item
    @IBAction func buyItemTapped(_ sender: UIButton) {
        // In production, this calls XPEngine.purchaseItem(profile:, item:)
        // which checks:
        //   1. Does the user have enough coins? (guard coinBalance >= item.cost)
        //   2. Is it a streak freeze? Cap at 3 max.
        //   3. Is it already owned? Prevent duplicate purchase.
        // On success: deduct coins, mark item as owned, haptic feedback

        let alert = UIAlertController(
            title: "Purchase Item?",
            message: "Do you want to buy this item for 100 coins?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Buy", style: .default) { [weak self] _ in
            print("Item purchased! Coins deducted.")
            // Haptic feedback
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            self?.loadStoreItems()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    /// Called when user taps "Equip" on an owned item
    @IBAction func equipItemTapped(_ sender: UIButton) {
        // In production:
        // 1. Un-equip all items in the same category
        // 2. Set item.isEquipped = true
        // 3. Update profile.avatarID or profile.selectedTitle
        print("Item equipped!")
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

    // MARK: - Private Helpers

    private func loadStoreItems() {
        // In production, this queries SwiftData for all StoreItem objects
        // sorted by cost, grouped by category:
        //
        //   let avatars = storeItems.filter { $0.category == .avatar }
        //   let badges = storeItems.filter { $0.category == .badge }
        //   let freezes = storeItems.filter { $0.category == .freeze }
        //
        //   coinBalanceLabel.text = "🪙 \(profile.coinBalance) coins"
        //   For each item: show name, cost, and Buy/Equip/Equipped state
    }
}
