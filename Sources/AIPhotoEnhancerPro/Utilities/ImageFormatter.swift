import Foundation

public final class ImageFormatter {
    public static let shared = ImageFormatter()

    private let byteFormatter: ByteCountFormatter
    private let dateFormatter: DateFormatter
    private let relativeDateFormatter: RelativeDateTimeFormatter

    private init() {
        byteFormatter = ByteCountFormatter()
        byteFormatter.countStyle = .file

        dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short

        relativeDateFormatter = RelativeDateTimeFormatter()
        relativeDateFormatter.unitsStyle = .abbreviated
    }

    public func formatFileSize(_ bytes: Int64) -> String {
        byteFormatter.string(fromByteCount: bytes)
    }

    public func formatDate(_ date: Date) -> String {
        dateFormatter.string(from: date)
    }

    public func formatRelativeDate(_ date: Date) -> String {
        relativeDateFormatter.localizedString(for: date, relativeTo: Date())
    }

    public func formatDimensions(width: Int, height: Int) -> String {
        "\(width) × \(height)"
    }

    public func formatProcessingTime(_ seconds: TimeInterval) -> String {
        if seconds < 1 {
            return "\(Int(seconds * 1000))ms"
        } else if seconds < 60 {
            return String(format: "%.1fs", seconds)
        } else {
            let minutes = Int(seconds) / 60
            let secs = Int(seconds) % 60
            return "\(minutes)m \(secs)s"
        }
    }
}
