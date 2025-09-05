# Breach - Content Discovery Platform

A modern Flutter application for discovering and consuming personalized content through an intuitive feed-based
interface. Breach breaks through the noise to help users find content that matters to them.

## 🎯 Project Overview

Breach is a sophisticated content discovery platform built with Flutter, featuring a clean architecture, smooth
animations, and comprehensive state management. The app provides users with a personalized feed of blog posts and live
streams based on their interests.

## ✨ Key Features

### 🎨 **Modern UI/UX Design**

- **Light & Dark Mode Support**: Comprehensive theming system with automatic system preference detection
- **Smooth Animations**: Custom entrance animations, micro-interactions, and transitions throughout the app
- **Responsive Design**: Optimized layouts for various screen sizes and orientations
- **Material Design 3**: Following latest design guidelines with custom color schemes

### 🏗️ **Clean Architecture**

- **Domain-Driven Design**: Clear separation of concerns with domain, data, and presentation layers
- **Feature-Based Structure**: Organized by features (auth, home, onboarding) for better maintainability
- **Repository Pattern**: Abstracted data access with clean interfaces
- **Dependency Injection**: Proper separation and testability

### 🔄 **State Management**

- **Built-in Flutter State Management**: Utilizing `ChangeNotifier` and `ValueNotifier` for reactive UI updates
- **Custom ViewModels**: MVVM pattern implementation for business logic separation
- **Reactive Programming**: Real-time updates with WebSocket integration
- **Form Validation**: Comprehensive input validation with user feedback

### 🚀 **Advanced Features**

- **Real-time Streaming**: WebSocket integration for live content updates
- **Category Filtering**: Dynamic content filtering based on user interests
- **Onboarding Flow**: Smooth user introduction with interest selection
- **Authentication System**: Secure login/signup with JWT token management
- **Offline Support**: SharedPreferences for data persistence
- **Error Handling**: Comprehensive error management with user-friendly messages

## 🛠️ How to Build

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / VS Code with Flutter extensions
- Android SDK for Android builds
- Xcode for iOS builds (macOS only)

### Quick Start

```bash
# Clone the repository
git clone https://github.com/logickoder/breach.git
cd breach

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Build Scripts

#### 🔧 **Build for All Platforms** (build.sh)

```bash
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
```

#### 🎯 **Quick Development Build** (dev-build.sh)

```bash
#!/bin/bash
echo "🔧 Quick development build..."
flutter clean && flutter pub get && flutter run --debug
```

Make scripts executable:

```bash
chmod +x build.sh scripts/dev-build.sh
```

## 📁 Code Structure & Architecture

### Project Organization

```
lib/
├── main.dart                 # App entry point
├── app/                      # Core app infrastructure
│   ├── components/           # Reusable UI components
│   ├── data/                 # Global data models & API client
│   └── theme/               # Theme configuration & colors
├── auth/                     # Authentication feature
│   ├── auth_screen.dart     # Login/Signup UI with animations
│   ├── auth_view_model.dart # Authentication business logic
│   ├── data/                # Auth DTOs and models
│   └── domain/              # Auth use cases & interceptors
├── home/                     # Main feed feature
│   ├── home_screen.dart     # Main feed UI with animations
│   ├── home_screen_view_model.dart # Feed business logic
│   ├── components/          # Feed-specific components
│   ├── data/                # Blog post models
│   └── domain/              # Feed state management
├── onboarding/              # User onboarding flow
│   ├── onboarding_screen.dart    # Welcome & interest selection
│   ├── select_interests_*.dart   # Interest selection logic
│   ├── components/          # Onboarding-specific UI
│   ├── data/                # Interest models
│   └── domain/              # Onboarding use cases
└── dashboard/               # Navigation & main container
    ├── dashboard_screen.dart     # Bottom navigation
    └── empty_dashboard_screen.dart # Placeholder states
```

### 🏛️ **Architecture Patterns**

#### **MVVM (Model-View-ViewModel)**

```dart
// Example: HomeScreenViewModel
class HomeScreenViewModel extends ChangeNotifier {
  // State management with ValueNotifier for reactive UI
  final postState = ValueNotifier<PostState>(const PostState());

  // Business logic separated from UI
  Future<void> loadBlogPosts() async {
    // Implementation
  }

