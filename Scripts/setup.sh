#!/bin/bash

# AI Photo Enhancer Pro - Project Setup Script
# This script sets up the development environment

set -e

echo "🔧 AI Photo Enhancer Pro - Setup"
echo "================================"

# Check for XcodeGen
if ! command -v xcodegen &> /dev/null; then
    echo "⚠️  XcodeGen not found. Installing via Homebrew..."
    if command -v brew &> /dev/null; then
        brew install xcodegen
    else:
        echo "❌ Homebrew not found. Please install XcodeGen manually:"
        echo "   brew install xcodegen"
        echo ""
        echo "   Or open Package.swift directly in Xcode 16+"
        exit 1
    fi
}

# Generate Xcode project
echo "📦 Generating Xcode project..."
xcodegen generate

echo "✅ Project generated successfully!"
echo ""
echo "Open the project:"
echo "   xed ."
echo ""
echo "Or open AIPhotoEnhancerPro.xcodeproj in Xcode."
