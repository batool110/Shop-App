import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/product_repository_impl.dart';
import '../../../core/error/app_exception.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepositoryImpl repository;

  ProductCubit(this.repository) : super(ProductInitial());

  Future<void> loadProducts() async {
    try {
      emit(ProductLoading());

      final products = await repository.getProducts();
      final favoriteIds = await repository.getFavoriteProductIds();

      emit(ProductLoaded(products: products, favoriteIds: favoriteIds));
    } catch (error) {
      final errorMessage = ErrorHandler.getErrorMessage(error);
      emit(ProductError(errorMessage));
    }
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
    }
  }

  Future<void> refreshProducts() async {
    await loadProducts();
  }
}
