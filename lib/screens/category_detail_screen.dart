import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/product_model.dart';
import '../utils/app_colors.dart';
import '../utils/edge_to_edge.dart';
import '../viewmodel/cart_view_model.dart';
import '../viewmodel/category_detail_view_model.dart';
import '../widgets/home_shimmer.dart';

class CategoryDetailScreen extends StatelessWidget {
  final String name;
  final String slug;
  final String url;

  const CategoryDetailScreen({
    super.key,
    required this.name,
    required this.slug,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CategoryDetailViewModel()..loadProducts(url),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.white,
          systemOverlayStyle: EdgeToEdge.onPrimarySystemUiOverlayStyle,
          title: Text(name),
        ),
        body: Consumer<CategoryDetailViewModel>(
          builder: (context, vm, child) {
            if (vm.isLoading) {
              return const HomeShimmer();
            }

            if (vm.errorMessage.isNotEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    vm.errorMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.discountText,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }

            if (vm.products.isEmpty) {
              return const Center(
                child: Text(
                  "No products found",
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }

            return ListView.builder(
              padding: edgeToEdgeScrollPadding(
                context,
                left: 14,
                top: 14,
                right: 14,
                bottom: 14,
              ),
              itemCount: vm.products.length,
              itemBuilder: (context, index) {
                final product = vm.products[index];

                return _ProductCard(
                  product: product,
                  onTap: () => _showProductDialog(context, product),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showProductDialog(BuildContext context, ProductModel product) {
    showDialog(
      context: context,
      builder: (context) {
        final mediaQuery = MediaQuery.of(context);
        final size = mediaQuery.size;
        final safeHeight = size.height - mediaQuery.viewPadding.vertical - 48;

        return SafeArea(
          child: Dialog(
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 24,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 520,
                maxHeight: safeHeight.clamp(320, size.height * 0.86).toDouble(),
              ),
              child: Column(
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
                                color: AppColors.softSurface,
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
                            value:
                                "\$${product.discountPrice.toStringAsFixed(2)}",
                            color: AppColors.discountText,
                          ),
                          _DetailRow(
                            label: "Ratings",
                            value: product.rating.toStringAsFixed(1),
                            color: AppColors.ratingText,
                          ),
                          _DetailRow(
                            label: "Stock",
                            value: product.stock.toString(),
                            color: AppColors.stockText,
                          ),
                          _DetailRow(
                            label: "Tag",
                            value: product.tags.join(", "),
                            color: AppColors.tagText,
                          ),
                          _DetailRow(
                            label: "Brand",
                            value: product.brand.isEmpty
                                ? "Not available"
                                : product.brand,
                            color: AppColors.brandText,
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text("Close"),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              /// Add-to-cart ViewModel logic lives in
                              /// CartViewModel, which also refreshes the badge.
                              // context.read<CartViewModel>().addProduct(product);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "${product.title} added to cart",
                                  ),
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
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;

  const _ProductCard({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                product.thumbnail,
                height: 120,
                width: 110,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 120,
                  width: 110,
                  color: AppColors.softSurface,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.image_not_supported,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.titleText,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    product.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.descriptionText,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _DetailLine(
                    text: "Category: ${product.category}",
                    color: AppColors.categoryText,
                  ),
                  _DetailLine(
                    text: "Price: \$${product.price.toStringAsFixed(2)}",
                    color: AppColors.priceText,
                  ),
                  _DetailLine(
                    text:
                        "Discount Price: \$${product.discountPrice.toStringAsFixed(2)}",
                    color: AppColors.discountText,
                  ),
                  _DetailLine(
                    text: "Ratings: ${product.rating.toStringAsFixed(1)}",
                    color: AppColors.ratingText,
                  ),
                  _DetailLine(
                    text: "Stock: ${product.stock}",
                    color: AppColors.stockText,
                  ),
                  _DetailLine(
                    text: "Tag: ${product.tags.join(", ")}",
                    color: AppColors.tagText,
                  ),
                  _DetailLine(
                    text:
                        "Brand: ${product.brand.isEmpty ? "N/A" : product.brand}",
                    color: AppColors.brandText,
                  ),
                  _DetailLine(
                    text:
                        "Shipping: ${product.shippingInformation.isEmpty ? "N/A" : product.shippingInformation}",
                    color: AppColors.shippingText,
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

class _DetailLine extends StatelessWidget {
  final String text;
  final Color color;

  const _DetailLine({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
        ),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
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
