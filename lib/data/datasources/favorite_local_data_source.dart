import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';

abstract class FavoriteLocalDataSource {
  Future<List<int>> getFavoriteProductIds();
  Future<void> addToFavorites(int productId);
  Future<void> removeFromFavorites(int productId);
  Future<bool> isFavorite(int productId);
}

class FavoriteLocalDataSourceImpl implements FavoriteLocalDataSource {
  @override
  Future<List<int>> getFavoriteProductIds() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds =
        prefs.getStringList(AppConstants.favoriteProductsKey) ?? [];
    return favoriteIds.map((id) => int.parse(id)).toList();
  }

  @override
  Future<void> addToFavorites(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = await getFavoriteProductIds();

    if (!favoriteIds.contains(productId)) {
      favoriteIds.add(productId);
      final stringIds = favoriteIds.map((id) => id.toString()).toList();
      await prefs.setStringList(AppConstants.favoriteProductsKey, stringIds);
    }
  }

  @override
  Future<void> removeFromFavorites(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = await getFavoriteProductIds();

    favoriteIds.remove(productId);
    final stringIds = favoriteIds.map((id) => id.toString()).toList();
    await prefs.setStringList(AppConstants.favoriteProductsKey, stringIds);
  }

  @override
  Future<bool> isFavorite(int productId) async {
    final favoriteIds = await getFavoriteProductIds();
    return favoriteIds.contains(productId);
  }
}
