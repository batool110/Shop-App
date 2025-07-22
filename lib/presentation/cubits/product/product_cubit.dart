import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/product_repository_impl.dart';
import '../../../data/models/product.dart';
import '../../../core/error/app_exception.dart';
import '../../../core/constants/app_constants.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepositoryImpl repository;
  List<Product> _allProducts = [];
  String? _selectedCategory;

  ProductCubit(this.repository) : super(ProductInitial());

  Future<void> loadProducts() async {
    try {
      emit(ProductLoading());

      // Get all products
      _allProducts = await repository.getAllProducts();
      final favoriteIds = await repository.getFavoriteProductIds();

      // Filter and paginate products
      final filteredProducts = _getFilteredProducts();
      final paginatedProducts = filteredProducts
          .take(AppConstants.initialProductLimit)
          .toList();

      emit(
        ProductLoaded(
          products: paginatedProducts,
          favoriteIds: favoriteIds,
          hasReachedMax: paginatedProducts.length >= filteredProducts.length,
          currentLimit: AppConstants.initialProductLimit,
          allProducts: _allProducts,
          selectedCategory: _selectedCategory,
        ),
      );
    } catch (error) {
      final errorMessage = ErrorHandler.getErrorMessage(error);
      emit(ProductError(errorMessage));
    }
  }

  Future<void> loadMoreProducts() async {
    final currentState = state;
    if (currentState is ProductLoaded && !currentState.hasReachedMax) {
      try {
        emit(
          ProductLoadingMore(
            currentProducts: currentState.products,
            favoriteIds: currentState.favoriteIds,
          ),
        );

        final filteredProducts = _getFilteredProducts();
        final newLimit =
            currentState.currentLimit + AppConstants.loadMoreProductLimit;
        final paginatedProducts = filteredProducts.take(newLimit).toList();
        final favoriteIds = await repository.getFavoriteProductIds();

        emit(
          ProductLoaded(
            products: paginatedProducts,
            favoriteIds: favoriteIds,
            hasReachedMax: paginatedProducts.length >= filteredProducts.length,
            currentLimit: newLimit,
            allProducts: _allProducts,
            selectedCategory: _selectedCategory,
          ),
        );
      } catch (error) {
        final errorMessage = ErrorHandler.getErrorMessage(error);
        emit(ProductError(errorMessage));
      }
    }
  }

  Future<void> filterByCategory(String? category) async {
    _selectedCategory = category;
    final currentState = state;

    if (currentState is ProductLoaded) {
      try {
        final filteredProducts = _getFilteredProducts();
        final paginatedProducts = filteredProducts
            .take(AppConstants.initialProductLimit)
            .toList();

        emit(
          ProductLoaded(
            products: paginatedProducts,
            favoriteIds: currentState.favoriteIds,
            hasReachedMax: paginatedProducts.length >= filteredProducts.length,
            currentLimit: AppConstants.initialProductLimit,
            allProducts: _allProducts,
            selectedCategory: _selectedCategory,
          ),
        );
      } catch (error) {
        final errorMessage = ErrorHandler.getErrorMessage(error);
        emit(ProductError(errorMessage));
      }
    }
  }

  List<Product> _getFilteredProducts() {
    if (_selectedCategory == null) {
      return _allProducts;
    }
    return _allProducts
        .where((product) => product.category == _selectedCategory)
        .toList();
  }

  List<String> getCategories() {
    if (_allProducts.isEmpty) return [];
    return _allProducts.map((p) => p.category).toSet().toList()..sort();
  }

  Future<void> toggleFavorite(int productId) async {
    final currentState = state;
    if (currentState is ProductLoaded) {
      try {
        final isFavorite = await repository.isFavorite(productId);

        if (isFavorite) {
          await repository.removeFromFavorites(productId);
        } else {
          await repository.addToFavorites(productId);
        }

        final updatedFavoriteIds = await repository.getFavoriteProductIds();

        emit(currentState.copyWith(favoriteIds: updatedFavoriteIds));
      } catch (error) {
        final errorMessage = ErrorHandler.getErrorMessage(error);
        emit(ProductError(errorMessage));
      }
    } else if (currentState is ProductLoadingMore) {
      try {
        final isFavorite = await repository.isFavorite(productId);

        if (isFavorite) {
          await repository.removeFromFavorites(productId);
        } else {
          await repository.addToFavorites(productId);
        }

        final updatedFavoriteIds = await repository.getFavoriteProductIds();

        emit(
          ProductLoadingMore(
            currentProducts: currentState.currentProducts,
            favoriteIds: updatedFavoriteIds,
          ),
        );
      } catch (error) {
        final errorMessage = ErrorHandler.getErrorMessage(error);
        emit(ProductError(errorMessage));
      }
    }
  }

  Future<void> refreshProducts() async {
    await loadProducts();
  }
}
