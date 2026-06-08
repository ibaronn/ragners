import Foundation
import Combine

@MainActor
public final class SettingsViewModel: BaseViewModel {
    @Published public var settings: AppSettings = .default
    @Published public var cacheSize: String = "Calculating..."
    @Published public var appVersion: String = ""
    @Published public var showingResetConfirmation: Bool = false

    private let cacheService: CacheService
    private let defaults = UserDefaults.standard

    public override init() {
        self.cacheService = CacheServiceImplementation()
        super.init()
        loadSettings()
        calculateCacheSize()
        loadAppVersion()
    }

    public func loadSettings() {
        if let data = defaults.data(forKey: "appSettings"),
           let decoded = try? JSONDecoder().decode(AppSettings.self, from: data) {
            settings = decoded
        } else {
            settings = .default
        }
    }

    public func saveSettings() {
        guard let data = try? JSONEncoder().encode(settings) else { return }
        defaults.set(data, forKey: "appSettings")
        applyTheme()
    }

    private func applyTheme() {
        NotificationCenter.default.post(
            name: NSNotification.Name("AppThemeChanged"),
            object: settings.theme
        )
    }

    public func updateLanguage(_ language: AppLanguage) {
        settings.language = language
        saveSettings()
    }

    public func updateTheme(_ theme: ThemeMode) {
        settings.theme = theme
        saveSettings()
    }

    public func updateAIQuality(_ quality: AIQuality) {
        settings.aiQuality = quality
        saveSettings()
    }

    public func updateExportQuality(_ quality: Double) {
        settings.exportQuality = quality
        saveSettings()
    }

    public func updateExportFormat(_ format: ExportFormat) {
        settings.exportFormat = format
        saveSettings()
    }

    public func toggleAutoSave() {
        settings.autoSaveToPhotos.toggle()
        saveSettings()
    }

    public func toggleHaptics() {
        settings.hapticFeedbackEnabled.toggle()
        saveSettings()
    }

    public func calculateCacheSize() {
        Task {
            do {
                let size = try await cacheService.getCacheSize()
                let formatter = ByteCountFormatter()
                formatter.countStyle = .file
                cacheSize = formatter.string(fromByteCount: Int64(size))
            } catch {
                cacheSize = "Unknown"
            }
        }
    }

    public func clearCache() {
        cacheService.clear()
        calculateCacheSize()
    }

    public func resetAllSettings() {
        settings = .default
        saveSettings()
        calculateCacheSize()
    }

    public func requestResetConfirmation() {
        showingResetConfirmation = true
    }

    private func loadAppVersion() {
        appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "1.0.0"
    }
}