  // UI updates through notifyListeners()
  void selectCategory(Category? category) {
    _selectedCategory = category;
    notifyListeners();
    loadBlogPosts();
  }
}
```

#### **Repository Pattern**

```dart
// Clean data access abstraction
class OnboardingUseCase {
  static Future<List<Interest>> getSavedInterests() async {
    // Data access logic
  }
}
```

#### **State Management Flow**

```
UI Input → ViewModel → UseCase → Repository → API/Storage
      ← Notification ← State Update ← Data Response ←
```

## 🎨 Key Technical Implementations

### **1. Theme System**

```dart
// Comprehensive theming with light/dark mode support
class AppTheme extends ThemeExtension<AppTheme> {
  final AppColors colors;

  // Automatic theme switching based on system preferences
  static ThemeData light() =>
      ThemeData(
        brightness: Brightness.light,
        extensions: [AppTheme(colors: AppColors.light)],
      );
}
```

### **2. Animation System**

```dart
// Custom entrance animations for enhanced UX
class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  // Staggered animations for smooth user experience
  Widget _buildForm() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(position: _slideAnimation, child: content),
    );
  }
}
```

### **3. Real-time Updates**

```dart
// WebSocket integration for live content
void _connectToWebSocket() async {
  _webSocketChannel = WebSocketChannel.connect(wsUri);
  _webSocketSubscription = _webSocketChannel!.stream.listen(
    _handleWebSocketMessage,
    onError: _handleWebSocketError,
  );
}
```

### **4. Category Filtering**

```dart
// Dynamic content filtering with smooth UI updates
void selectCategory(Category? category) {
  if (_selectedCategory != category) {
    _selectedCategory = category;
    notifyListeners();
    loadBlogPosts(); // Automatically refresh content
  }
}

Future<void> loadBlogPosts() async {
  String endpoint = '/blog/posts';
  if (_selectedCategory != null) {
    endpoint += '?categoryId=${_selectedCategory!.id}';
  }
  // API call with conditional filtering
}
```

## 🎬 Demo Videos

📱 **[Android Demo Video](https://drive.google.com/placeholder-android-demo)**

- Authentication flow with animations
- Interest selection onboarding
- Main feed with category filtering
- Real-time stream updates
- Dark/Light mode switching

🍎 **[iOS Demo Video](https://drive.google.com/placeholder-ios-demo)**

- Native iOS feel and animations
- Gesture navigation
- Platform-specific UI adaptations
- Performance demonstrations

## 🔧 Technical Highlights

### **Performance Optimizations**

- **Lazy Loading**: Efficient list rendering with `ListView.builder`
- **Image Caching**: Using `cached_network_image` for optimal image performance
- **Memory Management**: Proper disposal of controllers and listeners
- **State Preservation**: Smart state management to prevent unnecessary rebuilds

### **Code Quality**

- **Type Safety**: Full Dart null safety implementation
- **Error Handling**: Comprehensive error boundaries with user feedback
- **Code Documentation**: Well-documented classes and methods
- **Consistent Naming**: Following Dart conventions throughout

### **User Experience**

- **Micro-interactions**: Button press animations and hover effects
- **Loading States**: Elegant loading indicators with smooth transitions
- **Empty States**: Thoughtful placeholder content and messaging
- **Form Validation**: Real-time input validation with helpful error messages

### **Accessibility**

- **Semantic Labels**: Proper accessibility labeling for screen readers
- **High Contrast**: Color schemes optimized for visibility
- **Touch Targets**: Appropriately sized interactive elements
- **Keyboard Navigation**: Full keyboard support where applicable

## 🚀 Getting Started with Development

1. **Setup Environment**
   ```bash
   flutter doctor -v  # Verify Flutter installation
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Run Development Server**
   ```bash
   flutter run --debug
   ```

4. **Build for Production**
   ```bash
   ./scripts/build.sh  # Use provided build script
   ```

## 📝 API Integration

The app integrates with a REST API for content management:

- **Authentication**: JWT-based authentication system
- **Content Feed**: Paginated blog posts with filtering
- **Real-time Updates**: WebSocket connection for live streams
- **User Preferences**: Interest selection and profile management

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🔗 Repository

**GitHub Repository**: [https://github.com/logickoder/breach](https://github.com/logickoder/breach)

---

*Built with ❤️ using Flutter*
