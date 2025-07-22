# E-Commerce Shop App

A complete Flutter e-commerce application with clean architecture, featuring product browsing, favorites management, and modern UI design.

## Features

### ✨ Core Features
- **Product List**: Fetch and display products from [FakeStore API](https://fakestoreapi.com)
- **Grid View**: Responsive product grid layout
- **Favorites**: Add/remove products to/from favorites with local persistence
- **Product Details**: Detailed view with product information
- **Pull to Refresh**: Refresh product list with pull gesture
- **Error Handling**: Comprehensive error handling with retry options

### 🏗️ Architecture & Design Patterns
- **Clean Architecture**: Separation of concerns with data, domain, and presentation layers
- **Cubit State Management**: Using flutter_bloc for state management
- **Repository Pattern**: Abstraction layer for data sources
- **Dependency Injection**: Service locator pattern for dependency management

### 📁 Project Structure
```
lib/
├── core/
│   ├── constants/          # App constants, colors, text styles
│   ├── error/             # Error handling and exceptions
│   ├── network/           # HTTP client configuration
│   ├── theme/             # App theme configuration
│   └── di/                # Dependency injection setup
├── data/
│   ├── models/            # Data models
│   ├── datasources/       # Remote and local data sources
│   └── repositories/      # Repository implementations
└── presentation/
    ├── cubits/            # State management (Cubit)
    ├── screens/           # App screens
    └── widgets/           # Reusable UI components
```

### 🎨 UI Components
- **Custom Theme**: Material 3 design with custom colors and typography
- **Reusable Widgets**: Product cards, loading states, error widgets
- **Responsive Design**: Adaptive grid layout for different screen sizes
- **Modern UI**: Clean and intuitive user interface

### 🔧 Technical Features
- **HTTP Client**: Custom HTTP client with timeout and error handling
- **Local Storage**: SharedPreferences for favorites persistence
- **Image Caching**: Cached network images for better performance
- **State Management**: Reactive UI updates with Cubit
- **Error Recovery**: Retry mechanisms for failed operations

## Dependencies

```yaml
dependencies:
  flutter_bloc: ^8.1.6          # State management
  http: ^1.2.2                  # HTTP requests
  shared_preferences: ^2.3.2    # Local storage
  cached_network_image: ^3.4.1  # Image caching
  equatable: ^2.0.5             # Value equality
```

## Getting Started

### Prerequisites
- Flutter SDK (>=3.8.1)
- Dart SDK
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/batool110/Shop-App.git
   cd Shop-App
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## API Integration

The app integrates with [FakeStore API](https://fakestoreapi.com) to fetch product data:

- **Endpoint**: `https://fakestoreapi.com/products`
- **Method**: GET
- **Response**: Array of product objects with id, title, price, description, category, image, and rating

## State Management

Using **Cubit** pattern for state management:

### Product States
- `ProductInitial`: Initial state
- `ProductLoading`: Loading products
- `ProductLoaded`: Products loaded with favorites
- `ProductError`: Error occurred with message

### Product Events
- `loadProducts()`: Fetch products from API
- `toggleFavorite(int productId)`: Add/remove from favorites
- `refreshProducts()`: Refresh product list

## Local Storage

Favorites are persisted locally using SharedPreferences:
- Key: `favorite_products`
- Value: List of product IDs as strings
- Operations: Add, remove, check favorite status

## Error Handling

Comprehensive error handling with custom exceptions:
- `NetworkException`: No internet connection
- `ServerException`: Server errors (4xx, 5xx)
- `TimeoutException`: Request timeout
- `UnknownException`: Unexpected errors

## UI Themes

Custom Material 3 theme with:
- **Primary Color**: Blue (#2196F3)
- **Secondary Color**: Orange (#FF9800)
- **Typography**: Custom text styles for consistency
- **Components**: Styled cards, buttons, and app bars

## Testing

Run tests with:
```bash
flutter test
```

## Building

### Android APK
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## Contributing

1. Fork the project
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

**Batool** - [GitHub Profile](https://github.com/batool110)

## Acknowledgments

- [FakeStore API](https://fakestoreapi.com) for providing the product data
- Flutter team for the amazing framework
- Material Design for UI guidelines
