class AppConstants {
  // API
  static const String baseUrl = 'https://fakestoreapi.com';
  static const String productsEndpoint = '/products';

  // Local Storage Keys
  static const String favoriteProductsKey = 'favorite_products';

  // Pagination
  static const int initialProductLimit = 10;
  static const int loadMoreProductLimit = 5;

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double cardBorderRadius = 12.0;
  static const double cardElevation = 4.0;
  static const double iconSize = 24.0;
  static const double smallIconSize = 16.0;

  // Grid
  static const int gridCrossAxisCount = 2;
  static const double gridMainAxisSpacing = 16.0;
  static const double gridCrossAxisSpacing = 16.0;
  static const double gridChildAspectRatio = 0.75;

  // Animation
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // Error Messages
  static const String networkErrorMessage =
      'No internet connection. Please check your network and try again.';
  static const String serverErrorMessage =
      'Something went wrong. Please try again later.';
  static const String unknownErrorMessage =
      'An unknown error occurred. Please try again.';
  static const String timeoutErrorMessage =
      'Request timeout. Please try again.';
}
