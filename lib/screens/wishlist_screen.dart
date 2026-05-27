import 'package:flutter/material.dart';

import '../utils/edge_to_edge.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const EdgeToEdgeBody(
      bottom: false,
      child: Center(
        child: Text(
          "Wishlist Screen",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
