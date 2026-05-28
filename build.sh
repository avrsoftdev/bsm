#!/bin/bash

# Download and install Flutter
echo "Installing Flutter..."
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.22.0-stable.tar.xz
tar -xf flutter_linux_3.22.0-stable.tar.xz
export PATH=$PATH:$(pwd)/flutter/bin

# Install dependencies
echo "Getting Flutter dependencies..."
flutter config --enable-web
flutter pub get

# Build for web
echo "Building Flutter web..."
flutter build web --release

echo "Build complete!"
