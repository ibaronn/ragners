import UIKit

public extension UIImage {
    func resized(to targetSize: CGSize) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }

    func aspectFittedToMax(_ maxDimension: CGFloat) -> UIImage {
        let width = size.width
        let height = size.height
        let maxDim = max(width, height)

        guard maxDim > maxDimension else { return self }

        let scale = maxDimension / maxDim
        let newSize = CGSize(width: width * scale, height: height * scale)
        return resized(to: newSize)
    }

    func thumbnail(size: CGSize) -> UIImage {
        resized(to: size)
    }

    var heicData: Data? {
        heicData(compressionQuality: 0.9)
    }

    func heicData(compressionQuality: CGFloat) -> Data? {
        guard let mutableData = CFDataCreateMutable(nil, 0),
              let destination = CGImageDestinationCreateWithData(mutableData, "public.heic" as CFString, 1, nil) else {
            return nil
        }
        let options: [CFString: Any] = [
            kCGImageDestinationLossyCompressionQuality: compressionQuality
        ]
        guard let cgImage = self.cgImage else { return nil }
        CGImageDestinationAddImage(destination, cgImage, options as CFDictionary)
        guard CGImageDestinationFinalize(destination) else { return nil }
        return mutableData as Data
    }
}
