import Foundation
import SwiftData

@MainActor
let previewContainer: ModelContainer = {
    let schema = Schema([
        UserProfile.self,
        Workout.self,
        Quest.self,
        StoreItem.self,
        WeightLog.self
    ])
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: schema, configurations: [config])

    let profile = UserProfile()
    profile.lifetimeXP = 1350
    profile.level = 2
    profile.currentXP = 350
    profile.coinBalance = 180
    profile.currentStreak = 5
    profile.longestStreak = 12
    profile.bodyWeightKg = 72.5
    container.mainContext.insert(profile)

    let workout1 = Workout(type: .strength, name: "Bench Press Day", durationSec: 2400, sets: [
        SetEntry(reps: 10, weightKg: 60),
        SetEntry(reps: 8, weightKg: 70),
        SetEntry(reps: 6, weightKg: 80)
    ])
    container.mainContext.insert(workout1)

    let workout2 = Workout(type: .cardio, name: "Morning Run", durationSec: 1800, distanceKm: 5.2)
    container.mainContext.insert(workout2)

    let quest = Quest(
        title: "Log 1 Workout",
        detail: "Complete any workout today",
        xpReward: 100,
        coinReward: 25,
        cadence: .daily,
        targetMetric: .workoutsCount,
        targetValue: 1,
        expiresAt: Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: Date()))!
    )
    quest.progress = 1
    quest.isCompleted = true
    container.mainContext.insert(quest)

    let quest2 = Quest(
        title: "Train 20 Minutes",
        detail: "Accumulate 20 min of training",
        xpReward: 100,
        coinReward: 25,
        cadence: .daily,
        targetMetric: .totalDurationSec,
        targetValue: 1200,
        expiresAt: Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: Date()))!
    )
    quest2.progress = 900
    container.mainContext.insert(quest2)

    for i in 0..<8 {
        let weight = WeightLog(
            date: Calendar.current.date(byAdding: .day, value: -i * 3, to: Date())!,
            weightKg: 72.0 + Double.random(in: -1.5...1.5)
        )
        container.mainContext.insert(weight)
    }

    return container
}()
