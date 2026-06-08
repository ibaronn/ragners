import Foundation
import CoreGraphics

public final class LoadImageUseCase: UseCase {
    public typealias Input = URL
    public typealias Output = CGImage

    public init() {}

    public func execute(_ input: URL) async throws -> CGImage {
        let data = try Data(contentsOf: input)
        guard let dataProvider = CGDataProvider(data: data as CFData) else {
            throw AppError.imageLoadFailed
        }
        guard let cgImage = CGImage(
            jpegDataProviderSource: dataProvider,
            decode: nil,
            shouldInterpolate: true,
            intent: .defaultIntent
        ) ?? CGImage(
            pngDataProviderSource: dataProvider,
            decode: nil,
            shouldInterpolate: true,
            intent: .defaultIntent
        ) else {
            throw AppError.imageLoadFailed
        }
        return cgImage
    }
}
