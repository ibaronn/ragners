import Foundation

public final class DIContainer {
    public static let shared = DIContainer()

    private var services: [String: Any] = [:]
    private var factories: [String: () -> Any] = [:]
    private let lock = NSLock()

    private init() {}

    public func register<T>(_ type: T.Type, service: T) {
        lock.lock()
        defer { lock.unlock() }
        let key = String(describing: type)
        services[key] = service
    }

    public func register<T>(_ type: T.Type, factory: @escaping () -> T) {
        lock.lock()
        defer { lock.unlock() }
        let key = String(describing: type)
        factories[key] = factory
    }

    public func resolve<T>() -> T {
        lock.lock()
        defer { lock.unlock() }
        let key = String(describing: T.self)
        if let service = services[key] as? T {
            return service
        }
        if let factory = factories[key] {
            let service = factory()
            services[key] = service
            return service as! T
        }
        fatalError("No registered service for \(T.self)")
    }

    public func resolveIfPresent<T>() -> T? {
        lock.lock()
        defer { lock.unlock() }
        let key = String(describing: T.self)
        return services[key] as? T
    }

    public func reset() {
        lock.lock()
        defer { lock.unlock() }
        services.removeAll()
        factories.removeAll()
    }
}

@propertyWrapper
public struct Inject<T> {
    private let container: DIContainer

    public init(container: DIContainer = .shared) {
        self.container = container
    }

    public var wrappedValue: T {
        container.resolve()
    }
}
