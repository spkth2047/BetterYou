import SwiftUI
import SwiftData

struct ProfileView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var profiles: [UserProfile]
    @Query private var storeItems: [StoreItem]

    private var ownedBadges: [StoreItem] {
        storeItems.filter { $0.category == .badge && $0.isOwned }
            .sorted { $0.cost < $1.cost }
    }

    @State private var editingName = false
    @State private var nameInput = ""
    @State private var weightInput = ""
    @State private var showResetAlert = false

    private var profile: UserProfile? { profiles.first }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    if let profile {
                        // Avatar
                        VStack(spacing: 8) {
                            Image(systemName: profile.avatarID)
                                .font(.system(size: 60))
                                .foregroundStyle(AppTheme.accent)
                                .frame(width: 100, height: 100)
                                .background(AppTheme.surface)
                                .clipShape(Circle())
                                .neonGlow()

                            Text(profile.selectedTitle)
                                .font(AppTheme.caption())
                                .foregroundStyle(AppTheme.accentSecondary)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 4)
                                .background(AppTheme.accentSecondary.opacity(0.15))
                                .clipShape(Capsule())
                        }

                        // Avatar picker
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Choose Avatar")
                                .font(AppTheme.title(17))
                                .foregroundStyle(AppTheme.textPrimary)
                            AvatarPickerView(selectedAsset: profile.avatarID) { item in
                                profile.avatarID = item.assetName
                                let avatars = storeItems.filter { $0.category == .avatar }
                                for a in avatars { a.isEquipped = false }
                                item.isEquipped = true
                            }
                        }
                        .surfaceCard()

                        // Title picker
                        if !ownedBadges.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Choose Title")
                                    .font(AppTheme.title(17))
                                    .foregroundStyle(AppTheme.textPrimary)

                                FlowLayout(spacing: 8) {
                                    titleChip("Newbie", isSelected: profile.selectedTitle == "Newbie") {
                                        profile.selectedTitle = "Newbie"
                                    }
                                    ForEach(ownedBadges) { badge in
                                        titleChip(badge.name, isSelected: profile.selectedTitle == badge.name) {
                                            profile.selectedTitle = badge.name
                                        }
                                    }
                                }
                            }
                            .surfaceCard()
                        }

                        // Display Name
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Display Name")
                                .font(AppTheme.title(17))
                                .foregroundStyle(AppTheme.textPrimary)

                            HStack {
                                if editingName {
                                    TextField("Name", text: $nameInput)
                                        .textFieldStyle(.roundedBorder)
                                    Button("Save") {
                                        profile.name = nameInput
                                        editingName = false
                                    }
                                    .foregroundStyle(AppTheme.accent)
                                } else {
                                    Text(profile.name)
                                        .font(AppTheme.body())
                                        .foregroundStyle(AppTheme.textPrimary)
                                    Spacer()
                                    Button("Edit") {
                                        nameInput = profile.name
                                        editingName = true
                                    }
                                    .foregroundStyle(AppTheme.accentSecondary)
                                }
                            }
                        }
                        .surfaceCard()

                        // Body Weight
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Body Weight")
                                .font(AppTheme.title(17))
                                .foregroundStyle(AppTheme.textPrimary)

                            HStack {
                                if let weight = profile.bodyWeightKg {
                                    Text(String(format: "%.1f kg", weight))
                                        .font(AppTheme.body())
                                        .foregroundStyle(AppTheme.textPrimary)
                                } else {
                                    Text("Not set")
                                        .font(AppTheme.body())
                                        .foregroundStyle(AppTheme.textSecondary)
                                }
                                Spacer()
                                Button("Update") {
                                    weightInput = profile.bodyWeightKg.map { String(format: "%.1f", $0) } ?? ""
                                }
                                .foregroundStyle(AppTheme.accentSecondary)
                            }
                        }
                        .surfaceCard()

                        // About
                        VStack(alignment: .leading, spacing: 8) {
                            Text("About")
                                .font(AppTheme.title(17))
                                .foregroundStyle(AppTheme.textPrimary)

                            Group {
                                infoRow("Version", "1.0.0")
                                infoRow("Team", "Surya Prakash Seth")
                                infoRow("", "Naman Ahuja")
                                infoRow("Course", "CSE 4456 — iOS App Dev")
                            }
                        }
                        .surfaceCard()

                        // Reset
                        Button(role: .destructive) {
                            showResetAlert = true
                        } label: {
                            Text("Reset Progress")
                                .font(AppTheme.body())
                                .foregroundStyle(.red)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.red.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius))
                        }
                    }
                }
                .padding()
            }
            .background(AppTheme.background)
            .navigationTitle("Profile")
            .toolbarColorScheme(.dark, for: .navigationBar)
            .alert("Reset Progress", isPresented: $showResetAlert) {
                Button("Reset", role: .destructive) { resetProgress() }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will delete all workouts, quests, and reset your level. This cannot be undone.")
            }
        }
    }

    private func titleChip(_ title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(AppTheme.caption())
                .foregroundStyle(isSelected ? AppTheme.accent : AppTheme.textSecondary)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? AppTheme.accent.opacity(0.15) : AppTheme.surface)
                .clipShape(Capsule())
                .overlay(
                    Capsule().stroke(isSelected ? AppTheme.accent : Color.clear, lineWidth: 1)
                )
        }
    }

    private func infoRow(_ label: String, _ value: String) -> some View {
        HStack {
            if !label.isEmpty {
                Text(label)
                    .font(AppTheme.caption())
                    .foregroundStyle(AppTheme.textSecondary)
                    .frame(width: 60, alignment: .leading)
            }
            Text(value)
                .font(AppTheme.body())
                .foregroundStyle(AppTheme.textPrimary)
        }
    }

    private func resetProgress() {
        guard let profile else { return }
        profile.currentXP = 0
        profile.lifetimeXP = 0
        profile.level = 1
        profile.coinBalance = 0
        profile.currentStreak = 0
        profile.streakFreezesOwned = 0

        let workoutDescriptor = FetchDescriptor<Workout>()
        if let workouts = try? modelContext.fetch(workoutDescriptor) {
            for w in workouts { modelContext.delete(w) }
        }
        let questDescriptor = FetchDescriptor<Quest>()
        if let quests = try? modelContext.fetch(questDescriptor) {
            for q in quests { modelContext.delete(q) }
        }
        let weightDescriptor = FetchDescriptor<WeightLog>()
        if let logs = try? modelContext.fetch(weightDescriptor) {
            for l in logs { modelContext.delete(l) }
        }

        QuestEngine.refreshIfNeeded(context: modelContext)
    }
}

struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrange(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: proposal, subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y), proposal: .unspecified)
        }
    }

    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (positions: [CGPoint], size: CGSize) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth && x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            positions.append(CGPoint(x: x, y: y))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
        }

        return (positions, CGSize(width: maxWidth, height: y + rowHeight))
    }
}
