import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/product_remote_data_source.dart';
import '../../data/datasources/favorite_local_data_source.dart';
import '../../data/repositories/product_repository_impl.dart';
import '../../presentation/cubits/product/product_cubit.dart';
import '../../presentation/cubits/favorite/favorite_cubit.dart';

class ServiceLocator {
  static late ProductRemoteDataSource _productRemoteDataSource;
  static late FavoriteLocalDataSource _favoriteLocalDataSource;
  static late ProductRepositoryImpl _productRepository;

  static void init() {
    // Data Sources
    _productRemoteDataSource = ProductRemoteDataSourceImpl();
    _favoriteLocalDataSource = FavoriteLocalDataSourceImpl();

    // Repository
    _productRepository = ProductRepositoryImpl(
      remoteDataSource: _productRemoteDataSource,
      localDataSource: _favoriteLocalDataSource,
    );
  }

  static ProductCubit get productCubit => ProductCubit(_productRepository);
  static FavoriteCubit get favoriteCubit => FavoriteCubit(_productRepository);
}

class AppBlocProviders {
  static List<BlocProvider> get providers => [
    BlocProvider<ProductCubit>(
      create: (context) => ServiceLocator.productCubit,
    ),
    BlocProvider<FavoriteCubit>(
      create: (context) => ServiceLocator.favoriteCubit,
    ),
  ];
}
