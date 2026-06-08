// swift-tools-version: 5.9

import PackageDescription
import Foundation

let package = Package(
    name: "AIPhotoEnhancerPro",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "AIPhotoEnhancerPro",
            targets: ["AIPhotoEnhancerPro"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "AIPhotoEnhancerPro",
            dependencies: [],
            path: "Sources/AIPhotoEnhancerPro",
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "UnitTests",
            dependencies: ["AIPhotoEnhancerPro"],
            path: "Tests/UnitTests"
        ),
        .testTarget(
            name: "UITests",
            dependencies: ["AIPhotoEnhancerPro"],
            path: "Tests/UITests"
        ),
    ]
)
