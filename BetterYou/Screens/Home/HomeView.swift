import SwiftUI
import SwiftData

struct HomeView: View {
    @Query private var profiles: [UserProfile]
    @Query(sort: \Quest.assignedAt) private var allQuests: [Quest]

    private var dailyQuests: [Quest] {
        allQuests.filter { $0.cadence == .daily && !$0.isCompleted }
    }

    @Binding var selectedTab: Int
    @Binding var showLogWorkout: Bool

    private var profile: UserProfile? { profiles.first }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    if let profile {
                        LevelRingView(
                            level: profile.level,
                            progress: profile.xpProgress
                        )
                        .padding(.top, 20)

                        HStack(spacing: 12) {
                            StatPill(
                                icon: "bolt.fill",
                                label: "Lifetime XP",
                                value: "\(profile.lifetimeXP)",
                                color: AppTheme.accent
                            )
                            StatPill(
                                icon: "flame.fill",
                                label: "Streak",
                                value: "\(profile.currentStreak) days",
                                color: AppTheme.accentTertiary
                            )
                        }

                        if !dailyQuests.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Today's Quests")
                                    .font(AppTheme.title())
                                    .foregroundStyle(AppTheme.textPrimary)

                                ForEach(dailyQuests.prefix(2)) { quest in
                                    MiniQuestCard(quest: quest)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .surfaceCard()
                        }

                        PrimaryButton("Log Workout", icon: "plus.circle.fill") {
                            selectedTab = 1
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                showLogWorkout = true
                            }
                        }
                        .padding(.top, 8)
                    }
                }
                .padding()
            }
            .background(AppTheme.background)
            .navigationTitle("BetterYou")
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

// MARK: - Subviews

private struct StatPill: View {
    let icon: String
    let label: String
    let value: String
    let color: Color

    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                    .foregroundStyle(color)
                Text(value)
                    .font(AppTheme.title(18))
                    .foregroundStyle(AppTheme.textPrimary)
            }
            Text(label)
                .font(AppTheme.caption())
                .foregroundStyle(AppTheme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .surfaceCard()
    }
}

private struct MiniQuestCard: View {
    let quest: Quest

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(quest.title)
                    .font(AppTheme.body())
                    .foregroundStyle(AppTheme.textPrimary)
                Spacer()
                Text("+\(quest.xpReward) XP")
                    .font(AppTheme.caption())
                    .foregroundStyle(AppTheme.accentSecondary)
            }
            ProgressBar(value: quest.progressFraction, color: AppTheme.accentSecondary, height: 6)
        }
    }
}
