import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../model/cart_model.dart';
import '../utils/app_colors.dart';
import '../utils/edge_to_edge.dart';
import '../viewmodel/cart_view_model.dart';

/// =========================
/// CART SCREEN
/// =========================
/// Displays the user's cart items fetched from GET https://dummyjson.com/carts
///
/// Architecture role: VIEW layer in MVVM.
/// - Reads state from [CartViewModel] via [Consumer] / [context.read].
/// - Never calls the API directly — delegates everything to the ViewModel.
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();

    /// =========================
    /// TRIGGER CART LIST API
    /// =========================
    /// Called once when the Cart screen is first opened.
    /// [CartViewModel.loadCart] prevents duplicate API calls after the
    /// first successful load thanks to the internal [_hasLoaded] guard.
    Future.microtask(() => context.read<CartViewModel>().loadCart());
  }

  @override
  Widget build(BuildContext context) {
    return EdgeToEdgeBody(
      bottom: false,
      child: Consumer<CartViewModel>(
        /// =========================
        /// CONSUMER — LISTENS TO VIEWMODEL
        /// =========================
        /// Rebuilds this subtree whenever [CartViewModel.notifyListeners()]
        /// is called (e.g., after loading, removing an item, or an error).
        builder: (context, cartViewModel, child) {
          return Column(
            children: [
              /// Header shows live item count and total from the ViewModel.
              _CartHeader(
                itemCount: cartViewModel.cartCount,
                totalAmount: cartViewModel.totalAmount,
              ),
              Expanded(child: _buildCartBody(context, cartViewModel)),
            ],
          );
        },
      ),
    );
  }

  /// =========================
  /// CART BODY BUILDER
  /// =========================
  /// Routes to the correct widget based on the current ViewModel state:
  ///   - Loading  → Shimmer placeholder
  ///   - Error    → Error state with Retry button
  ///   - Empty    → Empty state illustration
  ///   - Data     → Scrollable list of [_CartItemCard] widgets
  Widget _buildCartBody(BuildContext context, CartViewModel cartViewModel) {
    // Show shimmer skeleton while the API call is in progress.
    if (cartViewModel.isLoading) {
      return const _CartShimmer();
    }

    // Show error state only if there's an error AND no cached items to show.
    if (cartViewModel.errorMessage.isNotEmpty && cartViewModel.items.isEmpty) {
      return _CartErrorState(
        message: cartViewModel.errorMessage,
        onRetry: () => cartViewModel.loadCart(forceRefresh: true),
      );
    }

    // Show empty state when the cart has no items.
    if (cartViewModel.items.isEmpty) {
      return const _EmptyCartState();
    }

    /// =========================
    /// CART LIST (RecyclerView/Adapter equivalent)
    /// =========================
    /// [ListView.builder] is Flutter's equivalent of Android's RecyclerView.
    /// It lazily builds each [_CartItemCard] only when it scrolls into view,
    /// making it memory-efficient for large lists.
    ///
    /// Pull-to-refresh forces a fresh API call via [forceRefresh: true].
    return RefreshIndicator(
      color: AppColors.primaryColor,
      onRefresh: () => cartViewModel.loadCart(forceRefresh: true),
      child: ListView.builder(
        padding: edgeToEdgeScrollPadding(
          context,
          left: 14,
          top: 14,
          right: 14,
          bottom: 18,
        ),
        itemCount: cartViewModel.items.length,

        /// =========================
        /// ITEM BUILDER — ADAPTER LOGIC
        /// =========================
        /// Equivalent to RecyclerView.Adapter.onBindViewHolder().
        /// Maps each [CartItemModel] at [index] to a [_CartItemCard] widget.
        itemBuilder: (context, index) {
          final item = cartViewModel.items[index];

          return _CartItemCard(
            item: item,
            onRemove: () {
              /// =========================
              /// REMOVE ITEM
              /// =========================
              /// Calls ViewModel.removeItem → updates [items] list →
              /// [cartCount] getter recalculates → [notifyListeners()] →
              /// Badge + header chip rebuild automatically.
              cartViewModel.removeItem(item);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.discountText,
                  content: Text("${item.title} removed from cart"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ─── Header ──────────────────────────────────────────────────────────────────

/// =========================
/// CART HEADER WIDGET
/// =========================
/// Displays the screen title, live item count, and running total.
/// Receives [itemCount] and [totalAmount] from the ViewModel via CartScreen.
class _CartHeader extends StatelessWidget {
  final int itemCount;
  final double totalAmount;

  const _CartHeader({required this.itemCount, required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.viewPaddingOf(context).top;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, topInset + 18, 20, 18),
      decoration: const BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "My Cart",
            style: TextStyle(
              color: AppColors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _HeaderInfo(
                label: "Items",
                value: itemCount.toString(),
                icon: Icons.shopping_bag_outlined,
              ),
              const SizedBox(width: 12),
              _HeaderInfo(
                label: "Total",
                value: "\$${totalAmount.toStringAsFixed(2)}",
                icon: Icons.payments_outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Small info tile used inside the header row.
class _HeaderInfo extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _HeaderInfo({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.white, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Cart Item Card ───────────────────────────────────────────────────────────

/// =========================
/// CART ITEM CARD — UI PER ITEM
/// =========================
/// Equivalent to a single row in RecyclerView / a ViewHolder layout.
/// Displays: thumbnail, title, description (fallback if absent), price,
/// quantity, line-total, and a remove button.
class _CartItemCard extends StatelessWidget {
  final CartItemModel item;
  final VoidCallback onRemove;

  const _CartItemCard({required this.item, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ─── Product Image ─────────────────────────────────────────────
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              item.thumbnail,
              width: 96,
              height: 116,
              fit: BoxFit.cover,
              // Fallback icon when the image URL fails to load.
              errorBuilder: (_, __, ___) => Container(
                width: 96,
                height: 116,
                color: AppColors.imagePlaceholder,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.image_not_supported,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          /// ─── Product Details ───────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Title
                    Expanded(
                      child: Text(
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.titleText,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    /// Remove button — triggers [onRemove] callback
                    IconButton(
                      tooltip: "Remove item",
                      visualDensity: VisualDensity.compact,
                      onPressed: onRemove,
                      icon: const Icon(
                        Icons.delete_outline,
                        color: AppColors.discountText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                /// Description (cart API does not return this field).
                Text(
                  item.description.isEmpty
                      ? "Description not available from cart API"
                      : item.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.descriptionText,
                    fontSize: 13,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 10),

                /// ─── Price / Qty / Total Chips ──────────────────────────
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _CartChip(
                      label: "Price",
                      value: "\$${item.price.toStringAsFixed(2)}",
                      color: AppColors.priceText,
                    ),
                    _CartChip(
                      label: "Qty",
                      value: item.quantity.toString(),
                      color: AppColors.stockText,
                    ),
                    _CartChip(
                      label: "Total",
                      value: "\$${item.total.toStringAsFixed(2)}",
                      color: AppColors.discountText,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Cart Chip ────────────────────────────────────────────────────────────────

/// Small colored label+value pill used for Price, Qty, and Total.
class _CartChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _CartChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(10),
      ),
      child: RichText(
        text: TextSpan(
          text: "$label: ",
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
          children: [
            TextSpan(
              text: value,
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Shimmer Loader ───────────────────────────────────────────────────────────

/// =========================
/// CART SHIMMER — LOADING STATE
/// =========================
/// Shown while [CartViewModel.isLoading] is true.
/// Renders 5 placeholder skeleton cards with a shimmer animation.
class _CartShimmer extends StatelessWidget {
  const _CartShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: ListView.builder(
        padding: edgeToEdgeScrollPadding(
          context,
          left: 14,
          top: 14,
          right: 14,
          bottom: 18,
        ),
        itemCount: 5,
        itemBuilder: (context, index) {
          return Container(
            height: 140,
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(18),
            ),
          );
        },
      ),
    );
  }
}

// ─── Error State ──────────────────────────────────────────────────────────────

/// =========================
/// CART ERROR STATE
/// =========================
/// Shown when [CartViewModel.errorMessage] is non-empty and [items] is empty.
/// Provides a Retry button that calls [loadCart(forceRefresh: true)].
class _CartErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _CartErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              color: AppColors.discountText,
              size: 46,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.descriptionText,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text("Retry"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonColor,
                foregroundColor: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Empty State ──────────────────────────────────────────────────────────────

/// =========================
/// EMPTY CART STATE
/// =========================
/// Shown when [CartViewModel.items] is empty after a successful API call.
class _EmptyCartState extends StatelessWidget {
  const _EmptyCartState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              color: AppColors.textSecondary,
              size: 54,
            ),
            SizedBox(height: 12),
            Text(
              "Your cart is empty",
              style: TextStyle(
                color: AppColors.titleText,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6),
            Text(
              "Products added to cart will appear here.",
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.descriptionText, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
