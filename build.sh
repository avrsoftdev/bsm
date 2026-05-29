#!/bin/bash
set -e

# Fix git dubious ownership issue
git config --global --add safe.directory '*'

# Download and install the current Flutter stable release
echo "Installing Flutter..."
git clone --depth 1 --branch stable https://github.com/flutter/flutter.git flutter

# Add Flutter to PATH
export PATH="$PATH:$(pwd)/flutter/bin"
export FLUTTER_HOME="$(pwd)/flutter"

# Verify Flutter installation
flutter --version
dart --version

# Install dependencies
echo "Getting Flutter dependencies..."
flutter config --enable-web
flutter pub get

# Build for web
echo "Building Flutter web..."
flutter build web --release

echo "Build complete!"
