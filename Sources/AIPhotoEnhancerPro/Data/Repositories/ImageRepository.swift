import Foundation
import UIKit
import ImageIO

public final class ImageRepository: ImageRepositoryProtocol {
    private let fileManager: FileManager
    private let cacheDirectory: URL

    public init() {
        self.fileManager = FileManager.default
        let cachesDir = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        self.cacheDirectory = cachesDir.appendingPathComponent("ProcessedImages", isDirectory: true)
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }

    public func saveImage(_ data: Data, name: String) async throws -> URL {
        let fileURL = cacheDirectory.appendingPathComponent(name)
        try data.write(to: fileURL, options: .atomic)
        return fileURL
    }

    public func loadImage(url: URL) async throws -> Data {
        guard fileManager.fileExists(atPath: url.path) else {
            throw AppError.imageLoadFailed
        }
        return try Data(contentsOf: url)
    }

    public func deleteImage(url: URL) async throws {
        guard fileManager.fileExists(atPath: url.path) else { return }
        try fileManager.removeItem(at: url)
    }

    public func getSavedImages() async throws -> [ProcessedImage] {
        guard fileManager.fileExists(atPath: cacheDirectory.path) else { return [] }

        let contents = try fileManager.contentsOfDirectory(
            at: cacheDirectory,
            includingPropertiesForKeys: [.contentModificationDateKey, .fileSizeKey],
            options: .skipsHiddenFiles
        )

        return contents.compactMap { url -> ProcessedImage? in
            guard let attrs = try? fileManager.attributesOfItem(atPath: url.path),
                  let fileSize = attrs[.size] as? Int64,
                  let modDate = attrs[.modificationDate] as? Date else {
                return nil
            }

            let dimensions = extractDimensions(from: url)

            return ProcessedImage(
                originalURL: url,
                processedURL: url,
                thumbnailURL: url,
                mode: .standard,
                createdAt: modDate,
                fileSize: fileSize,
                dimensions: dimensions
            )
        }
        .sorted { $0.createdAt > $1.createdAt }
    }

    private func extractDimensions(from url: URL) -> ImageDimensions {
        guard let source = CGImageSourceCreateWithURL(url as CFURL, nil),
              let props = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [CFString: Any] else {
            return ImageDimensions(width: 0, height: 0)
        }
        let width = props[kCGImagePropertyPixelWidth] as? Int ?? 0
        let height = props[kCGImagePropertyPixelHeight] as? Int ?? 0
        return ImageDimensions(width: width, height: height)
    }

    public func clearAll() throws {
        guard fileManager.fileExists(atPath: cacheDirectory.path) else { return }
        try fileManager.removeItem(at: cacheDirectory)
        try fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }

    public func getCacheSize() -> UInt64 {
        guard fileManager.fileExists(atPath: cacheDirectory.path) else { return 0 }
        guard let contents = try? fileManager.contentsOfDirectory(
            at: cacheDirectory,
            includingPropertiesForKeys: [.fileSizeKey],
            options: .skipsHiddenFiles
        ) else { return 0 }

        return contents.reduce(0) { total, url in
            let attrs = try? fileManager.attributesOfItem(atPath: url.path)
            let size = attrs?[.size] as? UInt64 ?? 0
            return total + size
        }
    }
}
