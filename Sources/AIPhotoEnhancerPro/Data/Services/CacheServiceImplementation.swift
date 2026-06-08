import Foundation
import CryptoKit

public final class CacheServiceImplementation: CacheService {
    private let cache = NSCache<NSString, CacheEntry>()
    private let fileManager: FileManager
    private let cacheDirectory: URL
    private let queue = DispatchQueue(label: "com.aiphotopro.cache", qos: .utility)

    public init() {
        self.fileManager = FileManager.default
        let cachesDir = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        self.cacheDirectory = cachesDir.appendingPathComponent("AIPhotoCache", isDirectory: true)
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)

        cache.countLimit = 100
        cache.totalCostLimit = 500 * 1024 * 1024
    }

    public func get(key: String) -> Data? {
        if let entry = cache.object(forKey: key as NSString) {
            if entry.isExpired {
                remove(key: key)
                return nil
            }
            return entry.data
        }

        let fileURL = cacheDirectory.appendingPathComponent(key.md5)
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        let entry = CacheEntry(data: data, ttl: 3600)
        cache.setObject(entry, forKey: key as NSString, cost: data.count)
        return data
    }

    public func set(key: String, data: Data, ttl: TimeInterval) {
        let entry = CacheEntry(data: data, ttl: ttl)
        cache.setObject(entry, forKey: key as NSString, cost: data.count)

        let fileURL = cacheDirectory.appendingPathComponent(key.md5)
        try? data.write(to: fileURL, options: .atomic)
    }

    public func remove(key: String) {
        cache.removeObject(forKey: key as NSString)
        let fileURL = cacheDirectory.appendingPathComponent(key.md5)
        try? fileManager.removeItem(at: fileURL)
    }

    public func clear() {
        cache.removeAllObjects()
        try? fileManager.removeItem(at: cacheDirectory)
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }

    public func getCacheSize() async throws -> UInt64 {
        return try await withCheckedThrowingContinuation { continuation in
            queue.async {
                guard self.fileManager.fileExists(atPath: self.cacheDirectory.path) else {
                    continuation.resume(returning: 0)
                    return
                }
                guard let contents = try? self.fileManager.contentsOfDirectory(
                    at: self.cacheDirectory,
                    includingPropertiesForKeys: [.fileSizeKey],
                    options: .skipsHiddenFiles
                ) else {
                    continuation.resume(returning: 0)
                    return
                }

                let totalSize = contents.reduce(0) { total, url in
                    let attrs = try? self.fileManager.attributesOfItem(atPath: url.path)
                    let size = attrs?[.size] as? UInt64 ?? 0
                    return total + size
                }
                continuation.resume(returning: totalSize)
            }
        }
    }

    public func clearExpired() {
        guard fileManager.fileExists(atPath: cacheDirectory.path) else { return }
        guard let contents = try? fileManager.contentsOfDirectory(
            at: cacheDirectory,
            includingPropertiesForKeys: [.creationDateKey],
            options: .skipsHiddenFiles
        ) else { return }

        for url in contents {
            guard let attrs = try? fileManager.attributesOfItem(atPath: url.path),
                  let creationDate = attrs[.creationDate] as? Date else { continue }

            if Date().timeIntervalSince(creationDate) > 86400 * 7 {
                try? fileManager.removeItem(at: url)
            }
        }
    }
}

final class CacheEntry {
    let data: Data
    let createdAt: Date
    let ttl: TimeInterval

    var isExpired: Bool {
        Date().timeIntervalSince(createdAt) > ttl
    }

    init(data: Data, ttl: TimeInterval) {
        self.data = data
        self.createdAt = Date()
        self.ttl = ttl
    }
}

private extension String {
    var md5: String {
        let data = Data(self.utf8)
        let hash = Insecure.MD5.hash(data: data)
        return hash.map { String(format: "%02x", $0) }.joined()
    }
}
