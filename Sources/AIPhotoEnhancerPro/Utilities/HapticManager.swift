import UIKit

public final class HapticManager {
    public static let shared = HapticManager()

    private init() {}

    public func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }

    public func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        UINotificationFeedbackGenerator().notificationOccurred(type)
    }

    public func selection() {
        UISelectionFeedbackGenerator().selectionChanged()
    }

    public func success() {
        notification(.success)
    }

    public func error() {
        notification(.error)
    }

    public func warning() {
        notification(.warning)
    }
}

@propertyWrapper
public struct HapticFeedback {
    public var wrappedValue: () -> Void

    public init(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        self.wrappedValue = {
            HapticManager.shared.impact(style)
        }
    }
}
