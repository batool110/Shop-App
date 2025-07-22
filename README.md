# Shop App - Enhanced E-Commerce Flutter Application

A modern Flutter e-commerce application featuring clean architecture, advanced animations, category filtering, and an intuitive single-screen design.

## 🌟 Features

### ✨ Core Features
- **Product Browsing**: Fetch and display products from [FakeStore API](https://fakestoreapi.com)
- **Enhanced Grid View**: Responsive product grid with interactive cards
- **Smart Favorites**: Add/remove products with animated feedback and local persistence
- **Category Filtering**: Filter products by categories with smooth animations
- **Pagination**: Load more products with infinite scroll and manual load more
- **Hero Animations**: Seamless transitions from product cards to detail views
- **Skeleton Loading**: Beautiful loading animations while fetching data
- **Pull to Refresh**: Refresh product list with pull-down gesture

### 🎨 UI/UX Enhancements
- **Single Screen Design**: Streamlined interface with floating favorites button
- **Enhanced Product Cards**: Interactive cards with scale animations and visual feedback
- **Animated Favorite Button**: Floating action button with pulse and scale animations
- **Category Filter Chips**: Smooth slide animations and chip-based selection
- **Product Details Modal**: Draggable bottom sheet with hero image transitions
- **Material 3 Design**: Modern design system with consistent theming

### 🏗️ Architecture & Design Patterns
- **Clean Architecture**: Separation of concerns with data, domain, and presentation layers
- **Cubit State Management**: Reactive state management with flutter_bloc
- **Repository Pattern**: Abstraction layer for data sources
- **Dependency Injection**: Service locator pattern for dependency management
- **Error Handling**: Comprehensive error handling with custom exceptions

### 📁 Project Structure
```
lib/
├── core/
│   ├── constants/          # App constants, colors, text styles, animation durations
│   ├── error/             # Error handling and custom exceptions
│   ├── network/           # HTTP client with timeout and retry logic
│   ├── theme/             # Material 3 theme configuration
│   └── di/                # Dependency injection and service locator
├── data/
│   ├── models/            # Product and rating data models
│   ├── datasources/       # Remote API and local storage data sources
│   └── repositories/      # Repository implementations with error handling
└── presentation/
    ├── cubits/            # State management (ProductCubit, FavoriteCubit)
    ├── screens/           # MainScreen, FavoritesScreen with animations
    └── widgets/           # Enhanced UI components with animations
        ├── enhanced_product_card.dart    # Interactive product cards with hero animations
        ├── animated_favorite_button.dart # Floating button with pulse animations
        ├── category_filter.dart          # Category filtering with slide animations
        ├── skeleton_loader.dart          # Beautiful loading animations
        └── product_details_modal.dart    # Draggable bottom sheet
```

### 🎨 Enhanced UI Components
- **Enhanced Product Cards**: Interactive cards with scale animations, hero transitions, and visual feedback
- **Animated Favorite Button**: Floating action button with dual animations (scale + pulse)
- **Category Filter**: Horizontal scrollable chips with slide animations
- **Skeleton Loaders**: Shimmer effect loading animations
- **Product Details Modal**: Draggable bottom sheet with hero image animation
- **Custom Theme**: Material 3 design with custom colors and typography
- **Responsive Design**: Adaptive layouts for different screen sizes

### 🔧 Advanced Technical Features
- **Hero Animations**: Seamless image transitions from cards to details
- **Multi-Controller Animations**: Complex animations with multiple animation controllers
- **Category Management**: Dynamic category extraction and filtering
- **Pagination System**: Infinite scroll with manual load more options
- **State Persistence**: Favorites and category selections persist across sessions
- **Image Caching**: Optimized image loading with cached_network_image
- **Error Recovery**: Intelligent retry mechanisms for failed operations
- **Performance Optimized**: Efficient state management and memory usage
- **Error Recovery**: Retry mechanisms for failed operations

## 📱 App Showcase

### Main Features
- **Single Screen Design**: Unified interface with category filtering and floating favorites button
- **Category-Based Filtering**: Filter products by electronics, jewelry, men's/women's clothing
- **Enhanced Animations**: Hero transitions, scale effects, and smooth category switching
- **Smart Pagination**: Automatic loading on scroll with manual load more options
- **Persistent Favorites**: Favorites saved locally and synced across app sessions

### User Experience
- **Intuitive Navigation**: Single screen eliminates tab confusion
- **Visual Feedback**: Interactive animations provide immediate user feedback
- **Smooth Transitions**: Hero animations create seamless flow between screens
- **Loading States**: Beautiful skeleton animations prevent empty screen flashing
- **Error Handling**: User-friendly error messages with retry options

## 🛠️ Dependencies

```yaml
dependencies:
  flutter_bloc: ^8.1.6          # State management
  http: ^1.2.2                  # HTTP requests
  shared_preferences: ^2.3.2    # Local storage
  cached_network_image: ^3.4.1  # Image caching
  equatable: ^2.0.5             # Value equality
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.8.1)
- Dart SDK (>=3.0.0)
- Android Studio / VS Code with Flutter extensions
- Git for version control
- Device/Emulator for testing

### Installation Steps

1. **Clone the to test repository**
   ```bash
   git clone https://github.com/batool110/Shop-App.git
   cd Shop-App
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Check Flutter setup**
   ```bash
   flutter doctor
   ```

4. **Run the app**
   ```bash
   # For debug mode
   flutter run
   
   # For specific device
   flutter run -d <device-id>
   
   # For web
   flutter run -d chrome
   ```

### Development Setup

1. **Enable developer options** on your device
2. **Enable USB debugging** for Android devices
3. **Install iOS simulator** for iOS development (macOS only)
4. **Configure IDE** with Flutter and Dart plugins

## 🌐 API Integration & Data Flow

Enhanced API integration with robust error handling:

### FakeStore API Integration
- **Base URL**: `https://fakestoreapi.com`
- **Endpoints**: 
  - `/products` - Get all products
  - `/products/categories` - Get all categories
- **Response Format**: JSON with product objects
- **Error Handling**: Comprehensive error catching and user feedback

### Data Flow Architecture
1. **UI Layer**: User interactions trigger Cubit methods
2. **State Layer**: Cubits manage state and call repository methods
3. **Repository Layer**: Coordinates between remote and local data sources
4. **Data Layer**: HTTP client fetches data, local storage persists favorites
5. **Error Layer**: Custom exceptions bubble up with user-friendly messages

## 🏛️ State Management Architecture

Using **Cubit** pattern for reactive state management:

### ProductCubit States
- `ProductInitial`: Initial state
- `ProductLoading`: Loading products with skeleton animation
- `ProductLoaded`: Products loaded with category filtering and favorites
- `ProductLoadingMore`: Loading additional products for pagination
- `ProductError`: Error occurred with retry mechanism

### ProductCubit Methods
- `loadProducts()`: Fetch initial products from API
- `loadMoreProducts()`: Load additional products for pagination
- `refreshProducts()`: Refresh entire product list
- `toggleFavorite(int productId)`: Add/remove from favorites with animation
- `filterByCategory(String? category)`: Filter products by selected category
- `getCategories()`: Extract unique categories from all products

### FavoriteCubit States
- `FavoriteInitial`: Initial state
- `FavoriteLoading`: Loading favorites from local storage
- `FavoriteLoaded`: Favorites loaded and ready for display
- `FavoriteError`: Error loading favorites

### Enhanced State Features
- **Category Management**: Dynamic category extraction and filtering
- **Pagination Support**: Efficient loading of large product lists
- **Local Persistence**: Favorites automatically saved and restored
- **Error Recovery**: Intelligent retry mechanisms for failed operations

## 💾 Local Storage & Persistence

Enhanced local storage using SharedPreferences:

### Favorites Management
- **Key**: `favorite_products`
- **Value**: List of product IDs as strings
- **Operations**: Add, remove, check favorite status, bulk operations
- **Persistence**: Favorites automatically saved and restored across app sessions

### Category Preferences
- **Smart Filtering**: Last selected category remembered
- **Performance**: Efficient category-based product filtering
- **User Experience**: Seamless category switching with animations

## 🎯 Animation System

Comprehensive animation framework for enhanced user experience:

### Hero Animations
- **Product to Details**: Seamless image transitions using Hero widgets
- **Unique Tags**: Dynamic hero tags for conflict-free animations
- **Performance**: Optimized hero animations with proper disposal

### Interactive Animations
- **Scale Effects**: Product cards scale on touch for immediate feedback
- **Pulse Animations**: Favorite button pulses to indicate interaction
- **Slide Transitions**: Category filters slide in with smooth curves
- **Loading Animations**: Skeleton loaders with shimmer effects

### Animation Controllers
- **Multi-Controller Setup**: Multiple animation controllers for complex effects
- **Proper Disposal**: Memory-efficient animation cleanup
- **Curve Animations**: Smooth easing curves for natural motion
- **Duration Constants**: Consistent timing across all animations

## 🚨 Error Handling & Recovery

Robust error handling system with user-friendly recovery:

### Custom Exceptions
- `NetworkException`: No internet connection with retry options
- `ServerException`: Server errors (4xx, 5xx) with detailed messages
- `TimeoutException`: Request timeout with automatic retry
- `UnknownException`: Unexpected errors with graceful fallbacks

### Error Recovery Features
- **Intelligent Retry**: Automatic retry with exponential backoff
- **User-Friendly Messages**: Clear, actionable error descriptions
- **Graceful Degradation**: App continues functioning with limited features
- **Error Boundaries**: Isolated error handling prevents app crashes

## 🎨 Enhanced UI/UX Design

Modern Material 3 design with custom enhancements:

### Color Scheme
- **Primary**: Purple (#AD21F3) - Eye-catching brand color
- **Secondary**: Orange (#FF9800) - Accent for highlights
- **Favorites**: Pink (#E91E63) - Distinct favorite indicator
- **Background**: Light gray (#F5F5F5) - Easy on the eyes
- **Success/Error/Warning**: Standard Material colors for consistency

### Typography
- **Headlines**: Bold, clear hierarchy for content structure
- **Body Text**: Optimized readability with proper line heights
- **Captions**: Subtle text for secondary information
- **Labels**: Clear, actionable text for interactive elements

### Component Design
- **Cards**: Elevated cards with rounded corners and shadows
- **Buttons**: Consistent styling with proper touch targets
- **Icons**: Material icons with consistent sizing
- **Loading States**: Beautiful skeleton animations

## 🧪 Testing & Quality Assurance

Comprehensive testing strategy for reliability:

### Unit Tests
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/unit/product_cubit_test.dart

# Run with coverage
flutter test --coverage
```

### Widget Tests
- **Product Card Testing**: Verify rendering and interactions
- **Animation Testing**: Ensure smooth animations and proper disposal
- **State Testing**: Validate state transitions and error handling

### Integration Tests
- **API Integration**: Test real API calls and error scenarios
- **Navigation Flow**: Verify screen transitions and hero animations
- **Persistence Testing**: Validate local storage operations

## 📱 Building & Deployment

Production-ready builds for different platforms:

### Android
```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# Android App Bundle (recommended for Play Store)
flutter build appbundle --release
```

### iOS
```bash
# iOS build
flutter build ios --release

# Create IPA for App Store
flutter build ipa --release
```

### Web
```bash
# Web build
flutter build web --release
```

### Performance Optimization
- **Code Splitting**: Efficient loading of resources
- **Image Optimization**: Cached network images with proper sizing
- **State Management**: Efficient state updates and memory management
- **Animation Performance**: Optimized animations with proper disposal

## 🔧 Configuration & Customization

Easy customization for different brands and requirements:

### Theme Customization
```dart
// lib/core/constants/app_colors.dart
static const Color primary = Color(0xFFAD21F3);  // Change brand color
static const Color secondary = Color(0xFFFF9800); // Change accent color
```

### API Configuration
```dart
// lib/core/constants/app_constants.dart
static const String baseUrl = 'https://your-api.com'; // Change API endpoint
```

### Animation Timing
```dart
// lib/core/constants/app_constants.dart
static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
```

## 🤝 Contributing

We welcome contributions! Here's how to get started:

### Development Workflow
1. **Fork the project** on GitHub
2. **Create a feature branch** (`git checkout -b feature/amazing-feature`)
3. **Follow coding standards** (use `flutter analyze` and `dart format`)
4. **Add tests** for new features
5. **Ensure all tests pass** (`flutter test`)
6. **Commit your changes** (`git commit -m 'Add amazing feature'`)
7. **Push to the branch** (`git push origin feature/amazing-feature`)
8. **Open a Pull Request** with detailed description

### Coding Standards
- Follow [Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable and function names
- Add comments for complex logic
- Maintain consistent file structure
- Write tests for new features

### Areas for Contribution
- **New Features**: Shopping cart, user authentication, product search
- **UI Improvements**: New animations, accessibility features
- **Performance**: Code optimization, memory management
- **Testing**: Increase test coverage, integration tests
- **Documentation**: Improve README, add code comments

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

### MIT License Summary
- ✅ Commercial use allowed
- ✅ Modification allowed
- ✅ Distribution allowed
- ✅ Private use allowed
- ❗ License and copyright notice required

## 👨‍💻 Author & Acknowledgments

### Author
**Batool** - *Lead Developer*
- GitHub: [@batool110](https://github.com/batool110)
- Project: [Shop-App](https://github.com/batool110/Shop-App)

### Special Thanks
- **[FakeStore API](https://fakestoreapi.com)** - Providing reliable product data for development
- **Flutter Team** - Creating an amazing cross-platform framework
- **Material Design** - Design system and guidelines
- **Open Source Community** - For inspiration and valuable packages

### Key Packages Used
- `flutter_bloc` - Reactive state management
- `cached_network_image` - Optimized image loading
- `http` - HTTP client for API calls
- `shared_preferences` - Local data persistence
- `equatable` - Value equality for state management

---

## 📊 Project Stats

- **Architecture**: Clean Architecture with SOLID principles
- **State Management**: Cubit (flutter_bloc)
- **UI Framework**: Flutter with Material 3
- **API**: RESTful API integration
- **Animations**: Custom hero and interactive animations
- **Testing**: Unit, widget, and integration tests
- **Platform Support**: iOS, Android, Web

### Recent Updates
- ✅ Enhanced UI with hero animations
- ✅ Category filtering with smooth transitions
- ✅ Single-screen design for better UX
- ✅ Advanced skeleton loading animations
- ✅ Improved error handling and recovery
- ✅ Performance optimizations

---

*Made with ❤️ using Flutter*
