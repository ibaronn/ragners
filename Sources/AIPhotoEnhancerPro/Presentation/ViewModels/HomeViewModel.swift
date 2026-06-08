import Foundation
import UIKit
import Combine
import CoreGraphics

@MainActor
public final class HomeViewModel: BaseViewModel {
    @Published public var state = HomeViewState()

    private let aiService: AIService
    private let imageRepository: ImageRepositoryProtocol
    private let cacheService: CacheService
    private let enhanceUseCase: EnhanceImageUseCase

    public override init() {
        self.aiService = AIEnhancementService()
        self.imageRepository = ImageRepository()
        self.cacheService = CacheServiceImplementation()
        self.enhanceUseCase = EnhanceImageUseCase(
            aiRepository: AIEnhancementRepository(),
            imageRepository: ImageRepository()
        )
        super.init()
        loadRecentImages()
    }

    public func loadRecentImages() {
        Task {
            do {
                let images = try await imageRepository.getSavedImages()
                state.recentImages = Array(images.prefix(20))
            } catch {
                state.recentImages = []
            }
        }
    }

    public func selectImage(_ data: Data) {
        state.selectedImage = data
        state.processedImage = nil
        state.processingStage = .idle
        state.processingProgress = 0
    }

    public func setMode(_ mode: EnhancementMode) {
        state.selectedMode = mode
    }

    public func processImage() async {
        guard let imageData = state.selectedImage else { return }

        state.isProcessing = true
        state.processingProgress = 0
        state.processingStage = .loading

        do {
            state.processingStage = .loading
            state.processingProgress = 0.1

            let result = try await enhanceUseCase.execute(
                EnhanceInput(imageData: imageData, mode: state.selectedMode, quality: .balanced)
            )

            state.processedImage = result.processedData
            state.processingStage = .completed
            state.processingProgress = 1.0

            loadRecentImages()

        } catch let appError as AppError {
            state.error = appError
            state.showError = true
            state.processingStage = .failed(appError.localizedDescription)
        } catch {
            let appError = AppError.processingFailed(error.localizedDescription)
            state.error = appError
            state.showError = true
            state.processingStage = .failed(error.localizedDescription)
        }

        state.isProcessing = false
    }

    public func processImageWithProgress(_ imageData: Data) async {
        state.isProcessing = true
        state.processingProgress = 0
        state.processingStage = .loading

        do {
            let pipeline = AIImageProcessingPipeline.shared
            let resultData = try await pipeline.processImage(
                imageData,
                mode: state.selectedMode,
                quality: .balanced
            ) { [weak self] progress in
                Task { @MainActor in
                    self?.state.processingProgress = progress
                    self?.updateProcessingStage(progress)
                }
            }

            state.processedImage = resultData
            state.processingStage = .completed
            state.processingProgress = 1.0

            let _ = try await imageRepository.saveImage(resultData, name: "result_\(UUID().uuidString).jpg")
            loadRecentImages()

        } catch let appError as AppError {
            state.error = appError
            state.showError = true
            state.processingStage = .failed(appError.localizedDescription)
        } catch {
            state.error = AppError.processingFailed(error.localizedDescription)
            state.showError = true
            state.processingStage = .failed(error.localizedDescription)
        }

        state.isProcessing = false
    }

    private func updateProcessingStage(_ progress: Float) {
        switch progress {
        case 0.0..<0.1: state.processingStage = .loading
        case 0.1..<0.3: state.processingStage = .denoising
        case 0.3..<0.5: state.processingStage = .upscaling
        case 0.5..<0.7: state.processingStage = .colorEnhancement
        case 0.7..<0.8: state.processingStage = .faceEnhancement
        case 0.8..<0.95: state.processingStage = .sharpening
        case 0.95..<1.0: state.processingStage = .saving
        default: break
        }
    }

    public func resetImage() {
        state.selectedImage = nil
        state.processedImage = nil
        state.processingStage = .idle
        state.processingProgress = 0
    }

    public func dismissError() {
        state.error = nil
        state.showError = false
    }

    public func toggleSettings() {
        state.showSettings.toggle()
    }

    public func getFormattedFileSize(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        return formatter.string(fromByteCount: bytes)
    }
}
