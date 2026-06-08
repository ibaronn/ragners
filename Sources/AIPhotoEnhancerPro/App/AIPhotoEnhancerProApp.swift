import SwiftUI

@main
struct AIPhotoEnhancerProApp: App {
    @StateObject private var settingsViewModel = SettingsViewModel()
    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                if showSplash {
                    SplashView()
                        .transition(.opacity)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                withAnimation(.easeInOut(duration: 0.6)) {
                                    showSplash = false
                                }
                            }
                        }
                } else {
                    MainTabView()
                        .environmentObject(settingsViewModel)
                        .preferredColorScheme(colorScheme)
                        .onAppear {
                            if settingsViewModel.settings.showOnboarding {
                                settingsViewModel.settings.showOnboarding = false
                                settingsViewModel.saveSettings()
                            }
                        }
                }
            }
        }
    }

    private var colorScheme: ColorScheme? {
        switch settingsViewModel.settings.theme {
        case .light: return .light
        case .dark: return .dark
        case .system: return nil
        }
    }
}
