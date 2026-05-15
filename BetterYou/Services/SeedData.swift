import Foundation
import SwiftData

struct QuestTemplate {
    let title: String
    let detail: String
    let metric: TargetMetric
    let value: Double
}

struct SeedData {
    // MARK: - Quest Templates

    static let dailyTemplates: [QuestTemplate] = [
        QuestTemplate(title: "Log 1 Workout", detail: "Complete any workout today", metric: .workoutsCount, value: 1),
        QuestTemplate(title: "Train 20 Minutes", detail: "Accumulate 20 min of training", metric: .totalDurationSec, value: 1200),
        QuestTemplate(title: "Hit 200 kg Volume", detail: "Lift a total of 200 kg today", metric: .totalVolumeKg, value: 200),
        QuestTemplate(title: "Cover 2 km", detail: "Run or walk 2 km today", metric: .distanceKm, value: 2),
        QuestTemplate(title: "Log 2 Workouts", detail: "Complete 2 workouts today", metric: .workoutsCount, value: 2),
        QuestTemplate(title: "Train 30 Minutes", detail: "Accumulate 30 min of training", metric: .totalDurationSec, value: 1800),
    ]

    static let weeklyTemplates: [QuestTemplate] = [
        QuestTemplate(title: "4 Workouts This Week", detail: "Complete 4 workouts", metric: .workoutsCount, value: 4),
        QuestTemplate(title: "Train 120 Minutes", detail: "Accumulate 2 hours this week", metric: .totalDurationSec, value: 7200),
        QuestTemplate(title: "Lift 2000 kg", detail: "Hit 2000 kg total volume", metric: .totalVolumeKg, value: 2000),
        QuestTemplate(title: "Cover 10 km", detail: "Log 10 km of cardio this week", metric: .distanceKm, value: 10),
        QuestTemplate(title: "5 Workouts This Week", detail: "Complete 5 workouts", metric: .workoutsCount, value: 5),
        QuestTemplate(title: "Train 150 Minutes", detail: "Accumulate 2.5 hours this week", metric: .totalDurationSec, value: 9000),
    ]

    // MARK: - Store Catalog

    static let avatars: [(name: String, asset: String, cost: Int)] = [
        ("Runner", "figure.run", 0),
        ("Lifter", "figure.strengthtraining.traditional", 100),
        ("Yogi", "figure.yoga", 150),
        ("Flame", "flame.fill", 200),
        ("Bolt", "bolt.fill", 250),
        ("Star", "star.fill", 300),
        ("Crown", "crown.fill", 400),
        ("Leaf", "leaf.fill", 500),
    ]

    static let badges: [(name: String, asset: String, cost: Int)] = [
        ("Iron Lifter", "dumbbell.fill", 150),
        ("Marathoner", "figure.run.circle.fill", 200),
        ("Streak Master", "flame.circle.fill", 250),
        ("Early Bird", "sunrise.fill", 200),
        ("Night Owl", "moon.stars.fill", 200),
        ("Quest Hunter", "target", 300),
        ("Volume King", "crown.fill", 400),
        ("Cardio Beast", "heart.circle.fill", 600),
    ]

    // MARK: - Bootstrap

    static func bootstrapIfNeeded(context: ModelContext) {
        let profileDescriptor = FetchDescriptor<UserProfile>()
        let profiles = (try? context.fetch(profileDescriptor)) ?? []

        if profiles.isEmpty {
            context.insert(UserProfile())
        }

        let storeDescriptor = FetchDescriptor<StoreItem>()
        let storeItems = (try? context.fetch(storeDescriptor)) ?? []

        if storeItems.isEmpty {
            for (index, avatar) in avatars.enumerated() {
                let item = StoreItem(
                    name: avatar.name,
                    category: .avatar,
                    cost: avatar.cost,
                    assetName: avatar.asset,
                    isOwned: index == 0,
                    isEquipped: index == 0
                )
                context.insert(item)
            }

            for badge in badges {
                let item = StoreItem(
                    name: badge.name,
                    category: .badge,
                    cost: badge.cost,
                    assetName: badge.asset
                )
                context.insert(item)
            }

            let freeze = StoreItem(
                name: "Streak Freeze",
                category: .freeze,
                cost: 200,
                assetName: "snowflake"
            )
            context.insert(freeze)
        }
    }
}
