import Foundation
import CoreGraphics
import CoreImage
import Accelerate
import Metal
import MetalPerformanceShaders

public final class CoreMLPhotoEnhancer {
    public static let shared = CoreMLPhotoEnhancer()
    private let ciContext: CIContext
    private let metalDevice: MTLDevice?

    private init() {
        metalDevice = MTLCreateSystemDefaultDevice()
        if let device = metalDevice {
            ciContext = CIContext(mtlDevice: device, options: [
                .workingColorSpace: CGColorSpace(name: CGColorSpace.sRGB)!,
                .highQualityDownsample: true
            ])
        } else {
            ciContext = CIContext(options: [
                .workingColorSpace: CGColorSpace(name: CGColorSpace.sRGB)!,
                .highQualityDownsample: true
            ])
        }
    }

    public func upscale(cgImage: CGImage, scale: Int) -> CGImage? {
        let inputImage = CIImage(cgImage: cgImage)
        let width = inputImage.extent.width * CGFloat(scale)
        let height = inputImage.extent.height * CGFloat(scale)

        let scaleTransform = CGAffineTransform(scaleX: CGFloat(scale), y: CGFloat(scale))
        let scaledImage = inputImage.transformed(by: scaleTransform)

        guard let lanczosFilter = CIFilter(name: "CILanczosScaleTransform") else {
            return ciContext.createCGImage(scaledImage, from: CGRect(x: 0, y: 0, width: width, height: height))
        }

        lanczosFilter.setValue(scaledImage, forKey: kCIInputImageKey)
        lanczosFilter.setValue(1.0, forKey: kCIInputScaleKey)
        lanczosFilter.setValue(1.0, forKey: kCIInputAspectRatioKey)

        guard let outputImage = lanczosFilter.outputImage else { return nil }
        return ciContext.createCGImage(outputImage, from: outputImage.extent)
    }

    public func denoise(cgImage: CGImage, intensity: Float) -> CGImage? {
        let inputImage = CIImage(cgImage: cgImage)
        guard let noiseFilter = CIFilter(name: "CINoiseReduction") else { return nil }
        noiseFilter.setValue(inputImage, forKey: kCIInputImageKey)
        noiseFilter.setValue(intensity * 0.02, forKey: "inputNoiseLevel")
        noiseFilter.setValue(0.4 * intensity, forKey: "inputSharpness")
        guard let outputImage = noiseFilter.outputImage else { return nil }
        return ciContext.createCGImage(outputImage, from: outputImage.extent)
    }

    public func sharpen(cgImage: CGImage, intensity: Float) -> CGImage? {
        let inputImage = CIImage(cgImage: cgImage)

        guard let sharpenFilter = CIFilter(name: "CISharpenLuminance") else { return nil }
        sharpenFilter.setValue(inputImage, forKey: kCIInputImageKey)
        sharpenFilter.setValue(intensity, forKey: kCIInputSharpnessKey)
        guard let outputImage = sharpenFilter.outputImage else { return nil }

        guard let unsharpFilter = CIFilter(name: "CIUnsharpMask") else {
            return ciContext.createCGImage(outputImage, from: outputImage.extent)
        }
        unsharpFilter.setValue(outputImage, forKey: kCIInputImageKey)
        unsharpFilter.setValue(intensity * 0.5, forKey: kCIInputIntensityKey)
        unsharpFilter.setValue(2.0, forKey: kCIInputRadiusKey)
        guard let finalImage = unsharpFilter.outputImage else { return nil }

        return ciContext.createCGImage(finalImage, from: finalImage.extent)
    }

    public func enhanceColor(cgImage: CGImage) -> CGImage? {
        let inputImage = CIImage(cgImage: cgImage)

        guard let colorFilter = CIFilter(name: "CIColorControls") else { return nil }
        colorFilter.setValue(inputImage, forKey: kCIInputImageKey)
        colorFilter.setValue(1.1, forKey: kCIInputSaturationKey)
        colorFilter.setValue(1.05, forKey: kCIInputContrastKey)
        colorFilter.setValue(0.05, forKey: kCIInputBrightnessKey)
        guard let colorAdjusted = colorFilter.outputImage else { return nil }

        guard let highlightFilter = CIFilter(name: "CIHighlightShadowAdjust") else {
            return ciContext.createCGImage(colorAdjusted, from: colorAdjusted.extent)
        }
        highlightFilter.setValue(colorAdjusted, forKey: kCIInputImageKey)
        highlightFilter.setValue(0.3, forKey: "inputHighlightAmount")
        highlightFilter.setValue(0.3, forKey: "inputShadowAmount")
        guard let outputImage = highlightFilter.outputImage else { return nil }

        guard let vibranceFilter = CIFilter(name: "CIVibrance") else {
            return ciContext.createCGImage(outputImage, from: outputImage.extent)
        }
        vibranceFilter.setValue(outputImage, forKey: kCIInputImageKey)
        vibranceFilter.setValue(0.2, forKey: kCIInputAmountKey)
        guard let finalImage = vibranceFilter.outputImage else { return nil }

        return ciContext.createCGImage(finalImage, from: finalImage.extent)
    }

