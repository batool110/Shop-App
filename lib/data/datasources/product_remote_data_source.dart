import '../../core/network/http_client.dart';
import '../../core/constants/app_constants.dart';
import '../models/product.dart';

abstract class ProductRemoteDataSource {
  Future<List<Product>> getProducts();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  @override
  Future<List<Product>> getProducts() async {
    final response = await HttpClient.get(AppConstants.productsEndpoint);

    if (response is List) {
      return response
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();
    }

    throw const FormatException('Invalid response format');
  }
}
