import SwiftUI
import SwiftData

struct StatsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var workouts: [Workout]
    @Query private var profiles: [UserProfile]

    @State private var showWeightInput = false
    @State private var weightInput = ""

    private var profile: UserProfile? { profiles.first }

    private var totalWorkouts: Int { workouts.count }

    private var totalTimeSec: Int {
        workouts.reduce(0) { $0 + $1.durationSec }
    }

    private var totalVolume: Double {
        workouts.reduce(0) { $0 + $1.totalVolume }
    }

    private var workoutsThisWeek: Int {
        let calendar = Calendar.current
        let monday = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
        return workouts.filter { $0.date >= monday }.count
    }

    private var typeCounts: [(WorkoutType, Int)] {
        WorkoutType.allCases.map { type in
            (type, workouts.filter { $0.type == type }.count)
        }.filter { $0.1 > 0 }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // KPI cards
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 12) {
                        KPICard(title: "Workouts", value: "\(totalWorkouts)", icon: "figure.run", color: AppTheme.accent)
                        KPICard(title: "Time", value: formatDuration(totalTimeSec), icon: "clock.fill", color: AppTheme.accentSecondary)
                        KPICard(title: "Volume", value: formatVolume(totalVolume), icon: "scalemass.fill", color: AppTheme.accentTertiary)
                    }

                    // Weekly progress
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("This Week")
                                .font(AppTheme.title(17))
                                .foregroundStyle(AppTheme.textPrimary)
                            Spacer()
                            Text("\(workoutsThisWeek)/4")
                                .font(AppTheme.body())
                                .foregroundStyle(AppTheme.accent)
                        }
                        ProgressBar(value: Double(workoutsThisWeek) / 4.0)
                    }
                    .surfaceCard()

                    // Per-type breakdown
                    if !typeCounts.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("By Type")
                                .font(AppTheme.title(17))
                                .foregroundStyle(AppTheme.textPrimary)

                            ForEach(typeCounts, id: \.0) { type, count in
                                HStack {
                                    Image(systemName: type.icon)
                                        .foregroundStyle(AppTheme.accentSecondary)
                                        .frame(width: 24)
                                    Text(type.displayName)
                                        .font(AppTheme.body())
                                        .foregroundStyle(AppTheme.textPrimary)
                                    Spacer()
                                    Text("\(count)")
                                        .font(AppTheme.title(17))
                                        .foregroundStyle(AppTheme.textSecondary)
                                }
                            }
                        }
                        .surfaceCard()
                    }

                    // Weight chart
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            WeightChartView()
                            Spacer()
                            Button {
                                showWeightInput = true
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2)
                                    .foregroundStyle(AppTheme.accent)
                            }
                        }
                    }
                    .surfaceCard()
                }
                .padding()
            }
            .background(AppTheme.background)
            .navigationTitle("Stats")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .alert("Log Weight", isPresented: $showWeightInput) {
                TextField("Weight (kg)", text: $weightInput)
                    .keyboardType(.decimalPad)
                Button("Save") {
                    if let weight = Double(weightInput), weight > 0 {
                        let log = WeightLog(weightKg: weight)
                        modelContext.insert(log)
                        if let profile {
                            profile.bodyWeightKg = weight
                        }
                    }
                    weightInput = ""
                }
                Button("Cancel", role: .cancel) {
                    weightInput = ""
                }
            } message: {
                Text("Enter your current weight in kg")
            }
        }
    }

    private func formatDuration(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        }
        return "\(minutes)m"
    }

    private func formatVolume(_ kg: Double) -> String {
        if kg >= 1000 {
            return String(format: "%.1fT", kg / 1000)
        }
        return "\(Int(kg))kg"
    }
}

private struct KPICard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(color)
            Text(value)
                .font(AppTheme.title(18))
                .foregroundStyle(AppTheme.textPrimary)
            Text(title)
                .font(AppTheme.caption(11))
                .foregroundStyle(AppTheme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .surfaceCard()
    }
}
