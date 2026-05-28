#!/bin/bash
set -e

# Download and install Flutter
echo "Installing Flutter..."
FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.22.0-stable.tar.xz"
curl -L $FLUTTER_URL -o flutter.tar.xz
tar -xf flutter.tar.xz
rm flutter.tar.xz

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
