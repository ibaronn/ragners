import Foundation

public enum AppError: Error, LocalizedError, Identifiable {
    case imageLoadFailed
    case imageSaveFailed
    case processingFailed(String)
    case modelLoadFailed(String)
    case modelNotFound(String)
    case invalidInput(String)
    case insufficientMemory
    case storageFull
    case permissionDenied(String)
    case general(String)
    case cancelled

    public var id: String { localizedDescription }

    public var errorDescription: String? {
        switch self {
        case .imageLoadFailed:
            return "Could not load the image. Please try again."
        case .imageSaveFailed:
            return "Could not save the image. Please check storage space."
        case .processingFailed(let detail):
            return "Processing failed: \(detail)"
        case .modelLoadFailed(let modelName):
            return "Failed to load AI model: \(modelName)"
        case .modelNotFound(let modelName):
            return "AI model not found: \(modelName)"
        case .invalidInput(let detail):
            return "Invalid input: \(detail)"
        case .insufficientMemory:
            return "Not enough memory to process this image."
        case .storageFull:
            return "Storage is full. Please free up some space."
        case .permissionDenied(let detail):
            return "Permission denied: \(detail)"
        case .general(let detail):
            return detail
        case .cancelled:
            return "Operation was cancelled."
        }
    }

    public var recoveryMessage: String? {
        switch self {
        case .imageLoadFailed:
            return "Try selecting a different image."
        case .processingFailed:
            return "Try a different enhancement mode or a smaller image."
        case .insufficientMemory:
            return "Close other apps and try again."
        case .storageFull:
            return "Free up storage space in Settings."
        case .permissionDenied:
            return "Grant permission in Settings."
        default:
            return nil
        }
    }
}
