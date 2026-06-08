import XCTest
@testable import AIPhotoEnhancerPro

final class AIEnhancementTests: XCTestCase {

    var enhancementService: AIEnhancementService!
    var pipeline: AIImageProcessingPipeline!

    override func setUp() async throws {
        enhancementService = AIEnhancementService()
        pipeline = AIImageProcessingPipeline.shared
    }

    override func tearDown() async throws {
        enhancementService = nil
    }

    func testEnhancementModeProperties() {
        XCTAssertEqual(EnhancementMode.standard.displayName, "Standard")
        XCTAssertEqual(EnhancementMode.ultraHD.suggestedScale, 4)
        XCTAssertEqual(EnhancementMode.superResolution.suggestedScale, 4)
        XCTAssertTrue(EnhancementMode.portrait.usesFaceEnhancement)
        XCTAssertTrue(EnhancementMode.night.usesDenoising)
        XCTAssertTrue(EnhancementMode.landscape.usesColorEnhancement)
        XCTAssertFalse(EnhancementMode.anime.usesFaceEnhancement)
    }

    func testAllModesHaveUniqueIDs() {
        let ids = EnhancementMode.allCases.map { $0.id }
        let uniqueIDs = Set(ids)
        XCTAssertEqual(ids.count, uniqueIDs.count)
    }

    func testAppSettingsDefaultValues() {
        let settings = AppSettings.default
        XCTAssertEqual(settings.theme, .system)
        XCTAssertEqual(settings.aiQuality, .balanced)
        XCTAssertEqual(settings.exportQuality, 0.95)
        XCTAssertEqual(settings.exportFormat, .jpeg)
        XCTAssertTrue(settings.autoSaveToPhotos)
        XCTAssertTrue(settings.hapticFeedbackEnabled)
    }

    func testExportFormatExtensions() {
        XCTAssertEqual(ExportFormat.png.fileExtension, "png")
        XCTAssertEqual(ExportFormat.jpeg.fileExtension, "jpg")
        XCTAssertEqual(ExportFormat.heic.fileExtension, "heic")
    }

    func testProcessedImageEquality() {
        let url = URL(string: "file:///test")!
        let image1 = ProcessedImage(
            originalURL: url,
            processedURL: url,
            thumbnailURL: url,
            mode: .standard
        )
        let image2 = ProcessedImage(
            id: image1.id,
            originalURL: url,
            processedURL: url,
            thumbnailURL: url,
            mode: .standard
        )
        XCTAssertEqual(image1, image2)
    }

    func testDIContainerRegistration() {
        let container = DIContainer.shared
        container.reset()

        container.register(String.self, service: "test")
        let resolved: String = container.resolve()
        XCTAssertEqual(resolved, "test")
    }

    func testDIContainerFactory() {
        let container = DIContainer.shared
        container.reset()

        container.register(Int.self) { 42 }
        let resolved: Int = container.resolve()
        XCTAssertEqual(resolved, 42)
    }

    func testDIContainerResolveIfPresent() {
        let container = DIContainer.shared
        container.reset()

        container.register(Double.self, service: 3.14)
        let resolved: Double? = container.resolveIfPresent()
        XCTAssertEqual(resolved, 3.14)

        let missing: String? = container.resolveIfPresent()
        XCTAssertNil(missing)
    }

    func testAIQualityDescriptions() {
        XCTAssertEqual(AIQuality.fast.description, "Quick results with good quality")
        XCTAssertEqual(AIQuality.balanced.description, "Balanced quality and speed")
        XCTAssertEqual(AIQuality.maximum.description, "Best quality, takes longer")
    }

    func testImageFormatter() {
        let formatter = ImageFormatter.shared
        let size = formatter.formatFileSize(1024)
        XCTAssertFalse(size.isEmpty)
        let date = formatter.formatDate(Date())
        XCTAssertFalse(date.isEmpty)
        let dims = formatter.formatDimensions(width: 1920, height: 1080)
        XCTAssertEqual(dims, "1920 × 1080")
    }

    func testEnhancementModeCaseCount() {
        XCTAssertEqual(EnhancementMode.allCases.count, 8)
    }

    func testExportFormatCaseCount() {
        XCTAssertEqual(ExportFormat.allCases.count, 3)
    }

    func testAppLanguageCaseCount() {
        XCTAssertEqual(AppLanguage.allCases.count, 8)
    }

    func testThemeModeCaseCount() {
        XCTAssertEqual(ThemeMode.allCases.count, 3)
    }

    func testAIQualityCaseCount() {
        XCTAssertEqual(AIQuality.allCases.count, 3)
    }

    func testAppErrorRecoveryMessages() {
        let loadError = AppError.imageLoadFailed
        XCTAssertNotNil(loadError.recoveryMessage)

        let memoryError = AppError.insufficientMemory
        XCTAssertNotNil(memoryError.recoveryMessage)
    }
}
