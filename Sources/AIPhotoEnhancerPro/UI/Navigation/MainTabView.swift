import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Tab = .home
    @EnvironmentObject private var settingsVM: SettingsViewModel

    enum Tab: String, CaseIterable {
        case home
        case settings

        var icon: String {
            switch self {
            case .home: return "wand.and.stars"
            case .settings: return "gear"
            }
        }

        var label: String {
            switch self {
            case .home: return "Enhance"
            case .settings: return "Settings"
            }
        }
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label(Tab.home.label, systemImage: Tab.home.icon)
                }
                .tag(Tab.home)

            SettingsView()
                .tabItem {
                    Label(Tab.settings.label, systemImage: Tab.settings.icon)
                }
                .tag(Tab.settings)
        }
        .tint(.accentColor)
    }
}

#Preview {
    MainTabView()
        .environmentObject(SettingsViewModel())
}
