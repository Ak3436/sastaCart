import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodel/cart_view_model.dart';

/// Reusable cart icon badge.
///
/// The badge listens to CartViewModel.cartCount, so it updates automatically
/// whenever the cart list is loaded, an item is added, or an item is removed.
class CartBadge extends StatelessWidget {
  final Color iconColor;
  final double iconSize;

  const CartBadge({
    super.key,
    this.iconColor = Colors.white,
    this.iconSize = 28,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CartViewModel>(
      builder: (context, cartViewModel, child) {
        final count = cartViewModel.cartCount;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(Icons.shopping_cart, color: iconColor, size: iconSize),
            if (count > 0)
              Positioned(
                right: -7,
                top: -8,
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    count > 99 ? "99+" : count.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
