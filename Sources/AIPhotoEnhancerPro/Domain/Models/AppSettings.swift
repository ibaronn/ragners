import Foundation

public struct AppSettings: Codable, Equatable {
    public var language: AppLanguage
    public var theme: ThemeMode
    public var aiQuality: AIQuality
    public var exportQuality: Double
    public var exportFormat: ExportFormat
    public var autoSaveToPhotos: Bool
    public var hapticFeedbackEnabled: Bool
    public var showOnboarding: Bool

    public static let `default` = AppSettings(
        language: .system,
        theme: .system,
        aiQuality: .balanced,
        exportQuality: 0.95,
        exportFormat: .jpeg,
        autoSaveToPhotos: true,
        hapticFeedbackEnabled: true,
        showOnboarding: true
    )
}

public enum AppLanguage: String, CaseIterable, Codable {
    case system
    case english
    case spanish
    case french
    case german
    case chinese
    case japanese
    case korean

    public var displayName: String {
        switch self {
        case .system: return "System"
        case .english: return "English"
        case .spanish: return "Español"
        case .french: return "Français"
        case .german: return "Deutsch"
        case .chinese: return "中文"
        case .japanese: return "日本語"
        case .korean: return "한국어"
        }
    }
}

public enum ThemeMode: String, CaseIterable, Codable {
    case system
    case light
    case dark

    public var displayName: String {
        switch self {
        case .system: return "System"
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }
}

public enum AIQuality: String, CaseIterable, Codable {
    case fast
    case balanced
    case maximum

    public var displayName: String {
        switch self {
        case .fast: return "Fast"
        case .balanced: return "Balanced"
        case .maximum: return "Maximum Quality"
        }
    }

    public var description: String {
        switch self {
        case .fast: return "Quick results with good quality"
        case .balanced: return "Balanced quality and speed"
        case .maximum: return "Best quality, takes longer"
        }
    }
}
