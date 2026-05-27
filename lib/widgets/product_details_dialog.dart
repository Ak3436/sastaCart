import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../model/product_model.dart';
import '../utils/app_colors.dart';
import '../viewmodel/cart_view_model.dart';
import '../viewmodel/product_detail_view_model.dart';

void showProductDetailsDialog(BuildContext context, int productId) {
  showDialog(
    context: context,
    builder: (_) {
      return ChangeNotifierProvider(
        create: (_) => ProductDetailViewModel()..loadProductDetails(productId),
        child: const ProductDetailsDialog(),
      );
    },
  );
}

class ProductDetailsDialog extends StatelessWidget {
  const ProductDetailsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;
    final safeHeight = size.height - mediaQuery.viewPadding.vertical - 48;

    return SafeArea(
      child: Dialog(
        backgroundColor: AppColors.dialogBackground,
        insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 520,
            maxHeight: safeHeight.clamp(340, size.height * 0.86).toDouble(),
          ),
          child: Consumer<ProductDetailViewModel>(
            builder: (context, vm, child) {
              if (vm.isLoading) {
                return const _ProductDetailsShimmer();
              }

              if (vm.errorMessage.isNotEmpty) {
                return _ProductDetailsError(message: vm.errorMessage);
              }

              final product = vm.product;
              if (product == null) {
                return const _ProductDetailsError(
                  message: "Product details not available",
                );
              }

              return _ProductDetailsContent(product: product);
            },
          ),
        ),
      ),
    );
  }
}

class _ProductDetailsContent extends StatelessWidget {
  final ProductModel product;

  const _ProductDetailsContent({required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    product.thumbnail,
                    width: double.infinity,
                    height: 210,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 210,
                      color: AppColors.imagePlaceholder,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.image_not_supported,
                        color: AppColors.textSecondary,
                        size: 42,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  product.title,
                  style: const TextStyle(
                    color: AppColors.titleText,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  product.description,
                  style: const TextStyle(
                    color: AppColors.descriptionText,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 14),
                _DetailRow(
                  label: "Category",
                  value: product.category,
                  color: AppColors.categoryText,
                ),
                _DetailRow(
                  label: "Price",
                  value: "\$${product.price.toStringAsFixed(2)}",
                  color: AppColors.priceText,
                ),
                _DetailRow(
                  label: "Discount Price",
                  value: "\$${product.discountPrice.toStringAsFixed(2)}",
                  color: AppColors.discountText,
                ),
                _DetailRow(
                  label: "Rating",
                  value: product.rating.toStringAsFixed(1),
                  color: AppColors.ratingText,
                ),
                _DetailRow(
                  label: "Stock",
                  value: product.stock.toString(),
                  color: AppColors.stockText,
                ),
                _DetailRow(
                  label: "Brand",
                  value: product.brand.isEmpty
                      ? "Not available"
                      : product.brand,
                  color: AppColors.brandText,
                ),
                _DetailRow(
                  label: "Tags",
                  value: product.tags.isEmpty
                      ? "Not available"
                      : product.tags.join(", "),
                  color: AppColors.tagText,
                ),
                _DetailRow(
                  label: "Shipping",
                  value: product.shippingInformation.isEmpty
                      ? "Not available"
                      : product.shippingInformation,
                  color: AppColors.shippingText,
                ),
              ],
            ),
          ),
        ),
        const Divider(height: 1, color: AppColors.dialogDivider),
        Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.cancelButtonText,
                    side: const BorderSide(color: AppColors.cancelButtonBorder),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Cancel"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    /// Add-to-cart ViewModel logic lives in CartViewModel.
                    /// Calling it here updates the shared cart count badge.
                    // context.read<CartViewModel>().addProduct(product);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: AppColors.successSnackBar,
                        content: Text("${product.title} added to cart"),
                      ),
                    );
                  },
                  icon: const Icon(Icons.shopping_cart),
                  label: const Text("Add to Cart"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonColor,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProductDetailsShimmer extends StatelessWidget {
  const _ProductDetailsShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ShimmerBox(height: 210, borderRadius: BorderRadius.circular(16)),
            const SizedBox(height: 18),
            const _ShimmerBox(height: 24, width: 220),
            const SizedBox(height: 12),
            const _ShimmerBox(height: 14),
            const SizedBox(height: 8),
            const _ShimmerBox(height: 14, width: 280),
            const SizedBox(height: 18),
            ...List.generate(
              7,
              (index) => const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: _ShimmerBox(height: 16),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: const [
                Expanded(child: _ShimmerBox(height: 48)),
                SizedBox(width: 12),
                Expanded(child: _ShimmerBox(height: 48)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductDetailsError extends StatelessWidget {
  final String message;

  const _ProductDetailsError({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(22),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline,
            color: AppColors.discountText,
            size: 42,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.discountText,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonColor,
              foregroundColor: AppColors.white,
            ),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double height;
  final double? width;
  final BorderRadius? borderRadius;

  const _ShimmerBox({required this.height, this.width, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: borderRadius ?? BorderRadius.circular(10),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _DetailRow({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: RichText(
        text: TextSpan(
          text: "$label: ",
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          children: [
            TextSpan(
              text: value,
              style: TextStyle(color: color, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
