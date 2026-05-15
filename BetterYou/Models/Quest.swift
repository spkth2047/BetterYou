import Foundation
import SwiftData

@Model
final class Quest {
    var id: UUID
    var title: String
    var detail: String
    var xpReward: Int
    var coinReward: Int
    var cadence: QuestCadence
    var targetMetric: TargetMetric
    var targetValue: Double
    var progress: Double
    var isCompleted: Bool
    var expiresAt: Date
    var assignedAt: Date

    init(
        title: String,
        detail: String,
        xpReward: Int,
        coinReward: Int,
        cadence: QuestCadence,
        targetMetric: TargetMetric,
        targetValue: Double,
        expiresAt: Date,
        assignedAt: Date = Date()
    ) {
        self.id = UUID()
        self.title = title
        self.detail = detail
        self.xpReward = xpReward
        self.coinReward = coinReward
        self.cadence = cadence
        self.targetMetric = targetMetric
        self.targetValue = targetValue
        self.progress = 0
        self.isCompleted = false
        self.expiresAt = expiresAt
        self.assignedAt = assignedAt
    }

    var progressFraction: Double {
        guard targetValue > 0 else { return 0 }
        return min(progress / targetValue, 1.0)
    }
}
