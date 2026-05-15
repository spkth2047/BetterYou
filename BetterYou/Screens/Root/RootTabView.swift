import SwiftUI
import SwiftData

struct RootTabView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var selectedTab = 0
    @State private var showLogWorkout = false

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(selectedTab: $selectedTab, showLogWorkout: $showLogWorkout)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)

            QuestsView(showLogWorkout: $showLogWorkout)
                .tabItem {
                    Label("Quests", systemImage: "target")
                }
                .tag(1)

            StatsView()
                .tabItem {
                    Label("Stats", systemImage: "chart.bar.fill")
                }
                .tag(2)

            StoreView()
                .tabItem {
                    Label("Store", systemImage: "bag.fill")
                }
                .tag(3)

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(4)
        }
        .tint(AppTheme.accent)
        .onAppear {
            SeedData.bootstrapIfNeeded(context: modelContext)
            QuestEngine.refreshIfNeeded(context: modelContext)

            let tabAppearance = UITabBarAppearance()
            tabAppearance.configureWithOpaqueBackground()
            tabAppearance.backgroundColor = UIColor(AppTheme.background)
            UITabBar.appearance().standardAppearance = tabAppearance
            UITabBar.appearance().scrollEdgeAppearance = tabAppearance
        }
    }
}
