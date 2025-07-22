import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/product_repository_impl.dart';
import '../../../core/error/app_exception.dart';
import 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final ProductRepositoryImpl repository;

  FavoriteCubit(this.repository) : super(FavoriteInitial());

  Future<void> loadFavorites() async {
    try {
      emit(FavoriteLoading());

      final favoriteIds = await repository.getFavoriteProductIds();
      final allProducts = await repository.getAllProducts();

      final favoriteProducts = allProducts
          .where((product) => favoriteIds.contains(product.id))
          .toList();

      emit(FavoriteLoaded(favoriteProducts: favoriteProducts));
    } catch (error) {
      final errorMessage = ErrorHandler.getErrorMessage(error);
      emit(FavoriteError(errorMessage));
    }
  }

  Future<void> toggleFavorite(int productId) async {
    try {
      final isFavorite = await repository.isFavorite(productId);

      if (isFavorite) {
        await repository.removeFromFavorites(productId);
      } else {
        await repository.addToFavorites(productId);
      }

      // Reload favorites to update the list
      await loadFavorites();
    } catch (error) {
      final errorMessage = ErrorHandler.getErrorMessage(error);
      emit(FavoriteError(errorMessage));
    }
  }

  Future<void> refreshFavorites() async {
    await loadFavorites();
  }
}
