import 'package:flutter/material.dart';

import '../model/product_model.dart';
import '../utils/app_colors.dart';
import '../utils/edge_to_edge.dart';
import '../widgets/product_details_dialog.dart';

class ProductListScreen extends StatelessWidget {
  final List<ProductModel> products;

  const ProductListScreen({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.white,
        title: const Text("All Products"),
      ),
      body: ListView.builder(
        padding: edgeToEdgeScrollPadding(context, bottom: 10),
        itemCount: products.length,
        itemBuilder: (_, index) {
          final product = products[index];

          return Card(
            color: AppColors.cardBackground,
            elevation: 0,
            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              onTap: () => showProductDetailsDialog(context, product.id),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  product.thumbnail,
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 64,
                    height: 64,
                    color: AppColors.imagePlaceholder,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.image_not_supported,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
              title: Text(
                product.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.titleText,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  product.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.descriptionText),
                ),
              ),
              trailing: Text(
                "\$${product.price.toStringAsFixed(2)}",
                style: const TextStyle(
                  color: AppColors.priceText,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
