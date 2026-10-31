import 'package:dio/dio.dart';
import 'product_model.dart';

class ProductsRepository {
  ProductsRepository(this._dio);
  final Dio _dio;

  Future<List<Product>> getProducts() async {
    final response = await _dio.get('/products', queryParameters: {'limit': 30});
    final data = response.data as Map<String, dynamic>;
    final list = data['products'] as List<dynamic>? ?? const [];
    return list
        .whereType<Map<String, dynamic>>()
        .map(Product.fromJson)
        .toList();
  }

  Future<Product> getProductById(int id) async {
    final response = await _dio.get('/products/$id');
    return Product.fromJson(response.data as Map<String, dynamic>);
  }
}
