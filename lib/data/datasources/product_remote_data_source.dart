import '../../core/network/http_client.dart';
import '../../core/constants/app_constants.dart';
import '../models/product.dart';

abstract class ProductRemoteDataSource {
  Future<List<Product>> getProducts({int? limit});
  Future<List<Product>> getAllProducts();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  @override
  Future<List<Product>> getProducts({int? limit}) async {
    String endpoint = AppConstants.productsEndpoint;
    if (limit != null) {
      endpoint += '?limit=$limit';
    }

    final response = await HttpClient.get(endpoint);

    if (response is List) {
      return response
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();
    }

    throw const FormatException('Invalid response format');
  }

  @override
  Future<List<Product>> getAllProducts() async {
    final response = await HttpClient.get(AppConstants.productsEndpoint);

    if (response is List) {
      return response
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();
    }

    throw const FormatException('Invalid response format');
  }
}
