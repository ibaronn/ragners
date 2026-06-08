# AI Photo Enhancer Pro

[![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/platform-iOS%2017%2B-blue.svg)](https://developer.apple.com/ios/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

A premium AI-powered image enhancement application for iPhone. Transform your photos with professional-grade AI enhancement, upscaling, and restoration — all processed locally on your device.

## Features

### AI Enhancement Modes
- **Standard** — Balanced enhancement for everyday photos
- **Ultra HD** — Maximum quality upscaling and detail recovery
- **Portrait** — Optimized face enhancement with natural skin tones
- **Anime** — AI-powered anime style enhancement
- **Landscape** — Enhanced colors and details for scenery
- **Night** — Noise reduction and low-light improvement
- **Restore Old Photos** — Restore and enhance vintage photographs
- **Super Resolution** — 4x upscaling with AI detail recovery

### Image Import
- Camera capture
- Photo library selection
- Files app integration
- Drag & drop support

### Export Options
- PNG, JPEG, HEIC formats
- Adjustable compression quality
- Share sheet integration
- Save directly to Photos

### Privacy First
- 100% on-device processing
- No data leaves your device
- No user tracking
- No account required

## Requirements

- iOS 17.0+
- iPhone with A12 Bionic chip or later
- Xcode 15.0+
- Swift 6.0+

## Installation

### Swift Package Manager

Open the project in Xcode:

```bash
open Package.swift
```

Or add as a dependency in your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/AIPhotoEnhancerPro.git", from: "1.0.0")
]
```

### Building from Source

1. Clone the repository:
```bash
git clone https://github.com/yourusername/AIPhotoEnhancerPro.git
cd AIPhotoEnhancerPro
```

2. Open in Xcode:
```bash
xed .
```

3. Select your target device or simulator

4. Build and run (Cmd+R)

### Release Build

For App Store distribution:

1. In Xcode, select **Product > Archive**
2. Select the latest archive
3. Click **Distribute App**
4. Choose **App Store Connect**
5. Follow the upload workflow

## Architecture

The app follows **MVVM + Clean Architecture** with these layers:

```
┌─────────────────────────────┐
│         UI (Views)          │  SwiftUI views with @StateObject
├─────────────────────────────┤
│    Presentation (ViewModels) │  ObservableObject view models
├─────────────────────────────┤
│      Domain (Use Cases)     │  Business logic and models
├─────────────────────────────┤
│       Data (Services)       │  AI processing and caching
├─────────────────────────────┤
│     Core (Architecture)     │  Protocols, DI, base classes
└─────────────────────────────┘
```

### Key Components

- **CoreMLPhotoEnhancer** — Optimized Core Image processing pipeline with Metal GPU acceleration
- **AIImageProcessingPipeline** — Async processing with progress reporting
- **DIContainer** — Simple dependency injection container
- **CacheService** — Memory and disk caching with TTL expiration

### Technology Stack

| Layer | Technology |
|-------|-----------|
| Language | Swift 6 |
| UI Framework | SwiftUI |
| Architecture | MVVM + Clean Architecture |
| AI Processing | Core Image, Accelerate, vImage |
| GPU Acceleration | Metal, Metal Performance Shaders |
| Concurrency | async/await, Task, OperationQueue |
| Caching | NSCache + File System |
| Minimum iOS | 17.0 |

## Project Structure

```
AIPhotoEnhancerPro/
├── Sources/
│   ├── AIPhotoEnhancerPro/
│   │   ├── App/              # App entry point
│   │   ├── Core/             # Protocols, DI, Base classes
│   │   │   ├── Protocols/
│   │   │   ├── DependencyInjection/
│   │   │   └── Base/
│   │   ├── Domain/           # Models, Use Cases, Interfaces
│   │   │   ├── Models/
│   │   │   ├── UseCases/
│   │   │   └── RepositoryInterfaces/
│   │   ├── Data/             # Services, Repositories, AI
│   │   │   ├── Repositories/
│   │   │   ├── Services/
│   │   │   └── AI/
│   │   ├── Presentation/     # ViewModels, States
│   │   │   ├── ViewModels/
│   │   │   └── States/
│   │   ├── UI/               # Views, Components
│   │   │   ├── Views/
│   │   │   ├── Components/
│   │   │   ├── Navigation/
│   │   │   ├── Onboarding/
│   │   │   └── Settings/
│   │   ├── Utilities/        # Helpers
│   │   ├── Extensions/       # Swift extensions
│   │   └── Resources/        # Assets, Info.plist
│   └── Assets/
├── Tests/
│   ├── UnitTests/
│   └── UITests/
├── Scripts/
├── Documentation/
├── Screenshots/
├── Package.swift
├── README.md
├── CHANGELOG.md
├── LICENSE
└── .gitignore
```

## Performance

- **120 FPS ProMotion** — Smooth animations and transitions
- **GPU Acceleration** — Metal-accelerated image processing
- **Async Processing** — Background processing without UI blocking
- **Memory Optimization** — Automatic cache management
- **Lazy Loading** — On-demand image loading
- **Multi-threading** — Concurrent operation execution

## Testing

Run unit tests:
```bash
swift test
```

Or in Xcode: **Product > Test** (Cmd+U)

## Contributing

See [CONTRIBUTING.md](Documentation/CONTRIBUTING.md) for guidelines.

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

## Privacy

AI Photo Enhancer Pro processes all images entirely on-device. No data is ever uploaded to external servers. No user tracking or analytics are implemented.

---

*Built with SwiftUI and CoreML for iOS 17+*
