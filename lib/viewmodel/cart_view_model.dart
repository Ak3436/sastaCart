import 'package:flutter/material.dart';

import '../model/cart_model.dart';
import '../repository/cart_repository.dart';

/// =========================
/// CART VIEW MODEL
/// =========================
/// Extends [ChangeNotifier] so that the UI automatically rebuilds
/// whenever [notifyListeners()] is called.
///
/// This ViewModel:
///   - Calls the Repository to fetch cart data from the API.
///   - Flattens all carts into a single list of [CartItemModel] items.
///   - Exposes derived values: [cartCount] and [totalAmount].
///   - Handles remove-item logic and updates the count reactively.
class CartViewModel extends ChangeNotifier {
  /// =========================
  /// REPOSITORY OBJECT
  /// =========================
  /// The ViewModel talks ONLY to the Repository, never to ApiService directly.
  final CartRepository repository = CartRepository();

  // ─── State Fields ──────────────────────────────────────────────────────────

  /// True while the API call is in progress (shows shimmer loader in the UI).
  bool isLoading = false;

  /// Non-empty when an API error occurs.
  String errorMessage = "";

  /// =========================
  /// CART ITEMS LIST
  /// =========================
  /// Flattened list of all products across all carts returned by the API.
  /// This is what the Cart screen's ListView displays.
  List<CartItemModel> items = [];

  /// Guard flag — prevents duplicate API calls after the first success.
  bool _hasLoaded = false;

  // ─── Derived Getters ───────────────────────────────────────────────────────

  /// =========================
  /// CART COUNT
  /// =========================
  /// Number of distinct cart items currently in [items].
  /// Displayed on the cart icon badge and the header chip.
  int get cartCount => items.length;

  /// =========================
  /// TOTAL AMOUNT
  /// =========================
  /// Sum of [CartItemModel.total] for every item in the cart.
  /// Displayed in the header "Total" chip.
  double get totalAmount =>
      items.fold(0.0, (sum, item) => sum + item.total);

  // ─── API Call ──────────────────────────────────────────────────────────────

  /// =========================
  /// LOAD CART — VIEWMODEL LOGIC
  /// =========================
  /// Fetches the cart list from the Repository and updates state.
  ///
  /// [forceRefresh] — when true, bypasses the [_hasLoaded] guard and
  /// re-fetches even if data was already loaded (used by the pull-to-refresh
  /// and the Retry button in the error state).
  Future<void> loadCart({bool forceRefresh = false}) async {
    // Skip the API call if data is already loaded and no refresh is requested.
    if (_hasLoaded && !forceRefresh) return;

    try {
      // Show shimmer loader.
      isLoading = true;
      errorMessage = "";
      notifyListeners();

      // =========================
      // REPOSITORY CALL
      // =========================
      // Calls CartRepository.getCartList() → ApiService.getCartList()
      // → GET https://dummyjson.com/carts
      final List<CartModel> carts = await repository.getCartList();

      // =========================
      // FLATTEN PRODUCTS
      // =========================
      // The API returns multiple carts; we merge all their products
      // into a single flat list so the ListView has one source of truth.
      items = carts.expand((cart) => cart.products).toList();

      // Mark as successfully loaded so duplicate calls are skipped.
      _hasLoaded = true;
    } catch (e) {
      // Store the error message; the UI shows an error state widget.
      errorMessage = "Failed to load cart. Please try again.";
    }

    // Hide loader and notify the UI to rebuild.
    isLoading = false;
    notifyListeners();
  }

  // ─── Remove Item ───────────────────────────────────────────────────────────

  /// =========================
  /// REMOVE ITEM — VIEWMODEL LOGIC
  /// =========================
  /// Removes a specific [CartItemModel] from [items] by object reference.
  ///
  /// How cart count is updated:
  ///   - [cartCount] is a getter computed from [items.length].
  ///   - After [items.remove(item)], [notifyListeners()] triggers a rebuild.
  ///   - The CartBadge widget and the header chip re-read [cartCount]
  ///     automatically because they listen to this ChangeNotifier.
  void removeItem(CartItemModel item) {
    items.remove(item);

    // notifyListeners() causes the cart badge, header count, and list
    // to all update in a single frame.
    notifyListeners();
  }
}
