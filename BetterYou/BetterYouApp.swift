import SwiftUI
import SwiftData

@main
struct BetterYouApp: App {
    var body: some Scene {
        WindowGroup {
            RootTabView()
                .preferredColorScheme(.dark)
        }
        .modelContainer(for: [
            UserProfile.self,
            Workout.self,
            Quest.self,
            StoreItem.self,
            WeightLog.self
        ])
    }
}
