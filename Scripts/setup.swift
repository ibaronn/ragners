#!/usr/bin/env swift

import Foundation

// AI Photo Enhancer Pro - Setup Assistant
// Run: swift Scripts/setup.swift

print("""
╔══════════════════════════════════════════╗
║    AI Photo Enhancer Pro - Setup         ║
║    macOS Setup Assistant                 ║
╚══════════════════════════════════════════╝
""")

let fileManager = FileManager.default
let currentPath = fileManager.currentDirectoryPath

// Verify project structure
print("📁 Verifying project structure...")

let requiredDirectories = [
    "Sources/AIPhotoEnhancerPro/App",
    "Sources/AIPhotoEnhancerPro/Core/Protocols",
    "Sources/AIPhotoEnhancerPro/Core/DependencyInjection",
    "Sources/AIPhotoEnhancerPro/Core/Base",
    "Sources/AIPhotoEnhancerPro/Domain/Models",
    "Sources/AIPhotoEnhancerPro/Domain/UseCases",
    "Sources/AIPhotoEnhancerPro/Domain/RepositoryInterfaces",
    "Sources/AIPhotoEnhancerPro/Data/Repositories",
    "Sources/AIPhotoEnhancerPro/Data/Services",
    "Sources/AIPhotoEnhancerPro/Data/AI",
    "Sources/AIPhotoEnhancerPro/Presentation/ViewModels",
    "Sources/AIPhotoEnhancerPro/Presentation/States",
    "Sources/AIPhotoEnhancerPro/UI/Views",
    "Sources/AIPhotoEnhancerPro/UI/Components",
    "Sources/AIPhotoEnhancerPro/UI/Navigation",
    "Sources/AIPhotoEnhancerPro/UI/Onboarding",
    "Sources/AIPhotoEnhancerPro/UI/Settings",
    "Sources/AIPhotoEnhancerPro/Utilities",
    "Sources/AIPhotoEnhancerPro/Extensions",
    "Sources/AIPhotoEnhancerPro/Resources",
    "Tests/UnitTests",
    "Tests/UITests",
    "Scripts",
    "Documentation",
    "Screenshots"
]

var allValid = true
for dir in requiredDirectories {
    let path = currentPath + "/" + dir
    var isDirectory: ObjCBool = false
    let exists = fileManager.fileExists(atPath: path, isDirectory: &isDirectory)
    if exists && isDirectory.boolValue {
        print("  ✅ \(dir)")
    } else {
        print("  ❌ \(dir) - MISSING")
        allValid = false
    }
}

if allValid {
    print("\n✅ Project structure is complete!")
} else {
    print("\n⚠️  Some directories are missing")
}

print("""

📖 Quick Start:
   - Open terminal in project directory
   - Run: xcodegen generate
   - Open: xed .
   - Select iOS 17+ simulator
   - Build & Run (Cmd+R)
""")
