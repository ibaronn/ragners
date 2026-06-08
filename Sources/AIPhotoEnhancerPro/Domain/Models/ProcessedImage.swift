import Foundation

public struct ProcessedImage: Identifiable, Codable, Hashable {
    public let id: String
    public let originalURL: URL
    public let processedURL: URL
    public let thumbnailURL: URL
    public let mode: EnhancementMode
    public let createdAt: Date
    public let fileSize: Int64
    public let dimensions: ImageDimensions

    public init(
        id: String = UUID().uuidString,
        originalURL: URL,
        processedURL: URL,
        thumbnailURL: URL,
        mode: EnhancementMode,
        createdAt: Date = Date(),
        fileSize: Int64 = 0,
        dimensions: ImageDimensions = ImageDimensions(width: 0, height: 0)
    ) {
        self.id = id
        self.originalURL = originalURL
        self.processedURL = processedURL
        self.thumbnailURL = thumbnailURL
        self.mode = mode
        self.createdAt = createdAt
        self.fileSize = fileSize
        self.dimensions = dimensions
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public static func == (lhs: ProcessedImage, rhs: ProcessedImage) -> Bool {
        lhs.id == rhs.id
    }
}

public struct ImageDimensions: Codable, Hashable {
    public let width: Int
    public let height: Int

    public init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }
}

public enum ExportFormat: String, CaseIterable, Identifiable, Codable {
    case png
    case jpeg
    case heic

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .png: return "PNG"
        case .jpeg: return "JPEG"
        case .heic: return "HEIC"
        }
    }

    public var fileExtension: String {
        switch self {
        case .png: return "png"
        case .jpeg: return "jpg"
        case .heic: return "heic"
        }
    }

    public var utType: String {
        switch self {
        case .png: return "public.png"
        case .jpeg: return "public.jpeg"
        case .heic: return "public.heic"
        }
    }
}
