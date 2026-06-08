import Foundation
import CoreGraphics
import CoreImage

public final class AIEnhancementService: AIService {
    public var isModelLoaded: Bool = true

    private let enhancer = CoreMLPhotoEnhancer.shared
    private let processingQueue = OperationQueue()

    public init() {
        processingQueue.maxConcurrentOperationCount = 1
        processingQueue.qualityOfService = .userInitiated
    }

    public func loadModels() async throws {
        isModelLoaded = true
    }

    public func unloadModels() {
        isModelLoaded = false
    }

    public func enhance(_ image: CGImage, mode: EnhancementMode, progress: @escaping (Float) -> Void) async throws -> CGImage {
        progress(0.1)

        var currentImage = image

        switch mode {
        case .standard:
            progress(0.3)
            if let enhanced = enhancer.autoEnhance(cgImage: currentImage) {
                currentImage = enhanced
            }
            progress(0.6)
            if let sharpened = enhancer.sharpen(cgImage: currentImage, intensity: 0.4) {
                currentImage = sharpened
            }
            progress(0.9)
            if let colorEnhanced = enhancer.enhanceColor(cgImage: currentImage) {
                currentImage = colorEnhanced
            }

        case .ultraHD:
            progress(0.3)
            if let upscaled = enhancer.upscale(cgImage: currentImage, scale: 2) {
                currentImage = upscaled
            }
            progress(0.5)
            if let hdr = enhancer.applyHDR(cgImage: currentImage) {
                currentImage = hdr
            }
            progress(0.7)
            if let sharpened = enhancer.sharpen(cgImage: currentImage, intensity: 0.7) {
                currentImage = sharpened
            }
            progress(0.9)
            if let colorEnhanced = enhancer.enhanceColor(cgImage: currentImage) {
                currentImage = colorEnhanced
            }

        case .portrait:
            progress(0.3)
            if let faceEnhanced = enhancer.enhanceFace(cgImage: currentImage) {
                currentImage = faceEnhanced
            }
            progress(0.6)
            if let sharpened = enhancer.sharpen(cgImage: currentImage, intensity: 0.3) {
                currentImage = sharpened
            }
            progress(0.8)
            if let colorEnhanced = enhancer.enhanceColor(cgImage: currentImage) {
                currentImage = colorEnhanced
            }

        case .anime:
            progress(0.4)
            if let colorEnhanced = enhancer.enhanceColor(cgImage: currentImage) {
                currentImage = colorEnhanced
            }
            progress(0.7)
            if let sharpened = enhancer.sharpen(cgImage: currentImage, intensity: 0.8) {
                currentImage = sharpened
            }

        case .landscape:
            progress(0.3)
            if let hdr = enhancer.applyHDR(cgImage: currentImage) {
                currentImage = hdr
            }
            progress(0.5)
            if let colorEnhanced = enhancer.enhanceColor(cgImage: currentImage) {
                currentImage = colorEnhanced
            }
            progress(0.7)
            if let sharpened = enhancer.sharpen(cgImage: currentImage, intensity: 0.6) {
                currentImage = sharpened
            }

        case .night:
            progress(0.3)
            if let denoised = enhancer.denoise(cgImage: currentImage, intensity: 0.8) {
                currentImage = denoised
            }
            progress(0.5)
            if let hdr = enhancer.applyHDR(cgImage: currentImage) {
                currentImage = hdr
            }
            progress(0.7)
            if let sharpened = enhancer.sharpen(cgImage: currentImage, intensity: 0.5) {
                currentImage = sharpened
            }

        case .restoreOldPhoto:
            progress(0.3)
            if let restored = enhancer.restoreOldPhoto(cgImage: currentImage) {
                currentImage = restored
            }
            progress(0.6)
            if let faceEnhanced = enhancer.enhanceFace(cgImage: currentImage) {
                currentImage = faceEnhanced
            }
            progress(0.8)
            if let colorEnhanced = enhancer.enhanceColor(cgImage: currentImage) {
                currentImage = colorEnhanced
            }

        case .superResolution:
            progress(0.2)
            if let upscaled = enhancer.upscale(cgImage: currentImage, scale: 4) {
                currentImage = upscaled
            }
            progress(0.4)
            if let denoised = enhancer.denoise(cgImage: currentImage, intensity: 0.3) {
                currentImage = denoised
            }
            progress(0.6)
            if let sharpened = enhancer.sharpen(cgImage: currentImage, intensity: 0.7) {
                currentImage = sharpened
            }
            progress(0.8)
            if let hdr = enhancer.applyHDR(cgImage: currentImage) {
                currentImage = hdr
            }
        }

        progress(1.0)
        return currentImage
    }

    public func upscale(_ image: CGImage, scale: Int, progress: @escaping (Float) -> Void) async throws -> CGImage {
        progress(0.3)
        guard let result = enhancer.upscale(cgImage: image, scale: scale) else {
            throw AppError.processingFailed("Upscaling failed")
        }
        progress(1.0)
        return result
    }

    public func denoise(_ image: CGImage, intensity: Float) async throws -> CGImage {
        guard let result = enhancer.denoise(cgImage: image, intensity: intensity) else {
            throw AppError.processingFailed("Denoising failed")
        }
        return result
    }

    public func sharpen(_ image: CGImage, intensity: Float) async throws -> CGImage {
        guard let result = enhancer.sharpen(cgImage: image, intensity: intensity) else {
            throw AppError.processingFailed("Sharpening failed")
        }
        return result
    }

    public func enhanceFace(_ image: CGImage) async throws -> CGImage {
        guard let result = enhancer.enhanceFace(cgImage: image) else {
            throw AppError.processingFailed("Face enhancement failed")
        }
        return result
    }

    public func enhanceColor(_ image: CGImage) async throws -> CGImage {
        guard let result = enhancer.enhanceColor(cgImage: image) else {
            throw AppError.processingFailed("Color enhancement failed")
        }
        return result
    }

    public func applyHDR(_ image: CGImage) async throws -> CGImage {
        guard let result = enhancer.applyHDR(cgImage: image) else {
            throw AppError.processingFailed("HDR enhancement failed")
        }
        return result
    }
}
