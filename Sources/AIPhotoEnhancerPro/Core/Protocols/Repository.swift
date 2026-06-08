import Foundation

public protocol Repository {
    associatedtype T
    func getAll() async throws -> [T]
    func get(id: String) async throws -> T?
    func save(_ item: T) async throws
    func delete(id: String) async throws
}

public protocol ImageRepositoryProtocol {
    func saveImage(_ data: Data, name: String) async throws -> URL
    func loadImage(url: URL) async throws -> Data
    func deleteImage(url: URL) async throws
    func getSavedImages() async throws -> [ProcessedImage]
}

public protocol AIEnhancementRepositoryProtocol {
    func enhance(_ image: Data, mode: EnhancementMode) async throws -> Data
    func upscale(_ image: Data, scale: Int) async throws -> Data
    func denoise(_ image: Data, intensity: Float) async throws -> Data
    func sharpen(_ image: Data, intensity: Float) async throws -> Data
    func enhanceFace(_ image: Data) async throws -> Data
    func enhanceColor(_ image: Data) async throws -> Data
}
