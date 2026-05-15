import Foundation
import SwiftData

@Model
final class UserProfile {
    var id: UUID
    var name: String
    var avatarID: String
    var selectedTitle: String
    var currentXP: Int
    var lifetimeXP: Int
    var level: Int
    var coinBalance: Int
    var currentStreak: Int
    var longestStreak: Int
    var streakFreezesOwned: Int
    var bodyWeightKg: Double?
    var createdAt: Date

    init(
        name: String = "Player",
        avatarID: String = "avatar_01",
        selectedTitle: String = "Newbie"
    ) {
        self.id = UUID()
        self.name = name
        self.avatarID = avatarID
        self.selectedTitle = selectedTitle
        self.currentXP = 0
        self.lifetimeXP = 0
        self.level = 1
        self.coinBalance = 0
        self.currentStreak = 0
        self.longestStreak = 0
        self.streakFreezesOwned = 0
        self.bodyWeightKg = nil
        self.createdAt = Date()
    }

    static func xpToReachLevel(_ n: Int) -> Int {
        n * 500
    }

    var xpInCurrentLevel: Int {
        lifetimeXP - UserProfile.xpToReachLevel(level)
    }

    var xpNeededForNextLevel: Int {
        500
    }

    var xpProgress: Double {
        Double(xpInCurrentLevel) / Double(xpNeededForNextLevel)
    }
}
