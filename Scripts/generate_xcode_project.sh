#!/bin/bash

# Generate Xcode project from Swift Package
# This script creates an Xcode project for development

set -e

echo "Generating Xcode project for AI Photo Enhancer Pro..."

# Generate .xcodeproj from Package.swift
swift package generate-xcodeproj

echo "Xcode project generated successfully."
echo "Open with: xed ."
