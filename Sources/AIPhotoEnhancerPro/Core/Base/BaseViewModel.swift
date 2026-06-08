import Foundation
import Combine

@MainActor
open class BaseViewModel: ObservableObject {
    @Published public var isLoading: Bool = false
    @Published public var error: AppError?
    @Published public var showError: Bool = false

    public var cancellables = Set<AnyCancellable>()

    public init() {}

    public func execute<T>(
        _ operation: () async throws -> T,
        _ completion: ((T) -> Void)? = nil
    ) async {
        isLoading = true
        error = nil
        do {
            let result = try await operation()
            completion?(result)
            isLoading = false
        } catch let appError as AppError {
            self.error = appError
            self.showError = true
            isLoading = false
        } catch {
            self.error = AppError.general(error.localizedDescription)
            self.showError = true
            isLoading = false
        }
    }

    public func handleError(_ appError: AppError) {
        error = appError
        showError = true
    }

    public func dismissError() {
        error = nil
        showError = false
    }

    deinit {
        cancellables.removeAll()
    }
}
