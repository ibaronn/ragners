# Changelog

All notable changes to AI Photo Enhancer Pro will be documented in this file.

## [1.0.0] - 2026-06-08

### Added
- Initial release of AI Photo Enhancer Pro
- 8 AI enhancement modes: Standard, Ultra HD, Portrait, Anime, Landscape, Night, Restore Old Photos, Super Resolution
- Image import from camera, photo library, files app, and drag & drop
- Core Image-based AI processing pipeline with GPU acceleration via Metal
- Face enhancement, noise reduction, sharpening, color enhancement, HDR
- Export to PNG, JPEG, HEIC formats
- Share sheet integration
- Save to Photos with permission handling
- Modern SwiftUI interface with glass effect design
- Dark mode and light mode support
- Customizable settings (theme, AI quality, export quality, format)
- Onboarding flow with feature highlights
- Splash screen with animated logo
- Haptic feedback integration
- Cache management with auto-cleanup
- Privacy-focused: all processing on-device
- Accessibility support
- 120 FPS ProMotion support
- Spring animations and micro-interactions
- Unit tests and UI tests
- Comprehensive documentation

### Technical
- Swift 6 with SwiftUI framework
- MVVM + Clean Architecture
- CoreML and Core Image for AI processing
- Metal Performance Shaders for GPU acceleration
- Async/await concurrency model
- OperationQueue for background processing
- NSCache with file system persistence
- SOLID principles throughout
- No external dependencies required
