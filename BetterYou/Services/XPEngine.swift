import Foundation
import SwiftData

struct XPEngine {
    static func awardWorkout(profile: UserProfile) {
        profile.lifetimeXP += 50
        profile.coinBalance += 10
        recalculateLevel(profile: profile)
    }

    static func awardQuest(profile: UserProfile, quest: Quest) {
        profile.lifetimeXP += quest.xpReward
        profile.coinBalance += quest.coinReward
        recalculateLevel(profile: profile)
    }

    static func recalculateLevel(profile: UserProfile) {
        var newLevel = profile.level
        while profile.lifetimeXP >= UserProfile.xpToReachLevel(newLevel + 1) {
            newLevel += 1
        }
        profile.level = newLevel
        profile.currentXP = profile.xpInCurrentLevel
    }

    static func didLevelUp(oldLevel: Int, profile: UserProfile) -> Bool {
        profile.level > oldLevel
    }

    static func grantLevelBonuses(profile: UserProfile) {
        if profile.level % 5 == 0 {
            profile.streakFreezesOwned = min(profile.streakFreezesOwned + 1, 3)
        }
    }

    static func purchaseItem(profile: UserProfile, item: StoreItem) -> Bool {
        guard profile.coinBalance >= item.cost else { return false }

        if item.category == .freeze {
            guard profile.streakFreezesOwned < 3 else { return false }
            profile.coinBalance -= item.cost
            profile.streakFreezesOwned += 1
        } else {
            guard !item.isOwned else { return false }
            profile.coinBalance -= item.cost
            item.isOwned = true
        }
        return true
    }
}
