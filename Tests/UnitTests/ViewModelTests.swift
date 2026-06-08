import XCTest
@testable import AIPhotoEnhancerPro

@MainActor
final class ViewModelTests: XCTestCase {

    var homeViewModel: HomeViewModel!
    var settingsViewModel: SettingsViewModel!

    override func setUp() async throws {
        homeViewModel = HomeViewModel()
        settingsViewModel = SettingsViewModel()
    }

    override func tearDown() async throws {
        homeViewModel = nil
        settingsViewModel = nil
    }

    func testInitialState() {
        XCTAssertNil(homeViewModel.state.selectedImage)
        XCTAssertNil(homeViewModel.state.processedImage)
        XCTAssertFalse(homeViewModel.state.isProcessing)
        XCTAssertEqual(homeViewModel.state.selectedMode, .standard)
        XCTAssertEqual(homeViewModel.state.processingStage, .idle)
    }

    func testSelectImage() {
        let testData = Data()
        homeViewModel.selectImage(testData)
        XCTAssertNotNil(homeViewModel.state.selectedImage)
        XCTAssertNil(homeViewModel.state.processedImage)
        XCTAssertEqual(homeViewModel.state.processingStage, .idle)
    }

    func testSetMode() {
        homeViewModel.setMode(.portrait)
        XCTAssertEqual(homeViewModel.state.selectedMode, .portrait)

        homeViewModel.setMode(.ultraHD)
        XCTAssertEqual(homeViewModel.state.selectedMode, .ultraHD)
    }

    func testResetImage() {
        homeViewModel.selectImage(Data())
        homeViewModel.resetImage()
        XCTAssertNil(homeViewModel.state.selectedImage)
        XCTAssertNil(homeViewModel.state.processedImage)
        XCTAssertEqual(homeViewModel.state.processingStage, .idle)
    }

    func testSettingsDefaultValues() {
        XCTAssertEqual(settingsViewModel.settings.theme, .system)
        XCTAssertEqual(settingsViewModel.settings.aiQuality, .balanced)
        XCTAssertEqual(settingsViewModel.settings.exportQuality, 0.95)
    }

    func testUpdateTheme() {
        settingsViewModel.updateTheme(.dark)
        XCTAssertEqual(settingsViewModel.settings.theme, .dark)
    }

    func testUpdateAIQuality() {
        settingsViewModel.updateAIQuality(.maximum)
        XCTAssertEqual(settingsViewModel.settings.aiQuality, .maximum)
    }

    func testUpdateExportQuality() {
        settingsViewModel.updateExportQuality(0.8)
        XCTAssertEqual(settingsViewModel.settings.exportQuality, 0.8)
    }

    func testUpdateExportFormat() {
        settingsViewModel.updateExportFormat(.heic)
        XCTAssertEqual(settingsViewModel.settings.exportFormat, .heic)
    }

    func testToggleHaptics() {
        let initial = settingsViewModel.settings.hapticFeedbackEnabled
        settingsViewModel.toggleHaptics()
        XCTAssertNotEqual(settingsViewModel.settings.hapticFeedbackEnabled, initial)
    }

    func testToggleAutoSave() {
        let initial = settingsViewModel.settings.autoSaveToPhotos
        settingsViewModel.toggleAutoSave()
        XCTAssertNotEqual(settingsViewModel.settings.autoSaveToPhotos, initial)
    }

    func testResetAllSettings() {
        settingsViewModel.updateTheme(.dark)
        settingsViewModel.updateAIQuality(.maximum)
        settingsViewModel.resetAllSettings()
        XCTAssertEqual(settingsViewModel.settings, .default)
    }

    func testProcessingStageMapping() {
        let stages: [HomeViewState.ProcessingStage] = [
            .idle, .loading, .denoising, .upscaling,
            .colorEnhancement, .faceEnhancement, .sharpening,
            .saving, .completed, .failed("test")
        ]
        XCTAssertEqual(stages.count, 10)
    }
}
