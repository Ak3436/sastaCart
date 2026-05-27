import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/edge_to_edge.dart';

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,

      highlightColor: Colors.grey.shade100,

      child: ListView.builder(
        padding: edgeToEdgeScrollPadding(context, top: 10, bottom: 10),

        itemCount: 6,

        itemBuilder: (_, index) {
          return Container(
            margin: const EdgeInsets.all(10),

            height: 120,

            decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.circular(15),
            ),
          );
        },
      ),
    );
  }
}
