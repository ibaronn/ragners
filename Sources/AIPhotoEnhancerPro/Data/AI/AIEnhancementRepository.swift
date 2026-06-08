import Foundation
import CoreGraphics
import UIKit

public final class AIEnhancementRepository: AIEnhancementRepositoryProtocol {
    private let pipeline = AIImageProcessingPipeline.shared

    public init() {}

    public func enhance(_ image: Data, mode: EnhancementMode) async throws -> Data {
        try await pipeline.processImage(
            image,
            mode: mode,
            quality: .balanced,
            progressHandler: { _ in }
        )
    }

    public func upscale(_ image: Data, scale: Int) async throws -> Data {
        guard let cgImage = try await loadCGImage(from: image) else {
            throw AppError.imageLoadFailed
        }
        let enhancer = CoreMLPhotoEnhancer.shared
        guard let upscaled = enhancer.upscale(cgImage: cgImage, scale: scale),
              let resultData = UIImage(cgImage: upscaled).jpegData(compressionQuality: 0.95) else {
            throw AppError.processingFailed("Upscaling failed")
        }
        return resultData
    }

    public func denoise(_ image: Data, intensity: Float) async throws -> Data {
        guard let cgImage = try await loadCGImage(from: image) else {
            throw AppError.imageLoadFailed
        }
        let enhancer = CoreMLPhotoEnhancer.shared
        guard let denoised = enhancer.denoise(cgImage: cgImage, intensity: intensity),
              let resultData = UIImage(cgImage: denoised).jpegData(compressionQuality: 0.95) else {
            throw AppError.processingFailed("Denoising failed")
        }
        return resultData
    }

    public func sharpen(_ image: Data, intensity: Float) async throws -> Data {
        guard let cgImage = try await loadCGImage(from: image) else {
            throw AppError.imageLoadFailed
        }
        let enhancer = CoreMLPhotoEnhancer.shared
        guard let sharpened = enhancer.sharpen(cgImage: cgImage, intensity: intensity),
              let resultData = UIImage(cgImage: sharpened).jpegData(compressionQuality: 0.95) else {
            throw AppError.processingFailed("Sharpening failed")
        }
        return resultData
    }

    public func enhanceFace(_ image: Data) async throws -> Data {
        guard let cgImage = try await loadCGImage(from: image) else {
            throw AppError.imageLoadFailed
        }
        let enhancer = CoreMLPhotoEnhancer.shared
        guard let enhanced = enhancer.enhanceFace(cgImage: cgImage),
              let resultData = UIImage(cgImage: enhanced).jpegData(compressionQuality: 0.95) else {
            throw AppError.processingFailed("Face enhancement failed")
        }
        return resultData
    }

    public func enhanceColor(_ image: Data) async throws -> Data {
        guard let cgImage = try await loadCGImage(from: image) else {
            throw AppError.imageLoadFailed
        }
        let enhancer = CoreMLPhotoEnhancer.shared
        guard let enhanced = enhancer.enhanceColor(cgImage: cgImage),
              let resultData = UIImage(cgImage: enhanced).jpegData(compressionQuality: 0.95) else {
            throw AppError.processingFailed("Color enhancement failed")
        }
        return resultData
    }

    private func loadCGImage(from data: Data) async throws -> CGImage? {
        try await withCheckedThrowingContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
                    continuation.resume(returning: nil)
                    return
                }
                let options: [CFString: Any] = [
                    kCGImageSourceShouldCache: true,
                    kCGImageSourceShouldAllowFloat: true
                ]
                let image = CGImageSourceCreateImageAtIndex(source, 0, options as CFDictionary)
                continuation.resume(returning: image)
            }
        }
    }
}
