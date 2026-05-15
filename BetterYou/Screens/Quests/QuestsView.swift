import SwiftUI
import SwiftData

struct QuestsView: View {
    @Query(sort: \Quest.assignedAt) private var allQuests: [Quest]
    @Binding var showLogWorkout: Bool
    @State private var selectedCadence: QuestCadence = .daily

    private var filteredQuests: [Quest] {
        allQuests.filter { $0.cadence == selectedCadence }
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    VStack(spacing: 16) {
                        Picker("Cadence", selection: $selectedCadence) {
                            Text("Daily").tag(QuestCadence.daily)
                            Text("Weekly").tag(QuestCadence.weekly)
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal)

                        if filteredQuests.isEmpty {
                            Text("No quests yet — relaunch the app!")
                                .font(AppTheme.body())
                                .foregroundStyle(AppTheme.textSecondary)
                                .padding(.top, 40)
                        } else {
                            ForEach(filteredQuests) { quest in
                                QuestCardView(quest: quest)
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top)
                    .padding(.bottom, 80)
                }
                .background(AppTheme.background)

                Button {
                    showLogWorkout = true
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "plus")
                        Text("Log Workout")
                    }
                    .font(AppTheme.title(16))
                    .foregroundStyle(AppTheme.background)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .background(AppTheme.accent)
                    .clipShape(Capsule())
                    .neonGlow()
                }
                .padding()
            }
            .navigationTitle("Quests")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .sheet(isPresented: $showLogWorkout) {
                LogWorkoutSheet()
            }
        }
    }
}
