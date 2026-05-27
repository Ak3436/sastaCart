import '../model/cart_model.dart';
import '../network/api_service.dart';

/// =========================
/// CART REPOSITORY
/// =========================
/// Acts as the single source of truth for cart data.
/// The ViewModel calls this class; this class calls [ApiService].
/// This separation keeps networking logic out of the ViewModel.
class CartRepository {
  /// =========================
  /// API SERVICE OBJECT
  /// =========================
  /// [ApiService] handles the actual HTTP requests via Dio.
  final ApiService apiService = ApiService();

  /// =========================
  /// GET CART LIST — REPOSITORY LOGIC
  /// =========================
  /// Fetches all carts from the DummyJSON API.
  /// Returns a list of [CartModel] objects parsed from the JSON response.
  ///
  /// API endpoint: GET https://dummyjson.com/carts
  Future<List<CartModel>> getCartList() async {
    return await apiService.getCartList();
  }
}
