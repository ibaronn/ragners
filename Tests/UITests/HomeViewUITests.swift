import XCTest

final class HomeViewUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testAppLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.exists)
    }

    func testNavigationBarExists() throws {
        let app = XCUIApplication()
        app.launch()

        let navBar = app.navigationBars["AI Enhancer"]
        XCTAssertTrue(navBar.exists)
    }

    func testUploadCardExists() throws {
        let app = XCUIApplication()
        app.launch()

        let uploadLabel = app.staticTexts["Tap to Upload"]
        XCTAssertTrue(uploadLabel.exists)
    }

    func testSettingsButtonExists() throws {
        let app = XCUIApplication()
        app.launch()

        let settingsButton = app.buttons["gearshape.fill"]
        XCTAssertTrue(settingsButton.exists)
    }

    func testModeSelectorExists() throws {
        let app = XCUIApplication()
        app.launch()

        let standardButton = app.buttons["Standard"]
        XCTAssertTrue(standardButton.exists)

        let ultraHDButton = app.buttons["Ultra HD"]
        XCTAssertTrue(ultraHDButton.exists)
    }

    func testTabNavigation() throws {
        let app = XCUIApplication()
        app.launch()

        let settingsTab = app.tabBars.buttons["Settings"]
        XCTAssertTrue(settingsTab.exists)
        settingsTab.tap()

        let enhanceTab = app.tabBars.buttons["Enhance"]
        XCTAssertTrue(enhanceTab.exists)
        enhanceTab.tap()
    }

    func testSettingsViewElements() throws {
        let app = XCUIApplication()
        app.launch()

        let settingsTab = app.tabBars.buttons["Settings"]
        settingsTab.tap()

        let themePicker = app.buttons["Theme"]
        XCTAssertTrue(themePicker.exists)
    }

    func testAccessibility() throws {
        let app = XCUIApplication()
        app.launch()

        let enhanceButton = app.buttons["Enhance Image"]
        XCTAssertTrue(enhanceButton.exists)
    }
}