    public func enhanceFace(cgImage: CGImage) -> CGImage? {
        let inputImage = CIImage(cgImage: cgImage)

        guard let faceBalance = CIFilter(name: "CIFaceBalance") else {
            return enhancePortraitSkin(inputImage)
        }
        faceBalance.setValue(inputImage, forKey: kCIInputImageKey)
        guard let balanceImage = faceBalance.outputImage else {
            return enhancePortraitSkin(inputImage)
        }

        return enhancePortraitSkin(balanceImage)
    }

    private func enhancePortraitSkin(_ image: CIImage) -> CGImage? {
        guard let filter = CIFilter(name: "CIPhotoEffectNoir") else {
            return ciContext.createCGImage(image, from: image.extent)
        }

        guard let skinMask = CIFilter(name: "CISkinToneAdjust") else {
            return ciContext.createCGImage(image, from: image.extent)
        }

        skinMask.setValue(image, forKey: kCIInputImageKey)
        skinMask.setValue(0.5, forKey: "inputSkinTone")
        guard let outputImage = skinMask.outputImage else { return nil }

        guard let smoothFilter = CIFilter(name: "CIBilateralFilter") else {
            return ciContext.createCGImage(outputImage, from: outputImage.extent)
        }
        smoothFilter.setValue(outputImage, forKey: kCIInputImageKey)
        smoothFilter.setValue(3.0, forKey: kCIInputRadiusKey)
        smoothFilter.setValue(0.3, forKey: "inputEdgeStrengh")
        guard let finalImage = smoothFilter.outputImage else { return nil }

        return ciContext.createCGImage(finalImage, from: finalImage.extent)
    }

    public func applyHDR(cgImage: CGImage) -> CGImage? {
        let inputImage = CIImage(cgImage: cgImage)

        guard let toneMap = CIFilter(name: "CIExposureAdjust") else { return nil }
        toneMap.setValue(inputImage, forKey: kCIInputImageKey)
        toneMap.setValue(0.5, forKey: kCIInputEVKey)
        guard let exposedImage = toneMap.outputImage else { return nil }

        guard let highlightFilter = CIFilter(name: "CIHighlightShadowAdjust") else {
            return ciContext.createCGImage(exposedImage, from: exposedImage.extent)
        }
        highlightFilter.setValue(exposedImage, forKey: kCIInputImageKey)
        highlightFilter.setValue(-0.2, forKey: "inputHighlightAmount")
        highlightFilter.setValue(0.5, forKey: "inputShadowAmount")
        guard let shadowImage = highlightFilter.outputImage else { return nil }

        guard let contrastFilter = CIFilter(name: "CIColorControls") else {
            return ciContext.createCGImage(shadowImage, from: shadowImage.extent)
        }
        contrastFilter.setValue(shadowImage, forKey: kCIInputImageKey)
        contrastFilter.setValue(1.3, forKey: kCIInputContrastKey)
        contrastFilter.setValue(1.15, forKey: kCIInputSaturationKey)
        guard let outputImage = contrastFilter.outputImage else { return nil }

        return ciContext.createCGImage(outputImage, from: outputImage.extent)
    }

    public func autoEnhance(cgImage: CGImage) -> CGImage? {
        let inputImage = CIImage(cgImage: cgImage)

        guard let autoFilter = CIFilter(name: "CIAutoAdjustmentFilter") else { return nil }
        autoFilter.setValue(inputImage, forKey: kCIInputImageKey)
        autoFilter.setValue(true, forKey: kCIInputRedEyeKey)
        autoFilter.setValue(true, forKey: kCIInputEnhanceKey)
        autoFilter.setValue(true, forKey: kCIInputShadowsKey)
        guard let outputImage = autoFilter.outputImage else { return nil }

        return ciContext.createCGImage(outputImage, from: outputImage.extent)
    }

    public func restoreOldPhoto(cgImage: CGImage) -> CGImage? {
        let inputImage = CIImage(cgImage: cgImage)

        guard let noiseFilter = CIFilter(name: "CINoiseReduction") else { return nil }
        noiseFilter.setValue(inputImage, forKey: kCIInputImageKey)
        noiseFilter.setValue(0.05, forKey: "inputNoiseLevel")
        noiseFilter.setValue(0.6, forKey: "inputSharpness")
        guard let denoised = noiseFilter.outputImage else { return nil }

        guard let colorFilter = CIFilter(name: "CIWhitePointAdjust") else { return nil }
        colorFilter.setValue(denoised, forKey: kCIInputImageKey)
        colorFilter.setValue(CIColor(color: .white), forKey: kCIInputColorKey)
        guard let colorAdjusted = colorFilter.outputImage else { return nil }

        guard let contrastFilter = CIFilter(name: "CIColorControls") else { return nil }
        contrastFilter.setValue(colorAdjusted, forKey: kCIInputImageKey)
        contrastFilter.setValue(1.2, forKey: kCIInputContrastKey)
        contrastFilter.setValue(1.05, forKey: kCIInputSaturationKey)
        guard let contrasted = contrastFilter.outputImage else { return nil }

        guard let sharpenFilter = CIFilter(name: "CIUnsharpMask") else { return nil }
        sharpenFilter.setValue(contrasted, forKey: kCIInputImageKey)
        sharpenFilter.setValue(0.5, forKey: kCIInputIntensityKey)
        sharpenFilter.setValue(1.5, forKey: kCIInputRadiusKey)
        guard let outputImage = sharpenFilter.outputImage else { return nil }

        return ciContext.createCGImage(outputImage, from: outputImage.extent)
    }
}
