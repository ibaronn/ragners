#!/bin/bash

# AI Photo Enhancer Pro Build Script
# Usage: ./Scripts/build.sh [configuration]

set -e

CONFIGURATION="${1:-Release}"
PROJECT_NAME="AIPhotoEnhancerPro"
SCHEME="AIPhotoEnhancerPro"

echo "Building $PROJECT_NAME with $CONFIGURATION configuration..."

# Resolve Swift packages
echo "Resolving package dependencies..."
xcodebuild -resolvePackageDependencies -project "$PROJECT_NAME.xcodeproj"

# Build
echo "Building..."
xcodebuild build \
    -project "$PROJECT_NAME.xcodeproj" \
    -scheme "$SCHEME" \
    -configuration "$CONFIGURATION" \
    -destination "generic/platform=iOS" \
    -derivedDataPath "./DerivedData" \
    CODE_SIGNING_REQUIRED=NO \
    CODE_SIGN_IDENTITY="" \
    | xcpretty || xcodebuild build \
    -project "$PROJECT_NAME.xcodeproj" \
    -scheme "$SCHEME" \
    -configuration "$CONFIGURATION" \
    -destination "generic/platform=iOS" \
    -derivedDataPath "./DerivedData" \
    CODE_SIGNING_REQUIRED=NO \
    CODE_SIGN_IDENTITY=""

echo "Build completed successfully."
