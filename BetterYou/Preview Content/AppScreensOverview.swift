import SwiftUI
import SwiftData

// MARK: - All Screens Overview
// Open this file in Xcode and enable the Canvas (Cmd+Option+Enter)
// to see all 5 app screens laid out like a storyboard.

#Preview("All Screens Overview") {
    ScrollView(.horizontal) {
        HStack(spacing: 20) {
            screenFrame("Home") {
                HomeView(selectedTab: .constant(0), showLogWorkout: .constant(false))
            }
            screenFrame("Quests") {
                QuestsView(showLogWorkout: .constant(false))
            }
            screenFrame("Stats") {
                StatsView()
            }
            screenFrame("Store") {
                StoreView()
            }
            screenFrame("Profile") {
                ProfileView()
            }
        }
        .padding(20)
    }
    .background(Color.black)
    .modelContainer(previewContainer)
    .preferredColorScheme(.dark)
}

#Preview("1. Home Screen") {
    HomeView(selectedTab: .constant(0), showLogWorkout: .constant(false))
        .modelContainer(previewContainer)
        .preferredColorScheme(.dark)
}

#Preview("2. Quests Screen") {
    QuestsView(showLogWorkout: .constant(false))
        .modelContainer(previewContainer)
        .preferredColorScheme(.dark)
}

#Preview("3. Stats Screen") {
    StatsView()
        .modelContainer(previewContainer)
        .preferredColorScheme(.dark)
}

#Preview("4. Store Screen") {
    StoreView()
        .modelContainer(previewContainer)
        .preferredColorScheme(.dark)
}

#Preview("5. Profile Screen") {
    ProfileView()
        .modelContainer(previewContainer)
        .preferredColorScheme(.dark)
}

#Preview("Log Workout Sheet") {
    LogWorkoutSheet()
        .modelContainer(previewContainer)
        .preferredColorScheme(.dark)
}

#Preview("Level Up Celebration") {
    LevelUpSheet(newLevel: 5, grantedFreeze: true)
        .preferredColorScheme(.dark)
}

#Preview("Full App - Tab View") {
    RootTabView()
        .modelContainer(previewContainer)
        .preferredColorScheme(.dark)
}

// MARK: - Helper

@ViewBuilder
private func screenFrame<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
    VStack(spacing: 0) {
        Text(title)
            .font(.system(size: 14, weight: .bold, design: .rounded))
            .foregroundStyle(.white)
            .padding(.vertical, 6)
            .frame(maxWidth: .infinity)
            .background(Color(hex: 0x39FF88).opacity(0.3))

        content()
            .frame(width: 360, height: 700)
            .clipped()
    }
    .clipShape(RoundedRectangle(cornerRadius: 20))
    .overlay(
        RoundedRectangle(cornerRadius: 20)
            .stroke(Color(hex: 0x39FF88).opacity(0.5), lineWidth: 2)
    )
    .shadow(color: Color(hex: 0x39FF88).opacity(0.3), radius: 10)
}
