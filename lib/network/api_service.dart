import 'package:dio/dio.dart';

import '../model/category_model.dart';
import '../model/cart_model.dart';
import '../model/product_model.dart';
import '../model/user_profile_model.dart';
import 'api_client.dart';

class ApiService {
  /// LOGIN API
  Future<Response> loginUser({
    required String username,
    required String password,
  }) async {
    final response = await ApiClient.dio.post(
      "auth/login",

      data: {"username": username, "password": password, "expiresInMins": 30},
    );

    return response;
  }

  /// CATEGORY API
  Future<List<CategoryModel>> getCategories() async {
    final response = await ApiClient.dio.get("products/categories");

    return (response.data as List)
        .map((e) => CategoryModel.fromJson(e))
        .toList();
  }

  /// PRODUCT API
  Future<List<ProductModel>> getProducts() async {
    final response = await ApiClient.dio.get("products");

    return (response.data['products'] as List)
        .map((e) => ProductModel.fromJson(e))
        .toList();
  }

  /// PRODUCT DETAILS API
  Future<ProductModel> getProductDetails(int productId) async {
    final response = await ApiClient.dio.get("products/$productId");

    return ProductModel.fromJson(response.data);
  }

  /// CATEGORY PRODUCT API
  Future<List<ProductModel>> getProductsByCategoryUrl(String url) async {
    final response = await ApiClient.dio.get(url);

    return (response.data['products'] as List)
        .map((e) => ProductModel.fromJson(e))
        .toList();
  }

  /// CART LIST API
  ///
  /// API calling code for the Cart screen is written here. The repository calls
  /// this method, then the ViewModel exposes the cart items to the UI.
  /// =========================
  /// GET CART LIST API
  /// =========================
  Future<List<CartModel>>
  getCartList() async {

    final response =
    await ApiClient.dio.get(
      "carts",
    );

    return (response.data['carts']
    as List)

        .map((e) =>
        CartModel.fromJson(e))
        .toList();
  }

  /// ADD CART API
  ///
  /// DummyJSON persists this only as a simulated response. The ViewModel still
  /// updates local state immediately so the cart count changes in the app.
  Future<Response> addProductToCart({
    required int userId,
    required int productId,
    required int quantity,
  }) {
    return ApiClient.dio.post(
      "carts/add",
      data: {
        "userId": userId,
        "products": [
          {"id": productId, "quantity": quantity},
        ],
      },
    );
  }


  // ── User Profile ─────────────────────────────────────────────────

  /// =========================
  /// USER PROFILE API
  /// =========================
  /// Fetches full user details for [userId] from /users/:id.
  /// The response now includes nested `address` and `company` objects
  /// which are parsed into [AddressModel] and [CompanyModel].
  Future<UserProfileModel> getUserProfile(int userId) async {
    final response = await ApiClient.dio.get("users/$userId");
    return UserProfileModel.fromJson(response.data);
  }
}
