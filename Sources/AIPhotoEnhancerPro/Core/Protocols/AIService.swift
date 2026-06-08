import Foundation
import CoreGraphics

public protocol AIService {
    var isModelLoaded: Bool { get }
    func loadModels() async throws
    func unloadModels()
    func enhance(_ image: CGImage, mode: EnhancementMode, progress: @escaping (Float) -> Void) async throws -> CGImage
    func upscale(_ image: CGImage, scale: Int, progress: @escaping (Float) -> Void) async throws -> CGImage
    func denoise(_ image: CGImage, intensity: Float) async throws -> CGImage
    func sharpen(_ image: CGImage, intensity: Float) async throws -> CGImage
    func enhanceFace(_ image: CGImage) async throws -> CGImage
    func enhanceColor(_ image: CGImage) async throws -> CGImage
    func applyHDR(_ image: CGImage) async throws -> CGImage
}

public protocol CacheService {
    func get(key: String) -> Data?
    func set(key: String, data: Data, ttl: TimeInterval)
    func remove(key: String)
    func clear()
    func getCacheSize() async throws -> UInt64
    func clearExpired()
}
