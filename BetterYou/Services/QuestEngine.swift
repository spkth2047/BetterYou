import Foundation
import SwiftData

struct QuestEngine {
    static func refreshIfNeeded(context: ModelContext) {
        let calendar = Calendar.current
        let now = Date()
        let startOfToday = calendar.startOfDay(for: now)

        refreshDailyQuests(context: context, startOfToday: startOfToday, now: now)
        refreshWeeklyQuests(context: context, calendar: calendar, now: now)
    }

    private static func refreshDailyQuests(context: ModelContext, startOfToday: Date, now: Date) {
        let allQuests = (try? context.fetch(FetchDescriptor<Quest>())) ?? []
        let existing = allQuests.filter { $0.cadence == .daily }

        let needsRefresh = existing.isEmpty || existing.allSatisfy { $0.assignedAt < startOfToday }

        if needsRefresh {
            for quest in existing { context.delete(quest) }
            let templates = SeedData.dailyTemplates.shuffled().prefix(3)
            let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfToday)!
            for template in templates {
                let quest = Quest(
                    title: template.title,
                    detail: template.detail,
                    xpReward: 100,
                    coinReward: 25,
                    cadence: .daily,
                    targetMetric: template.metric,
                    targetValue: template.value,
                    expiresAt: endOfDay,
                    assignedAt: now
                )
                context.insert(quest)
            }
        }
    }

    private static func refreshWeeklyQuests(context: ModelContext, calendar: Calendar, now: Date) {
        let allQuests = (try? context.fetch(FetchDescriptor<Quest>())) ?? []
        let existing = allQuests.filter { $0.cadence == .weekly }

        let mondayOfThisWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!

        let needsRefresh = existing.isEmpty || existing.allSatisfy { $0.assignedAt < mondayOfThisWeek }

        if needsRefresh {
            for quest in existing { context.delete(quest) }
            let templates = SeedData.weeklyTemplates.shuffled().prefix(3)
            let nextMonday = calendar.date(byAdding: .weekOfYear, value: 1, to: mondayOfThisWeek)!
            for template in templates {
                let quest = Quest(
                    title: template.title,
                    detail: template.detail,
                    xpReward: 250,
                    coinReward: 60,
                    cadence: .weekly,
                    targetMetric: template.metric,
                    targetValue: template.value,
                    expiresAt: nextMonday,
                    assignedAt: now
                )
                context.insert(quest)
            }
        }
    }

    static func recomputeProgress(context: ModelContext, profile: UserProfile) {
        let calendar = Calendar.current
        let now = Date()
        let startOfToday = calendar.startOfDay(for: now)
        let mondayOfThisWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!

        let allQuests = (try? context.fetch(FetchDescriptor<Quest>())) ?? []
        let allWorkouts = (try? context.fetch(FetchDescriptor<Workout>())) ?? []

        for quest in allQuests where !quest.isCompleted {
            let relevantWorkouts: [Workout]
            if quest.cadence == .daily {
                relevantWorkouts = allWorkouts.filter { $0.date >= startOfToday }
            } else {
                relevantWorkouts = allWorkouts.filter { $0.date >= mondayOfThisWeek }
            }

            let oldProgress = quest.progress
            switch quest.targetMetric {
            case .workoutsCount:
                quest.progress = Double(relevantWorkouts.count)
            case .totalDurationSec:
                quest.progress = relevantWorkouts.reduce(0) { $0 + Double($1.durationSec) }
            case .totalVolumeKg:
                quest.progress = relevantWorkouts.reduce(0) { $0 + $1.totalVolume }
            case .distanceKm:
                quest.progress = relevantWorkouts.reduce(0) { $0 + ($1.distanceKm ?? 0) }
            }

            if quest.progress >= quest.targetValue && oldProgress < quest.targetValue {
                quest.isCompleted = true
                XPEngine.awardQuest(profile: profile, quest: quest)
            }
        }
    }
}
