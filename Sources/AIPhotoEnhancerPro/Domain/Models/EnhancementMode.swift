import Foundation

public enum EnhancementMode: String, CaseIterable, Identifiable, Codable {
    case standard
    case ultraHD
    case portrait
    case anime
    case landscape
    case night
    case restoreOldPhoto
    case superResolution

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .standard: return "Standard"
        case .ultraHD: return "Ultra HD"
        case .portrait: return "Portrait"
        case .anime: return "Anime"
        case .landscape: return "Landscape"
        case .night: return "Night"
        case .restoreOldPhoto: return "Restore Old Photos"
        case .superResolution: return "Super Resolution"
        }
    }

    public var iconName: String {
        switch self {
        case .standard: return "wand.and.stars"
        case .ultraHD: return "rectangle.compress.vertical"
        case .portrait: return "person.crop.rectangle"
        case .anime: return "paintbrush.pointed"
        case .landscape: return "mountain.2"
        case .night: return "moon.stars"
        case .restoreOldPhoto: return "clock.arrow.circlepath"
        case .superResolution: return "magnifyingglass"
        }
    }

    public var description: String {
        switch self {
        case .standard: return "Balanced enhancement for everyday photos"
        case .ultraHD: return "Maximum quality upscaling and detail"
        case .portrait: return "Optimized for faces and portraits"
        case .anime: return "AI-powered anime style enhancement"
        case .landscape: return "Enhanced colors and details for scenery"
        case .night: return "Reduced noise and improved low-light"
        case .restoreOldPhoto: return "Restore and enhance vintage photographs"
        case .superResolution: return "4x upscaling with AI detail recovery"
        }
    }

    public var suggestedScale: Int {
        switch self {
        case .standard: return 2
        case .ultraHD: return 4
        case .superResolution: return 4
        case .restoreOldPhoto: return 2
        default: return 1
        }
    }

    public var usesFaceEnhancement: Bool {
        switch self {
        case .portrait, .restoreOldPhoto: return true
        default: return false
        }
    }

    public var usesDenoising: Bool {
        switch self {
        case .night, .restoreOldPhoto: return true
        default: return false
        }
    }

    public var usesColorEnhancement: Bool {
        switch self {
        case .landscape, .standard, .ultraHD: return true
        default: return false
        }
    }

    public var usesSharpening: Bool {
        switch self {
        case .standard, .ultraHD, .landscape: return true
        default: return false
        }
    }
}
