import Foundation
import UIKit

public final class SaveImageUseCase: UseCase {
    public typealias Input = SaveImageInput
    public typealias Output = URL

    private let imageRepository: ImageRepositoryProtocol

    public init(imageRepository: ImageRepositoryProtocol) {
        self.imageRepository = imageRepository
    }

    public func execute(_ input: SaveImageInput) async throws -> URL {
        var saveData: Data

        switch input.format {
        case .png:
            guard let uiImage = UIImage(data: input.imageData),
                  let pngData = uiImage.pngData() else {
                throw AppError.imageSaveFailed
            }
            saveData = pngData

        case .jpeg:
            guard let uiImage = UIImage(data: input.imageData),
                  let jpegData = uiImage.jpegData(compressionQuality: input.compressionQuality) else {
                throw AppError.imageSaveFailed
            }
            saveData = jpegData

        case .heic:
            guard let uiImage = UIImage(data: input.imageData),
                  let heicData = uiImage.heicData(compressionQuality: input.compressionQuality) else {
                throw AppError.imageSaveFailed
            }
            saveData = heicData
        }

        let name = "export_\(UUID().uuidString).\(input.format.fileExtension)"
        return try await imageRepository.saveImage(saveData, name: name)
    }
}

public struct SaveImageInput {
    public let imageData: Data
    public let format: ExportFormat
    public let compressionQuality: Double

    public init(imageData: Data, format: ExportFormat, compressionQuality: Double = 0.95) {
        self.imageData = imageData
        self.format = format
        self.compressionQuality = compressionQuality
    }
}
