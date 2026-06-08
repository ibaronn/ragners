import Foundation
import CoreGraphics

public final class EnhanceImageUseCase: UseCase {
    public typealias Input = EnhanceInput
    public typealias Output = EnhanceOutput

    private let aiRepository: AIEnhancementRepositoryProtocol
    private let imageRepository: ImageRepositoryProtocol

    public init(
        aiRepository: AIEnhancementRepositoryProtocol,
        imageRepository: ImageRepositoryProtocol
    ) {
        self.aiRepository = aiRepository
        self.imageRepository = imageRepository
    }

    public func execute(_ input: EnhanceInput) async throws -> EnhanceOutput {
        var imageData = input.imageData

        if input.mode.usesDenoising {
            imageData = try await aiRepository.denoise(imageData, intensity: input.mode == .night ? 0.8 : 0.5)
        }

        if input.mode.suggestedScale > 1 {
            imageData = try await aiRepository.upscale(imageData, scale: input.mode.suggestedScale)
        }

        if input.mode.usesColorEnhancement {
            imageData = try await aiRepository.enhanceColor(imageData)
        }

        if input.mode.usesFaceEnhancement {
            imageData = try await aiRepository.enhanceFace(imageData)
        }

        if input.mode.usesSharpening {
            imageData = try await aiRepository.sharpen(imageData, intensity: 0.6)
        }

        let finalData = try await aiRepository.enhance(imageData, mode: input.mode)

        let savedURL = try await imageRepository.saveImage(finalData, name: "enhanced_\(UUID().uuidString)")

        return EnhanceOutput(
            processedData: finalData,
            processedURL: savedURL
        )
    }
}

public struct EnhanceInput {
    public let imageData: Data
    public let mode: EnhancementMode
    public let quality: AIQuality

    public init(imageData: Data, mode: EnhancementMode, quality: AIQuality = .balanced) {
        self.imageData = imageData
        self.mode = mode
        self.quality = quality
    }
}

public struct EnhanceOutput {
    public let processedData: Data
    public let processedURL: URL
}
