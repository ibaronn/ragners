import Foundation

public struct HomeViewState {
    public var selectedImage: Data?
    public var processedImage: Data?
    public var isProcessing: Bool = false
    public var processingProgress: Float = 0
    public var selectedMode: EnhancementMode = .standard
    public var recentImages: [ProcessedImage] = []
    public var showImagePicker: Bool = false
    public var showCamera: Bool = false
    public var showFilePicker: Bool = false
    public var showSettings: Bool = false
    public var showOnboarding: Bool = false
    public var error: AppError?
    public var showError: Bool = false
    public var processingStage: ProcessingStage = .idle

    public enum ProcessingStage: Equatable {
        case idle
        case loading
        case denoising
        case upscaling
        case colorEnhancement
        case faceEnhancement
        case sharpening
        case saving
        case completed
        case failed(String)
    }
}
