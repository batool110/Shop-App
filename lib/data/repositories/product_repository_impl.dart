import '../models/product.dart';
import '../datasources/product_remote_data_source.dart';
import '../datasources/favorite_local_data_source.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts({int? limit});
  Future<List<Product>> getAllProducts();
  Future<List<int>> getFavoriteProductIds();
  Future<void> addToFavorites(int productId);
  Future<void> removeFromFavorites(int productId);
  Future<bool> isFavorite(int productId);
}

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final FavoriteLocalDataSource localDataSource;

  ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<Product>> getProducts({int? limit}) async {
    return await remoteDataSource.getProducts(limit: limit);
  }

  @override
  Future<List<Product>> getAllProducts() async {
    return await remoteDataSource.getAllProducts();
  }

  @override
  Future<List<int>> getFavoriteProductIds() async {
    return await localDataSource.getFavoriteProductIds();
  }

  @override
  Future<void> addToFavorites(int productId) async {
    await localDataSource.addToFavorites(productId);
  }

  @override
  Future<void> removeFromFavorites(int productId) async {
    await localDataSource.removeFromFavorites(productId);
  }

  @override
  Future<bool> isFavorite(int productId) async {
    return await localDataSource.isFavorite(productId);
  }
}
