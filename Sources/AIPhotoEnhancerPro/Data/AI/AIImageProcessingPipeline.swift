import Foundation
import CoreGraphics
import CoreImage
import UIKit

public final class AIImageProcessingPipeline {
    public static let shared = AIImageProcessingPipeline()

    private let enhancer = CoreMLPhotoEnhancer.shared
    private let processingQueue = DispatchQueue(
        label: "com.aiphotopro.pipeline",
        qos: .userInitiated,
        attributes: .concurrent
    )

    private init() {}

    public func processImage(
        _ imageData: Data,
        mode: EnhancementMode,
        quality: AIQuality,
        progressHandler: @escaping (Float) -> Void
    ) async throws -> Data {
        progressHandler(0.05)

        guard let cgImage = try await loadCGImage(from: imageData) else {
            throw AppError.imageLoadFailed
        }

        progressHandler(0.1)

        let scaledImage: CGImage

        switch quality {
        case .fast:
            let maxDimension: CGFloat = 2048
            scaledImage = try await resizeImageIfNeeded(cgImage, maxDimension: maxDimension)
        case .balanced:
            let maxDimension: CGFloat = 4096
            scaledImage = try await resizeImageIfNeeded(cgImage, maxDimension: maxDimension)
        case .maximum:
            scaledImage = cgImage
        }

        progressHandler(0.2)

        let service = AIEnhancementService()

        let resultImage = try await service.enhance(scaledImage, mode: mode) { progress in
            let mappedProgress = 0.2 + (progress * 0.7)
            progressHandler(mappedProgress)
        }

        progressHandler(0.9)

        guard let resultData = try await imageToData(resultImage, quality: quality) else {
            throw AppError.processingFailed("Failed to convert result to data")
        }

        progressHandler(1.0)
        return resultData
    }

    private func loadCGImage(from data: Data) async throws -> CGImage? {
        try await withCheckedThrowingContinuation { continuation in
            processingQueue.async {
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

    private func resizeImageIfNeeded(_ image: CGImage, maxDimension: CGFloat) async throws -> CGImage {
        let width = CGFloat(image.width)
        let height = CGFloat(image.height)

        guard max(width, height) > maxDimension else { return image }

        let scale = maxDimension / max(width, height)
        let newWidth = Int(width * scale)
        let newHeight = Int(height * scale)

        let inputImage = CIImage(cgImage: image)
        guard let filter = CIFilter(name: "CILanczosScaleTransform") else { return image }

        filter.setValue(inputImage, forKey: kCIInputImageKey)
        filter.setValue(scale, forKey: kCIInputScaleKey)
        filter.setValue(1.0, forKey: kCIInputAspectRatioKey)

        guard let outputImage = filter.outputImage else { return image }
        let ciContext = CIContext(options: [.workingColorSpace: CGColorSpace(name: CGColorSpace.sRGB)!])
        guard let result = ciContext.createCGImage(outputImage, from: outputImage.extent) else {
            return image
        }
        return result
    }

    private func imageToData(_ image: CGImage, quality: AIQuality) async throws -> Data? {
        let uiImage = UIImage(cgImage: image)
        let compression: CGFloat = quality == .maximum ? 1.0 : 0.9
        return uiImage.jpegData(compressionQuality: compression)
    }
}
