#!/bin/bash

echo "🚀 Starting Breach build process..."

# Clean previous builds
echo "🧹 Cleaning previous builds..."
flutter clean
flutter pub get

# Build for Android
echo "📱 Building Android APK..."
flutter build apk --release
echo "✅ Android APK built successfully!"

# Build for iOS (macOS only)
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "🍎 Building iOS app..."
    flutter build ios --release
    echo "✅ iOS app built successfully!"
else
    echo "⚠️ iOS build skipped (requires macOS)"
fi

# Build for Web
echo "🌐 Building Web app..."
flutter build web --release
echo "✅ Web app built successfully!"

echo "🎉 Build process completed!"
echo "📦 Outputs:"
echo "  - Android: build/app/outputs/flutter-apk/app-release.apk"
echo "  - iOS: build/ios/iphoneos/Runner.app (macOS only)"
echo "  - Web: build/web/"
