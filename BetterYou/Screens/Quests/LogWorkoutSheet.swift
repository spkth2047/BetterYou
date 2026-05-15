import SwiftUI
import SwiftData

struct LogWorkoutSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var profiles: [UserProfile]

    @State private var workoutType: WorkoutType = .strength
    @State private var name = ""
    @State private var durationMinutes = ""
    @State private var notes = ""
    @State private var sets: [SetEntry] = [SetEntry(reps: 10, weightKg: 20)]
    @State private var distanceKm = ""

    @State private var showLevelUp = false
    @State private var newLevel = 1
    @State private var grantedFreeze = false

    private var profile: UserProfile? { profiles.first }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Picker("Type", selection: $workoutType) {
                        ForEach(WorkoutType.allCases) { type in
                            Text(type.displayName).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)

                    TextField("Workout Name", text: $name)
                        .textFieldStyle(.roundedBorder)

                    TextField("Duration (minutes)", text: $durationMinutes)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)

                    switch workoutType {
                    case .strength:
                        setsSection
                    case .cardio:
                        TextField("Distance (km)", text: $distanceKm)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.decimalPad)
                    case .bodyweight:
                        setsSection
                    case .custom:
                        EmptyView()
                    }

                    TextField("Notes", text: $notes, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(3...5)
                }
                .padding()
            }
            .background(AppTheme.background)
            .navigationTitle("Log Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveWorkout() }
                        .fontWeight(.bold)
                        .tint(AppTheme.accent)
                }
            }
            .sheet(isPresented: $showLevelUp) {
                LevelUpSheet(newLevel: newLevel, grantedFreeze: grantedFreeze)
            }
        }
    }

    private var setsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Sets")
                    .font(AppTheme.title(17))
                    .foregroundStyle(AppTheme.textPrimary)
                Spacer()
                Button {
                    sets.append(SetEntry(reps: 10, weightKg: workoutType == .strength ? 20 : nil))
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundStyle(AppTheme.accent)
                }
            }

            ForEach(Array(sets.enumerated()), id: \.element.id) { index, _ in
                HStack(spacing: 12) {
                    Text("Set \(index + 1)")
                        .font(AppTheme.caption())
                        .foregroundStyle(AppTheme.textSecondary)
                        .frame(width: 44)

                    HStack(spacing: 4) {
                        TextField("Reps", value: $sets[index].reps, format: .number)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numberPad)
                            .frame(width: 70)
                        Text("reps")
                            .font(AppTheme.caption(12))
                            .foregroundStyle(AppTheme.textSecondary)
                    }

                    if workoutType == .strength {
                        HStack(spacing: 4) {
                            TextField("kg", value: $sets[index].weightKg, format: .number)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.decimalPad)
                                .frame(width: 70)
                            Text("kg")
                                .font(AppTheme.caption(12))
                                .foregroundStyle(AppTheme.textSecondary)
                        }
                    }

                    if sets.count > 1 {
                        Button {
                            sets.remove(at: index)
                        } label: {
                            Image(systemName: "minus.circle")
                                .foregroundStyle(.red)
                        }
                    }
                }
            }
        }
    }

    private func saveWorkout() {
        guard let profile else { return }
        let oldLevel = profile.level

        let duration = (Int(durationMinutes) ?? 0) * 60
        let workoutName = name.isEmpty ? workoutType.displayName : name
        let distance = Double(distanceKm)

        let workout = Workout(
            type: workoutType,
            name: workoutName,
            durationSec: duration,
            notes: notes,
            sets: workoutType == .custom ? [] : sets,
            distanceKm: distance
        )
        modelContext.insert(workout)

        XPEngine.awardWorkout(profile: profile)
        QuestEngine.recomputeProgress(context: modelContext, profile: profile)

        if XPEngine.didLevelUp(oldLevel: oldLevel, profile: profile) {
            newLevel = profile.level
            grantedFreeze = profile.level % 5 == 0
            XPEngine.grantLevelBonuses(profile: profile)
            showLevelUp = true
        } else {
            dismiss()
        }
    }
}
