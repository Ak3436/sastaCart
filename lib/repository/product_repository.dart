import '../model/product_model.dart';
import '../network/api_service.dart';

class ProductRepository {
  final ApiService apiService;

  ProductRepository({ApiService? apiService})
    : apiService = apiService ?? ApiService();

  Future<List<ProductModel>> getProductsByCategoryUrl(String url) {
    return apiService.getProductsByCategoryUrl(url);
  }

  Future<ProductModel> getProductDetails(int productId) {
    return apiService.getProductDetails(productId);
  }
}
