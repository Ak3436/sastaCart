/// =========================
/// CART MODEL
/// =========================
/// Represents the full Cart API response from: GET https://dummyjson.com/carts
///
/// Each cart contains a list of [CartProducts].
/// Note: DummyJSON cart products do NOT include a description field,
/// so description is kept optional and the UI shows a fallback message.

// ─── CartModel ───────────────────────────────────────────────────────────────

class CartModel {
  /// Unique cart ID returned by the API.
  final int id;

  /// List of products inside this cart.
  final List<CartProducts> products;

  /// Total price of all items in this cart.
  final double total;

  /// Number of distinct products in the cart.
  final int totalProducts;

  /// Total quantity across all products.
  final int totalQuantity;

  CartModel({
    required this.id,
    required this.products,
    required this.total,
    required this.totalProducts,
    required this.totalQuantity,
  });

  /// =========================
  /// JSON PARSING
  /// =========================
  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'],
      products: (json['products'] as List)
          .map((e) => CartProducts.fromJson(e))
          .toList(),
      total: (json['total'] as num).toDouble(),
      totalProducts: json['totalProducts'],
      totalQuantity: json['totalQuantity'],
    );
  }
}

// ─── CartProducts ─────────────────────────────────────────────────────────────

class CartProducts {
  /// Product ID.
  final int id;

  /// Product title.
  final String title;

  /// Price per unit.
  final double price;

  /// Quantity ordered.
  final int quantity;

  /// Total price for this line item (price × quantity).
  final double total;

  /// Thumbnail image URL.
  final String thumbnail;

  /// Description is NOT provided by the cart API.
  /// It defaults to an empty string; the UI shows a fallback message.
  final String description;

  CartProducts({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
    required this.total,
    required this.thumbnail,
    this.description = "",
  });

  /// =========================
  /// JSON PARSING
  /// =========================
  factory CartProducts.fromJson(Map<String, dynamic> json) {
    return CartProducts(
      id: json['id'],
      title: json['title'],
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'],
      total: (json['total'] as num).toDouble(),
      thumbnail: json['thumbnail'],
      // description is absent from the cart API – default to empty string.
      description: json['description'] ?? "",
    );
  }
}

/// =========================
/// TYPE ALIAS
/// =========================
/// [CartItemModel] is an alias for [CartProducts].
/// The Cart screen and ViewModel use this name for clarity.
typedef CartItemModel = CartProducts;
